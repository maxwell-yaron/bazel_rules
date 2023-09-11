#include "static_lib.h"
#include "dynamic_lib.h"
#include "generic_lib.h"

#include <iostream>
#include <cmath>
#include <thread>

void local_hello() {
  std::cout << "hello world" << std::endl;
}

int main() {
  std::thread th(local_hello);
  static_hello();
  generic_hello();
  dynamic_hello();
  th.join();
  return 0;
};
