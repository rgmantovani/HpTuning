#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

tunePSO = function(learner, task, resampling, measures, par.set, control, opt.path, show.info,
  resample.fun) {

  requirePackages("pso", why = "tunePSO", default.method = "load")

  par.set = convertParamsTypes(par.set = par.set)
  cx = function(x, par.set) {
    customizedConverter(x = x, par.set = par.set)
  }

  low = ParamHelpers::getLower(par.set)
  upp = ParamHelpers::getUpper(par.set)
  start = control$start

  if (is.null(start)) {
    start = sampleValue(par = par.set, discrete.names = FALSE, trafo = FALSE)
  }
  start = mlr:::convertStartToNumeric(start, par.set)

  ctrl.pso = list(trace = 0, trace.stats = NULL)
  ctrl.pso = insert(ctrl.pso, control$extra.args)
  assertInt(x = ctrl.pso$n.particles, lower = 10, null.ok = TRUE, .var.name = "n.particles")

  if(is.null(ctrl.pso$maxit)) {
    ctrl.pso$maxit = 100L
  }

  if (is.null(ctrl.pso$n.particles)) {
    if (ctrl.pso$pso.impl == "SPSO2011") {
      ctrl.pso$s = 40L
    } else {
      ctrl.pso$s = floor(10+2*sqrt(length(par.set)))
    }
  } else {
    ctrl.pso$s = ctrl.pso$n.particles
    ctrl.pso$n.particles = NULL
  }
  ctrl.pso$pso.impl = NULL

  ctrl.pso$maxf = (ctrl.pso$s * ctrl.pso$maxit)
  if (is.null(control$budget)){
    control$budget = ctrl.pso$maxf
  } else {
    if(ctrl.pso$maxf != control$budget) {
      stopf("The given budget (%i) contradicts to the maximum number of function evaluations (maxf = %i).",
      control$budget, ctrl.pso$maxf)
    }
  }

  res = pso::psoptim(par = unlist(start), fn = mlr:::tunerFitnFun, learner = learner, task = task,
    resampling = resampling, measures = measures, par.set = par.set, ctrl = control,
    opt.path = opt.path, show.info = show.info, resample.fun = resample.fun, convertx = cx,
    remove.nas = TRUE, lower = low, upper = upp, control = ctrl.pso)

  tune.result = mlr:::makeTuneResultFromOptPath(learner = learner, par.set = par.set,
    resampling = resampling, measures = measures, control  = control, opt.path = opt.path)

  return(tune.result)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
