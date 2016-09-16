#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getSMBOControl = function(par.set, budget) {

  ctrl = makeMBOControl(impute.y.fun = function(x, y, opt.path) 0)
  ctrl = setMBOControlTermination(ctrl, iters = budget)
  ctrl = setMBOControlInfill(ctrl, crit = "ei", opt = "focussearch", opt.restarts = 2L,
    opt.focussearch.points = 500L)
  design = generateRandomDesign(n = 10, par.set = par.set)

  surrogate.model = makeImputeWrapper(
    learner = makeLearner("regr.randomForest", 
      predict.type = "se", 
      config = list(on.learner.error = "warn")),
    classes = list(numeric = imputeMedian(), factor = imputeMode())
  )
  
  ctrl = mlr:::makeTuneControlMBO(learner = surrogate.model, mbo.control = ctrl, mbo.design = design)
  return(ctrl)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------