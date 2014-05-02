/*
 * Copyright (c) 2005, 2013, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Oracle designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Oracle in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
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

    private StampedLock stampedLock;
    private long stampedAdder;

    //------------------------------------------------------------------------

    @Param({"1024"})
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

    @GenerateMicroBenchmark
    @Group("Dirty")
    public long dWrites() {
        long value = ++dirtyAdder;
        BlackHole.consumeCPU(consumedCPU);
        return value;
    }

    @GenerateMicroBenchmark
    @Group("Dirty")
    public long dReads() {
        long value = dirtyAdder;
        BlackHole.consumeCPU(consumedCPU);
        return value;
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("DirtyVolatile")
    public long dvWrites() {
        long value = ++dirtyVolatileAdder;
        BlackHole.consumeCPU(consumedCPU);
        return value;
    }

    @GenerateMicroBenchmark
    @Group("DirtyVolatile")
    public long dvReads() {
        long value = dirtyVolatileAdder;
        BlackHole.consumeCPU(consumedCPU);
        return value;
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Synchronized")
    public long syWrites() {
        synchronized (synchronizedGuard) {
            long value = ++synchronizedAdder;
            BlackHole.consumeCPU(consumedCPU);
            return value;
        }
    }

    @GenerateMicroBenchmark
    @Group("Synchronized")
    public long syReads() {
        synchronized (synchronizedGuard) {
            long value = synchronizedAdder;
            BlackHole.consumeCPU(consumedCPU);
            return value;
        }
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("ReentrantReadWriteLock")
    public long rrwlWrites() {
        try {
            reentrantReadWriteLock.writeLock().lock();
            long value = ++rwlAdder;
            BlackHole.consumeCPU(consumedCPU);
            return value;
        } finally {
            reentrantReadWriteLock.writeLock().unlock();
        }
    }

    @GenerateMicroBenchmark
    @Group("ReentrantReadWriteLock")
    public long rrwlReads() {
        try {
            reentrantReadWriteLock.readLock().lock();
            long value = rwlAdder;
            BlackHole.consumeCPU(consumedCPU);
            return value;
        } finally {
            reentrantReadWriteLock.readLock().unlock();
        }
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Atomic")
    public long atWrites() {
        long value = atomicLong.incrementAndGet();
        BlackHole.consumeCPU(consumedCPU);
        return value;
    }

    @GenerateMicroBenchmark
    @Group("Atomic")
    public long atReads() {
        long value = atomicLong.get();
        BlackHole.consumeCPU(consumedCPU);
        return value;
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Adder")
    public void adWrites() {
        longAdder.increment();
        BlackHole.consumeCPU(consumedCPU);
    }

    @GenerateMicroBenchmark
    @Group("Adder")
    public long adReads() {
        long value = longAdder.sum();
        BlackHole.consumeCPU(consumedCPU);
        return value;
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Stamped")
    public long stWrites() {
        long stamp;
        long oldValue;
        long newValue;

        stamp = stampedLock.readLock();
        try {
            oldValue = stampedAdder;
            newValue = oldValue + 1;
            BlackHole.consumeCPU(consumedCPU);

            long writeStamp = stampedLock.tryConvertToWriteLock(stamp);
            if (writeStamp == 0L) {
                stampedLock.unlockRead(stamp);
                stamp = stampedLock.writeLock();
                oldValue = stampedAdder;
                newValue = oldValue + 1;
                BlackHole.consumeCPU(consumedCPU);
                stampedAdder = newValue;
            } else {
                stamp = writeStamp;
                stampedAdder = newValue;
            }
        } finally {
            stampedLock.unlock(stamp);
        }
        return newValue;
    }

    @GenerateMicroBenchmark
    @Group("Stamped")
    public long stReads() {
        long stamp;
        long currentAdder;

        stamp = stampedLock.tryOptimisticRead();
        currentAdder = stampedAdder;
        BlackHole.consumeCPU(consumedCPU);

        if (!stampedLock.validate(stamp)) {
            stamp = stampedLock.readLock();
            try {
                currentAdder = stampedAdder;
                BlackHole.consumeCPU(consumedCPU);
            } finally {
                stampedLock.unlockRead(stamp);
            }
        }
        return currentAdder;
    }
}
