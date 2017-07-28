#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

convertParamsTypes = function(par.set) {

  aux = lapply(par.set$pars, function(par) {
    
    if(par$type == "logical") {
      par$type = "integer"
      par$lower = 0
      par$upper = 1
      par$default = ifelse(par$default, 1, 0)
    }    
    return(par)
  })

  par.set$pars = aux
  return(par.set)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

customizedConverter = function(x, par.set) {

  new.x = mlr:::convertXNumeric(x, par.set)
  bool.params = c("O", "R", "B", "S", "A", "J", "stump")
  for(par in bool.params) {
    if(!is.null(new.x[[par]])) {
      new.x[[par]] = as.logical(new.x[[par]])
    }
  }

  # J48 requirements
  if(!is.null(new.x[["R"]])) {
    if(new.x$R) {
      new.x$C = NA
      if(is.na(new.x$N)) { new.x$N = 3 }
    } else {
      new.x$N = NA
      if(is.na(new.x$C)) { new.x$C = 0.25 }
    }
  }

  return(new.x)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------