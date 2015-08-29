#include "gpio.h"
#include "gfx.h"
#include "mem.h"
#include "text.h"

void init(void) {
  unsigned int frame_buffer = init_frame_buffer(SCREEN_WIDTH, SCREEN_HEIGHT, BIT_DEPTH);

  if (frame_buffer == 0) {
    setGpioFunc(GPIO_OK_LED_ADDR, GPIO_FUNC_WRITE);
    setGpio(GPIO_OK_LED_ADDR, GPIO_SET_ON);
    return;
  }

  char *testString = "Hello, this is a test to see if the sentence will keep on going onto the next line when it overflows the screen alksjdflkasjdflkjsadlfkjasdlkfjlksadjflkasdjfkljsadlkfjsaldkfjlsakdjflksadjflkasjdflkjsadlfkjsaldkfjlkasjfewjioejwfoijweoifjweoifjoiwncoinvoinvoinewvoinweiovnoiwenvoiwnevionweoiniweonviowneivonwoienviowenviowevnoiwenvoiwnevoinwieonvoinweoiniwevoniowejf.\0";
  gpu_draw_str(testString, 0, 0, frame_buffer);
}
