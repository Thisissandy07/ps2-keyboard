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

Receiver and decoder:

iverilog -o ps2_sim ps2_receiver_tb.v ps2_receiver.v shift_reg.v key_decoder.v
vvp ps2_sim
gtkwave ps2_receiver.vcd

Shift register:

iverilog -o shift_sim shift_reg_tb.v shift_reg.v
vvp shift_sim
gtkwave shift_reg.vcd

Clock:

iverilog -o clock_sim clock_tb.v
vvp clock_sim
gtkwave clock.vcd

If the receiver test passes, it prints a PASS message. If a key comes out wrong, it stops with an error.

