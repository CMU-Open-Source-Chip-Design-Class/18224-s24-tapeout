# VGA Resolution Demonstrator

Bill Nace
18-224 Spring 2024 Final Tapeout Project

## Overview

A simple VGA module driving two different resolutions.

## How it Works

I have two different VGA modules, tuned for different resolutions and 
requiring different clock frequencies.  The 640x480 resolution module 
works with a 25MHz clock.  The 800x600 resolution version works with
a 29.5MHz clock.

Both modules are used in this demonstrator to output a test pattern,
consisting of bars of different colors.  The test pattern is slightly
different on the two resolutions, just to ensure there is a visible
difference on the monitor to distinguish which resolution is which.


## Inputs/Outputs

| io_in[0]    | choose vga mode, when 0 640x480. When 1, 800x480 |
|-------------|--------------------------------------------------|
| io_in[11:1] | unused                                           |
| io_out[2:0] | Red channel                                      |
| io_out[5:3] | Green channel                                    |
| io_out[8:6] | Blue channel                                     |
| io_out[9]   | HS, horizontal sync                              |
| io_out[10]  | VS, vertical sync                                |
| io_out[11]  | liveness check.  Toggles every couple of seconds |

## Hardware Peripherals

The output is 3-bit color, which is good for driving the Digilent PmodVGA
board.

Clock frequency should be 25MHz for 640x480 mode and 29.5MHz for 800x600
mode.

## Design Testing / Bringup

I tested my design with FPGA emulation only.  No simulation scripts
were written in the course of this project. (don't tell my students).

Bringup should probably proceed with a liveness check, followed by
connection to the VGA monitor.

The liveness output is a "divide by a lot of bits" counter, which should
toggle every four seconds or so.

Connecting to a VGA monitor should show a test pattern of each of the
8 basic colors (black, blue, green, cyan, red, purple, yellow, white).
In 600x480 mode, each color will be a rectangle on the top half of the
screen.  In 800x600 mode, each color is a rectangle from the top of the 
screen.  The length of the color rectangles vary, from 60 pixels tall for 
the blue rectangle, increasing by 60 pixels for each.  Thus, the white
rectangle is from (700,0) to (799,419).  Remember that the top row of the
screen is row zero.


