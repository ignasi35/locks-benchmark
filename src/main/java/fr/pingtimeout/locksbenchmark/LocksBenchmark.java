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
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.Threads;
import org.openjdk.jmh.annotations.Warmup;

@BenchmarkMode(Mode.Throughput)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@Warmup(iterations = 10, time = 3, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 10, time = 3, timeUnit = TimeUnit.SECONDS)
@Fork(5)
@Threads(10)
@State(Scope.Benchmark)
public class LocksBenchmark {

    // Dirty adder : No-guard, invalid result
    private long dirtyAdder = 0L;

    // Dirty volatile adder : No-guard, invalid result
    private volatile long dirtyVolatileAdder = 0L;

    // Synchronized adder : Guarded by object itself, valid result
    private final Object synchronizedGuard = new Object();
    private long synchronizedAdder = 0L;

    // ReentrantReadWriteLock adder : Guarded by RWLock, valid result
    @State(Scope.Thread)
    public static class RWLock {
        public final ReentrantReadWriteLock reentrantReadWriteLock = new ReentrantReadWriteLock();
        public final ReentrantReadWriteLock.ReadLock readLock = reentrantReadWriteLock.readLock();
        public final ReentrantReadWriteLock.WriteLock writeLock = reentrantReadWriteLock.writeLock();
    }

    private long rwlAdder = 0L;

    // AtomicLong adder : Guarded by CAS-ing values, valid result
    private AtomicLong atomicLong = new AtomicLong(0);

    // LongAdder : Guarded by CAS-ing values, valid result
    private LongAdder longAdder = new LongAdder();

    private final StampedLock stampedLock = new StampedLock();
    private long stampedAdder = 0L;

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Dirty")
    public long dWrites() {
        return ++dirtyAdder;
    }

    @GenerateMicroBenchmark
    @Group("Dirty")
    public long dReads() {
        return dirtyAdder;
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("DirtyVolatile")
    public long dvWrites() {
        return ++dirtyVolatileAdder;
    }

    @GenerateMicroBenchmark
    @Group("DirtyVolatile")
    public long dvReads() {
        return dirtyVolatileAdder;
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Synchronized")
    public long syWrites() {
        synchronized (synchronizedGuard) {
            return ++synchronizedAdder;
        }
    }

    @GenerateMicroBenchmark
    @Group("Synchronized")
    public long syReads() {
        synchronized (synchronizedGuard) {
            return synchronizedAdder;
        }
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("ReentrantReadWriteLock")
    public long rrwlWrites(RWLock rwLock) {
        try {
            rwLock.writeLock.lock();
            return ++rwlAdder;
        } finally {
            rwLock.writeLock.unlock();
        }
    }

    @GenerateMicroBenchmark
    @Group("ReentrantReadWriteLock")
    public long rrwlReads(RWLock rwLock) {
        try {
            rwLock.readLock.lock();
            return rwlAdder;
        } finally {
            rwLock.readLock.unlock();
        }
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Atomic")
    public long atWrites() {
        return atomicLong.incrementAndGet();
    }

    @GenerateMicroBenchmark
    @Group("Atomic")
    public long atReads() {
        return atomicLong.get();
    }

    //------------------------------------------------------------------------

    @GenerateMicroBenchmark
    @Group("Adder")
    public void adWrites() {
        longAdder.increment();
    }

    @GenerateMicroBenchmark
    @Group("Adder")
    public long adReads() {
        return longAdder.sum();
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

            long writeStamp = stampedLock.tryConvertToWriteLock(stamp);
            if (writeStamp == 0L) {
                stampedLock.unlockRead(stamp);
                stamp = stampedLock.writeLock();
                oldValue = stampedAdder;
                newValue = oldValue + 1;
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
        if (!stampedLock.validate(stamp)) {
            stamp = stampedLock.readLock();
            try {
                currentAdder = stampedAdder;
            } finally {
                stampedLock.unlockRead(stamp);
            }
        }
        return currentAdder;
    }
}
