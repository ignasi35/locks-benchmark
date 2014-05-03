#!/bin/bash

echo -n "#"
echo -n "nb-threads "
echo -n "direct-reads direct-reads-mean-error direct-writes direct-writes-mean-error "
echo -n "direct-volatile-reads direct-volatile-reads-mean-error direct-volatile-writes direct-volatile-writes-mean-error "
echo -n "synchronized-reads synchronized-reads-mean-error synchronized-writes synchronized-writes-mean-error "
echo -n "reentrant-read-write-lock-reads reentrant-read-write-lock-reads-mean-error reentrant-read-write-lock-writes reentrant-read-write-lock-writes-mean-error "
echo -n "atomic-reads atomic-reads-mean-error atomic-writes atomic-writes-mean-error "
echo -n "adder-reads adder-reads-mean-error adder-writes adder-writes-mean-error "
echo -n "stamped-reads stamped-reads-mean-error stamped-writes stamped-writes-mean-error "
echo ""

for i in `seq $1`
do
    RESULTS_DIRECTORY=`printf '%03d-threads' $i`

    DIRTY_READ=`grep f.p.l.LocksBenchmark.Dirty:dReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    DIRTY_WRITE=`grep f.p.l.LocksBenchmark.Dirty:dWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    DIRTY_VOLATILE_READ=`grep f.p.l.LocksBenchmark.DirtyVolatile:dvReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    DIRTY_VOLATILE_WRITE=`grep f.p.l.LocksBenchmark.DirtyVolatile:dvWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`

    SYNCHRONIZED_READ=`grep f.p.l.LocksBenchmark.Synchronized:syReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    SYNCHRONIZED_WRITE=`grep f.p.l.LocksBenchmark.Synchronized:syWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    RRWL_READ=`grep f.p.l.LocksBenchmark.ReentrantReadWriteLock:rrwlReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    RRWL_WRITE=`grep f.p.l.LocksBenchmark.ReentrantReadWriteLock:rrwlWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    ATOMIC_READ=`grep f.p.l.LocksBenchmark.Atomic:atReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    ATOMIC_WRITE=`grep f.p.l.LocksBenchmark.Atomic:atWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    ADDER_READ=`grep f.p.l.LocksBenchmark.Adder:adReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    ADDER_WRITE=`grep f.p.l.LocksBenchmark.Adder:adWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    STAMPED_READ=`grep f.p.l.LocksBenchmark.Stamped:stReads ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`
    STAMPED_WRITE=`grep f.p.l.LocksBenchmark.Stamped:stWrites ${RESULTS_DIRECTORY}/microbenchmark.log | awk '{print $5 " " $6}'`

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


