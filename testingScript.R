#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

  devtools::load_all()

  datafile = "iris"
  # datafile = "glass"
  
  # algo     = "classif.J48"
  # algo     = "classif.svm"
  algo     = "classif.rpart"
  
  # tuning   = "mbo"
  # tuning   = "random"
  tuning   = "defaults"
  # tuning = "irace"
  
  rep      = 8

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

    outer.cv = makeResampleDesc(method = "CV", iter = 2)
    inner.cv = makeResampleDesc(method = "CV", iter = 3)

    measures = list(ber, acc, timetrain, timepredict)
    learner = getLearner(algo = algo)

    if(tuning == "defaults") {
      new.lrn = learner
    } else {

      par.set = getHyperSpace(learner = learner, p = mlr::getTaskNFeats(task), 
        n = mlr::getTaskSize(task))

      BUDGET  = 10 #50
      cat(paste0(" @ budget: ", BUDGET, "\n"))

      switch(tuning,
        random = { ctrl = makeTuneControlRandom(maxit = BUDGET)},
        mbo    = { ctrl = getSMBOControl(par.set = par.set, budget = BUDGET)},
        irace  = { ctrl = makeTuneControlIrace(budget = BUDGET, nbIterations = 1L, minNbSurvival = 1)}
      )

      # New wrapper tuned learner 
      new.lrn = makeTuneWrapper(learner = learner, resampling = inner.cv,
        measure = ber, par.set = par.set, control = ctrl, show.info = TRUE)
    }

    # Running: dataset + learner + tuning method
    res = benchmark(learners = new.lrn, tasks = list(task), resamplings = outer.cv, 
      measures = measures, show.info = TRUE, models = FALSE)

    # Saving results
    saveResults(res = res, task = task, output.dir = output.dir, tuning = tuning)
  }

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
