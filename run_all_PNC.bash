#!/usr/bin/env bash

#
# run all PNC data
#

# 20180906WF - adapt run_t1_all.bash

# where is freesurfer output
export SUBJECTS_DIR=$SCRATCH/FS_PNC
[ ! -d $SUBJECTS_DIR ] && mkdir -p $SUBJECTS_DIR

# where to log things
[ ! -d $SCRATCH/joblog/ ] && mkdir $SCRATCH/joblog/
logfile="$SCRATCH/joblog/slurm-%A_%a.out" 

# for all t1s
for d in $SCRATCH/PNC/mprage/*/; do
   export REP_DCM=$(find $d -maxdepth 1 -type f -print -quit -iname '*.nii.gz')
   export SUBJ=$(basename $d)
   [ -z "$REP_DCM" ] && echo "$SUBJ: missing dicoms" && continue
   fslog=$SUBJECTS_DIR/$SUBJ/scripts/recon-all.log
   grep 'finished without error' $fslog 2>/dev/null >/dev/null && 
    continue

   # submit to queue
   if [ -n "$DRYRUN" ]; then 
     echo "export SUBJ=$SUBJ REP_DCM=$REP_DCM"
     echo "  sbatch -o $logfile -e $logfile -J $SUBJ fs_batch_cmd.bash # $SUBJ $REP_DCM"
     [ ! -r $fslog ] && continue
     (du -hcs $SUBJECTS_DIR/$SUBJ/; ls -l $fslog;echo; tail -n2 $fslog) | sed 's/^/   /'
     echo; echo;
     continue
   fi
   sbatch -o $logfile -e $logfile -J $SUBJ fs_batch_cmd.bash # $SUBJ $REP_DCM $SUBJECTS_DIR

   # todo remove this and run for all
done
