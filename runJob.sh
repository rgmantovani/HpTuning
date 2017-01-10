#!/bin/bash
#$ -S /bin/bash
#$ -cwd

R CMD BATCH --no-save --no-restore '--args' --datafile="$1" --algo="$2 " --tuning="$3" --epoch="$4" mainHP.R out_"$1"_"$2"_"$3"_rep_"$4".log