#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

  devtools::load_all()

  datafile = "iris.arff"
  
  algo     = "classif.J48"
  # algo     = "classif.svm"
  # tuning   = "mbo"
  # tuning   = "random"
  # tuning   = "defaults"
  tuning = "irace"

  rep      = 4

  checkArgs(datafile = datafile, algo = algo, tuning = tuning, rep = rep)

  base.name = gsub(x = datafile, pattern = ".arff", replacement = "")
  output.dir = paste0("output/", base.name, "/", algo, "/", tuning, "/rep", rep)

  if(!dir.exists(output.dir)) {
    dir.create(path = output.dir, recursive = TRUE)
    catf(paste0(" - Creating dir: ", output.dir))
  }

  catf(paste0(" @ Loading dataset: ", datafile))
  data = foreign::read.arff(paste0("data/", datafile))

  task = makeClassifTask(
    id = base.name,
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

    par.set = getHyperSpace(learner = learner, p = mlr::getTaskNFeats(task))
    BUDGET  = 20

    if(tuning == "random") {
      ctrl = makeTuneControlRandom(maxit = BUDGET)
    } else if(tuning == "mbo") {
      ctrl = getSMBOControl(par.set = par.set, budget = BUDGET)
    } else if(tuning == "irace") {
      ctrl = makeTuneControlIrace(budget = BUDGET, nbIterations = 1L, minNbSurvival = 1)
    }
    # New wrapper tuned learner 
    new.lrn = makeTuneWrapper(learner = learner, resampling = inner.cv,
      measure = acc, par.set = par.set, control = ctrl, show.info = TRUE)
  }

  # Running: dataset + learner + tuning method
  res = benchmark(learners = new.lrn, tasks = list(task), resamplings = outer.cv, 
    measures = measures, show.info = TRUE, models = FALSE)

  # Saving results
  ret = saveResults(res = res, task = task, output.dir = output.dir, tuning = tuning)
  print(ret)

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
