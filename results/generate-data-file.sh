#!/bin/bash

echo -n "#"
echo -n "nb-threads "
echo -n "dirty-reads/ms dirty-writes/ms "
echo -n "dirty-volatile-reads/ms dirty-volatile-writes/ms "
echo -n "synchronized-writes/ms synchronized-writes/ms "
echo -n "reentrant-read-write-lock-reads/ms reentrant-read-write-lock-writes/ms "
echo -n "atomic-reads/ms atomic-writes/ms "
echo -n "adder-reads/ms adder-writes/ms "
echo -n "stamped-reads/ms stamped-writes/ms "
echo ""

for i in `seq $1`
do
    RESULTS_DIRECTORY=`printf '%03d-threads' $i`

    DIRTY_READ=`grep f.p.t.TapikiBenchmark.Dirty:dReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    DIRTY_WRITE=`grep f.p.t.TapikiBenchmark.Dirty:dWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    DIRTY_VOLATILE_READ=`grep f.p.t.TapikiBenchmark.DirtyVolatile:dvReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    DIRTY_VOLATILE_WRITE=`grep f.p.t.TapikiBenchmark.DirtyVolatile:dvWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`

    SYNCHRONIZED_READ=`grep f.p.t.TapikiBenchmark.Synchronized:syReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    SYNCHRONIZED_WRITE=`grep f.p.t.TapikiBenchmark.Synchronized:syWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    RRWL_READ=`grep f.p.t.TapikiBenchmark.ReentrantReadWriteLock:rrwlReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    RRWL_WRITE=`grep f.p.t.TapikiBenchmark.ReentrantReadWriteLock:rrwlWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    ATOMIC_READ=`grep f.p.t.TapikiBenchmark.Atomic:atReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    ATOMIC_WRITE=`grep f.p.t.TapikiBenchmark.Atomic:atWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    ADDER_READ=`grep f.p.t.TapikiBenchmark.Adder:adReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    ADDER_WRITE=`grep f.p.t.TapikiBenchmark.Adder:adWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    STAMPED_READ=`grep f.p.t.TapikiBenchmark.Stamped:stReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`
    STAMPED_WRITE=`grep f.p.t.TapikiBenchmark.Stamped:stWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $4}'`

    echo -n "${i} "
    echo -n "${DIRTY_READ} ${DIRTY_WRITE} "
    echo -n "${DIRTY_VOLATILE_READ} ${DIRTY_VOLATILE_WRITE} "
    echo -n "${SYNCHRONIZED_READ} ${SYNCHRONIZED_WRITE} "
    echo -n "${RRWL_READ} ${RRWL_WRITE} "
    echo -n "${ATOMIC_READ} ${ATOMIC_WRITE} "
    echo -n "${ADDER_READ} ${ADDER_WRITE} "
    echo -n "${STAMPED_READ} ${STAMPED_WRITE} "
    echo ""
done


