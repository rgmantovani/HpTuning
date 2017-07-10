#!/bin/bash
#$ -S /bin/bash
#$ -cwd

DIR='data';
EXT='\.arff';
DATASETS=`ls ./$DIR/*$EXT | sed -e "s/\.\/$DIR\///g" | sed -e "s/$EXT//g"`  

for data in "${arr[@]}"
do
  for algo in "classif.J48" # "classif.rpart" "classif.svm"
  do
    for tuning in "defaults" "random" "mbo" #"irace"
    do
      for rep in $(seq 1 30);
      do
        qsub runJob.sh $data $algo $tuning $rep
      done
    done
  done
done
