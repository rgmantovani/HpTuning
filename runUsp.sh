#!/bin/bash

DIR='data';
EXT='\.arff';
DATASETS=`ls ./$DIR/*$EXT | sed -e "s/\.\/$DIR\///g" | sed -e "s/$EXT//g"`

for data in $DATASETS
do
  # echo $data
  for algo in "classif.J48" # "classif.rpart" "classif.svm"
  do
    for tuning in "defaults" "random" "mbo" "irace"
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
