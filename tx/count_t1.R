#!/usr/bin/env Rscript

library(dbplyr)
library(dplyr)
# sqlite3 'select patname,study,Name,ndcm,dir from mrinfo where (Name like "%rage%" or Name like "tfl%") and ndcm > 160 '  |less
db <- src_sqlite("/Volumes/Zeus/mr_sqlite/db")
mrinfo <- tbl(db, "mrinfo")

d <-
   mrinfo %>%
   filter( (Name %like% "%rage%" | Name %like% "tfl%") & ndcm > 160) %>%
   select(patname, study, Name, ndcm, dir) %>% collect %>%
   # remove pet ids
   mutate(patname=gsub("\\^.*", "", patname),
          study=gsub("^cog.*", "cog", study),
          study=gsub("old$", "", study)) %>%
   # remove luna only scandates
   filter(!grepl("^\\d{5}$", patname), !duplicated(patname))

d %>% group_by(study) %>% tally

# birc to luna lookup
b2l <- LNCDR::db_query("
   with
    b as (select pid,id as birc from enroll where etype like 'BIRC'),
    l as (select pid,id as luna from enroll where etype like 'LunaID')
    select birc,luna from b natural join l")
# merge with sqlite data
ided <-
   d %>%
   filter(study=="cog") %>%
   merge(b2l, by.x="patname", by.y="birc", all=T)
# 32 with no lookup, 12 before 2016

# put matched ids back into all data
# 20180709 -- also use fullname for transfer to PSC
d.luna <-
   ided %>%
   filter(!is.na(luna)) %>%
   # combine luna_birc, make patname actually luna for rbind later
   mutate(fullname=paste(sep="_", luna, patname), patname=luna) %>%
   select(-luna) %>%
   rbind( d %>% filter(study != "cog") %>% mutate(fullname=patname))

d_luna_nodate <- d.luna %>%
   select(-dir,-fullname) %>%
   mutate(patname=gsub("[_-]\\d{8,}", "", patname))

## WHAT WE WANT
allt1ids <- unique( grep("^\\d{5}$", d_luna_nodate$patname, value=T) )
print(allt1ids)
length(allt1ids)

## DIAGNOSTICS

## grab only lunaid part of id (and discard those that don't match)
badid <-  d_luna_nodate %>% filter(!grepl("^\\d{5}$", patname))
# 14 with weird ids

# get unique subjects in a study (and also count apperence in a study)
subrep <-
   d_luna_nodate %>%
   filter(grepl("^\\d{5}$", patname)) %>%
   group_by(patname, study) %>%
   tally

by_timepoint <-
   subrep %>%
   group_by(study, n) %>%
   summarise(nn=n()) %>%
   tidyr::spread(n, nn)

print(by_timepoint)

find_extra <- function(study, nmax) {
  s <- subrep %>% filter(study==!!study, n>!!nmax) %>%
     ungroup %>%
     #mutate(patname=paste0(patname, ".*")) %>%
     select(patname) %>% unlist
  s %>% unname %>% print
  d[sapply(d$patname, function(x) any(!is.na(stringr::str_match(x, s)))), ] %>%
     arrange(patname)
}

find_extra("p5",  1)
find_extra("pet", 2)

# save unique id and raw directory for other scripts
write.table(d.luna %>% select(fullname, dir),
            file="/Volumes/Zeus/DB_SQL/queries/txt/allT1s.txt")
