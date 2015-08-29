#include "wait.h"
#include "mem.h"

void wait(unsigned int microseconds) {
  unsigned int sysTime = GET32(SYSTEM_TIME_OFFSET);
  unsigned int destTime = microseconds + sysTime;

  while (sysTime < destTime) {
    sysTime = GET32(SYSTEM_TIME_OFFSET);
  }
}
