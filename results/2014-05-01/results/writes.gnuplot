set term png size 1000,800
set logscale y
set xlabel "Number of threads"
set ylabel "Number of writes/ms"
set title "Number of writes/ms per number of threads"
set grid layerdefault
set yrange [1:]
plot 'benchmark-results.data' using 1:3 with lines title 'Direct', \
     'benchmark-results.data' using 1:5 with lines title 'Volatile', \
     'benchmark-results.data' using 1:7 with lines title 'Synchronized', \
     'benchmark-results.data' using 1:9 with lines title 'ReentrantReadWriteLock', \
     'benchmark-results.data' using 1:11 with lines title 'AtomicLong', \
     'benchmark-results.data' using 1:13 with lines title 'LongAdder', \
     'benchmark-results.data' using 1:15 with lines title 'StampedLock'
