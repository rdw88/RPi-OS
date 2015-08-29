#ifndef GPIO_H__
#define GPIO_H__

#define GPIO_BASE_ADDRESS 0x20200000
#define GPIO_FUNC_READ 0
#define GPIO_FUNC_WRITE 1

#define GPIO_OK_LED_ADDR 0x10

#define GPIO_SET_ON 0
#define GPIO_SET_OFF 1

void setGpioFunc(unsigned int pinNum, unsigned int type);

void setGpio(unsigned int pinNum, unsigned int pinVal);

void ok_flashInf(unsigned int waitTime);

#endif
