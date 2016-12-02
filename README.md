# HpTuning

'HPTuning' is a program that performs hyper-parameter tuning of different Machine Learning (ML) classification algorithms. It uses 'mlr' [1] package as structure, and 'mlrMBO' [2] to perform Sequential Model Based Optimzation (SMBO) [3].

### Technical Requirements

* R version >= 3.1.0
* Required packages: [mlr](https://cran.r-project.org/web/packages/mlr/index.html), [mlrMBO](https://github.com/mlr-org/mlrMBO), [checkmate](https://cran.r-project.org/web/packages/checkmate/index.html)

### Setup

To install all of the required R packages you can run the ```setup.R```file:

* inside R: 
```R 
source("setup.R")
```
* outside R:
```
R CMD BATCH --no-save --no-restore setup.R &
``` 

### Running the code

To run the project, please, call it by the bash file executing it by the command:
```
 R CMD BATCH --no-save --no-restore '--args' --datafile=<datafile> --algo=<algo> --tuning=<tuning> \
    --epoch=<epoch> mainHP.R out_"$datafile"_"$algo"_"$tuning"_rep_"$epoch".log &
```

It will start the execution saving the status in an output log file. You can follow the execution and errors checking directly this file. 

The available values for the execution parameters to this current version are:
* datafile: any dataset filename available at the "data/" subdir;
* algo: "classif.J48"- J48 Decision Tree algorithm [4], "classif.rpart" - CART trees [5] and "classif.svm" - Support Vector Machines [6];
* tuning: "defaults" - Default hyper-parameter values, "random" - Random Search (RS) method, "mbo" - Sequential Model-Based Optimization (SMBO) and "irace" - Iterative Race;
* epoch: id of the repetition (may be a value between 1 and 30).

### How it works?

The program will receive the specified parameters <datafile, algo, tuning, epoch> and will perform the "epoch"-th execution of the hyper-parameter tuning technique "tuning" over the classification algorithm "algo" with the dataset "datafile".

Each single execution will be saved in a different folder, organized by its input parameters. The program will save the final performances, the optimization path, and the predications obtained with the tuned hyper-parameters found.

### Contact

Rafael Gomes Mantovani (rgmantovani@gmail.com) University of São Paulo - São Carlos, Brazil.

### References

[1] Bernd Bischl, Michel Lang, Lars Kotthoff, Julia Schiffner, Jakob Richter, Zachary Jones, Giuseppe Casalicchio. mlr: Machine Learning in R, R package version 2.10. URL https://github.com/mlr-org/mlr.

[2] Bernd Bischl, Jakob Bossek, Daniel Horn and Michel Lang (NA). mlrMBO: Model-Based Optimization for mlr. R package version 1.0. Available at: https://github.com/berndbischl/mlrMBO .

[3] [add SMBO ref]

[4] [add J48 ref]

[5] [add CART ref]

[6] [add SVM ref]

### Citation

If you use our code/experiments in your research, please, cite [our paper]() where this project was first used:

[ADD citation]

### Bibtex 

[ADD bibtex entry]
