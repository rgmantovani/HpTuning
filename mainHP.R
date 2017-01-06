#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

mainHP = function(datafile = NULL, algo = NULL, tuning = NULL, rep = NULL) {

  devtools::load_all()

  assertChoice(x = tuning, choices = AVAILABLE.TUNNERS, .var.name = "tuning")
  sub.data = gsub(x = list.files(path = "data/"), pattern = ".arff", replacement = "")
  assertChoice(x = datafile, choices = sub.data, .var.name = "datafile")
  assertChoice(x = algo, choices = AVAILABLE.LEARNERS, .var.name = "algo")
  assertInt(x = rep, lower = 1, upper = 30, .var.name = "rep")

  set.seed(rep)

  cat(paste0(" - Datafile: \t", datafile, "\n"))
  cat(paste0(" - Algorithm: \t", algo, "\n"))
  cat(paste0(" - Tuning: \t", tuning, "\n"))
  cat(paste0(" - Repetition: \t", rep, "\n"))

  runTuning(datafile = datafile, algo = algo, tuning = tuning, rep = rep)
  
  cat("Done!")
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
mainHP(datafile = argsL[[1]], algo = argsL[[2]], tuning = argsL[[3]], 
  rep = as.integer(argsL[[4]]))

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------