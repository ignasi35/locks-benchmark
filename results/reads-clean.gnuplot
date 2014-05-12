set term png size 1000,800
set logscale y
set xlabel "Number of threads"
set ylabel "Number of reads/ms"
set title "Number of reads/ms per number of threads"
set grid layerdefault
#set yrange [1:]
plot 'benchmark-results.data' using 1:10:11 with errorbars title 'Synchronized', \
     'benchmark-results.data' using 1:14:15 with errorbars title 'ReentrantReadWriteLock', \
     'benchmark-results.data' using 1:18:19 with errorbars title 'AtomicLong', \
     'benchmark-results.data' using 1:22:23 with errorbars title 'LongAdder', \
     'benchmark-results.data' using 1:26:27 with errorbars title 'StampedLock'
