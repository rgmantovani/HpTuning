#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

  devtools::load_all(path = "../R")

  # it is not being loaded (still do not know why)
  library(BBmisc)

  unlockBinding("tuneParams", as.environment("package:mlr"))

  assignInNamespace("tuneParams", myTuneParams, ns="mlr",
    envir=as.environment("package:mlr"))

  assign("tuneParams", myTuneParams, as.environment("package:mlr"))
  lockBinding("tuneParams", as.environment("package:mlr"))

  assignInNamespace("checkTunerParset", myCheckTunerParset, ns="mlr",
    envir=as.environment("package:mlr"))

  # Note: All work for Ctree
  # args = c("iris", "classif.ctree", "defaults", 24) # ok
  # args = c("iris", "classif.ctree", "random", 25)   # ok
  # args = c("iris", "classif.ctree", "mbo", 24)      # ok
  # args = c("iris", "classif.ctree", "irace", 5)     # ok
  # args = c("iris", "classif.ctree", "pso", 2)       # ok
  # args = c("iris", "classif.ctree", "eda", 24)      # ok
  # args = c("iris", "classif.ctree", "ga", 24)       # ok

  # Note: All work for xGboost
  # args = c("iris", "classif.xgboost", "defaults",3)
  # args = c("iris", "classif.xgboost", "irace", 3)
  # args = c("iris", "classif.xgboost", "ga", 3)
  # args = c("iris", "classif.xgboost", "eda", 3)
  # args = c("iris", "classif.xgboost", "pso", 3)
  # args = c("iris", "classif.xgboost", "mbo", 3)

  # Note: All work for SVMs
  # args = c("iris", "classif.svm", "defaults", 24) # ok
  # args = c("iris", "classif.svm", "random", 24)   # ok
  args = c("iris", "classif.svm", "mbo", 24)      # ok
  # args = c("iris", "classif.svm", "irace", 24)    # ok
  # args = c("iris", "classif.svm", "pso", 15)       # ok
  # args = c("iris", "classif.svm", "eda", 24)      # ok
  # args = c("iris", "classif.svm", "ga", 24)       # ok

  # Note: All work for J48
  # args = c("iris", "classif.J48", "defaults", 24) # ok
  # args = c("iris", "classif.J48", "random", 24)   # ok
  # args = c("iris", "classif.J48", "mbo", 24)      # ok
  # args = c("iris", "classif.J48", "irace", 24)    # ok
  # args = c("iris", "classif.J48", "pso", 2)       # ok
  # args = c("iris", "classif.J48", "ga", 20)       # ok
  # args = c("iris", "classif.J48", "eda", 20)      # ok

  # Note: All work for rpart
  # args = c("iris", "classif.rpart", "defaults", 24)# ok
  # args = c("iris", "classif.rpart", "random", 24)  # ok
  # args = c("iris", "classif.rpart", "mbo", 24)     # ok
  # args = c("iris", "classif.rpart", "irace", 24)   # ok
  # args = c("iris", "classif.rpart", "pso", 2)      # ok
  # args = c("iris", "classif.rpart", "eda", 24)     # ok
  # args = c("iris", "classif.rpart", "ga", 24)      # ok

  # Note: All work for randomforest
  # args = c("iris", "classif.randomForest", "defaults", 23) # ok
  # args = c("iris", "classif.randomForest", "mbo", 24)      # ok
  # args = c("iris", "classif.randomForest", "random", 20)   # ok
  # args = c("iris", "classif.randomForest", "irace", 24)    # ok
  # args = c("iris", "classif.randomForest", "pso", 2)       # ok
  # args = c("iris", "classif.randomForest", "eda", 24)      # ok
  # args = c("iris", "classif.randomForest", "ga", 24)       # ok

  # Note: All works for C5.0
  # args = c("iris", "classif.C50", "defaults", 24) # ok
  # args = c("iris", "classif.C50", "random", 24)   # ok
  # args = c("iris", "classif.C50", "mbo", 24)      # ok
  # args = c("iris", "classif.C50", "irace", 24)    # ok
  # args = c("iris", "classif.C50", "pso", 2)       # ok
  # args = c("iris", "classif.C50", "ga", 20)       # ok
  # args = c("iris", "classif.C50", "eda", 20)      # ok

  # Note: some works for kknn
  # args = c("iris", "classif.kknn", "defaults", 24) # ok
  # args = c("iris", "classif.kknn", "random", 24)   # ok
  # args = c("iris", "classif.kknn", "mbo", 24)      # ok
  # args = c("iris", "classif.kknn", "irace", 24)    # ok
  # args = c("iris", "classif.kknn", "pso", 2)       # ok
  # args = c("iris", "classif.kknn", "ga", 20)       # ok
  # args = c("iris", "classif.kknn", "eda", 20)      # not (check eda configurations)

  # Note: just defaults works for Naive Bayes (there are no HPs)
  # args = c("iris", "classif.naiveBayes", "defaults", 24) # ok
  # args = c("iris", "classif.naiveBayes", "random", 24)   # ok



  datafile = args[[1]]
  algo     = args[[2]]
  tuning   = args[[3]]
  rep      = as.integer(args[[4]])

  set.seed(rep)

  # Checking params values
  assertChoice(x = tuning, choices = AVAILABLE.TUNNERS, .var.name = "tuning")
  sub.data = gsub(x = list.files(path = "../data/"), pattern = ".arff", replacement = "")
  assertChoice(x = datafile, choices = sub.data, .var.name = "datafile")
  assertChoice(x = algo, choices = AVAILABLE.LEARNERS, .var.name = "algo")
  assertInt(x = rep, lower = 1, upper = 30, .var.name = "rep")

  cat(paste0(" - Datafile: \t", datafile, "\n"))
  cat(paste0(" - Algorithm: \t", algo, "\n"))
  cat(paste0(" - Tuning: \t", tuning, "\n"))
  cat(paste0(" - Repetition: \t", rep, "\n"))

  output.dir = paste0("../", "output/", datafile, "/", algo, "/", tuning, "/rep", rep)

  if(!dir.exists(output.dir)) {
    dir.create(path = output.dir, recursive = TRUE)
    cat(paste0(" - Creating dir: ", output.dir, "\n"))
  }

  if(file.exists(paste0("../", output.dir, "/perf_", datafile, ".RData"))) {
    warningf("Job already finished!\n")
  } else {

    cat(paste0(" @ Loading dataset: ", datafile, "\n"))
    data = foreign::read.arff(paste0("../data/", datafile, ".arff"))

    task = makeClassifTask(
      id = datafile,
      data = data,
      target = "Class",
    )

    outer.cv = makeResampleDesc(method = "CV", iter = 2, stratify = TRUE)
    inner.cv = makeResampleDesc(method = "CV", iter = 3, stratify = TRUE)

    measures = list(ber, acc, timetrain, timepredict)
    learner = getLearner(algo = algo)

    if(tuning == "defaults") {
      new.lrn = learner
    } else {

      par.set = getHyperSpace(learner = learner, p = mlr::getTaskNFeats(task),
        n = mlr::getTaskSize(task))

      BUDGET  = 50
      cat(paste0(" @ budget: ", BUDGET, "\n"))

      switch(tuning,
        random = { ctrl = makeTuneControlRandom(maxit = BUDGET)},
        mbo    = { ctrl = getSMBOControl(par.set = par.set, budget = BUDGET, n.init.points = 10)},
        irace  = { ctrl = makeTuneControlIrace(budget = BUDGET, nbIterations = 1L, minNbSurvival = 1)},
        pso    = { ctrl = makeTuneControlPSO(n.particles = POP.SIZE, maxit = 2)},
        ga     = { ctrl = makeTuneControlGA(pop.size = POP.SIZE, maxit = 2)},
        eda    = { ctrl = makeTuneControlEDA(pop.size = POP.SIZE, maxit = 2)}
      )

      # New wrapper tuned learner
      new.lrn = makeTuneWrapper(learner = learner, resampling = inner.cv,
        measure = list(ber, timetrain, timepredict), par.set = par.set, control = ctrl,
        show.info = TRUE)
    }

    # Running: dataset + learner + tuning method
    res = benchmark(learners = new.lrn, tasks = list(task), resamplings = outer.cv,
      measures = measures, show.info = TRUE, keep.pred = TRUE, models = FALSE)

    # Saving results
    saveResults(res = res, task = task, output.dir = output.dir, tuning = tuning)
  }

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
