#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

checkArgs = function(datafile, algo, tuning, rep) {

  # Checking valid tuning parameter
  if(tuning %nin% c("random", "defaults", "mbo", "pso")) {
    stopf(" * Please, choose one of the following tune options: random, mbo, pso or defaults")
  }

  # datafile must be a file in data/run folder
  datasets = list.files(path = "data/")
  if( datafile %nin% datasets) {
    stopf(" * Please, pass as an argument a valid dataset file from /data/ directory")
  }

  # algo = [classif.svm | classif.J48]
  if(algo %nin% c("classif.svm", "classif.J48")) {
    stopf(" * Please, choose an algorithm between: {\'classif.svm\', \'classif.J48\'}")
  }

  # rep = [1 ... 30]
  if(rep < 1 || rep > 30) {
    stopf(" * Please, choose a rep value between: 1 and 30")
  }

  catf(paste0(" - Datafile: \t", datafile))
  catf(paste0(" - Algorithm: \t", algo))
  catf(paste0(" - Tuning: \t", tuning))
  catf(paste0(" - Repetition: \t", rep))

}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
