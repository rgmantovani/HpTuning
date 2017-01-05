#!/bin/bash

declare -a arr=("monks1" "bupa" "breast-tissue-6class" "vertebra-column-3c" "hill-valley-with-noise" 
  "micro-mass-mixed-spectra" "nursery-4class" "plant-species-leaves-margin" "plant-species-leaves-shape" 
  "plant-species-leaves-texture" "semeion" "user-knowledge" "yeast")

#algo="classif.J48" | classif.svm | 
algo="classif.rpart"

#"random | mbo | defaults | irace
tuning="defaults"
#tuning="mbo"
#tuning="random"
#tuning="irace"

for i in "${arr[@]}"
do
  #Iterate the number of executions
  for j in $(seq 1 30);
  do
    R CMD BATCH --no-save --no-restore '--args' --datafile="$i" --algo="$algo " --tuning="$tuning" \
       --epoch="$j" mainHP.R out_"$i"_"$algo"_"$tuning"_rep_"$j".log &
        PIDS[$j]=$!
  done
  for k in $(seq 1 30);
  do
    wait ${PIDS[$k]}
  done;
done