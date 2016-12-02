#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

# loading packages
library("foreign")
library("checkmate")
library("mlr")
library("mlrMBO")

# mlr config
configureMlr(on.learner.error = "warn")
configureMlr(show.info = TRUE)

# constants
INNER_FOLDS = 3
OUTER_FOLDS = 10
TUNING_CONSTANT = 100

# put the available learners
AVAILABLE.LEARNERS = c("classif.svm", "classif.J48", "classif.rpart")

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------