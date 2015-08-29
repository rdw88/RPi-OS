#ifndef TEXT_H__
#define TEXT_H__

#define BYTES_PER_CHAR_RENDER 16
#define NUM_CHARS 128
#define FONT_BIN_LEN 2048
#define TEXT_COLOR 0xffffffff

void gpu_draw_char(unsigned char code, unsigned int x, unsigned int y, unsigned int frame_buffer);

void gpu_draw_str(char *str, unsigned int x, unsigned int y, unsigned int frame_buffer);

#endif
