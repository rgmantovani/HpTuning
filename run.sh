#!/bin/bash

declare -a arr=("abalone-11class" "abalone-28class" "abalone-3class" "abalone-7class" "acute-inflammations-nephritis"
	"analcatdata_authorship" "analcatdata_boxing1" "analcatdata_boxing2" "analcatdata_creditscore" "analcatdata_dmft" 
	"analcatdata_germangss" "analcatdata_lawsuit" "appendicitis" "artificial-characters" "autoUniv-au1-1000" 
	"autoUniv-au4-2500" "autoUniv-au6-1000" "autoUniv-au6-250-drift-au6-cd1-500" "autoUniv-au6-cd1-400" 
	"autoUniv-au7-300-drift-au7-cpd1-800" "autoUniv-au7-700" "autoUniv-au7-cpd1-500" "backache" "balance-scale" "banana" 
	"bank-marketing" "banknote-authentication" "blood-transfusion-service" "breast-cancer-wisconsin" "breast-tissue-4class" 
	"breast-tissue-6class" "bupa" "car-evaluation" "cardiotocography-3class" "climate-simulation-craches" "cloud" "cmc" 
	"collins" "connectionist-mines-vs-rocks" "connectionist-vowel-reduced" "connectionist-vowel" "contraceptive-method-choice"
	"dermatology" "ecoli" "energy-efficiency-y1" "energy-efficiency-y2" "fertility-diagnosis" "first-order-theorem" 
	"flags-colour" "flags-religion" "flags" "flare" "glass" "habermans-survival" "hayes-roth" "heart-disease-processed-cleveland" 
	"heart-disease-processed-hungarian" "heart-disease-processed-switzerland" "heart-disease-processed-va" 
	"heart-disease-reprocessed-hungarian" "hepatitis" "horse-colic-surgical" "indian-liver-patient" "ionosphere" "iris" "kr-vs-kp" 
	"leaf" "led7digit" "leukemia-haslinger" "lsvt-voice-rehabilitation" "lymphography" "mammographic-mass" "meta-data" "mfeat-fourier" 
	"molecular-promotor-gene" "monks1" "monks2" "monks3" "movement-libras" "mushroom" "musk" "optdigits" "ozone-eighthr" "ozone-onehr" 
	"page-blocks" "parkinsons" "phoneme" "pima-indians-diabetes" "planning-relax" "plant-species-leaves-margin" 
	"plant-species-leaves-shape" "plant-species-leaves-texture" "prnn_crabs" "qsar-biodegradation" "qualitative-bankruptcy" "ringnorm" 
	"robot-failure-lp4" "robot-failure-lp5" "robot-nav-sensor-readings-2" "robot-nav-sensor-readings-24" "robot-nav-sensor-readings-4" 
	"saheart" "seeds" "seismic-bumps" "soybean-large" "spambase" "spect-heart" "spectf-heart" "statlog-australian-credit" 
	"statlog-german-credit-numeric" "statlog-german-credit" "statlog-heart" "statlog-image-segmentation" "statlog-landsat-satellite" 
	"statlog-vehicle-silhouettes" "steel-plates-faults" "teaching-assistant-evaluation" "texture" "thoracic-surgery" "thyroid-allbp" 
	"thyroid-allhyper" "thyroid-allhypo" "thyroid-allrep" "thyroid-ann" "thyroid-dis" "thyroid-hypothyroid" "thyroid-newthyroid" 
	"thyroid-sick-euthyroid" "thyroid-sick" "tic-tac-toe" "turkiye-student" "twonorm" "user-knowledge" "vertebra-column-2c" 
	"vertebra-column-3c" "volcanoes-a1" "volcanoes-a2" "volcanoes-a3" "volcanoes-a4" "volcanoes-d1" "volcanoes-d2" "volcanoes-d3" 
	"volcanoes-d4" "volcanoes-e1" "volcanoes-e2" "volcanoes-e3" "volcanoes-e4" "volcanoes-e5" "voting" "waveform-v1" "waveform-v2" 
	"wdbc" "wholesale-channel" "wholesale-region" "wilt" "wine-quality-5class" "wine-quality-red" "wine-quality-white-5class" 
	"wine-quality-white" "wine" "wpbc" "yeast-4class" "yeast")

algo="classif.J48"
tuning="mbo"

#Iterates for each dataset
for i in "${arr[@]}"
do
	#Iterate the number of executions
	for j in $(seq 1 30);
    do
    	R CMD BATCH --no-save --no-restore '--args' --datafile="$i" --algo="$algo " --tuning="$tuning" \
    	 --epoch="$j" mainHP.R out_"$i"_"$algo"_"$tuning"_rep_"$j".log &
	done
done