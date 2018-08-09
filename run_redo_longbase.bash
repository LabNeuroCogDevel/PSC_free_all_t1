#!/usr/bin/env bash
export SUBJECTS_DIR=$SCRATCH/FS
grep -Li 'finished without e' scratch/FS/*long.base*/scripts/recon-all.log |
 perl -lne 'print "$1 $2" if m/((\d{5})_\d+)/' |
 while read iddate base; do
   export SUBJ=$base
  
   blog=$SUBJECTS_DIR/base_$SUBJ/scripts/recon-all.log
   [ ! -r $blog ] && echo base_$SUBJ never run && continue
  
   # rerun making base
   if ! grep 'finished without err' -iq $blog; then
     echo base_$SUBJ did not finish
     [ $(squeue -A $(id -gn) -n base_$SUBJ | wc -l) -gt 1 ] && echo "$SUBJ: already in queue!" && continue
     echo sbatch -o $logfile -e $logfile -J base_$SUBJ fs_batch_long.bash 
     continue
   fi
  
   echo recon-all -long $iddate base_$SUBJ  -all -no-isrunning
done

