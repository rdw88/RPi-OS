.section .init
.globl _start


_start:
  b main

.section .text

main:
  mov sp, #0x8000
  ldr r0, =screenRes
  ldr r1, [r0, #4]
  ldr r2, [r0, #8]
  ldr r0, [r0]
  bl InitializeFrameBuffer

  teq r0, #0
  bne noerror$

  error$:
    ldr r0, =30000
    bleq GpioFlashInfinite

  noerror$:
    mov r3, r0
    ldr r0, =header
    ldr r1, =0
    ldr r2, =100

    bl DrawString

    mov r3, r0
    ldr r0, =createdby
    ldr r1, =0
    ldr r2, =120

    bl DrawString

    mov r3, r0
    ldr r0, =date
    ldr r1, =0
    ldr r2, =140

    bl DrawString

    forever$:
    b forever$


.section .data
.align 4
.globl screenRes


screenRes:
  .int 1440 /* Width */
  .int 1080 /* Height */
  .int 16 /* Bit Depth */

header:
  .string "Wise OS version 0.0.1"
  .byte 0

createdby:
  .string "created by Ryan Wise"
  .byte 0

date:
  .string "August 27, 2015"
  .byte 0
