#!/bin/bash

DATE=$1

cd $DATE
mkdir -p results/images/

../generate-writers-per-reader-data-file.sh > results/results-by-nb-of-writers.data
../generate-writers-per-reader-data-file.sh | tr ' ' ';' > results/results-by-nb-of-writers.csv
../generate-nb-threads-data-file.sh > results/results-by-nb-of-threads.data
../generate-nb-threads-data-file.sh | tr ' ' ';' > results/results-by-nb-of-threads.csv

cd results/

for graphtype in dirty volatile synchronized reentrant-read-write-lock atomic adder stamped-lock reads writes reads-clean writes-clean
do
  gnuplot ../../$graphtype.gnuplot > images/$graphtype.png
done


