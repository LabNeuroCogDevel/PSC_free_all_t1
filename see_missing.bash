#!/usr/bin/env bash
SUBJECTS_DIR=$HOME/scratch/FS
txtdir=$(dirname $0)/txt
[ ! -d $txtdir ] && mkdir $txtdir
cd $txtdir

if [ -n "$NEW" ]; then
        echo -n "all files with errors: "
	grep -l 'ERRORS'           $SUBJECTS_DIR/*/scripts/recon-all.log > once_error.txt
        cat once_error.txt|wc -l

        echo -n "all files with without finishing line: "
	grep -L 'finished without' $SUBJECTS_DIR/*/scripts/recon-all.log > unfinished.txt
        cat unfinished.txt|wc -l
fi

echo "=== ERRORS ==="
cat once_error.txt | while read f; do tail -n1 $f |grep 'finished without' -q || echo $f ; done | tee errors.txt

echo "==== unfinished no error ==="
comm -13 errors.txt unfinished.txt | tee unfinished_noerror.txt

echo "==== Mising summary ==="
cat errors.txt unfinished.txt |sort|uniq |perl -lne 'print $& if m/(base|\d{5})_\d+(.long.base_\d+)?/' | perl -lne 'next unless m/(\d{5})($|_)/; push @{$h{$1}}, $_; END{print join "\t", $_, @{$h{$_}} for (reverse sort keys %h)}' | sort


# remove like
# rm -r /home/foranw/scratch/FS/*.long.base_{11394,11445,11448,11457,11458,11508,11512}
