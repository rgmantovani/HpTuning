# HpTuning

'HPTuning' is a program that performs hyper-parameter tuning of different Machine Learning (ML) classification algorithms using different optimization techniques. The project itsleft uses the 'mlr' [1] package as structure, and working as a wrapper to the techniques provided by literature.

### Technical Requirements

* R version >= 3.1.0
* Required packages: [mlr](https://cran.r-project.org/web/packages/mlr/index.html), [mlrMBO](https://github.com/mlr-org/mlrMBO), [checkmate](https://cran.r-project.org/web/packages/checkmate/index.html), [pso](https://cran.r-project.org/web/packages/pso/index.html), [GA](https://cran.r-project.org/web/packages/GA/index.html), [copulaedas](https://cran.r-project.org/web/packages/copulaedas/index.html) and [foreign](https://cran.r-project.org/web/packages/foreign/index.html).

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

### How it works?

The program neeeds some specific parameters to run: \<datafile, algo, tuning, epoch\>. 
* **datafile** -  dataset filename available at the "data/" subdir

* **algo** - ML algorithm to be tuned
  * "classif.J48"- J48 Decision Tree algorithm \[2\] (using RWeka R package)
  * "classif.rpart" - CART trees \[3\] (via rpart R package)
  * "classif.svm" - Support Vector Machines \[4\] (via e1071 R package)

* **tuning** - hyper-parameter tuning technique 
  * "defaults" - Default hyper-parameter values (from respecitive R packages); 
  * "random" - Random Search (RS) \[5\], 
  * "mbo" - Sequential Model-Based Optimization (SMBO) \[6\] (implemented with mlrMBO package);  
  * "irace" - Iterative Racing Algorithm \[7\] (implemented with irace package); 
  * "pso" - Particle Swarm Optimization \[8\] (implemented with pso package); 
  * "ga" - Genetic Algorithm \[9\] (implemented with ga package);
  * "eda" - Estimation of Distribution Algorithms (EDA) \[10\] (implemented with copulaedas package).

* **epoch** - id of the repetition being executed. It must be a value between 1 and 30. It also controls the seed for reproducibility.

Basically, given the 4-tuple, it will tune the <algo> on <datafile> using the <tuning> technique. The **epoch** parameter specifies the repetition being executed. Since most of the tuning techniques covered here are stochastics, when comparing them they need to run several times with different seeds. This execution parameter also controls this '''(seed = epoch)'''.

Each single execution will be saved in a different folder, organized by its input parameters. The program will save the final performances, the hyper-parameter found during optmization, the optimization path and the predications obtained with the tuned hyper-parameters.

**Obs**: On every datafile, the target attribute must be labeled as *Class*.

### Running the code

To run the project, please, call it by the bash file executing it by the command:
```
 R CMD BATCH --no-save --no-restore '--args' --datafile=<datafile> --algo=<algo> --tuning=<tuning> \
    --epoch=<epoch> mainHP.R out_"$datafile"_"$algo"_"$tuning"_rep_"$epoch".log &
```

It will start the script saving the status in an output log file. You can follow the execution and errors checking directly this file. 

### Contact

Rafael Gomes Mantovani (rgmantovani@gmail.com) University of São Paulo - São Carlos, Brazil.

### References

[1] Bernd Bischl, Michel Lang, Lars Kotthoff, Julia Schiffner, Jakob Richter, Zachary Jones, Giuseppe Casalicchio. mlr: Machine Learning in R, R package version 2.10. URL https://github.com/mlr-org/mlr.

[2] J48 ref

[3] CART ref 

[4] SVM ref

[5] RS ref

[6] Bernd Bischl, Jakob Bossek, Daniel Horn and Michel Lang (NA). mlrMBO: Model-Based Optimization for mlr. R package version 1.0. 

[7] irace ref

[8] pso ref

[9] ga ref

[10] eda ref

### Citation

If you use our code/experiments in your research, please, cite [our paper]() where this project was first used:

[ADD citation]

### Bibtex 

[ADD bibtex entry]
