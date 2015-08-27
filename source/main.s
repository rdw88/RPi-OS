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
    ldr r0, =50000
    bleq GpioFlashInfinite

  noerror$:
    mov r3, r0
    ldr r0, =customStrings
    ldr r1, =475
    ldr r2, =375

    bl DrawString

    forever$:
    b forever$


.section .data
.align 4
.globl screenRes
.globl customStrings


screenRes:
  .int 1024 /* Width */
  .int 768 /* Height */
  .int 16 /* Bit Depth */

customStrings:
  .short 1
  .byte 0x39
