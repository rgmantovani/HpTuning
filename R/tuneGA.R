#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

# TODO: add suppor to discrete params

tuneGA = function(learner, task, resampling, measures, par.set, control, opt.path, show.info,
  resample.fun) {

  requirePackages("GA", why = "tuneGA", default.method = "load")

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

  ctrl.ga = control$extra.args
  maxf = ctrl.ga$pop.size  * ctrl.ga$maxit

  if (is.null(control$budget)) {
    control$budget = maxf
  } else {
    if (maxf != control$budget) {
      stopf("The given budget (%i) contradicts to the maximum number of function evaluations (maxf = %i).",
        control$budget, maxf)
    }
  }

  res = GA::ga(type = "real-valued", fitness = mlr:::tunerFitnFun, learner = learner, task = task,
    resampling = resampling, measures = measures, par.set = par.set, ctrl = control,
    opt.path = opt.path, show.info = show.info, resample.fun = resample.fun, convertx = cx,
    remove.nas = TRUE, min = low, max = upp, maxiter = ctrl.ga$maxit, run = ctrl.ga$maxit,
    popSize = ctrl.ga$pop.size , pcrossover = ctrl.ga$prob.crossover,
    pmutation = ctrl.ga$prob.mutation, suggestions = start, monitor = NULL)

  tune.result = mlr:::makeTuneResultFromOptPath(learner = learner, par.set = par.set,
    resampling = resampling, measures = measures, control  = control, opt.path = opt.path)

  return(tune.result)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
