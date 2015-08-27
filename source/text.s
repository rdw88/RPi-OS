.section .text

.globl DrawCharacter
.globl DrawString

/* r0=char, r1=x, r2=y, r3=framebuffer */
DrawCharacter:
  push {r4, r5, r6, r7, r8, r9, r10, r11, lr}

  ldr r8, =fontSize
  ldr r8, [r8, #4]
  cmp r0, r8
  ldrls r8, =screenRes
  movls r9, r8
  ldrls r8, [r8]
  cmpls r1, r8
  ldrhi r0, =150000
  bhi GpioFlashInfinite
  addls r9, #4
  cmpls r2, r9
  movhi pc, lr
  teq r3, #0
  moveq pc, lr

  offset .req r0
  x .req r1
  y .req r2
  frameBuffer .req r9
  initOffset .req r4
  base .req r5
  pixel .req r6
  color .req r7
  bytesPerRow .req r10

  lsl offset, #4 /* Multiply char by 16 to get offset in memory */
  mov initOffset, offset
  ldr color, =0xffff
  ldr bytesPerRow, =screenRes
  ldr bytesPerRow, [bytesPerRow]
  add bytesPerRow, bytesPerRow

  render$:
    ldr frameBuffer, [r3, #32]
    mul r11, bytesPerRow, y
    add r11, x
    add r11, r11
    add frameBuffer, r11
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
      sub r11, bytesPerRow, #16
      add frameBuffer, r11
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
  .unreq bytesPerRow

  pop {r4, r5, r6, r7, r8, r9, r10, r11, pc}


/* r0=str, r1=x, r2=y, r3=frame buffer */
/* First 2 bytes of string are the length of the string, remaining bytes are ascii codes */
DrawString:
  x .req r1
  y .req r2
  frameBuffer .req r3
  string .req r4
  strlen .req r5
  counter .req r6

  push {r4, r5, r6, r7, lr}

  mov string, r0
  ldrh strlen, [string] /* load first two bytes of string (represent strlen) */
  mov counter, #2

  strDrawLoop$:
    push {x, y}
    ldr r0, [string, counter]
    bl DrawCharacter
    pop {x, y}

    mov frameBuffer, r0
    add x, #10
    add counter, #1
    sub r7, counter, #2
    cmp r7, strlen
    bl strDrawLoop$

  .unreq x
  .unreq y
  .unreq frameBuffer
  .unreq string
  .unreq strlen
  .unreq counter

  pop {r4, r5, r6, r7, pc}






.section .data
.align 4

font:
  .incbin "font.bin"

fontSize:
  .int 16 /* Each character map takes up 16 bytes of memory */
  .int 128 /* Number of characters available */
