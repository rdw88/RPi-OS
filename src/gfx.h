#ifndef GFX_H__
#define GFX_H__

#define GPU_MAILBOX_ADDR 0x2000B880
#define FRAME_BUFFER_POINTER_OFFSET 32

#define SCREEN_WIDTH 1440
#define SCREEN_HEIGHT 1080
#define BIT_DEPTH 32

typedef struct FrameBuffer {
  unsigned int p_width;
  unsigned int p_height;
  unsigned int v_width;
  unsigned int v_height;
  unsigned int gpu_pitch;
  unsigned int bit_depth;
  unsigned int x;
  unsigned int y;
  unsigned int buffer;
  unsigned int bufferSize;
} FrameBuffer;


unsigned int gpu_mailboxSend(unsigned int mailboxNumber, unsigned int message);

unsigned int gpu_mailboxRead(unsigned int channel);

unsigned int init_frame_buffer(unsigned int width, unsigned int height, unsigned int bit_depth);

#endif
