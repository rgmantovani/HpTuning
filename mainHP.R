#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

mainMetaLevel = function(datafile = NULL, algo = NULL, tuning = NULL, rep = NULL) {

  devtools::load_all()
  checkArgs(datafile = datafile, algo = algo, tuning = tuning, rep = rep)

  base.name = gsub(x = datafile, pattern = "_space.RData", replacement = "")
  output.dir = paste0("output/meta/", base.name, "/", algo, "/", tuning)

  if(!dir.exists(output.dir)) {
    dir.create(path = output.dir, recursive = TRUE)
    catf(paste0(" - Creating dir: ", output.dir))
  }

  catf(paste0(" @ Loading dataset: ", datafile))
  data = foreign::read.arff(paste0("data/", datafile))

  task = makeClassifTask(
    id = gsub(x = datafile, pattern = ".arff", replacement = ""),
    data = data,
    target = "Class",
  )

  outer.cv = makeResampleDesc(method = "CV", iter = OUTER_FOLDS)
  inner.cv = makeResampleDesc(method = "CV", iter = INNER_FOLDS)
  measures = list(ber, acc, f1, gmean, timetrain, timepredict)

  learner = getLearner(algo = algo)
  par.set = getHyperSpace(learner = learner)

  if(tuning == "defaults") {
    new.lrn = learner
  } else {

    par.set = getHyperSpace(learner = learner, p = mlr::getTaskNFeats(task))

    if(tuning == "random") {
      ctrl = makeTuneControlRandom(maxit = BUDGET)
    } else if(tuning == "mbo") {
      ctrl = getSMBOControl(par.set = par.set, budget = BUDGET)
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
  return(ret)

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