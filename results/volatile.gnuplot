set term png size 1000,800
set xlabel "Number of threads"
set ylabel "Number of ops/ms"
set title "Number of volatile (unsafe) ops/ms per number of threads"
set grid layerdefault
set yrange [0:]
plot 'benchmark-results.data' using 1:6:7 with errorbars lt rgb 'green' title 'Reads', \
     'benchmark-results.data' using 1:8:9 with errorbars lt rgb 'red' title 'Writes'
