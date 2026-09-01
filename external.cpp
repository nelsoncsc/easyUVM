#include <stdio.h>

extern "C" int sum(int a, int b) {
  return a + b;
}

// SystemVerilog can pass data to C by importing this function and calling it
// with ordinary DPI-compatible arguments.  This is the direction most users
// mean when they want to "export data to C".
extern "C" void c_receive_data(int a, int b, int result) {
  printf("DPI-C received: a=%d b=%d result=%d\n", a, b, result);
}
