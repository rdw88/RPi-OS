#include "gfx.h"
#include "mem.h"
#include "gpio.h"

unsigned int gpu_mailboxSend(unsigned int mailboxNumber, unsigned int message) {
  if ((message & 0xf) != 0) {
    return 1;
  }

  if (mailboxNumber > 15) {
    return 1;
  }

  unsigned int status;

  do {
    status = GET32(GPU_MAILBOX_ADDR + 0x18);
    status = status & 0x80000000;
  } while (status != 0);

  message = message | mailboxNumber;
  PUT32(GPU_MAILBOX_ADDR + 0x20, message);
  return 0;
}


unsigned int gpu_mailboxRead(unsigned int channel) {
  if (channel > 15) {
    return channel;
  }

  unsigned int status;
  unsigned int mail;
  unsigned int inchan;

  do {
    do {
      status = GET32(GPU_MAILBOX_ADDR + 0x18);
    } while ((status & 0x40000000) != 0);

    mail = GET32(GPU_MAILBOX_ADDR);
    inchan = mail & 0xf;
  } while (inchan != channel);

  return mail & 0xfffffff0;
}


unsigned int init_frame_buffer(unsigned int width, unsigned int height, unsigned int bit_depth) {
  if (width > 4096 || height > 4096 || bit_depth > 32) {
    return 0;
  }

  FrameBuffer *buffer = (FrameBuffer *) 0x40040000;
  buffer->p_width = width;
  buffer->p_height = height;
  buffer->v_width = width;
  buffer->v_height = height;
  buffer->gpu_pitch = 0;
  buffer->bit_depth = bit_depth;
  buffer->x = 0;
  buffer->y = 0;
  buffer->buffer = 0;
  buffer->bufferSize = 0;

  unsigned int buffer_ptr = (unsigned int) buffer;
  unsigned int stat = gpu_mailboxSend(1, buffer_ptr);
  if (stat != 0) {
    return 0;
  }

  unsigned int result = gpu_mailboxRead(1);
  if (result != 0) {
    return 0;
  }

  return buffer_ptr;
}
