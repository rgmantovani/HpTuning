import time, os, itertools
from multiprocessing import Pool
from os import listdir
from os.path import isfile, join

def myjob(op):
    #command = "Rscript mainHP.R --datafile="+op[0]+" --algo="+op[1]+" --tuning="+op[2]+" --epoch="+op[3]
    command = "R CMD BATCH --no-save --no-restore \'--args\' --datafile="+op[0]+" --algo="+op[1]+" --tuning="+op[2]+" --epoch="+op[3]+" mainHP.R job_"+op[0]+"_"+op[1]+"_"+op[2]+"_"+op[3]+".log"
    #print(command)
    # execute the command
    os.system(command.format(*op))

def main():
    mypath = "./data/"
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]

    datasets = []
    for string in onlyfiles:
        new_string = string.replace(".arff", "")
        datasets.append(new_string)

    algo  = ["classif.svm"]  # Algorithms to be tuned
    tuner = ["mbo"]          # HP tuning technique

    # seeds from 1 to 10
    seed = [str(i) for i in range(1,11)]

    # script's parameters (options)
    options = itertools.product(datasets, algo, tuner, seed)
    #for opt in options:
    #    print(opt)

    with Pool(processes=20) as pool:
        # map blocks until the result is ready
        results = pool.imap(myjob, options, chunksize=1)
        #TODO: add timeout (100 hs)
        pool.close()
        pool.join()
    return

if __name__ == "__main__":
    main()
