#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getSMBOControl = function(par.set, budget, n.init.points = 10) {

  ctrl = makeMBOControl(
    impute.y.fun = function(x, y, opt.path) { return(0) }
  )

  ctrl = setMBOControlTermination(ctrl, iters = budget - n.init.points)
  ctrl = setMBOControlInfill(ctrl, crit = "ei", opt = "focussearch", opt.restarts = 2L,
    opt.focussearch.points = 500L)
  design = generateRandomDesign(n = n.init.points, par.set = par.set)

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