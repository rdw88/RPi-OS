#include "gpio.h"
#include "gfx.h"
#include "mem.h"
#include "text.h"
#include "image.h"


void init(void) {
  unsigned int frame_buffer = init_frame_buffer(SCREEN_WIDTH, SCREEN_HEIGHT, BIT_DEPTH);

  if (frame_buffer == 0) {
    setGpioFunc(GPIO_OK_LED_ADDR, GPIO_FUNC_WRITE);
    setGpio(GPIO_OK_LED_ADDR, GPIO_SET_ON);
    return;
  }

  draw_bitmap(GET_PICTURE(0), 0, 0, frame_buffer);
}
