#!/bin/sh

# Linux only

run_benchmark()
{
    consumed_cpu=$1
    readers=$2
    writers=$3

    threads=$((writers + readers))
    prefix="$writers-writers-$readers-readers-$consumed_cpu-consumed-cpu-factor"

    tg="-tg $readers,$writers"
    t="-t $threads"
    gc="-Xloggc:$prefix-gc.log -XX:+PrintGCDetails -XX:+PrintTenuringDistribution"
    p="-p consumedCPU=$consumed_cpu"

    vmstat 1 > $prefix-vmstat.log &
    java $gc -jar microbenchmarks.jar $tg $t $p | tee $prefix-microbenchmark.log
    for job in `jobs -p`
    do
        kill $job
    done
}

CONSUMED_CPU=1

for WRITERS in `seq 1 23`
do
    READERS=1
    run_benchmark $CONSUMED_CPU $READERS $WRITERS
done
for WRITERS in `seq 2 12`
do
    READERS=$WRITERS
    run_benchmark $CONSUMED_CPU $READERS $WRITERS
done
for READERS in `seq 1 23`
do
    WRITERS=1
    run_benchmark $CONSUMED_CPU $READERS $WRITERS
done

