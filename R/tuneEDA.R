#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

tuneEDA = function(learner, task, resampling, measures, par.set, control, opt.path, show.info) {
  requirePackages("copulaedas", why = "tuneEDA", default.method = "load")
  
  # if there is logical parameter
  if(any(unlist(lapply(par.set$pars, function(par) { par$type == "logical"})))) {
    par.set = convertLogicalToInteger(par.set = par.set)
    cx = function(x, par.set) { customizedConverter(x, par.set) }
  } else {
    cx = function(x, par.set) mlr:::convertXNumeric(x, par.set)
  }

  low = ParamHelpers::getLower(par.set)
  upp = ParamHelpers::getUpper(par.set)
  start = control$start

  if (is.null(start))
    start = sampleValue(par.set, start, trafo = FALSE)
  start = mlr:::convertStartToNumeric(start, par.set)

  ctrl.eda = control$extra.args
 
  maxf = ctrl.eda$pop.size * ctrl.eda$maxit
  if (is.null(control$budget)) {
    control$budget = maxf
  } else {
    if (maxf != control$budget) {
      stopf("The given budget (%i) contradicts to the maximum number of function evaluations (maxf = %i).",
        control$budget, maxf)
    }
  }

  if (ctrl.eda$eda.impl == "UMDA") {
	  model = copulaedas::CEDA(copula = "indep", margin = "truncnorm", popSize = ctrl.eda$pop.size,
	    maxGens = ctrl.eda$maxit)
  } else if (ctrl.eda$eda.impl == "GCEDA") {
	  model = copulaedas::CEDA(copula = "normal", margin = "truncnorm", popSize = ctrl.eda$pop.size,
	    maxGens = ctrl.eda$maxit)
  } else if (ctrl.eda$eda.impl == "CVEDA") {
  	model = copulaedas::VEDA(vine = "CVine", indepTestSigLevel = 0.01, copulas = c("normal"),
  	  margin = "truncnorm", popSize = ctrl.eda$pop.size, maxGens = ctrl.eda$maxit)
  } else {
 	  model = copulaedas::VEDA(vine = "DVine", indepTestSigLevel = 0.01, copulas = c("normal"),
 	    margin = "truncnorm", popSize = ctrl.eda$pop.size, maxGens = ctrl.eda$maxit)
  }

  copulaedas::edaSeedUniform(model, lower = low, upper = upp)

  tunerFitFunWrapper = function(learner = learner, tasks = task, resampling = resampling,
    measures = measures, par.set = par.set, ctrl = ctrl, opt.path = opt.path, show.info = show.info,
    convertx = convertx, remove.nas = remove.nas) {
  	temp = function(x) {
		return( mlr:::tunerFitnFun (x, learner, task, resampling, measures, par.set, ctrl, opt.path,
  	  show.info, convertx, remove.nas))
  	}
  }

  res = copulaedas::edaRun(model, f = tunerFitFunWrapper(learner = learner, task = task,
  	resampling = resampling, measures = measures, par.set = par.set, ctrl = control,
    opt.path = opt.path, show.info = show.info, convertx = cx, remove.nas = TRUE),
    lower = low, upper = upp)

  tune.result = mlr:::makeTuneResultFromOptPath(learner, par.set, measures, control, opt.path)
  return(tune.result)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

