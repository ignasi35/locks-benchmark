set term png size 1000,800
set xlabel "Number of threads"
set ylabel "Number of ops/ms"
set title "Number of ReentrantReadWriteLock ops/ms per number of threads"
set grid layerdefault
set yrange [0:]
plot 'benchmark-results.data' using 1:8 with lines lt rgb 'green' title 'Reads', \
     'benchmark-results.data' using 1:9 with lines lt rgb 'red' title 'Writes'
