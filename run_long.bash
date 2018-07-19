#!/usr/bin/env bash

# where is freesurfer output
export SUBJECTS_DIR=$SCRATCH/FS

# where to log things
[ ! -d $SCRATCH/joblog/ ] && mkdir $SCRATCH/joblog/
logfile="$SCRATCH/joblog/long-%A_%a.out" 

ls -d $SUBJECTS_DIR/1*_*/ |
 perl -lne 'print $1 if m:/(1\d{4})_:' |
 sort |
 uniq -c |
 while read cnt subj; do
  # need long
  [ $cnt -le 1 ] && echo "$subj: too few ($cnt)" && continue

  # have all of what we need (no unfinished runs)
  nfinished=$(grep -l 'finished without error' $SUBJECTS_DIR/${subj}_*/scripts/recon-all.log |wc -l)
  [ $nfinished -ne $cnt ] && echo "ERROR: $subj unfinished" && continue

  # not running
  [ $(squeue -A $(id -gn) -n base_$subj | wc -l) -gt 1 ] && echo "$subj: already in queue!" && continue

  # not already ran
  outdir=$SUBJECTS_DIR/base_$subj 
  [ -d $outdir ] && echo "$subj: have $outdir" && continue
  
  # RUN
  export SUBJ=$subj 
  echo $SUBJ
  sbatch -o $logfile -e $logfile -J base_$SUBJ fs_batch_long.bash # $SUBJ
  break
done

