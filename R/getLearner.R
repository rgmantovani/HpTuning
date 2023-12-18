# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# [*] mlr Wrapper learners
# http://mlr-org.github.io/mlr-tutorial/release/html/wrapper/index.html

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getLearner = function(algo) {

  if(algo == "classif.glmnet") {
    lrn = makeLearner(algo, alpha = 0)
  } else {
    lrn = makeLearner(algo)
  }

  lrn = makeImputeWrapper(
    learner = lrn,
    classes = list(numeric = imputeMedian(), factor = imputeMode(), integer = imputeMedian()),
    dummy.classes = c("numeric", "factor", "integer")
  )

  new.lrn = makeRemoveConstantFeaturesWrapper(learner = lrn)
  return(new.lrn)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getRpartSkLearnDefaults = function() {

  lrn = makeImputeWrapper(
    # minsplit and minbucket are respectively 2 and 1
    learner = mlr::makeLearner("classif.rpart", minsplit = 2, minbucket = 1),
    classes = list(numeric = imputeMedian(), factor = imputeMode(), integer = imputeMedian()),
    dummy.classes = c("numeric", "factor", "integer")
  )

  new.lrn = makeRemoveConstantFeaturesWrapper(learner = lrn)
  return(new.lrn)
}


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------