#!/bin/bash

#
# Extracts results from a microbenchmark.log file.
#
# This scripts outputs a line with results (reads/writes throughput & mean
# error) for every group
#
# Usage : ./extract-results-from-file.sh <path-to-microbenchmark.log>
#

SOURCE_FILE=$1

DIRTY_READ=`grep f.p.l.LocksBenchmark.Dirty:dReads $SOURCE_FILE | awk '{print $5 " " $6}'`
DIRTY_WRITE=`grep f.p.l.LocksBenchmark.Dirty:dWrites $SOURCE_FILE | awk '{print $5 " " $6}'`
DIRTY_VOLATILE_READ=`grep f.p.l.LocksBenchmark.DirtyVolatile:dvReads $SOURCE_FILE | awk '{print $5 " " $6}'`
DIRTY_VOLATILE_WRITE=`grep f.p.l.LocksBenchmark.DirtyVolatile:dvWrites $SOURCE_FILE | awk '{print $5 " " $6}'`
SYNCHRONIZED_READ=`grep f.p.l.LocksBenchmark.Synchronized:syReads $SOURCE_FILE | awk '{print $5 " " $6}'`
SYNCHRONIZED_WRITE=`grep f.p.l.LocksBenchmark.Synchronized:syWrites $SOURCE_FILE | awk '{print $5 " " $6}'`
RRWL_READ=`grep f.p.l.LocksBenchmark.ReentrantReadWriteLock:rrwlReads $SOURCE_FILE | awk '{print $5 " " $6}'`
RRWL_WRITE=`grep f.p.l.LocksBenchmark.ReentrantReadWriteLock:rrwlWrites $SOURCE_FILE | awk '{print $5 " " $6}'`
ATOMIC_READ=`grep f.p.l.LocksBenchmark.Atomic:atReads $SOURCE_FILE | awk '{print $5 " " $6}'`
ATOMIC_WRITE=`grep f.p.l.LocksBenchmark.Atomic:atWrites $SOURCE_FILE | awk '{print $5 " " $6}'`
ADDER_READ=`grep f.p.l.LocksBenchmark.Adder:adReads $SOURCE_FILE | awk '{print $5 " " $6}'`
ADDER_WRITE=`grep f.p.l.LocksBenchmark.Adder:adWrites $SOURCE_FILE | awk '{print $5 " " $6}'`
STAMPED_READ=`grep f.p.l.LocksBenchmark.Stamped:stReads $SOURCE_FILE | awk '{print $5 " " $6}'`
STAMPED_WRITE=`grep f.p.l.LocksBenchmark.Stamped:stWrites $SOURCE_FILE | awk '{print $5 " " $6}'`

echo -n "${DIRTY_READ} ${DIRTY_WRITE} "
echo -n "${DIRTY_VOLATILE_READ} ${DIRTY_VOLATILE_WRITE} "
echo -n "${SYNCHRONIZED_READ} ${SYNCHRONIZED_WRITE} "
echo -n "${RRWL_READ} ${RRWL_WRITE} "
echo -n "${ATOMIC_READ} ${ATOMIC_WRITE} "
echo -n "${ADDER_READ} ${ADDER_WRITE} "
echo -n "${STAMPED_READ} ${STAMPED_WRITE} "
echo ""
