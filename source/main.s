.section .init
.globl _start


_start:
  b main

.section .text

main:
  mov sp, #0x8000
  ldr r0, =1024
  ldr r1, =768
  mov r2, #16
  bl InitializeFrameBuffer

  teq r0, #0
  bne noerror$

  error$:
    ldr r0, =150000
    bleq GpioFlashInfinite

  noerror$:
    mov r3, r0
    mov r0, #0
    mov r1, #500
    mov r2, #300

    bl DrawCharacter

    mov r3, r0
    mov r0, #16
    mov r1, #520
    mov r2, #300

    bl DrawCharacter

    mov r3, r0
    mov r0, #32
    mov r1, #540
    mov r2, #300

    bl DrawCharacter

    mov r3, r0
    mov r0, #48
    mov r1, #560
    mov r2, #300

    bl DrawCharacter

    forever$:
    b forever$
