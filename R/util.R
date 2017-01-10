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

customizedConverter = function(x, par.set) { #} org.par.set) {
 
  # round integers
  new.x = Map(function(par, v) {
    if (par$type %in% c("integer", "integervector") & !is.na(v)) {
      as.integer(round(v))
    }
    else { 
      v 
    }
  }, par.set$pars, x)

  # TODO: change this - turn back to logical
  new.x$O = as.logical(new.x$O)
  new.x$R = as.logical(new.x$R)
  new.x$B = as.logical(new.x$B)
  new.x$S = as.logical(new.x$S)
  new.x$A = as.logical(new.x$A)
  new.x$J = as.logical(new.x$J)
  if(new.x$R) {new.x$C = NA} else {new.x$N = NA}
 
  return(new.x)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------