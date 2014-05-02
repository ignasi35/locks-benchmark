set term png size 1000,800
set logscale y
set xlabel "Number of threads"
set ylabel "Number of writes/ms"
set title "Number of writes/ms per number of threads"
set grid layerdefault
#set yrange [1:]
plot 'benchmark-results.data' using 1:4:5 with errorbars title 'Direct', \
     'benchmark-results.data' using 1:8:9 with errorbars title 'Volatile', \
     'benchmark-results.data' using 1:12:13 with errorbars title 'Synchronized', \
     'benchmark-results.data' using 1:16:17 with errorbars title 'ReentrantReadWriteLock', \
     'benchmark-results.data' using 1:20:21 with errorbars title 'AtomicLong', \
     'benchmark-results.data' using 1:24:25 with errorbars title 'LongAdder', \
     'benchmark-results.data' using 1:28:29 with errorbars title 'StampedLock'
