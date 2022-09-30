# 64-bit-Kogge-Stone-Adder

Implementation in VHDL of the Kogge-Stone adder design for the addition of 64 bits integers.

## Principle
## Files

* Adder implements the design using 5 stages of processing elements, one preprocessing stage and one postprocessing stage.
* processing_elem implements one element to compute (Gi,Gj)o(Pi,Pj).
* half_adder is used for the preprocessing of the inputs.