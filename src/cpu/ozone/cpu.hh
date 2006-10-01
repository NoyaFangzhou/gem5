/*
 * Copyright (c) 2006 The Regents of The University of Michigan
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met: redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer;
 * redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution;
 * neither the name of the copyright holders nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Authors: Kevin Lim
 */

#ifndef __CPU_OZONE_CPU_HH__
#define __CPU_OZONE_CPU_HH__

#include <set>

#include "base/statistics.hh"
#include "base/timebuf.hh"
#include "config/full_system.hh"
#include "cpu/base.hh"
#include "cpu/thread_context.hh"
#include "cpu/inst_seq.hh"
#include "cpu/ozone/rename_table.hh"
#include "cpu/ozone/thread_state.hh"
#include "cpu/pc_event.hh"
#include "cpu/static_inst.hh"
#include "mem/page_table.hh"
#include "sim/eventq.hh"

// forward declarations
#if FULL_SYSTEM
#include "arch/alpha/tlb.hh"

class AlphaITB;
class AlphaDTB;
class PhysicalMemory;
class MemoryController;

class RemoteGDB;
class GDBListener;

namespace Kernel {
    class Statistics;
};

#else

class Process;

#endif // FULL_SYSTEM

class Checkpoint;
class EndQuiesceEvent;
class MemObject;
class Request;

namespace Trace {
    class InstRecord;
}

template <class>
class Checker;

/**
 * Light weight out of order CPU model that approximates an out of
 * order CPU.  It is separated into a front end and a back end, with
 * the template parameter Impl describing the classes used for each.
 * The goal is to be able to specify through the Impl the class to use
 * for the front end and back end, with different classes used to
 * model different levels of detail.
 */
template <class Impl>
class OzoneCPU : public BaseCPU
{
  private:
    typedef typename Impl::FrontEnd FrontEnd;
    typedef typename Impl::BackEnd BackEnd;
    typedef typename Impl::DynInst DynInst;
    typedef typename Impl::DynInstPtr DynInstPtr;

    typedef TheISA::FloatReg FloatReg;
    typedef TheISA::FloatRegBits FloatRegBits;
    typedef TheISA::MiscReg MiscReg;

  public:
    class OzoneTC : public ThreadContext {
      public:
        OzoneCPU<Impl> *cpu;

        OzoneThreadState<Impl> *thread;

        BaseCPU *getCpuPtr();

        void setCpuId(int id);

        int readCpuId() { return thread->readCpuId(); }

#if FULL_SYSTEM
        System *getSystemPtr() { return cpu->system; }

        PhysicalMemory *getPhysMemPtr() { return cpu->physmem; }

        AlphaITB *getITBPtr() { return cpu->itb; }

        AlphaDTB * getDTBPtr() { return cpu->dtb; }

        Kernel::Statistics *getKernelStats()
        { return thread->getKernelStats(); }

        FunctionalPort *getPhysPort() { return thread->getPhysPort(); }

        VirtualPort *getVirtPort(ThreadContext *tc = NULL)
        { return thread->getVirtPort(tc); }

        void delVirtPort(VirtualPort *vp);
#else
        TranslatingPort *getMemPort() { return thread->getMemPort(); }

        Process *getProcessPtr() { return thread->getProcessPtr(); }
#endif

        Status status() const { return thread->status(); }

        void setStatus(Status new_status);

        /// Set the status to Active.  Optional delay indicates number of
        /// cycles to wait before beginning execution.
        void activate(int delay = 1);

        /// Set the status to Suspended.
        void suspend();

        /// Set the status to Unallocated.
        void deallocate(int delay = 0);

        /// Set the status to Halted.
        void halt();

#if FULL_SYSTEM
        void dumpFuncProfile();
#endif

        void takeOverFrom(ThreadContext *old_context);

        void regStats(const std::string &name);

        void serialize(std::ostream &os);
        void unserialize(Checkpoint *cp, const std::string &section);

#if FULL_SYSTEM
        EndQuiesceEvent *getQuiesceEvent();

        Tick readLastActivate();
        Tick readLastSuspend();

        void profileClear();
        void profileSample();
#endif

