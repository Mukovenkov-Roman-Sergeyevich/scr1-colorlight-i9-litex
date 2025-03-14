.global main
.global isr
.global _start

_start:
    j crt_init
    nop
    nop
    nop
    nop
    nop
    nop
    nop

.global trap_entry
.align(6)
trap_entry:
    addi sp, sp, -16*4
    sw   x1,  0*4(sp)
    sw   x5,  1*4(sp)
    sw   x6,  2*4(sp)
    sw   x7,  3*4(sp)
    sw   x10, 4*4(sp)
    sw   x11, 5*4(sp)
    sw   x12, 6*4(sp)
    sw   x13, 7*4(sp)
    sw   x14, 8*4(sp)
    sw   x15, 9*4(sp)
    sw   x16, 10*4(sp)
    sw   x17, 11*4(sp)
    sw   x28, 12*4(sp)
    sw   x29, 13*4(sp)
    sw   x30, 14*4(sp)
    sw   x31, 15*4(sp)
    call isr
    lw   x1,  0*4(sp)
    lw   x5,  1*4(sp)
    lw   x6,  2*4(sp)
    lw   x7,  3*4(sp)
    lw   x10, 4*4(sp)
    lw   x11, 5*4(sp)
    lw   x12, 6*4(sp)
    lw   x13, 7*4(sp)
    lw   x14, 8*4(sp)
    lw   x15, 9*4(sp)
    lw   x16, 10*4(sp)
    lw   x17, 11*4(sp)
    lw   x28, 12*4(sp)
    lw   x29, 13*4(sp)
    lw   x30, 14*4(sp)
    lw   x31, 15*4(sp)
    addi sp, sp, 16*4
    mret
.text

crt_init:
    la sp, _fstack
    la a0, trap_entry
    csrw mtvec, a0

data_init:
    la a0, _fdata
    la a1, _edata
    la a2, _fdata_rom
data_loop:
    beq a0,a1,data_done
    lw a3,0(a2)
    sw a3,0(a0)
    add a0,a0,4
    add a2,a2,4
    j data_loop
data_done:

bss_init:
    la a0, _fbss
    la a1, _ebss
bss_loop:
    beq a0,a1,bss_done
    sw zero,0(a0)
    add a0,a0,4
    j bss_loop

bss_done:
    call scr_ipic_init
    li a0, 0x800  # No timer
    csrw mie, a0
    call main
infinit_loop:
    j infinit_loop
