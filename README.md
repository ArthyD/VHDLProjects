# My VHDL Projects

These are my academic projects done with VHDL

## E0 implementation

This project aims to implement the E0 crypto algorithm (for bluetooth communication). It is based on LFSR to generate pseudo random bit sequence.

## Kogge-Stone adder

This project implements a trade-off design between ripple carry adders and carry lookahead adders for a 64 bits adder.

## RISC-V implementation

This project provides a functionnal model and a RTL model implementing the RISC-V processor design. Here are the instructions implemented :
* lb
* lbu 
* lh 
* lhu 
* lw 
-- Store instruction --
* sb 
* sh 
* w 
-- Arithmetic instruction --
* add 
* sub 
* addi 
-- Special arithmetic load move --
* lui 
* auipc 
-- Logic instructions --
* xor 
* or 
* and 
* xori 
* ori 
* andi 
-- Shift instruction --
* sll 
* srl 
* sra 
* slli 
* srli :
* srai 
-- Compare instruction --
* slt 
* sltu 
* slti 
* sltiu 
-- Branch instruction --
* beq 
* bne 
* blt 
* bge 
* bltu 
* bgeu 
-- Jump instruction --
* jal 
* jalr