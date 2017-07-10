# HpTuning

'HPTuning' is a program that performs hyper-parameter tuning of different Machine Learning (ML) classification algorithms using different optimization techniques. The project uses the 'mlr' [01] package as structure, and works as a wrapper to the techniques provided by literature.

### Technical Requirements

* R >= 3.1.0
* [mlr](https://cran.r-project.org/web/packages/mlr/index.html) >= 2.9
* [devtools](https://cran.r-project.org/web/packages/devtools/index.html) >= 1.12.0 

### Setup

You can install the current project, please use the following command inside your R session:
```R 
devtools::install_github("rgmantovani/HpTuning")
```

### How it works?

Basically, given a 4-tuple of execution parameters **\<datafile, algo, tuning, epoch\>**, it will tune the **\<algo\>** on **\<datafile\>** using the **\<tuning\>** technique. The **\<epoch\>** parameter specifies the seed of the repetition being executed. Since most of the tuning techniques covered here are stochastics, when comparing them they need to run several times with different seeds.

Each execution (or single job) will be saved in a different folder and organized by its input parameters. The program will store at the disk:
* the final peformances reached by the tuned models;
* the predictions reached by the tuned models;
* the hyper-parameters returned by the optimization process; and
* the optimization path with all the candidate settings evaluated during search.

### Available Options 

There is no restriction regarding the **datafile** option: the code will run with the datasets provided by you and located at the ```data``` sub-folder. **Obs**: On every datafile, the target attribute must be the last one and labeled as **Class**.

The availabe options (in this current version) for the other runtime parameters are:

* **algo** - ML algorithm to be tuned:
  * "classif.J48": J48 Decision Tree algorithm \[02\], implemented by the [*RWeka*](https://cran.r-project.org/web/packages/RWeka/index.html) package;
  * "classif.rpart": CART trees \[03\], implemented by the [*rpart*](https://cran.r-project.org/web/packages/rpart/index.html) package;
  * "classif.svm": Support Vector Machines \[04\], implemented by the [*e1071*](https://cran.r-project.org/web/packages/e1071/index.html) package;
  * "classif.randomForest": Random Forest \[05\], implemented by the [*randomForest*](https://cran.r-project.org/web/packages/randomForest/index.html) package.

* **tuning** - hyper-parameter tuning technique 
  * "defaults" - Default hyper-parameter values (from respecitive R implementations); 
  * "random" - Random Search (RS) \[06\], the *mlr* implementation; 
  * "mbo" - Sequential Model-Based Optimization (SMBO) \[07\], implemented by the [*mlrMBO*](https://cran.r-project.org/web/packages/mlrMBO/index.html) package;  
  * "irace" - Iterative Racing Algorithm \[08\], implemented by the [*irace*](https://cran.r-project.org/web/packages/irace/index.html) package; 
  * "pso" - Particle Swarm Optimization \[09\], implemented by the [*pso*](https://cran.r-project.org/web/packages/pso/index.html) package; 
  * "ga" - Genetic Algorithm \[10\], implemented by the [*GA*](https://cran.r-project.org/web/packages/GA/index.html) package;
  * "eda" - Estimation of Distribution Algorithms (EDA) \[11\], implemented by the [*copulaedas*](https://cran.r-project.org/web/packages/copulaedas/index.html) package.

* **epoch** - id of the repetition being executed. It controls the seed for reproducibility. We restric the range between 1 and 30. 

### Running the code

To run the project, please, call it by the bash file executing it by the command:
```R
R CMD BATCH --no-save --no-restore '--args' --datafile=<datafile> --algo=<algo> --tuning=<tuning> \
  --epoch=<epoch> mainHP.R out_job.log &
```

It will start the script saving the status in an output log file. You can follow the execution and errors checking directly this file, and also change the name of this log file as you whish.

### Contact

Rafael Gomes Mantovani (rgmantovani@gmail.com) University of São Paulo - São Carlos, Brazil.

### References

[01] B. Bischl, Michel Lang, Lars Kotthoff, Julia Schiffner, Jakob Richter, Zachary Jones, Giuseppe Casalicchio. mlr: Machine Learning in R, R package version 2.10. URL https://github.com/mlr-org/mlr.

[02] J. R. Quinlan, C4.5:  Programs for Machine Learning, Morgan KaufmannPublishers Inc., San Francisco, CA, USA, 1993.

[03] L. Breiman, J. Friedman, R. Olshen, C. Stone, Classification and Regres-sion Trees, Chapman \& Hall (Wadsworth, Inc.), 1984.

[04] C. Cortes, V. Vapnik. Support Vector Networks. Machine Learning, vol. 20 (1995), num.3, 273-297.

[05] L. Breiman. Random Forests. Machine Learning, vol. 45 (2001), num., 5-32.

[05] J. Bergstra, Y. Bengio, Random search for hyper-parameter optimization, J. Mach. Learn. Res. 13 (2012) 281–305.

[06] J. Snoek, H. Larochelle, R. P. Adams, Practical bayesian optimization ofmachine learning algorithms, in: F. Pereira, C. Burges, L. Bottou, K. Weinberger (Eds.), Advances in Neural Information Processing Systems 25, Cur-ran Associates, Inc., 2012, pp. 2951–2959.

[07] M. López-Ibáñez, J. Dubois-Lacoste, L. Pérez Cáceres, T. Stützle, and M.Birattari. The irace package: Iterated Racing for Automatic Algorithm Configuration. Operations Research Perspectives, 2016.

[08] J. Kennedy,  R. Eberhart, Particle swarm optimization. In: Proceedingsof the IEEE International Conference on Neural Networks, Vol. 4, Perth,Australia, 1995, pp. 1942 – 1948.

[09] D. Goldberg, Genetic Algorithms in Search, Optimization and Machine Learning, Addison Wesley, 1989.

[10] M. Hauschild,  M. Pelikan. An introduction and survey of estimation of distribution algorithms, Swarm and Evolutionary Computation (3) (2011)111 – 128.

### Citation

If you use our code/experiments in your research, please, cite one of our papers where this project was first used:

TODO: Add refs and bibtex entry
