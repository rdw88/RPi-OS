#include "gpio.h"
#include "wait.h"
#include "mem.h"


void setGpioFunc(unsigned int pinNum, unsigned int type) {
  if (pinNum > 53 || type > 7) {
    return;
  }

  unsigned int ok_addr = GPIO_BASE_ADDRESS;

  while (pinNum > 9) {
    pinNum -= 10;
    ok_addr += 4;
  }

  pinNum = pinNum + (pinNum << 1);
  type = type << pinNum;
  PUT32(ok_addr, type);
}


void setGpio(unsigned int pinNum, unsigned int pinVal) {
  if (pinNum > 53)
    return;

  unsigned int ok_addr = GPIO_BASE_ADDRESS;
  unsigned int pinBank = pinNum >> 5;
  pinBank = pinBank << 2;
  ok_addr += pinBank;

  pinNum = pinNum & 31;
  unsigned int setBit = 1;
  setBit = setBit << pinNum;

  if (pinVal == 0) {
    ok_addr += 40;
  } else {
    ok_addr += 28;
  }

  PUT32(ok_addr, setBit);
}


void ok_flashInf(unsigned int waitTime) {
  setGpioFunc(GPIO_OK_LED_ADDR, 1);

  while (1) {
    setGpio(GPIO_OK_LED_ADDR, GPIO_SET_ON);
    wait(waitTime);
    setGpio(GPIO_OK_LED_ADDR, GPIO_SET_OFF);
    wait(waitTime);
  }
}
