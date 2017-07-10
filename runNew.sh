#!/bin/bash

declare -a arr=("1100_PopularKids" "1500_seismic-bumps" "1519_robot-failures-lp4" "1520_robot-failures-lp5" 
  "20_mfeat-pixel" "299_libras_move" "338_grub-damage" "685_visualizing_livestock")

for data in "${arr[@]}"
do
  for algo in "classif.rpart"
  do
    for tuning in "defaults" "irace"
    do
      for rep in $(seq 1 30);
      do
        R CMD BATCH --no-save --no-restore '--args' --datafile="$data" --algo="$algo " --tuning="$tuning" \
           --epoch="$rep" mainHP.R out_"$data"_"$algo"_"$tuning"_rep_"$rep".log &
            PIDS[$rep]=$!
      done
      for k in $(seq 1 30);
      do
        wait ${PIDS[$k]}
      done;
    done
  done
done
