#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getHyperSpace = function(learner, ...) {

  temp = gsub(x = learner$id, pattern = ".preproc", replacement = "")
  name = sub('classif.', '', temp)
  name = sub('.customized', '', name)
  name = sub('.imputed', '', name)
  substring(name, 1, 1) = toupper(substring(name, 1, 1)) 
  
  fn.space = get(paste0("get", name , "Space"))
  par.set = fn.space(...)
  return(par.set)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
