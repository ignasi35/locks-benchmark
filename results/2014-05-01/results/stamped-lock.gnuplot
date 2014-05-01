set term png size 1000,800
set xlabel "Number of threads"
set ylabel "Number of ops/ms"
set title "Number of StampedLock reads/writes over time"
set grid layerdefault
set yrange [0:]
plot 'benchmark-results.data' using 1:14 with lines title 'Reads', \
     'benchmark-results.data' using 1:15 with lines title 'Writes'
