#!/usr/bin/env bash

#SBATCH -N 1
#SBATCH -p RM
#SBATCH --ntasks-per-node 1
#SBATCH -t 30:00:00

#
# test usage
# SUBJ=1024 bash fs_bach_long.bash
#

export FREESURFER_HOME=$HOME/bin/freesurfer/
export SUBJECTS_DIR=$SCRATCH/FS
[ ! -d $SUBJECTS_DIR ] && mkdir -p $SUBJECTS_DIR

source $FREESURFER_HOME/FreeSurferEnv.sh

[ -z "$SUBJ" ] && echo "bad input SUBJ '$SUBJ' REP_DCM '$REP_DCM'" && exit 1

# build comdargs -- append new timepoint
cmdargs=""
for d in $SUBJECTS_DIR/${SUBJ}_[0-9]*; do
  # all dirs need to be complete
  logfile=$d/scripts/recon-all.log
  ! grep  'finished without error' $logfile >/dev/null && echo "$SUBJ: incomplete; see $logfile" && exit 1
  cmdargs="$cmdargs -tp $(basename $d)"
done
[ -z "$cmdargs" ] && echo "$SUBJ: no dirs in $SUBJECTS_DIR!" && exit 1

# generate template
recon-all -base base_$SUBJ $cmdargs -all  -no-isrunning

# longitudinally process all timepoints
for d in $SUBJECTS_DIR/${SUBJ}_[0-9]*; do
  recon-all -long $(basename $d)  base_$SUBJ  -all
done

