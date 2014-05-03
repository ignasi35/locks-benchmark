set term png size 1000,800
set xlabel "Number of threads"
set ylabel "Number of ops/ms"
set title "Number of StampedLock ops/ms per number of threads"
set grid layerdefault
set yrange [0:]
plot 'benchmark-results.data' using 1:26:27 with errorbars lt rgb 'green' title 'Reads', \
     'benchmark-results.data' using 1:28:29 with errorbars lt rgb 'red' title 'Writes'
