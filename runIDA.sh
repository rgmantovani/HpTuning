#!/bin/bash

declare -a DATASETS=("1500_seismic-bumps" "461_analcatdata_creditscore" "1455_acute-inflammations" "1499_seeds" "1556_acute-inflammations"               
  "43_haberman" "61_iris" "685_visualizing_livestock" "444_analcatdata_boxing2" "48_tae" "464_prnn_synth" "1511_wholesale-customers"
  "40496_LED-display-domain-7digit" "450_analcatdata_lawsuit" "448_analcatdata_boxing1" "1463_blogger" 
  "1495_qualitative-bankruptcy" "446_prnn_crabs" "49_heart-c" "481_biomed" "1523_vertebra-column"  "23380_cjs"
  "1473_fertility" "187_wine" "1462_banknote-authentication" "329_hayes-roth" "1456_appendicitis" "694_diggle_table_a2"
  "451_irish" "1075_datatrieve" "1465_breast-tissue" "1121_badges2" "53_heart-statlog" "51_heart-h" "455_cars" "1508_user-knowledge"  
  "13_breast-cancer" "1073_jEdit_4.0_4.2" "338_grub-damage" "11_balance-scale" "55_hepatitis" "1115_teachingAssistant"
  "1512_heart-long-beach" "679_rmftsa_sleepdata" "1559_breast-tissue" "1167_pc1_req" "56_vote" "1490_planning-relax"
  "1063_kc2" "466_schizo" "334_monks-problems-2" "1048_jEdit_4.2_4.3" "15_breast-w" "475_analcatdata_germangss" "1498_sa-heart"
  "1064_ar6" "1100_PopularKids" "1464_blood-transfusion-service-center" "1488_parkinsons"  "463_backache" "335_monks-problems-3"
  "333_monks-problems-1" "336_SPECT" "1061_ar4" "1565_heart-h-v3" "452_analcatdata_broadwaymult" "1480_ilpd" "1506_thoracic-surgery"
  "37_diabetes" "1054_mc2" "469_analcatdata_dmft" "1446_CostaMadre1" "59_ionosphere" "1554_autoUniv-au7-500" "470_profb"
  "1442_MegaWatt1" "1467_climate-simulation-crashes" "1529_volcanoes-a3" "292_Australian" "1071_mw1" "1447_CastMetal1"
  "40_sonar" "1527_volcanoes-a1" "1065_kc3" "1530_volcanoes-a4" "54_vehicle" "1600_SPECTF" "29_credit-a" "1528_volcanoes-a2"
  "1068_pc1" "1510_wdbc" "35_dermatology" "1066_kc1-binary" "1443_PizzaCutter1" "1519_robot-failures-lp4"
  "1553_autoUniv-au7-700" "1520_robot-failures-lp5" "164_molecular-biology_promoters" "1452_PieChart2" "185_baseball" "50_tic-tac-toe"
  "40733_yeast_v7" "1451_PieChart1" "1551_autoUniv-au6-400" "1470_dresses-sales" "1547_autoUniv-au1-1000" "1444_PizzaCutter3"
  "6332_cylinder-bands" "307_vowel" "31_credit-g" "1067_kc1" "188_eucalyptus" "1069_pc2" "1552_autoUniv-au7-1100" "1494_qsar-biodeg"
  "1453_PieChart3" "311_oil_spill" "21_car" "1049_pc4" "299_libras_move" "23_cmc" "18_mfeat-morphological"
  "377_synthetic_control" "458_analcatdata_authorship" "1570_wilt" "1050_pc3" "1549_autoUniv-au6-750" "1466_cardiotocography"
  "36_segment" "38_sick" "1504_steel-plates-fault" "1497_wall-robot-navigation" "25_colic"
  "1484_lsvt" "1056_mc1" "1555_autoUniv-au6-1000" "310_mammography" "30_page-blocks" "1460_banana" "1526_wall-robot-navigation-v3"
  "40474_thyroid-allbp" "40475_thyroid-allhyper" "1487_ozone-level-8hr" "22_mfeat-zernike" "3_kr-vs-kp" "1489_phoneme"
  "1558_bank-marketing" "1496_ringnorm" "1479_hill-valley" "4550_MiceProtein" "1507_twonorm" "16_mfeat-karhunen" "1566_hill-valley"
  "24_mushroom" "1037_ada_prior" "1536_volcanoes-b6" "1535_volcanoes-b5" "1531_volcanoes-b1" "1533_volcanoes-b3" "1534_volcanoes-b4"
  "1532_volcanoes-b2" "316_yeast_ml8" "40499_texture" "14_mfeat-fourier" "1459_artificial-characters" "4534_PhishingWebsites"
  "44_spambase" "32_pendigits" "1541_volcanoes-d4" "1538_volcanoes-d1" "1493_one-hundred-plants-texture" "182_satimage"
  "1539_volcanoes-d2" "60_waveform-5000" "294_satellite_image" "1540_volcanoes-d3" "1491_one-hundred-plants-margin" 
  "1492_one-hundred-plants-shape" "375_JapaneseVowels" "12_mfeat-factors" "1514_micro-mass" "1043_ada_agnostic" "28_optdigits"
  "1568_nursery-v3" "1046_mozilla4" "46_splice" "1053_jm1" "1501_semeion" "1548_autoUniv-au4-2500"
  "312_scene" "20_mfeat-pixel" "1468_cnae-9" "1040_sylva_prior" "1116_musk" "1475_first-order-theorem-proving" "1120_MagicTelescope"
  "4538_GesturePhaseSegmentationProcessed" "1471_eeg-eye-state" "1044_eye_movements" "6_letter" "1042_gina_prior" "1485_madelon"
  "1041_gina_prior2" "1476_gas-drift" "1477_gas-drift-different-concentrations" "1461_bank-marketing" "1038_gina_agnostic"
  "300_isolet")

FROM=0
TO=207
REPS=10

for id in $(seq $FROM $TO);
do
  for algo in "classif.svm"
  do
    for tuning in "random" #"defaults" "mbo" "irace"
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

