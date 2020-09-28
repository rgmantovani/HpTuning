#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

mlr::configureMlr(on.learner.error = "warn")
mlr::configureMlr(show.info = TRUE)

AVAILABLE.LEARNERS = c("classif.svm", "classif.J48", "classif.rpart", "classif.randomForest",
  "classif.ctree", "classif.xgboost", "classif.C50", "classif.glmnet")
AVAILABLE.TUNNERS = c("random", "defaults", "mbo", "irace", "pso", "ga", "eda")

INNER_FOLDS = 3
OUTER_FOLDS = 10

TUNING_CONSTANT = 100
POP.SIZE = 10

CONFIG.BUDGET = 900

GA.PROB.MUT = 0.05
GA.ELITISM = max(1, round(POP.SIZE * 0.05))

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
