.section .text

.globl GetMailboxBase
.globl MailboxSend
.globl MailboxRead
.globl InitializeFrameBuffer

GetMailboxBase:
  ldr r0, =0x2000B880
  mov pc, lr


MailboxSend:
  mailboxNumber .req r1
  message .req r2
  mov message, r0
  tst message, #0b1111
  movne pc, lr
  cmp mailboxNumber, #15
  movhi pc, lr

  push {lr}
  bl GetMailboxBase
  status .req r3
  mailboxAddr .req r0

  statusloop$:
    ldr status, [mailboxAddr, #0x18]
    and status, #0x80000000
    teq status, #0
    bne statusloop$

  .unreq status
  orr message, mailboxNumber
  str message, [mailboxAddr, #0x20]

  .unreq message
  .unreq mailboxNumber
  .unreq mailboxAddr
  pop {pc}


MailboxRead:
  channel .req r1
  mov channel, r0
  cmp channel, #15
  movhi pc, lr

  push {lr}
  bl GetMailboxBase
  mailbox .req r0

  rightmail$:
  readloop$:
    status .req r2
    ldr status, [mailbox, #0x18]
    tst status, #0x40000000
    .unreq status
    bne readloop$

  mail .req r2
  ldr mail, [mailbox]
  inchan .req r3
  and inchan, mail, #0b1111
  teq inchan, channel
  .unreq inchan
  bne rightmail$
  .unreq channel
  .unreq mailbox

  and r0, mail, #0xfffffff0
  .unreq mail
  pop {pc}

/* r0 = width, r1 = height, r2 = bit depth */
InitializeFrameBuffer:
  width .req r3
  height .req r1
  depth .req r2
  mov width, r0
  cmp width, #4096
  cmpls height, #4096
  cmpls depth, #32
  result .req r0
  movhi result, #0
  movhi pc, lr

  push {r4,lr}
  FrameBuffer .req r4
  ldr FrameBuffer, =FrameBufferInfo
  str width, [FrameBuffer, #0]
  str height, [FrameBuffer, #4]
  str width, [FrameBuffer, #8]
  str height, [FrameBuffer, #12]
  str depth, [FrameBuffer, #20]

  .unreq width
  .unreq height
  .unreq depth
  mov r0, FrameBuffer
  add r0, #0x40000000
  mov r1, #1
  bl MailboxSend
  mov r0, #1
  bl MailboxRead
  teq result, #0
  movne result, #0
  popne {r4,pc}
  mov result, FrameBuffer
  .unreq FrameBuffer
  .unreq result
  pop {r4,pc}


.section .data
.align 12
.globl FrameBufferInfo

FrameBufferInfo:
  .int 1024 /* #0 Physical Width */
  .int 768 /* #4 Physical Height */
  .int 1024 /* #8 Virtual Width */
  .int 768 /* #12 Virtual Height */
  .int 0 /* #16 GPU - Pitch */
  .int 16 /* #20 Bit Depth */
  .int 0 /* #24 X */
  .int 0 /* #28 Y */
  .int 0 /* #32 GPU - Frame Buffer Pointer */
  .int 0 /* #36 GPU - Frame Buffer Size */
