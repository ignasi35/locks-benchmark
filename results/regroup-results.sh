#!/bin/sh

grep -h '^#' 2014-05-*/results.data | uniq > results.data
for results in `ls 2014-05-*/results.data`
do
    grep -v '^#' $results
done >> results.data

cat results.data | sed -e 's/ /;/g' -e 's/#//' > results.csv

