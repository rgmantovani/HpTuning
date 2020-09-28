#!/bin/bash

declare -a DATASETS=("acute-inflammations-nephritis" "analcatdata_authorship" "analcatdata_boxing1" "analcatdata_boxing2" 
 "analcatdata_creditscore" "analcatdata_dmft" "analcatdata_germangss" "analcatdata_lawsuit" "appendicitis"
 "artificial-characters" "autoUniv-au1-1000" "autoUniv-au4-2500" "autoUniv-au6-1000" "autoUniv-au6-250-drift-au6-cd1-500"
 "autoUniv-au6-cd1-400" "autoUniv-au7-300-drift-au7-cpd1-800" "autoUniv-au7-700" "autoUniv-au7-cpd1-500"
 "backache" "balance-scale" "banana" "bank-marketing" "banknote-authentication" "blood-transfusion-service"
 "breast-cancer-wisconsin" "breast-tissue-6class" "bupa" "car-evaluation" "cardiotocography-3class" 
 "climate-simulation-crashes" "cloud" "cmc" "connectionist-mines-vs-rocks" "connectionist-vowel" "dermatology"
 "fertility-diagnosis" "first-order-theorem" "flare" "habermans-survival" "hayes-roth" "heart-disease-processed-cleveland"
 "heart-disease-processed-hungarian" "heart-disease-processed-va" "heart-disease-reprocessed-hungarian" "hepatitis"
 "hill-valley-with-noise" "horse-colic-surgical" "indian-liver-patient" "ionosphere" "iris" "kr-vs-kp" "led7digit"
 "lsvt-voice-rehabilitation" "mammographic-mass" "meta-data" "mfeat-fourier" "micro-mass-mixed-spectra"
 "molecular-promotor-gene" "molecular-splice-junction" "monks1" "monks2" "monks3" "movement-libras" "multiple-features"
 "mushroom" "nursery-4class" "optdigits" "ozone-eighthr" "ozone-onehr" "page-blocks" "parkinsons" "phoneme"
 "plant-species-leaves-margin" "plant-species-leaves-shape" "plant-species-leaves-texture" "robot-nav-sensor-readings-4"
 "saheart" "seeds" "semeion" "statlog-german-credit" "statlog-heart" "statlog-image-segmentation" "statlog-landsat-satellite"
 "statlog-vehicle-silhouettes" "steel-plates-faults" "teaching-assistant-evaluation" "texture" "thoracic-surgery"                   
 "thyroid-allbp" "thyroid-allhyper" "user-knowledge" "vertebra-column-3c" "wine" "yeast-4class")  

FROM=0
TO=95
REPS=30

for id in $(seq $FROM $TO);
do
  for algo in "classif.ctree"
  do
    for tuning in "pso"
    do
      for rep in $(seq 1 $REPS);
      do
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