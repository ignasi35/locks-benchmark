#!/bin/bash

DATE=$1

cd $DATE
mkdir -p results/images/

../generate-data-file.sh 24 > results/benchmark-results.data
../generate-data-file.sh 24 | tr ' ' ';' > results/benchmark-results.csv

cd results/

for graphtype in dirty volatile synchronized reentrant-read-write-lock atomic adder stamped-lock reads writes reads-clean writes-clean
do
  gnuplot ../../$graphtype.gnuplot > images/$graphtype.png
done


