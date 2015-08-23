.section .init
.globl _start


_start:
  b main

.section .text
main:
  mov sp, #0x8000
  pinNum .req r0
  pinFunc .req r1
  mov pinNum,#16
  mov pinFunc,#1
  bl SetGpioFunction
  .unreq pinNum
  .unreq pinFunc

  ptrn .req r4
  ldr ptrn,=pattern
  ldr ptrn,[ptrn]
  seq .req r5
  mov seq,#0

  loop$:
    pinNum .req r0
    pinVal .req r1
    mov pinNum,#16
    mov pinVal,#1
    lsl pinVal, seq
    and pinVal, ptrn
    bl SetGpio
    .unreq pinNum
    .unreq pinVal
    add seq, #1

    ldr r0, =250000
    bl systemWait

    teq seq, #32
    moveq seq, #0

    b loop$

.section .data
.align 2

pattern:
  .int 0b11111111101010100010001000101010
