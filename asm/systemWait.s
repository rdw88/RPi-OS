.globl getSystemTime
.globl systemWait

getSystemTime:
  ldr r3, =0x20003000
  ldr r0, [r3, #4]
  mov pc, lr

systemWait:
  waitUntil .req r1
  push {lr}
  mov waitUntil, r0
  currentTime .req r0
  bl getSystemTime
  add waitUntil, currentTime

  waitloop$:
    bl getSystemTime
    cmp currentTime, waitUntil
    bls waitloop$

  .unreq currentTime
  .unreq waitUntil
  pop {pc}
