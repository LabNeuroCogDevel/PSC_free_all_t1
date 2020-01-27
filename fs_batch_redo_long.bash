#!/usr/bin/env bash

#SBATCH -N 1
#SBATCH -p RM
#SBATCH --ntasks-per-node 1
#SBATCH -t 3:00:00

#
# test usage
# SUBJ=1024 LONG=1024_xxxxxx bash fs_bach_redo_long.bash
#

export FREESURFER_HOME=$SCRATCH/bin/freesurfer/
export SUBJECTS_DIR=$SCRATCH/FS
recon-all -long $LONG  base_$SUBJ  -all -no-isrunning

