#!/bin/bash

#
# Generates the gnuplot instruction files with a given title, data file and model.
#
# Usage : ./generate-gnuplot-instructions.sh \
#    "Read throughput for 1 reader, 10 cpu-consumed-factor" \
#    2014-02-26/results.data \
#    gnuplot-scripts/clean-graph.gnuplot-model \
#    3
#

title=$1
x_label=$2
y_label=$3
data_file=$4
gnuplot_model=$5

if [ "$y_label" = "Reads per second" ]
then
    first_column_index=4
else
    first_column_index=6
fi

if [ "$x_label" = "Number of readers" ]
then
    x_column=2
else
    x_column=3
fi

sed -e "s/\${graph-title}/$title/" \
    -e "s/\${x-label}/$x_label/" \
    -e "s/\${y-label}/$y_label/" \
    -e "s,\${data-file},$data_file," \
    -e "s/\${x-column}/$x_column/" \
    -e "s/\${direct-column}/$((first_column_index + 0))/" \
    -e "s/\${direct-column-mean-error}/$((first_column_index + 1))/" \
    -e "s/\${volatile-column}/$((first_column_index + 4))/" \
    -e "s/\${volatile-column-mean-error}/$((first_column_index + 5))/" \
    -e "s/\${synchronized-column}/$((first_column_index + 8))/" \
    -e "s/\${synchronized-column-mean-error}/$((first_column_index + 9))/" \
    -e "s/\${rrwl-column}/$((first_column_index + 12))/" \
    -e "s/\${rrwl-column-mean-error}/$((first_column_index + 13))/" \
    -e "s/\${atomiclong-column}/$((first_column_index + 16))/" \
    -e "s/\${atomiclong-column-mean-error}/$((first_column_index + 17))/" \
    -e "s/\${longadder-column}/$((first_column_index + 20))/" \
    -e "s/\${longadder-column-mean-error}/$((first_column_index + 21))/" \
    -e "s/\${stamped-column}/$((first_column_index + 24))/" \
    -e "s/\${stamped-column-mean-error}/$((first_column_index + 25))/" \
    $gnuplot_model

