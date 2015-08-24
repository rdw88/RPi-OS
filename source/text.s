.section .text

.globl DrawCharacter

/* r0=char (offset), r1=x, r2=y, r3=framebuffer */
DrawCharacter:
  cmp r0, #48
  cmpls r1, #1024
  cmpls r2, #768
  movhi pc, lr
  teq r3, #0
  moveq pc, lr

  push {r4, r5, r6, r7, r8, r9, lr}

  offset .req r0
  x .req r1
  y .req r2
  frameBuffer .req r9
  initOffset .req r4
  base .req r5
  pixel .req r6
  color .req r7

  mov initOffset, offset
  ldr color, =0xffff

  render$:
    ldr frameBuffer, [r3, #32]
    ldr r8, =2048
    mul r8, y
    add r8, x
    add frameBuffer, r8
    mov offset, initOffset

    row$:
      ldr r8, =font
      add r8, offset
      ldrb base, [r8]
      mov pixel, #0b10000000

      pixel$:
        and r8, base, pixel
        teq r8, #0
        beq skippixel$

        strh color, [frameBuffer]
        skippixel$:
          add frameBuffer, #2
          lsr pixel, #1
          teq pixel, #0
          bne pixel$

      add offset, #1
      add r8, initOffset, #16
      add frameBuffer, #2032
      teq r8, offset
      bne row$

  mov r0, r3
  .unreq offset
  .unreq x
  .unreq y
  .unreq frameBuffer
  .unreq initOffset
  .unreq base
  .unreq pixel
  .unreq color

  pop {r4, r5, r6, r7, r8, r9, pc}




.section .data
.align 4

font:
  .incbin "font.bin" /* offsets: R=0, Y=16, A=32, N=48 */
