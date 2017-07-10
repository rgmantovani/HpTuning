#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

  devtools::load_all()
 
  unlockBinding("tuneParams", as.environment("package:mlr"))
  assignInNamespace("tuneParams", myTuneParams, ns="mlr", envir=as.environment("package:mlr"))
  assign("tuneParams", myTuneParams, as.environment("package:mlr"))
  lockBinding("tuneParams", as.environment("package:mlr"))

  assignInNamespace("checkTunerParset", myCheckTunerParset, ns="mlr", envir=as.environment("package:mlr"))

  # Note: All works for SVMs
  # args = c("iris", "classif.svm", "defaults", 24) # ok
  # args = c("iris", "classif.svm", "random", 24)   # ok 
  # args = c("iris", "classif.svm", "mbo", 24)      # ok 
  # args = c("iris", "classif.svm", "irace", 24)    # ok
  # args = c("iris", "classif.svm", "pso", 24)      # ok
  # args = c("iris", "classif.svm", "eda", 24)      # ok
  # args = c("iris", "classif.svm", "ga", 24)       # ok

  # Note: All works for J48
  # args = c("iris", "classif.J48", "defaults", 24) # ok
  # args = c("iris", "classif.J48", "random", 24)   # ok
  # args = c("iris", "classif.J48", "mbo", 24)      # ok
  # args = c("iris", "classif.J48", "irace", 24)    # ok
  # args = c("iris", "classif.J48", "pso", 20)      # ok 
  # args = c("iris", "classif.J48", "ga", 20)       # ok
  # args = c("iris", "classif.J48", "eda", 20)      # ok

  # Note: All works for rpart
  # args = c("iris", "classif.rpart", "defaults", 24)# ok
  # args = c("iris", "classif.rpart", "random", 24)  # ok
  # args = c("iris", "classif.rpart", "mbo", 24)     # ok
  # args = c("iris", "classif.rpart", "irace", 24)   # ok
  # args = c("iris", "classif.rpart", "pso", 24)     # ok
  # args = c("iris", "classif.rpart", "eda", 24)     # ok
  # args = c("iris", "classif.rpart", "ga", 24)      # ok

  # args = c("iris", "classif.randomForest", "defaults", 23) # ok
  # args = c("iris", "classif.randomForest", "mbo", 24)      # ok
  # args = c("iris", "classif.randomForest", "random", 20)    # ok
  # args = c("iris", "classif.randomForest", "irace", 24)    # ok
  # args = c("iris", "classif.randomForest", "pso", 24)      # ok
  # args = c("iris", "classif.randomForest", "eda", 24)      # ok
  # args = c("iris", "classif.randomForest", "ga", 24)       # ok

  # args = c("20_mfeat-pixel", "classif.J48", "defaults", 24)  # ok
  # args = c("299_libras_move", "classif.J48", "defaults", 24)  # ok
  # args = c("338_grub-damage", "classif.J48", "defaults", 24) #ok
  # args = c("685_visualizing_livestock", "classif.J48", "defaults", 24) #ok
  # args = c("1100_PopularKids", "classif.J48", "defaults", 24) #ok
  # args = c("1500_seismic-bumps", "classif.J48", "defaults", 24)#ok
  # args = c("1519_robot-failures-lp4", "classif.J48", "defaults", 24)
  # args = c("1520_robot-failures-lp5", "classif.J48", "defaults", 24) #ok


  datafile = args[[1]]
  algo     = args[[2]]
  tuning   = args[[3]] 
  rep      = as.integer(args[[4]])

  set.seed(rep)

  # Checking params values
  assertChoice(x = tuning, choices = AVAILABLE.TUNNERS, .var.name = "tuning")
  sub.data = gsub(x = list.files(path = "data/"), pattern = ".arff", replacement = "")
  assertChoice(x = datafile, choices = sub.data, .var.name = "datafile")
  assertChoice(x = algo, choices = AVAILABLE.LEARNERS, .var.name = "algo")
  assertInt(x = rep, lower = 1, upper = 30, .var.name = "rep")

  cat(paste0(" - Datafile: \t", datafile, "\n"))
  cat(paste0(" - Algorithm: \t", algo, "\n"))
  cat(paste0(" - Tuning: \t", tuning, "\n"))
  cat(paste0(" - Repetition: \t", rep, "\n"))

  output.dir = paste0("output/", datafile, "/", algo, "/", tuning, "/rep", rep)

  if(!dir.exists(output.dir)) {
    dir.create(path = output.dir, recursive = TRUE)
    cat(paste0(" - Creating dir: ", output.dir, "\n"))
  }

  if(file.exists(paste0(output.dir, "/perf_", datafile, ".RData"))) {
    warningf("Job already finished!\n")
  } else {

    cat(paste0(" @ Loading dataset: ", datafile, "\n"))
    data = foreign::read.arff(paste0("data/", datafile, ".arff"))

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
        pso    = { ctrl = makeTuneControlPSO(n.particles = POP.SIZE, maxit = 5)},
        ga     = { ctrl = makeTuneControlGA(pop.size = POP.SIZE, maxit = 5)},
        eda    = { ctrl = makeTuneControlEDA(pop.size = POP.SIZE, maxit = 5)}
      )

      # New wrapper tuned learner 
      new.lrn = makeTuneWrapper(learner = learner, resampling = inner.cv,
        measure = list(ber, timetrain, timepredict), par.set = par.set, control = ctrl, show.info = TRUE)
    }

    # Running: dataset + learner + tuning method
    res = benchmark(learners = new.lrn, tasks = list(task), resamplings = outer.cv, 
      measures = measures, show.info = TRUE, keep.pred = TRUE, models = FALSE)

    # Saving results
    saveResults(res = res, task = task, output.dir = output.dir, tuning = tuning)
  }

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
