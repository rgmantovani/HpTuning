#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

runTuning = function(datafile, algo, tuning, rep) {

  output.dir = paste0("output/", datafile, "/", algo, "/", tuning, "/rep", rep)

  if(!dir.exists(output.dir)) {
    dir.create(path = output.dir, recursive = TRUE)
    cat(paste0(" - Creating dir: ", output.dir, "\n"))
  }

  #check if the output already exists
  if(file.exists(paste0(output.dir, "/perf_", datafile, ".RData"))) {
     warningf("Job already finished!")
  } else{

    cat(paste0(" @ Loading dataset: ", datafile, "\n"))
    data = foreign::read.arff(paste0("data/", datafile, ".arff"))

    task = makeClassifTask(
      id = datafile,
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

      par.set = getHyperSpace(learner = learner, p = mlr::getTaskNFeats(task), 
        n = mlr::getTaskSize(task))
      BUDGET  = TUNING_CONSTANT * length(par.set$pars)
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

    saveResults(res = res, task = task, output.dir = output.dir, tuning = tuning)
  }

}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
