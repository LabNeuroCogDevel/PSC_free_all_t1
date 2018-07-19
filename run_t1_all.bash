#!/usr/bin/env bash

# where is freesurfer output
export SUBJECTS_DIR=$SCRATCH/FS

# where to log things
[ ! -d $SCRATCH/joblog/ ] && mkdir $SCRATCH/joblog/
logfile="$SCRATCH/joblog/slurm-%A_%a.out" 

# for all t1s
for d in $SCRATCH/t1s/*/; do
   export REP_DCM=$(find $d -maxdepth 1 -type f -print -quit)
   export SUBJ=$(basename $d)
   [ -z "$REP_DCM" ] && echo "$SUBJ: missing dicoms" && continue
   grep 'finished without error' $SUBJECTS_DIR/$SUBJ/scripts/recon-all.log 2>/dev/null >/dev/null && 
    continue

   # submit to queue
   [ -n "$DRYRUN" ] && echo would run "$SUBJ $REP_DCM" && continue
   sbatch -o $logfile -e $logfile -J $SUBJ fs_batch_cmd.bash # $SUBJ $REP_DCM

   # todo remove this and run for all
done
