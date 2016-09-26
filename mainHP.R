#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

mainMetaLevel = function(datafile = NULL, algo = NULL, tuning = NULL, rep = NULL) {

  devtools::load_all()

  assertChoice(x = tuning, choices = c("random", "defaults", "mbo", "irace"), .var.name = "tuning")
  sub.data = gsub(x = list.files(path = "data/"), pattern = ".arff", replacement = "")
  assertChoice(x = datafile, choices = sub.data, .var.name = "datafile")
  assertChoice(x = algo, choices = c("classif.svm", "classif.J48"), .var.name = "algo")
  assertInt(x = rep, lower = 1, upper = 30, .var.name = "rep")

  catf(paste0(" - Datafile: \t", datafile))
  catf(paste0(" - Algorithm: \t", algo))
  catf(paste0(" - Tuning: \t", tuning))
  catf(paste0(" - Repetition: \t", rep))

  runTuning(datafile = datafile, algo = algo, tuning = tuning, rep = rep)
  
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
mainMetaLevel(datafile = argsL[[1]], algo = argsL[[2]], tuning = argsL[[3]], 
  rep = as.integer(argsL[[4]]))

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------