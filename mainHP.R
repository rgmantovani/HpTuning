#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

mainMetaLevel = function(datafile = NULL, algo = NULL, tuning = NULL, rep = NULL) {

  devtools::load_all()

  assertChoice(x = tuning, choices = c("random", "defaults", "mbo", "irace"), .var.name = "tuning")
  assertChoice(x = datafile, choices = list.files(path = "data/"), .var.name = "datafile")
  assertChoice(x = algo, choices = c("classif.svm", "classif.J48"), .var.name = "algo")
  assertInt(x = rep, lower = 1, upper = 30, .var.name = "rep")

  catf(paste0(" - Datafile: \t", datafile))
  catf(paste0(" - Algorithm: \t", algo))
  catf(paste0(" - Tuning: \t", tuning))
  catf(paste0(" - Repetition: \t", rep))

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

  outer.cv = makeResampleDesc(method = "CV", iter = OUTER_FOLDS)
  inner.cv = makeResampleDesc(method = "CV", iter = INNER_FOLDS)

  measures = list(ber, acc, timetrain, timepredict)
  learner = getLearner(algo = algo)

  if(tuning == "defaults") {
    new.lrn = learner
  } else {

    par.set = getHyperSpace(learner = learner, p = mlr::getTaskNFeats(task))
    BUDGET  = TUNING_CONSTANT * length(par.set)

    if(tuning == "random") {
      ctrl = makeTuneControlRandom(maxit = BUDGET)
    } else if(tuning == "mbo") {
      ctrl = getSMBOControl(par.set = par.set, budget = BUDGET)
    } else if(tuning == "irace") {
      ctrl = makeTuneControlIrace(budget = BUDGET, nbIterations = 4, minNbSurvival = 4)
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

  catf("Done!")
}


#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

# parse params and call main
options(echo = TRUE) 
args = commandArgs(trailingOnly = TRUE)

# Parse arguments (we expect the form --arg=value)
parseArgs = function(x) strsplit(sub("^--", "", x), "=")
argsDF = as.data.frame(do.call("rbind", parseArgs(args)))
argsL = as.list(as.character(argsDF$V2))

# Calling execution with the arguments
mainMetaLevel(datafile = argsL[[1]], algo = argsL[[2]], tuning = argsL[[3]], rep = argsL[[4]])

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------