#include "text.h"
#include "gfx.h"
#include "mem.h"
#include "font.h"

void gpu_draw_char(unsigned char code, unsigned int x, unsigned int y, unsigned int frame_buffer) {
  if (code > NUM_CHARS || x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT || frame_buffer == 0)
    return;

  unsigned int char_offset = code << 4;
  const unsigned int bytes_per_pixel = BIT_DEPTH / 8;
  const unsigned int bytes_per_pixel_row = bytes_per_pixel * SCREEN_WIDTH;

  unsigned int draw_buffer = GET32(frame_buffer + FRAME_BUFFER_POINTER_OFFSET);
  draw_buffer += (x * bytes_per_pixel) + (y * bytes_per_pixel_row);

  unsigned int row, pixel;
  for (row = 0; row < BYTES_PER_CHAR_RENDER; row++) {
    for (pixel = 0x80; pixel != 0; pixel = pixel >> 1) {
      if ((FONT[char_offset] & pixel) != 0)
        PUT32(draw_buffer, TEXT_COLOR);

      draw_buffer += bytes_per_pixel;
    }

    draw_buffer += (bytes_per_pixel_row - (bytes_per_pixel * 8));
    char_offset++;
  }
}


void gpu_draw_str(char *str, unsigned int x, unsigned int y, unsigned int frame_buffer) {
  while (1) {
    unsigned char c = GET_BYTE((unsigned int) str);

    if (c == 0)
      break;

    if (x + 8 >= SCREEN_WIDTH) {
      x = 0;
      y += 20;
    }

    gpu_draw_char(c, x, y, frame_buffer);
    x += 10;
    str++;
  }
}

