set term png size 1000,800
set logscale y
set xlabel "Number of threads"
set ylabel "Number of reads/ms"
set title "Number of reads over time"
set grid layerdefault
set yrange [1:]
plot 'benchmark-results.data' using 1:2 with lines title 'Direct', \
     'benchmark-results.data' using 1:4 with lines title 'Volatile', \
     'benchmark-results.data' using 1:6 with lines title 'Synchronized', \
     'benchmark-results.data' using 1:8 with lines title 'ReentrantReadWriteLock', \
     'benchmark-results.data' using 1:10 with lines title 'AtomicLong', \
     'benchmark-results.data' using 1:12 with lines title 'LongAdder', \
     'benchmark-results.data' using 1:14 with lines title 'StampedLock'
