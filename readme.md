# FreeSurfer on all T1s

using the longitudinal  pipeline on the Pittsburgh Super Computer (XSEDE).

## steps
  0. collect and transfer. see `tx/`
  1. first pass FS: `run_t1_all.bash` submits `fs_batch_cmd.bash` jobs to with `sbatch`
  2. long pass: `run_long.bash` submits `fs_batch_long.bash` 

## ref

https://surfer.nmr.mgh.harvard.edu/fswiki/LongitudinalProcessing
