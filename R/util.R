#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

convertLogicalToInteger = function(par.set) {
  
  aux = lapply(par.set$pars, function(par) {
    
    if(par$type == "logical") {
      par$type = "integer"
      par$lower = 0
      par$upper = 1
      if(par$default) {
        par$default = 1 
      } else {
        par$default = 0
      }
    }
    return(par)
  })

  par.set$pars = aux
  return(par.set)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

customizedConverter = function(x, par.set) {
 
  # round integers
  new.x = Map(function(par, v) {
    if (par$type %in% c("integer", "integervector") & !is.na(v)) {
      as.integer(round(v))
    }
    else { 
      v 
    }
  }, par.set$pars, x)

  # TODO: apply something when there is no value
  # TODO: change this - turn back to logical
  new.x$O = as.logical(new.x$O)
  new.x$R = as.logical(new.x$R)
  new.x$B = as.logical(new.x$B)
  new.x$S = as.logical(new.x$S)
  new.x$A = as.logical(new.x$A)
  new.x$J = as.logical(new.x$J)
  if(new.x$R) {
    new.x$C = NA
    if(is.na(new.x$N)) { new.x$N = 3 }
  } else {
    new.x$N = NA
    if(is.na(new.x$C)) { new.x$C = 0.25 }
  }
  return(new.x)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------