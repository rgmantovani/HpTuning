# HpTuning

'HPTuning' is a program that performs hyper-parameter tuning of different Machine Learning (ML) classification algorithms using different optimization techniques. The project itsleft uses the 'mlr' [1] package as structure, and working as a wrapper to the techniques provided by literature.

### Technical Requirements

* R version >= 3.1.0
* Required packages: [mlr](https://cran.r-project.org/web/packages/mlr/index.html), [mlrMBO](https://github.com/mlr-org/mlrMBO), [checkmate](https://cran.r-project.org/web/packages/checkmate/index.html), [pso](https://cran.r-project.org/web/packages/pso/index.html), [GA](https://cran.r-project.org/web/packages/GA/index.html), [copulaedas](https://cran.r-project.org/web/packages/copulaedas/index.html), [foreign](https://cran.r-project.org/web/packages/foreign/index.html), [RWeka](https://cran.r-project.org/web/packages/RWeka/index.html), [rpart](https://cran.r-project.org/web/packages/rpart/index.html), [e1071](https://cran.r-project.org/web/packages/e1071/index.html).

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

The program neeeds some specific parameters to run: **\<datafile, algo, tuning, epoch\>**. 
* **datafile** -  dataset filename available at the "data/" subdir

* **algo** - ML algorithm to be tuned
  * "classif.J48": J48 Decision Tree algorithm \[2\], implemented by the *RWeka* package;
  * "classif.rpart": CART trees \[3\], implemented by the *rpart* package;
  * "classif.svm": Support Vector Machines \[4\], implemented by the *e1071* package;

* **tuning** - hyper-parameter tuning technique 
  * "defaults" - Default hyper-parameter values (from respecitive R implementations); 
  * "random" - Random Search (RS) \[5\], the *mlr* implementation; 
  * "mbo" - Sequential Model-Based Optimization (SMBO) \[6\], implemented by the *mlrMBO* package;  
  * "irace" - Iterative Racing Algorithm \[7\], implemented by the *irace* package; 
  * "pso" - Particle Swarm Optimization \[8\], implemented by the *pso* package; 
  * "ga" - Genetic Algorithm \[9\], implemented by the *GA* package;
  * "eda" - Estimation of Distribution Algorithms (EDA) \[10\], implemented by the *copulaedas* package.

* **epoch** - id of the repetition being executed. It must be a value between 1 and 30. It also controls the seed for reproducibility.

Basically, given the 4-tuple of execution parameters, it will tune the **\<algo\>** on **\<datafile\>** using the **\<tuning\>** technique. The **\<epoch\>** parameter specifies the repetition being executed. Since most of the tuning techniques covered here are stochastics, when comparing them they need to run several times with different seeds. This execution parameter also controls this ```(seed = epoch)```.

Each single execution will be saved in a different folder, organized by its input parameters. The program will save the final performances, the hyper-parameter found during optmization, the optimization path and the predications obtained with the tuned hyper-parameters.

**Obs**: On every datafile, the target attribute must be labeled as **Class**.

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

[1] B. Bischl, Michel Lang, Lars Kotthoff, Julia Schiffner, Jakob Richter, Zachary Jones, Giuseppe Casalicchio. mlr: Machine Learning in R, R package version 2.10. URL https://github.com/mlr-org/mlr.

[2] J. R. Quinlan, C4.5:  Programs for Machine Learning, Morgan KaufmannPublishers Inc., San Francisco, CA, USA, 1993.

[3] L. Breiman, J. Friedman, R. Olshen, C. Stone, Classification and Regres-sion Trees, Chapman \& Hall (Wadsworth, Inc.), 1984.

[4] C. Cortes, V. Vapnik. Support Vector Networks. Machine Learning, vol. 20 (1995), num.3, 273-297.

[5] J. Bergstra, Y. Bengio, Random search for hyper-parameter optimization, J. Mach. Learn. Res. 13 (2012) 281–305.

[6] J. Snoek, H. Larochelle, R. P. Adams, Practical bayesian optimization ofmachine learning algorithms, in: F. Pereira, C. Burges, L. Bottou, K. Weinberger (Eds.), Advances in Neural Information Processing Systems 25, Cur-ran Associates, Inc., 2012, pp. 2951–2959.

[7] M. López-Ibáñez, J. Dubois-Lacoste, L. Pérez Cáceres, T. Stützle, and M.Birattari. The irace package: Iterated Racing for Automatic Algorithm Configuration. Operations Research Perspectives, 2016.

[8] J. Kennedy,  R. Eberhart, Particle swarm optimization. In: Proceedingsof the IEEE International Conference on Neural Networks, Vol. 4, Perth,Australia, 1995, pp. 1942 – 1948.

[9] D. Goldberg, Genetic Algorithms in Search, Optimization and Machine Learning, Addison Wesley, 1989.

[10] M. Hauschild,  M. Pelikan. An introduction and survey of estimation of distribution algorithms, Swarm and Evolutionary Computation (3) (2011)111 – 128.

### Citation

If you use our code/experiments in your research, please, cite [our paper]() where this project was first used:

[ADD citation]

### Bibtex 

[ADD bibtex entry]
