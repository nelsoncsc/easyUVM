# easyUVM

A small UVM testbench for an adder, including a SystemVerilog DPI-C reference-model example.

The UVM testbench walkthrough is available at https://sistenix.com/basic_uvm.html.

## DPI-C example

`refmod.sv` imports C functions implemented in `external.cpp`:

```systemverilog
import "DPI-C" context function int sum(int a, int b);
import "DPI-C" function void c_receive_data(int a, int b, int result);
```

There are two DPI directions that are easy to confuse:

- **SystemVerilog -> C:** declare a C/C++ function with `import "DPI-C"` in SystemVerilog, then call it and pass the values as arguments. `c_receive_data()` demonstrates this by sending `A`, `B`, and the reference result to C.
- **C -> SystemVerilog:** declare a SystemVerilog function/task with `export "DPI-C"` when C needs to call back into SystemVerilog.

For the question in issue #1 (sending data from the UVM/SystemVerilog side into C), the first form is the appropriate one; an SV `export` is not required.

The C implementation uses C linkage so the simulator can find the symbols when compiling as C++:

```cpp
extern "C" void c_receive_data(int a, int b, int result) {
  printf("DPI-C received: a=%d b=%d result=%d\n", a, b, result);
}
```

## Running

The supplied `Makefile` targets Synopsys VCS and expects `vcs`, a C++ compiler, and a UVM-capable installation to be available in the environment:

```sh
make sim
```
