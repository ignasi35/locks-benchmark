#!/bin/bash

day=$1
target_dir=$day/results

mkdir -p $target_dir

c=`grep -Eo '^\d+' $day/results.data | uniq`
grep -E '^\d+ 1 \d+ ' $day/results.data > $target_dir/results-1-reader.data
grep -E '^\d+ \d+ 1 ' $day/results.data > $target_dir/results-1-writer.data
grep -Ev '^(#|\d+ 1 \d+ |\d+ \d+ 1 )' $day/results.data > $target_dir/results-n-readers-and-writers.data

./generate-gnuplot-instructions.sh "Write throughput for 1 reader, consumed-cpu-factor=$c" "Number of writers" "Writes per second" $target_dir/results-1-reader.data gnuplot-scripts/clean-graph.gnuplot.model | gnuplot > $target_dir/write-throughput-one-reader-$c-consumed-cpu-factor.png
./generate-gnuplot-instructions.sh "Read throughput for 1 reader, consumed-cpu-factor=$c"  "Number of writers" "Reads per second"  $target_dir/results-1-reader.data gnuplot-scripts/clean-graph.gnuplot.model | gnuplot > $target_dir/read-throughput-one-reader-$c-consumed-cpu-factor.png

./generate-gnuplot-instructions.sh "Write throughput for 1 writer, consumed-cpu-factor=$c" "Number of readers" "Writes per second" $target_dir/results-1-writer.data gnuplot-scripts/clean-graph.gnuplot.model | gnuplot > $target_dir/write-throughput-one-writer-$c-consumed-cpu-factor.png
./generate-gnuplot-instructions.sh "Read throughput for 1 writer, consumed-cpu-factor=$c"  "Number of readers" "Reads per second"  $target_dir/results-1-writer.data gnuplot-scripts/clean-graph.gnuplot.model | gnuplot > $target_dir/read-throughput-one-writer-$c-consumed-cpu-factor.png

./generate-gnuplot-instructions.sh "Write throughput for n actors, consumed-cpu-factor=$c" "Number of readers and writers" "Writes per second" $target_dir/results-n-readers-and-writers.data gnuplot-scripts/clean-graph.gnuplot.model | gnuplot > $target_dir/write-throughput-n-readers-and-writers-$c-consumed-cpu-factor.png
./generate-gnuplot-instructions.sh "Read throughput for n actors, consumed-cpu-factor=$c"  "Number of readers and writers" "Reads per second"  $target_dir/results-n-readers-and-writers.data gnuplot-scripts/clean-graph.gnuplot.model | gnuplot > $target_dir/read-throughput-n-readers-and-writers-$c-consumed-cpu-factor.png

#{
#    echo "set logscale y"
#    ./generate-gnuplot-instructions.sh \
#        "Read throughput for 1 reader, consumed-cpu-factor=1" \
#        $target_dir/results-1-reader.data \
#        gnuplot-scripts/clean-graph.gnuplot.model \
#        3
#} | gnuplot > $target_dir/results-1-reader-logscale.png
#
#{
#    echo "set logscale y"
#    ./generate-gnuplot-instructions.sh \
#        "Read throughput for 1 writer, consumed-cpu-factor=1" \
#        $target_dir/results-1-writers.data \
#        gnuplot-scripts/clean-graph.gnuplot.model \
#        2
#} | gnuplot > $target_dir/results-1-writers-logscale.png
#
#rm $target_dir/*ers.data
#
#
