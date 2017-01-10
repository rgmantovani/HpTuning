#!/bin/bash
#$ -S /bin/bash
#$ -cwd

declare -a arr=("abalone-28class" "acute-inflammations-nephritis" "analcatdata_authorship" 
  "analcatdata_boxing1" "analcatdata_boxing2" "analcatdata_creditscore" "analcatdata_dmft" 
  "analcatdata_germangss" "analcatdata_lawsuit" "appendicitis" "artificial-characters" 
  "autoUniv-au1-1000" "autoUniv-au4-2500" "autoUniv-au6-1000" "autoUniv-au6-250-drift-au6-cd1-500"
  "autoUniv-au6-cd1-400" "autoUniv-au7-300-drift-au7-cpd1-800" "autoUniv-au7-700" 
  "autoUniv-au7-cpd1-500" "backache" "balance-scale" "banana" "bank-marketing" 
  "banknote-authentication" "blood-transfusion-service" "breast-cancer-wisconsin" 
  "breast-tissue-6class" "bupa" "car-evaluation" "cardiotocography-3class" 
  "climate-simulation-craches" "cloud" "cmc" "collins" "connectionist-mines-vs-rocks" 
  "connectionist-vowel" "dermatology" "ecoli" "energy-efficiency-y1" "energy-efficiency-y2" 
  "fertility-diagnosis" "first-order-theorem" "flags-colour" "flags-religion" "flare" "glass" 
  "habermans-survival" "hayes-roth" "heart-disease-processed-cleveland" 
  "heart-disease-processed-hungarian" "heart-disease-processed-switzerland" 
  "heart-disease-processed-va" "heart-disease-reprocessed-hungarian" "hepatitis" 
  "horse-colic-surgical" "indian-liver-patient" "ionosphere" "iris" "kr-vs-kp" "leaf" "led7digit" 
  "lsvt-voice-rehabilitation" "lymphography" "mammographic-mass" "meta-data" "mfeat-fourier" 
  "molecular-promotor-gene" "monks1" "monks2" "monks3" "movement-libras" "mushroom" "optdigits" 
  "ozone-eighthr" "ozone-onehr" "page-blocks" "parkinsons" "phoneme" "robot-nav-sensor-readings-4" 
  "saheart" "seeds" "statlog-german-credit" "statlog-heart" "statlog-image-segmentation" 
  "statlog-landsat-satellite" "statlog-vehicle-silhouettes" "steel-plates-faults" 
  "teaching-assistant-evaluation" "texture" "thoracic-surgery" "thyroid-allbp" "thyroid-allhyper" 
  "vertebra-column-3c" "hill-valley-with-noise" "micro-mass-mixed-spectra" "nursery-4class" 
  "plant-species-leaves-margin" "plant-species-leaves-shape" "plant-species-leaves-texture" "semeion" 
  "user-knowledge" "yeast" "molecular-splice-junction" "multiple-features" "soybean-large" 
  "spectometer" "wpbc")

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
