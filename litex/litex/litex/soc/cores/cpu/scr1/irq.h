/**
 * Copyright (c) 2023 Syntacore
 * Copyright (c) 2019 Western Digital Corporation or its affiliates
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Some definitions taken from https://github.com/syntacore/zephyr
 *
 * Syntacore:
 * file: intc_scr_ipic.c
 * author: psk-sc
 * brief: Syntacore Integrated Programmable Interrupt Controller (IPIC) Interface
 *        for RISC-V processors
 *
 * Western Digital Corporation or its affiliates:
 * irq_enable modified from:
 * file: intc_swerv_pic.c
 */

#ifndef __IRQ_H
#define __IRQ_H

#ifdef __cplusplus
extern "C" {
#endif

#include <system.h>
#include <generated/csr.h>
#include <stdio.h>

#define IPIC_IRQ_PENDING       (1 << 0)
#define IPIC_IRQ_ENABLE        (1 << 1)
#define IPIC_IRQ_LEVEL         (0 << 2)
#define IPIC_IRQ_EDGE          (1 << 2)
#define IPIC_IRQ_INV           (1 << 3)
#define IPIC_IRQ_MODE_MASK     (3 << 2)
#define IPIC_IRQ_CLEAR_PENDING IPIC_IRQ_PENDING

#define IPIC_IRQ_IN_SERVICE (1 << 4) // RO
#define IPIC_IRQ_PRIV_MASK  (3 << 8)
#define IPIC_IRQ_PRIV_MMODE (3 << 8)
#define IPIC_IRQ_PRIV_SMODE (1 << 8)
#define IPIC_IRQ_LN_OFFS    (12)

#ifndef PLF_IPIC_MBASE
#define PLF_IPIC_MBASE (0xbf0)
#endif
#define IPIC_CISV  (PLF_IPIC_MBASE + 0)
#define IPIC_CICSR (PLF_IPIC_MBASE + 1)
#define IPIC_IPR   (PLF_IPIC_MBASE + 2)
#define IPIC_ISVR  (PLF_IPIC_MBASE + 3)
#define IPIC_EOI   (PLF_IPIC_MBASE + 4)
#define IPIC_SOI   (PLF_IPIC_MBASE + 5)
#define IPIC_IDX   (PLF_IPIC_MBASE + 6)
#define IPIC_ICSR  (PLF_IPIC_MBASE + 7)
#define IPIC_IER   (PLF_IPIC_MBASE + 8)
#define IPIC_IMAP  (PLF_IPIC_MBASE + 9)
#define IPIC_VOID_VEC 16

#define PLF_IPIC_STATIC_LINE_MAPPING 0
#define PLF_IPIC_IRQ_LN_NUM (1)
#define PLF_IPIC_IRQ_VEC_NUM 1
#define IPIC_IRQ_LN_VOID 1

#define MK_IRQ_CFG(line, mode, flags) ((mode) | (flags) | ((line) << IPIC_IRQ_LN_OFFS))


static void ipic_irq_enable(unsigned irq_vec);

static void ipic_irq_disable(unsigned irq_vec);

static unsigned long ipic_soi(void);

static void ipic_eoi(void);

static void ipic_irq_reset(int irq_vec);

static int ipic_irq_setup(int irq_vec, int line, int mode, int flags);

#define csr_read(csr)						\
({								\
	register unsigned long __rv;				\
	__asm__ volatile ("csrr %0, " STRINGIFY(csr)		\
				: "=r" (__rv));			\
	__rv;							\
})

#define csr_write(csr, val)					\
({								\
	unsigned long __wv = (unsigned long)(val);		\
	__asm__ volatile ("csrw " STRINGIFY(csr) ", %0"		\
				: : "rK" (__wv)			\
				: "memory");			\
})

#define Z_STRINGIFY(x) #x
#define STRINGIFY(s) Z_STRINGIFY(s)

static inline unsigned int irq_getie(void)
{
    return (csrr(mstatus) & CSR_MSTATUS_MIE) != 0;
}

static inline void irq_setie(unsigned int ie)
{
    if (ie)
        csrs(mstatus, CSR_MSTATUS_MIE);
    else
        csrc(mstatus, CSR_MSTATUS_MIE);
}

static inline unsigned int irq_getmask(void)  // unused
{
    return 0;
}

static inline void irq_setmask(unsigned int mask)  // unused
{
    return;
}

static inline unsigned int irq_pending(void)  // unused
{
    return 0;
}

void ipic_irq_enable(unsigned irq_vec)  // unused
{
    csr_write(IPIC_IDX, irq_vec);
    const unsigned long state = (csr_read(IPIC_ICSR) & ~IPIC_IRQ_PENDING) | IPIC_IRQ_ENABLE;
    csr_write(IPIC_ICSR, state);
}

void ipic_irq_disable(unsigned irq_vec)  // unused
{
    csr_write(IPIC_IDX, irq_vec);
    const unsigned long state = csr_read(IPIC_ICSR) & ~(IPIC_IRQ_ENABLE | IPIC_IRQ_PENDING);
    csr_write(IPIC_ICSR, state);
}

static void ipic_eoi(void)
{
    csr_write(IPIC_EOI, 0);
}

static unsigned long ipic_soi(void)
{
    csr_write(IPIC_SOI, 0);
    unsigned long value = csr_read(IPIC_CISV);
    return value;
}

static int ipic_irq_setup(int irq_vec, int line, int mode, int flags) {
    csr_write(IPIC_IDX, irq_vec);
    unsigned long config = MK_IRQ_CFG(line, mode, flags | IPIC_IRQ_CLEAR_PENDING);
    csr_write(IPIC_ICSR, config);
    return irq_vec;
}

static void ipic_irq_reset(int irq_vec)  // unused
{
    ipic_irq_setup(irq_vec, IPIC_IRQ_LN_VOID, IPIC_IRQ_PRIV_MMODE, IPIC_IRQ_CLEAR_PENDING);
}

#ifdef __cplusplus
}
#endif

#endif /* __IRQ_H */
