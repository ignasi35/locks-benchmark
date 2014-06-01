/*
 * Copyright (c) 2014, Pierre Laporte
 *
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3 only, as
 * published by the Free Software Foundation.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this work; if not, see <http://www.gnu.org/licenses/>.
 */
package fr.pingtimeout.locksbenchmark;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.LongAdder;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.concurrent.locks.StampedLock;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Fork;
import org.openjdk.jmh.annotations.GenerateMicroBenchmark;
import org.openjdk.jmh.annotations.Group;
import org.openjdk.jmh.annotations.GroupThreads;
import org.openjdk.jmh.annotations.Measurement;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Param;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.Setup;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.Threads;
import org.openjdk.jmh.annotations.Warmup;
import org.openjdk.jmh.logic.BlackHole;

@BenchmarkMode(Mode.Throughput)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@Warmup(iterations = 10, time = 3, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 10, time = 3, timeUnit = TimeUnit.SECONDS)
@Fork(5)
@Threads(10)
@State(Scope.Benchmark)
public class LocksBenchmark {

    // Dirty adder : No-guard, invalid result
    private long dirtyAdder;

    // Dirty volatile adder : No-guard, invalid result
    private volatile long dirtyVolatileAdder;

    // Synchronized adder : Guarded by object itself, valid result
    private Object synchronizedGuard;
    private long synchronizedAdder;

    // ReentrantReadWriteLock adder : Guarded by RWLock, valid result
    public ReentrantReadWriteLock reentrantReadWriteLock;
    private long rwlAdder;

    // AtomicLong adder : Guarded by CAS-ing values, valid result
    private AtomicLong atomicLong;

    // LongAdder : Guarded by CAS-ing values, valid result
    private LongAdder longAdder;

    // StampedLock adder : Guarded by a StampedLock, valid results
    private StampedLock stampedLock;
    private long stampedAdder;

    //------------------------------------------------------------------------

    @Param({"1"})
    private int consumedCPU;

    @Setup
    public void init() {
        dirtyAdder = 0L;
        dirtyVolatileAdder = 0L;
        synchronizedGuard = new Object();
        synchronizedAdder = 0L;
        reentrantReadWriteLock = new ReentrantReadWriteLock();
        rwlAdder = 0L;
        atomicLong = new AtomicLong(0);
        longAdder = new LongAdder();
        stampedLock = new StampedLock();
        stampedAdder = 0L;
    }

    //------------------------------------------------------------------------

    // Write scenario
    // - Serial section
    // --- Burn CPU (identify shared data structure)
    // --- Increment associated counter
    // - Parallel section
    // --- burn CPU (whatever)
    //
    // Read scenario
    // - Serial section
    // --- Burn CPU (identify shared data structure)
    // --- Read counter

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Dirty")
    @GroupThreads(1)
    public void dWrites() {
        BlackHole.consumeCPU(consumedCPU);
        long currentValue = dirtyAdder;
        long newValue = currentValue + 1;
        dirtyAdder = newValue;

        BlackHole.consumeCPU(consumedCPU);
//        return newValue;
    }

