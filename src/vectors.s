.section .text

.globl _start
_start:
  mov sp,#0x8000
  bl init

hang: b hang

.globl PUT32
PUT32:
  str r1, [r0]
  bx lr


.globl PUT16
PUT16:
  strh r1, [r0]
  bx lr


.globl PUT_BYTE
PUT_BYTE:
  strb r1, [r0]
  bx lr


.globl GET32
GET32:
  ldr r0, [r0]
  bx lr


.globl GET16
GET16:
  ldrh r0, [r0]
  bx lr


.globl GET_BYTE
GET_BYTE:
  ldrb r0, [r0]
  bx lr
