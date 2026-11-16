# PS/2 Keyboard Receiver

A Verilog project that reads data from a PS/2 keyboard and turns key presses into ASCII characters.

## What it does

- Reads the serial data a PS/2 keyboard sends
- Checks the parity bit to catch bad data
- Detects when a key is pressed and when it is released
- Converts scan codes into ASCII (letters, numbers, space and Enter)
- Handles Shift and Caps Lock

## How it works

A PS/2 keyboard sends each key as a scan code, one bit at a time. Each byte is sent as 11 bits: a start bit, 8 data bits (lowest bit first), an odd parity bit and a stop bit.

1. The receiver (ps2_receiver) watches for falling edges on the PS/2 clock and collects the bits using the shift register.
2. It checks the parity bit. A good byte comes out as scan_code with scan_valid set.
3. The decoder (key_decoder) turns the scan code into an ASCII character.

When a key is released, the keyboard sends F0 first and then the key's code. The decoder watches for F0 and marks the next key as released.

## Files

- ps2_receiver.v : receives PS/2 data and checks parity
- shift_reg.v : 8-bit shift register (module name: shift_register)
- key_decoder.v : converts scan codes to ASCII and detects press/release
- ps2_receiver_tb.v : tests the receiver and decoder together
- shift_reg_tb.v : tests the shift register
- clock_tb.v : simple clock test

## Decoder outputs

- key_ascii : the ASCII value of the key
- key_released : 1 if the key was released, 0 if pressed
- key_valid : 1 for one clock cycle when a new key is ready

## Tools needed

- Icarus Verilog (to simulate)
- GTKWave (to view waveforms)

## How to run the tests

Run these commands from the project root (`ps2keyboard`).

Receiver and decoder (compile, then print simulation output):

```sh
make run
```

Open the generated waveform:

```sh
gtkwave ps2_receiver.vcd
```

In GTKWave, select `ps2_receiver_tb` in the hierarchy, select signals and
click **Append**, then use **Zoom Fit** to see the full simulation.
Useful signals: `clk`, `reset`, `ps2_clk`, `ps2_data`, `scan_code`,
`scan_valid`, `key_ascii`, `key_released`, and `key_valid`.
Set `key_ascii` to ASCII display to read characters.

Equivalent commands without Make:

```sh
mkdir -p build
iverilog -s ps2_receiver_tb -o build/ps2_receiver_tb.vvp testbench/ps2_receiver_tb.v src/ps2_receiver.v src/shift_reg.v src/key_decoder.v
vvp build/ps2_receiver_tb.vvp
gtkwave ps2_receiver.vcd
```

Shift register:

```sh
make run TB=shift_reg_tb
gtkwave shift_reg.vcd
```

Clock:

```sh
make run TB=clock_tb
gtkwave clock.vcd
```

Compile without running: `make`. Run all testbenches: `make test-all`.
Remove compiled files: `make clean`. VCD files are regenerated whenever
simulations run and can be deleted when no longer needed.

The receiver test checks 12 press/release cases: 7 unshifted, 3 with Left Shift,
and 2 with Right Shift. It prints a final PASS message when all checks pass.
Caps Lock is not currently tested. The clock and shift-register testbenches
do not contain self-checking assertions.
