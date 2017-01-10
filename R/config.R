#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

# loading packages
library("foreign")
library("checkmate")
library("mlr")
library("mlrMBO")
library("pso")

# mlr config
configureMlr(on.learner.error = "warn")
configureMlr(show.info = TRUE)

# constants
INNER_FOLDS = 3

OUTER_FOLDS = 10

TUNING_CONSTANT = 100

AVAILABLE.LEARNERS = c("classif.svm", "classif.J48", "classif.rpart")

AVAILABLE.TUNNERS = c("random", "defaults", "mbo", "irace", "pso")

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------