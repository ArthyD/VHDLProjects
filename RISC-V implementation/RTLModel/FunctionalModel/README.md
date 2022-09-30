# Functional CPU

VHDL Project to provide functional model of a CPU based on RiscV.

## Description of project

Project is divided into several files :
* System : main part that models the full CPU
* cpu_defs_pack : provide all constant and subtype used in project (contains opcode)
* cpu_trace_pack : provide the procedures to trac CPU activity
* logicArithm_defs_pack : provides all function and procedures to make arithmetic or logical operations
* flag_handler_pack : provides all function and procedures to deal with flags
* bit_vector_natural_pack : provides functions to turn bit vector to natural and natural to bit vector

Additional files are :
* Memory : where instructions to be executed are stored
* Trace : to get the trace of instructions executed by the cpu 
* Dump : to dump memory at the end of the execution
* IOInput : where input data are stored
* IOOutput : where output data are stored

_Library used_ :
  - IEEE.STD_LOGIC_1164
  - IEEE.NUMERIC_STD
  - std.textio




