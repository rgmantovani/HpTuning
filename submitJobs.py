import time, os, itertools
from multiprocessing import Pool
from os import listdir
from os.path import isfile, join
import math

# working directory
#os.chdir("/Users/rafael/Documents/Development/HpTuning")


def myjob(op):
    command = "Rscript mainHP.R --datafile="+op[0]+" --algo="+op[1]+" --tuning="+op[2]+" --epoch="+op[3]
    # print(command)
    # execute the command
    os.system(command.format(*op))

def main():
    mypath = "./data/"
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]

    datasets = []
    for string in onlyfiles:
        new_string = string.replace(".arff", "")
        datasets.append(new_string)
    #print(datasets)

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
        results = pool.map(myjob, options, chunksize=1)
        #TODO: add timeout (100 hs)
        pool.close()
        pool.join()
    return

if __name__ == "__main__":
    main()