        int getThreadNum();

        // Also somewhat obnoxious.  Really only used for the TLB fault.
        TheISA::MachInst getInst();

        void copyArchRegs(ThreadContext *tc);

        void clearArchRegs();

        uint64_t readIntReg(int reg_idx);

        FloatReg readFloatReg(int reg_idx, int width);

        FloatReg readFloatReg(int reg_idx);

        FloatRegBits readFloatRegBits(int reg_idx, int width);

        FloatRegBits readFloatRegBits(int reg_idx);

        void setIntReg(int reg_idx, uint64_t val);

        void setFloatReg(int reg_idx, FloatReg val, int width);

        void setFloatReg(int reg_idx, FloatReg val);

        void setFloatRegBits(int reg_idx, FloatRegBits val, int width);

        void setFloatRegBits(int reg_idx, FloatRegBits val);

        uint64_t readPC() { return thread->PC; }
        void setPC(Addr val);

        uint64_t readNextPC() { return thread->nextPC; }
        void setNextPC(Addr val);

        uint64_t readNextNPC()
        {
            return 0;
        }

        void setNextNPC(uint64_t val)
        { }

      public:
        // ISA stuff:
        MiscReg readMiscReg(int misc_reg);

        MiscReg readMiscRegWithEffect(int misc_reg, Fault &fault);

        Fault setMiscReg(int misc_reg, const MiscReg &val);

        Fault setMiscRegWithEffect(int misc_reg, const MiscReg &val);

        unsigned readStCondFailures()
        { return thread->storeCondFailures; }

        void setStCondFailures(unsigned sc_failures)
        { thread->storeCondFailures = sc_failures; }

#if FULL_SYSTEM
        bool inPalMode() { return cpu->inPalMode(); }
#endif

        bool misspeculating() { return false; }

#if !FULL_SYSTEM
        TheISA::IntReg getSyscallArg(int i)
        { return thread->renameTable[TheISA::ArgumentReg0 + i]->readIntResult(); }

        // used to shift args for indirect syscall
        void setSyscallArg(int i, TheISA::IntReg val)
        { thread->renameTable[TheISA::ArgumentReg0 + i]->setIntResult(i); }

        void setSyscallReturn(SyscallReturn return_value)
        { cpu->setSyscallReturn(return_value, thread->readTid()); }

        Counter readFuncExeInst() { return thread->funcExeInst; }

        void setFuncExeInst(Counter new_val)
        { thread->funcExeInst = new_val; }
#endif
        void changeRegFileContext(TheISA::RegFile::ContextParam param,
                                          TheISA::RegFile::ContextVal val)
        { panic("Not supported on Alpha!"); }
    };

    // Ozone specific thread context
    OzoneTC ozoneTC;
    // Thread context to be used
    ThreadContext *tc;
    // Checker thread context; will wrap the OzoneTC if a checker is
    // being used.
    ThreadContext *checkerTC;

    typedef OzoneThreadState<Impl> ImplState;

  private:
    // Committed thread state for the OzoneCPU.
    OzoneThreadState<Impl> thread;

  public:
    // main simulation loop (one cycle)
    void tick();

    std::set<InstSeqNum> snList;
    std::set<Addr> lockAddrList;
  private:
    struct TickEvent : public Event
    {
        OzoneCPU *cpu;
        int width;

        TickEvent(OzoneCPU *c, int w);
        void process();
        const char *description();
    };

    TickEvent tickEvent;

    /// Schedule tick event, regardless of its current state.
    void scheduleTickEvent(int delay)
    {
        if (tickEvent.squashed())
            tickEvent.reschedule(curTick + cycles(delay));
        else if (!tickEvent.scheduled())
            tickEvent.schedule(curTick + cycles(delay));
    }

    /// Unschedule tick event, regardless of its current state.
    void unscheduleTickEvent()
    {
        if (tickEvent.scheduled())
            tickEvent.squash();
    }

  public:
    enum Status {
        Running,
        Idle,
        SwitchedOut
    };

    Status _status;

  public:
    void post_interrupt(int int_num, int index);

