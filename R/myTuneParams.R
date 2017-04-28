#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

myTuneParams = function(learner, task, resampling, measures, par.set, control, show.info = getMlrOption("show.info"), 
  resample.fun = resample) { 

  learner = mlr:::checkLearner(learner)
  assertClass(task, classes = "Task")
  measures = mlr:::checkMeasures(measures, learner)
  assertClass(par.set, classes = "ParamSet")
  assertClass(control, classes = "TuneControl")
  assertFunction(resample.fun)
  if (!inherits(resampling, "ResampleDesc") &&  !inherits(resampling, "ResampleInstance"))
    stop("Argument resampling must be of class ResampleDesc or ResampleInstance!")
  if (inherits(resampling, "ResampleDesc") && control$same.resampling.instance)
    resampling = makeResampleInstance(resampling, task = task)
  assertFlag(show.info)
  mlr:::checkTunerParset(learner, par.set, measures, control)
  control = mlr:::setDefaultImputeVal(control, measures)

  cl = getClass1(control)
  sel.func = switch(cl,
    TuneControlRandom =  mlr:::tuneRandom,
    TuneControlGrid   =  mlr:::tuneGrid,
    TuneControlDesign =  mlr:::tuneDesign,
    TuneControlCMAES  =  mlr:::tuneCMAES,
    TuneControlGenSA  =  mlr:::tuneGenSA,
    TuneControlMBO    =  mlr:::tuneMBO,
    TuneControlIrace  =  mlr:::tuneIrace,
    TuneControlPSO    = tunePSO,
    TuneControlGA     = tuneGA, 
    TuneControlEDA    = tuneEDA,
    stopf("Tuning algorithm for '%s' does not exist!", cl)
  )

  need.extra = control$tune.threshold || mlr:::getMlrOption("on.error.dump")
  opt.path = mlr:::makeOptPathDFFromMeasures(par.set, measures, include.extra = need.extra)
  if (show.info) {
    messagef("[Tune] Started tuning learner %s for parameter set:", learner$id)
    message(printToChar(par.set)) 
    messagef("With control class: %s", cl)
    messagef("Imputation value: %g", control$impute.val)
  }
  or = sel.func(learner, task, resampling, measures, par.set, control, opt.path, show.info, resample.fun)
  if (show.info)
    messagef("[Tune] Result: %s : %s", paramValueToString(par.set, or$x), mlr:::perfsToString(or$y))
  return(or)
}


#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------