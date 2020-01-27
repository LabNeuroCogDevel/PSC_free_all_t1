#!/usr/bin/env bash

#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH --ntasks-per-node 1
#SBATCH -t 35:00:00

export FREESURFER_HOME=$SCRATCH/bin/freesurfer/
[ -z $SUBJECTS_DIR ] && echo "need $SUBJECTS_DIR defined!" && exit 1
#export SUBJECTS_DIR=$SCRATCH/FS
[ ! -d $SUBJECTS_DIR ] && mkdir -p $SUBJECTS_DIR

source $FREESURFER_HOME/FreeSurferEnv.sh

[ -z "$SUBJ" -o -z "$REP_DCM" ] && echo "bad input SUBJ '$SUBJ' REP_DCM '$REP_DCM'" && exit 1
if [ -d $SUBJECTS_DIR/$SUBJ ]; then
     echo "$SUBJ: have $SUBJECTS_DIR/$SUBJ "
     recon-all  -all -s $SUBJ -no-isrunning -make autorecon3
else
     recon-all  -all -s $SUBJ -i  $REP_DCM 
fi