    void zero_fill_64(Addr addr) {
        static int warned = 0;
        if (!warned) {
            warn ("WH64 is not implemented");
            warned = 1;
        }
    };

    typedef typename Impl::Params Params;

    OzoneCPU(Params *params);

    virtual ~OzoneCPU();

    void init();

  public:
    BaseCPU *getCpuPtr() { return this; }

    void setCpuId(int id) { cpuId = id; }

    int readCpuId() { return cpuId; }

    int cpuId;

    void switchOut();
    void signalSwitched();
    void takeOverFrom(BaseCPU *oldCPU);

    int switchCount;

#if FULL_SYSTEM
    Addr dbg_vtophys(Addr addr);

    bool interval_stats;

    AlphaITB *itb;
    AlphaDTB *dtb;
    System *system;
    PhysicalMemory *physmem;
#endif

    virtual Port *getPort(const std::string &name, int idx);

    MemObject *mem;

    FrontEnd *frontEnd;

    BackEnd *backEnd;

  private:
    Status status() const { return _status; }
    void setStatus(Status new_status) { _status = new_status; }

    virtual void activateContext(int thread_num, int delay);
    virtual void suspendContext(int thread_num);
    virtual void deallocateContext(int thread_num, int delay);
    virtual void haltContext(int thread_num);

    // statistics
    virtual void regStats();
    virtual void resetStats();

    // number of simulated instructions
  public:
    Counter numInst;
    Counter startNumInst;

    virtual Counter totalInstructions() const
    {
        return numInst - startNumInst;
    }

  private:
    // number of simulated loads
    Counter numLoad;
    Counter startNumLoad;

    // number of idle cycles
    Stats::Average<> notIdleFraction;
    Stats::Formula idleFraction;

  public:
    virtual void serialize(std::ostream &os);
    virtual void unserialize(Checkpoint *cp, const std::string &section);

#if FULL_SYSTEM
    /** Translates instruction requestion. */
    Fault translateInstReq(RequestPtr &req, OzoneThreadState<Impl> *thread)
    {
        return itb->translate(req, thread->getTC());
    }

    /** Translates data read request. */
    Fault translateDataReadReq(RequestPtr &req, OzoneThreadState<Impl> *thread)
    {
        return dtb->translate(req, thread->getTC(), false);
    }

    /** Translates data write request. */
    Fault translateDataWriteReq(RequestPtr &req, OzoneThreadState<Impl> *thread)
    {
        return dtb->translate(req, thread->getTC(), true);
    }

#else
    /** Translates instruction requestion in syscall emulation mode. */
    Fault translateInstReq(RequestPtr &req, OzoneThreadState<Impl> *thread)
    {
        return thread->getProcessPtr()->pTable->translate(req);
    }

    /** Translates data read request in syscall emulation mode. */
    Fault translateDataReadReq(RequestPtr &req, OzoneThreadState<Impl> *thread)
    {
        return thread->getProcessPtr()->pTable->translate(req);
    }

    /** Translates data write request in syscall emulation mode. */
    Fault translateDataWriteReq(RequestPtr &req, OzoneThreadState<Impl> *thread)
    {
        return thread->getProcessPtr()->pTable->translate(req);
    }
#endif

    /** Old CPU read from memory function. No longer used. */
    template <class T>
    Fault read(Request *req, T &data)
    {
#if 0
#if FULL_SYSTEM && defined(TARGET_ALPHA)
        if (req->flags & LOCKED) {
            req->xc->setMiscReg(TheISA::Lock_Addr_DepTag, req->paddr);
            req->xc->setMiscReg(TheISA::Lock_Flag_DepTag, true);
        }
#endif
        if (req->flags & LOCKED) {
            lockAddrList.insert(req->paddr);
            lockFlag = true;
        }
#endif
        Fault error;

        error = this->mem->read(req, data);
        data = gtoh(data);
        return error;
    }


    /** CPU read function, forwards read to LSQ. */
    template <class T>
    Fault read(Request *req, T &data, int load_idx)
    {
        return backEnd->read(req, data, load_idx);
    }

