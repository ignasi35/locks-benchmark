#!/bin/bash

#
# Extracts microbenchmark results for a given day.
#
# This script iterates over the results of a given day and produces a gnuplot
# compatible output with what could be parsed.
#
# Parsed results are runs with :
# * 1 writer and [1;23] readers
# * [2;12] writers and the same number of readers
# * [2;23] writers and 1 reader
#
# Usage : ./extract-results-for-day <day>
#

extract_results()
{
    scripts_dir=`dirname $0`
    day=$1
    readers=$2
    writers=$3
    day_dir=${scripts_dir}/$day

    consumed_cpu=`grep -Eo 'consumedCPU = \d+' ${day_dir}/1-writers-1-readers-*/microbenchmark.log | uniq | grep -Eo '\d+'`
    run_dir="${day_dir}/$writers-writers-$readers-readers-$consumed_cpu-consumed-cpu-factor"

    echo -n "$consumed_cpu $readers $writers "
    ${scripts_dir}/extract-results-from-file.sh $run_dir/microbenchmark.log
}

day=$1
output_file=$day/results.data
echo '#consumed-cpu number-of-readers number-of-writers direct-reads direct-reads-mean-error direct-writes direct-writes-mean-error direct-volatile-reads direct-volatile-reads-mean-error direct-volatile-writes direct-volatile-writes-mean-error synchronized-reads synchronized-reads-mean-error synchronized-writes synchronized-writes-mean-error reentrant-read-write-lock-reads reentrant-read-write-lock-reads-mean-error reentrant-read-write-lock-writes reentrant-read-write-lock-writes-mean-error atomic-reads atomic-reads-mean-error atomic-writes atomic-writes-mean-error adder-reads adder-reads-mean-error adder-writes adder-writes-mean-error stamped-reads stamped-reads-mean-error stamped-writes stamped-writes-mean-error' > $output_file

for writers in `seq 1 11`
do
    readers=1
    extract_results $day $readers $writers
done >> $output_file

for writers in `seq 2 12`
do
    readers=$writers
    extract_results $day $readers $writers
done >> $output_file

for readers in `seq 2 11`
do
    writers=1
    extract_results $day $readers $writers
done >> $output_file

