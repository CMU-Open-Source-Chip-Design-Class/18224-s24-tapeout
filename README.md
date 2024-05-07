# 18-224 Student Designs Spring 2024

This repository contains the tapeout infrastructure and student designs from the Spring 2024 18-224 course "Intro to Open-Source Chip Design" at Carnegie Mellon.

(For questions or interest, email: `wnace [at] cmu [dot] edu` or `anish [at] anishsinghani [dot] com`)

## The Course

The course was run at full scale for the first time in Spring 2024 as a way to introduce students to chip design who might not otherwise get that exposure and give them an opportunity to do mini-tapeout project. Students were taught a variety of tools including Yosys, OpenLANE/OpenROAD, NextPNR, Verilator, CocoTB, MCY, Chisel, Amaranth, LiteX, and more.

The course culminated in a final project where students were given a limited area (equivalent to ~4000 standard cells) in which to design a chip of their choosing. Students chose a variety of projects ranging from games to CPUs to accelerators.

## The Chip

The final chip, taped out through the Skywater foundry (via the Efabless ChipIgnite program), is comprised of all student designs merged together, along with a multiplexer unit to share the limited I/O ports amongst all of the designs. Each design is given 12 outputs, 12 inputs, and a dedicated clock and reset signal. 

## Index of Designs

Following is a list of student designs on the chip, along with the design indices (The `des_sel` pins on the chip are used to enable a particular design).

TODO

## Multiplexer Documentation

TODO

## Bringup Instructions

TODO
