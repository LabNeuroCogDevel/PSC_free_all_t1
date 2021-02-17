# .bashrc
source ~/CogAllVox/foranw/paths.src.bash
# export PATH="$PATH:/pylon5/ib5phip/foranw/apps/afni:/pylon5/ib5phip/foranw/apps/fmri_processing_scripts"
# export R_LIBS_USER="/pylon5/ib5phip/foranw/apps/Rlibs"

[ "$TERM" == "xterm" ] && TERM=xterm-256color
# Source global definitions
test -f /etc/bashrc && . $_

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export FREESURFER_HOME=$SCRATCH/bin/freesurfer/
export FS_SUBJECTS=$SCRATCH/FS
export SUBJECTS_DIR=$SCRATCH/FS

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source $FREESURFER_HOME/FreeSurferEnv.sh

sq(){ squeue -A $(id -gn) -o"%i %.10T %.10M %.10l %j" $@; }

x11title="\[\033]0;\u@PSC:\w\007\]"
PS1="$x11title$(tput rev)$(tput setaf 2) $(tput sgr0)$(tput bold)\t $(tput sgr0)$(tput rev)\w$(tput sgr0)\n> "