    /** Old CPU write to memory function. No longer used. */
    template <class T>
    Fault write(Request *req, T &data)
    {
#if 0
#if FULL_SYSTEM && defined(TARGET_ALPHA)
        ExecContext *xc;

        // If this is a store conditional, act appropriately
        if (req->flags & LOCKED) {
            xc = req->xc;

            if (req->flags & UNCACHEABLE) {
                // Don't update result register (see stq_c in isa_desc)
                req->result = 2;
                xc->setStCondFailures(0);//Needed? [RGD]
            } else {
                bool lock_flag = xc->readMiscReg(TheISA::Lock_Flag_DepTag);
                Addr lock_addr = xc->readMiscReg(TheISA::Lock_Addr_DepTag);
                req->result = lock_flag;
                if (!lock_flag ||
                    ((lock_addr & ~0xf) != (req->paddr & ~0xf))) {
                    xc->setMiscReg(TheISA::Lock_Flag_DepTag, false);
                    xc->setStCondFailures(xc->readStCondFailures() + 1);
                    if (((xc->readStCondFailures()) % 100000) == 0) {
                        std::cerr << "Warning: "
                                  << xc->readStCondFailures()
                                  << " consecutive store conditional failures "
                                  << "on cpu " << req->xc->readCpuId()
                                  << std::endl;
                    }
                    return NoFault;
                }
                else xc->setStCondFailures(0);
            }
        }

        // Need to clear any locked flags on other proccessors for
        // this address.  Only do this for succsful Store Conditionals
        // and all other stores (WH64?).  Unsuccessful Store
        // Conditionals would have returned above, and wouldn't fall
        // through.
        for (int i = 0; i < this->system->threadContexts.size(); i++){
            xc = this->system->threadContexts[i];
            if ((xc->readMiscReg(TheISA::Lock_Addr_DepTag) & ~0xf) ==
                (req->paddr & ~0xf)) {
                xc->setMiscReg(TheISA::Lock_Flag_DepTag, false);
            }
        }

#endif

        if (req->flags & LOCKED) {
            if (req->flags & UNCACHEABLE) {
                req->result = 2;
            } else {
                if (this->lockFlag) {
                    if (lockAddrList.find(req->paddr) !=
                        lockAddrList.end()) {
                        req->result = 1;
                    } else {
                        req->result = 0;
                        return NoFault;
                    }
                } else {
                    req->result = 0;
                    return NoFault;
                }
            }
        }
#endif

        return this->mem->write(req, (T)htog(data));
    }

    /** CPU write function, forwards write to LSQ. */
    template <class T>
    Fault write(Request *req, T &data, int store_idx)
    {
        return backEnd->write(req, data, store_idx);
    }

    void prefetch(Addr addr, unsigned flags)
    {
        // need to do this...
    }

    void writeHint(Addr addr, int size, unsigned flags)
    {
        // need to do this...
    }

    Fault copySrcTranslate(Addr src);

    Fault copy(Addr dest);

  public:
    void squashFromTC();

    void dumpInsts() { frontEnd->dumpInsts(); }

#if FULL_SYSTEM
    Fault hwrei();
    int readIntrFlag() { return thread.intrflag; }
    void setIntrFlag(int val) { thread.intrflag = val; }
    bool inPalMode() { return AlphaISA::PcPAL(thread.PC); }
    bool inPalMode(Addr pc) { return AlphaISA::PcPAL(pc); }
    bool simPalCheck(int palFunc);
    void processInterrupts();
#else
    void syscall(uint64_t &callnum);
    void setSyscallReturn(SyscallReturn return_value, int tid);
#endif

    ThreadContext *tcBase() { return tc; }

    struct CommStruct {
        InstSeqNum doneSeqNum;
        InstSeqNum nonSpecSeqNum;
        bool uncached;
        unsigned lqIdx;

        bool stall;
    };

    InstSeqNum globalSeqNum;

    TimeBuffer<CommStruct> comm;

    bool decoupledFrontEnd;

    bool lockFlag;

    Stats::Scalar<> quiesceCycles;

    Checker<DynInstPtr> *checker;
};

#endif // __CPU_OZONE_CPU_HH__
