# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getJ48Space = function(...) {
  args = list(...)
  par.set = makeParamSet(
    makeLogicalLearnerParam(id = "O", default = FALSE),
    makeLogicalLearnerParam(id = "R", default = FALSE),
    makeNumericLearnerParam(id = "C", default = 0.25, lower = 0.001, upper = 0.5, requires = quote(R == FALSE)),
    makeIntegerLearnerParam(id = "M", default = 2L, lower = 1L, upper = 50L),
    makeIntegerLearnerParam(id = "N", default = 3L, lower = 2L, upper = 10, requires = quote(R == TRUE)),
    makeLogicalLearnerParam(id = "B", default = FALSE),
    makeLogicalLearnerParam(id = "S", default = FALSE),
    makeLogicalLearnerParam(id = "A", default = FALSE),
    makeLogicalLearnerParam(id = "J", default = FALSE)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getRangerSpace = function(...) {
  args = list(...)
  par.set = makeParamSet(
    makeIntegerParam("mtry", lower = round(args$p ^ 0.1), upper = round(args$p ^ 0.9)),
    makeIntegerParam("num.trees", lower = 0, upper=10, trafo = function(x) 2^x)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getKknnSpace = function(...) {
  par.set = makeParamSet(
    makeIntegerParam("k", lower = 1, upper = 50, default = 1)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getSvmSpace = function(...) {
  par.set = makeParamSet(
    makeDiscreteParam("kernel", values = "radial", default = "radial", tunable = FALSE),
    makeNumericParam("cost" , lower = -12, upper = 12, trafo = function(x) 2^x),
    makeNumericParam("gamma", lower = -12, upper = 12, trafo = function(x) 2^x)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getRpartSpace = function(...) {
  args = list(...)
  par.set = makeParamSet(
    makeNumericParam("cp", lower = -4, upper = -1, trafo = function(x) 10^x),
    makeIntegerParam("minsplit", lower = 1, upper = min(7, floor(log2(args$n))), 
      trafo = function(x) 2^x),
    makeIntegerParam("minbucket", lower = 0, upper = min(6, floor(log2(args$n))), 
      trafo = function(x) 2^x)
  )
  return(par.set)  
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getGbmSpace = function(...) {
  par.set = makeParamSet(
    makeIntegerParam("n.trees", lower = 500, upper = 10000),
    makeIntegerParam("interaction.depth", lower = 1, upper = 5),
    makeNumericParam("shrinkage", lower = -4, upper = -1, trafo = function(x) 10^x)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getNaiveBayesSpace = function(...) {
  par.set =  makeParamSet()
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
