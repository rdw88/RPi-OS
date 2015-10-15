#include "image.h"
#include "gfx.h"
#include "mem.h"


void draw_bitmap(unsigned int src, unsigned int x, unsigned int y, unsigned int frame_buffer) {
	unsigned int image_width = GET32(src);

	unsigned int xt, yt;
	unsigned int relative_width = x + image_width;
	unsigned int relative_height = y + GET32(src + 4);
	unsigned int index = 0;
	unsigned int pixel_color = 0;

	for (yt = y; yt < relative_height; yt++) {
		if (yt >= SCREEN_HEIGHT || yt < 0)
			continue;
		
		for (xt = x; xt < relative_width; xt++) {
			if (xt >= SCREEN_WIDTH || xt < 0) {
				index ++;
				continue;
			}
			
			pixel_color = GET32(src + (index << 2) + 8);

			gpu_set_pixel(pixel_color, xt, yt, frame_buffer);
			index ++;
		}
	}
}