    @GenerateMicroBenchmark
    @Group("Dirty")
    @GroupThreads(1)
    public long dReads() {
        BlackHole.consumeCPU(consumedCPU);
        long currentValue = dirtyAdder;
        return currentValue;
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("DirtyVolatile")
    @GroupThreads(1)
    public void dvWrites() {
        BlackHole.consumeCPU(consumedCPU);
        long currentValue = dirtyVolatileAdder;
        long newValue = currentValue + 1;
        dirtyVolatileAdder = newValue;

        BlackHole.consumeCPU(consumedCPU);
//        return newValue;
    }

    @GenerateMicroBenchmark
    @Group("DirtyVolatile")
    @GroupThreads(1)
    public long dvReads() {
        BlackHole.consumeCPU(consumedCPU);
        long currentValue = dirtyVolatileAdder;
        return currentValue;
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Synchronized")
    @GroupThreads(1)
    public void syWrites() {
        long newValue;
        synchronized (synchronizedGuard) {
            BlackHole.consumeCPU(consumedCPU);
            long currentValue = synchronizedAdder;
            newValue = currentValue + 1;
            synchronizedAdder = newValue;
        }

        BlackHole.consumeCPU(consumedCPU);
//        return newValue;
    }

    @GenerateMicroBenchmark
    @Group("Synchronized")
    @GroupThreads(1)
    public long syReads() {
        synchronized (synchronizedGuard) {
            BlackHole.consumeCPU(consumedCPU);
            return synchronizedAdder;
        }
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("ReentrantReadWriteLock")
    @GroupThreads(1)
    public void rrwlWrites() {
        long newValue;
        try {
            reentrantReadWriteLock.writeLock().lock();
            BlackHole.consumeCPU(consumedCPU);
            long currentValue = rwlAdder;
            newValue = currentValue + 1;
            rwlAdder = newValue;
        } finally {
            reentrantReadWriteLock.writeLock().unlock();
        }

        BlackHole.consumeCPU(consumedCPU);
//        return newValue;
    }

    @GenerateMicroBenchmark
    @Group("ReentrantReadWriteLock")
    @GroupThreads(1)
    public long rrwlReads() {
        try {
            reentrantReadWriteLock.readLock().lock();
            BlackHole.consumeCPU(consumedCPU);
            return rwlAdder;
        } finally {
            reentrantReadWriteLock.readLock().unlock();
        }
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Atomic")
    @GroupThreads(1)
    public void atWrites() {
        BlackHole.consumeCPU(consumedCPU);
        atomicLong.incrementAndGet();

        BlackHole.consumeCPU(consumedCPU);
    }

    @GenerateMicroBenchmark
    @Group("Atomic")
    @GroupThreads(1)
    public long atReads() {
        BlackHole.consumeCPU(consumedCPU);
        return atomicLong.get();
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Adder")
    @GroupThreads(1)
    public void adWrites() {
        BlackHole.consumeCPU(consumedCPU);
        longAdder.add(1);

        BlackHole.consumeCPU(consumedCPU);
    }

    @GenerateMicroBenchmark
    @Group("Adder")
    @GroupThreads(1)
    public long adReads() {
        BlackHole.consumeCPU(consumedCPU);
        return longAdder.sum();
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Stamped")
    @GroupThreads(1)
    public long stWrites() {
        long stamp;
        long newValue;
        stamp = stampedLock.readLock();
        try {
            BlackHole.consumeCPU(consumedCPU);
            long currentValue = stampedAdder;
            newValue = currentValue + 1;
            long writeStamp = stampedLock.tryConvertToWriteLock(stamp);
            if (writeStamp != 0L) {
                stamp = writeStamp;
                stampedAdder = newValue;
            } else {
                stampedLock.unlockRead(stamp);
                stamp = stampedLock.writeLock();
                BlackHole.consumeCPU(consumedCPU);
                currentValue = stampedAdder;
                newValue = currentValue + 1;
                stampedAdder = newValue;
            }
        } finally {
            stampedLock.unlock(stamp);
        }

        BlackHole.consumeCPU(consumedCPU);
        return newValue;
    }

    @GenerateMicroBenchmark
    @Group("Stamped")
    @GroupThreads(1)
    public long stReads() {
        long stamp;
        long currentValue;
        stamp = stampedLock.tryOptimisticRead();
        BlackHole.consumeCPU(consumedCPU);
        currentValue = stampedAdder;
        if (!stampedLock.validate(stamp)) {
            stamp = stampedLock.readLock();
            try {
                BlackHole.consumeCPU(consumedCPU);
                currentValue = stampedAdder;
            } finally {
                stampedLock.unlockRead(stamp);
            }
        }
        return currentValue;
    }
}
