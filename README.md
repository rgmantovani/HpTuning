# HpTuning

'HPTuning' is a program that performs hyper-parameter tuning of different Machine Learning (ML) classification algorithms. It uses 'mlr' [1] package as structure, and 'mlrMBO' [2] to perform Sequential Model Based Optimzation [3].

### Technical Requirements

* R version >= 3.1.0
* Required packages: [mlr](https://cran.r-project.org/web/packages/mlr/index.html), [mlrMBO](https://github.com/mlr-org/mlrMBO), [checkmate](https://cran.r-project.org/web/packages/checkmate/index.html)

### Setup

To install all of the required R packages run the ```setup.R```file:

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
./runRandomBot.sh &
```
```
 R CMD BATCH --no-save --no-restore '--args' --datafile=<datafile> --algo=<algo> --tuning=<tuning> \
    --epoch=<epoch> mainHP.R out_"$datafile"_"$algo"_"$tuning"_rep_"$epoch".log &
```

It will start the execution saving the status in an output log file. You can follow the execution and errors checking directly this file. 

The possible parameter values specified to execute it are:
* datafile: any dataset filename available at the "data/" subdir;
* algo: "classif.J48"- J48 Decision Tree algorithm, "classif.rpart" - CART trees and "classif.svn" - Support Vector Machines;
* tuning: "defaults" - Defaults hyper-parameter values, "random" - Random Search, "mbo" - Sequential Model-Based Optimization and "irace" - Iterative Race;
* epoch: id of the repetition (may be between 1 and 30).


### How it works?

The program will receive the specified parameters <datafile, algo, tuning, epoch> and will perform the "epoch"-th execution of the hyper-parameter tuning technique "tuning" over the classification algorithm "algo" with the dataset "datafile".

Each single execution will be saved in a different folder, organized by its input parameters. The program will save the final performances, the optimization path, and the predications obtained with the tuned hyper-parameters found.

### Contact

Rafael Gomes Mantovani (rgmantovani@gmail.com) University of São Paulo - São Carlos, Brazil.

### References

[1] Bernd Bischl, Michel Lang, Lars Kotthoff, Julia Schiffner, Jakob Richter, Zachary Jones, Giuseppe Casalicchio. mlr: Machine Learning in R, R package version 2.10. URL https://github.com/mlr-org/mlr.

[2] Bernd Bischl, Jakob Bossek, Daniel Horn and Michel Lang (NA). mlrMBO: Model-Based Optimization for mlr. R package version 1.0. Available at: https://github.com/berndbischl/mlrMBO .

[3] Snoek

### Citation

If you use our code/experiments in your research, please, cite [our paper]() where this project was first used:

[ADD citation]

### Bibtex 

[ADD bibtex entry]