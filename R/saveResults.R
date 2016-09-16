# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

saveResults = function(res, task, output.dir, tuning = NULL) {

  cat(" - Saving results ... ")
  
  ret.perf = getBMRPerformances(res, as.df = TRUE)
  save(ret.perf, file = paste0(output.dir, "/perf_", getTaskId(task), ".RData"))

  ret.pred = getBMRPredictions(bmr = res, as.df = TRUE)
  save(ret.pred, file = paste0(output.dir, "/preds_", getTaskId(task), ".RData"))

  # saving the trace
  if(tuning != "defaults" & !is.null(tuning)) {
    ret.params.list = getBMRTuneResults(bmr = res)
    save(ret.params.list, file = paste0(output.dir, "/opt_params_", getTaskId(task), ".RData"))
  }

  catf(" SAVED!")
  return(ret.perf)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
