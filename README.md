# Disclaimer

As most benchmarks available on the internet, this benchmark may or may not produce valid results, and may be completely flawed. This code is provided as-is, in the hope that it will be useful to the community. 

# Description

This repository contains a benchmark attempt of lock strategies in Java 8.

The idea is to increment a counter using the following strategies :

* no protection on the field (invalid results, of course)
* field protection with 'volatile' keyword (invalid result, also)
* field protection with 'synchronized' keyword
* field protection with ReentrantReadWriteLock
* usage of AtomicLong
* usage of LongAdder
* field protection with StampedLock

The source of the benchmark is in the file 'LocksBenchmark.java'.

# How to

First, build the project :

```java
mvn package
```

Then, run the benchmark with a given number of threads, using :

```sh
java -jar target/microbenchmarks.jar -t $NB_THREADS
```

# Long run

To run the benchmark multiple times using different number of threads, use the following script. It will produce 3 files :

* vmstat.log - the result of a command ```vmstat 1``` during the benchmark
* gc.log - the gc log
* microbenchmark.log - the output of the tests

```sh
#!/bin/sh

for NB_THREADS in `seq 100`
do
    vmstat 1 > $NB_THREADS-threads-vmstat.log &
    java -Xloggc:$NB_THREADS-threads-gc.log -XX:+PrintGCDetails -XX:+PrintTenuringDistribution -jar microbenchmarks.jar -t $NB_THREADS | tee $NB_THREADS-threads-microbenchmark.log
    for job in `jobs -p`
    do
        kill $job
    done
done
```

