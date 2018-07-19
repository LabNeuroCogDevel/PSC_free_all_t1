#!/usr/bin/env bash

#SBATCH -N 1
#SBATCH -p RM
#SBATCH --ntasks-per-node 1
#SBATCH -t 24:00:00

export FREESURFER_HOME=$HOME/bin/freesurfer/
export SUBJECTS_DIR=$SCRATCH/FS
[ ! -d $SUBJECTS_DIR ] && mkdir -p $SUBJECTS_DIR

source $FREESURFER_HOME/FreeSurferEnv.sh

[ -z "$SUBJ" -o -z "$REP_DCM" ] && echo "bad input SUBJ '$SUBJ' REP_DCM '$REP_DCM'" && exit 1
if [ -d $SUBJECTS_DIR/$SUBJ ]; then
     echo "$SUBJ: have $SUBJECTS_DIR/$SUBJ "
     recon-all  -all -s $SUBJ 
else
     recon-all  -all -s $SUBJ -i  $REP_DCM 
fi
