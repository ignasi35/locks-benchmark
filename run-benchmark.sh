#!/bin/sh

# Linux only

for NB_WRITERS_PER_READER in `seq 1 23`
do
    # NB_WRITERS_PER_READER : 2 3 ... 23
    MIN_THREADS=$(($NB_WRITERS_PER_READER + 1))

    # MIN_THREADS : 3 4 ... 24
    for NB_THREADS in `seq $MIN_THREADS $MIN_THREADS 24`
    do
        # NB_THREADS : 3 -> 3 6 ... 24 ; 4 -> 4 8 ... 24 ; 5 -> 5 10 ... 20
        TG="-tg 1,$NB_WRITERS_PER_READER"
        T="-t $NB_THREADS"
        PREFIX="$NB_WRITERS_PER_READER-writers-per-reader-$NB_THREADS-threads"
        GC="-Xloggc:$PREFIX-gc.log -XX:+PrintGCDetails -XX:+PrintTenuringDistribution"
        P="-p consumedCPU=10"

        vmstat 1 > $PREFIX-vmstat.log &
        java $GC -jar microbenchmarks.jar $TG $T $P | tee $PREFIX-microbenchmark.log
        for job in `jobs -p`
        do
            kill $job
        done
    done
done

