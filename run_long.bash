#!/usr/bin/env bash

# where is freesurfer output
export SUBJECTS_DIR=$SCRATCH/FS

# where to log things
[ ! -d $SCRATCH/joblog/ ] && mkdir $SCRATCH/joblog/
logfile="$SCRATCH/joblog/long-%A_%a.out" 

ls -d $SUBJECTS_DIR/1*_[0-9]*/ | grep -v long.base |
 perl -lne 'print $1 if m:/(1\d{4})_:' |
 sort |
 uniq -c |
 while read cnt subj; do
  # need long
  [ $cnt -le 1 ] && echo "$subj: too few ($cnt: $(ls -d $SUBJECTS_DIR/${subj}_*/|xargs -n1 basename) )" && continue

  # have all of what we need (no unfinished runs)
  nfinished=$(grep -l 'finished without error' $SUBJECTS_DIR/${subj}_*/scripts/recon-all.log|grep -v long.base |wc -l)
  [ $nfinished -ne $cnt ] && echo "ERROR: $subj unfinished ($nfinished/$cnt: $(grep -L 'finished without error' $SUBJECTS_DIR/${subj}_*/scripts/recon-all.log|grep -v long.base |perl -ne 'print "$&\t" if m/\d{5}_\d+/'))" && continue
  continue

  # not running
  [ $(squeue -A $(id -gn) -n base_$subj | wc -l) -gt 1 ] && echo "$subj: already in queue!" && continue

  # not already ran
  outdir=$SUBJECTS_DIR/base_$subj 
  [ -d $outdir ] && echo "$subj: have $outdir" && continue
  
  # RUN
  export SUBJ=$subj 
  if [ -n "$DRYRUN" ]; then
      echo $SUBJ
      sbatch -o $logfile -e $logfile -J base_$SUBJ fs_batch_long.bash # $SUBJ
  else
      echo "export SUBJ=$SUBJ"
      echo "sbatch -o $logfile -e $logfile -J base_$SUBJ fs_batch_long.bash"
  fi

done

