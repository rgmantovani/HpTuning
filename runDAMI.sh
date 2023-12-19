#!/bin/bash

DIR='data';
EXT='\.arff';
DATASETS=(`ls ./$DIR/*$EXT | sed -e "s/\.\/$DIR\///g" | sed -e "s/$EXT//g"`)

FROM=0
# TO=171
TO=${#DATASETS[@]} # all elements
REPS=10

for id in $(seq $FROM $TO);
do
  for algo in "classif.rpart"
  do
    for tuning in "defaults-skl"
    do
      for rep in $(seq 1 $REPS);
      do
        # echo ${DATASETS[$id]} $algo $tuning $rep out_"${DATASETS[$id]}"_"$algo"_"$tuning"_rep_"$rep".log
        R CMD BATCH  --no-save --no-restore '--args' --datafile="${DATASETS[$id]}" --algo="$algo " --tuning="$tuning" \
          --epoch="$rep" mainHP.R out_"${DATASETS[$id]}"_"$algo"_"$tuning"_rep_"$rep".log &
        PIDS[$rep]=$!
      done
      for k in $(seq 1 $REPS);
      do
        wait ${PIDS[$k]}
      done;
    done
  done
done
