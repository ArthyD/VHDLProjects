----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 06/06/2022
-- Project Name: CPU Functional model

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library work;
-- Package needed --
use work.bit_vector_natural_pack.all;
use work.cpu_defs_pack.all;
use work.mem_defs_pack.all;
use work.logicArithm_defs_pack.all;
use work.flag_handler_pack.all;
use work.cpu_trace_pack.all;
use std.textio.all;

entity System is
end System;

architecture functional of System is
begin
    process


    -- Declaration of variables --
    variable Memory: mem_type := init_memory("Memory.dat");
    variable Reg : reg_type;
    variable INSTR : data_type; -- instruction --
    variable OP : opcode_type; -- opcode --
    variable X, Y, Z : reg_addr_type; -- operand --
    variable PC : addr_type :=X"000" ; -- Program counter --
    variable Zero, Carry, Negative, Overflow : bit := '0' ; --Flags --
    variable DATA : data_type; -- temporary variable to store data --
    variable Addr : addr_type; -- temporary variable to store address --

    -- Files --
    file TraceFile : Text open WRITE_MODE is "Trace.mem";
    file DumpFile : Text open WRITE_MODE is "Dump.mem";
    file MemoryFile : Text open READ_MODE is "Memory.mem";
    file IOInputFile : Text open READ_MODE is "IOInput.mem";
    file IOOutputFile: Text open WRITE_MODE is "IOOutput.mem";
    variable l : line;
    variable l_IOIn : line;
    variable l_IOOut : line;

    begin
        loop
            -- fetch instruction from memory --
            Instr := get(Memory,PC);
            -- decode instruction --
            OP := Instr(data_width-1 downto data_width-opcode_width);
            X := Instr(data_width-opcode_width-1 downto data_width-opcode_width-reg_addr_width);
            Y :=  Instr(data_width-opcode_width-reg_addr_width-1 downto data_width-opcode_width-2*reg_addr_width);
            Z :=  Instr(data_width-opcode_width-2*reg_addr_width-1 downto data_width-opcode_width-3*reg_addr_width);
            write_PC_CMD(l, PC, Op, X, Y, Z);
            PC := INC(PC);

            -- compute operation --
            case OP is
                when code_nop => NULL; -- No Operation
                    write_no_param( l );
                when code_stop => dump_memory( Memory, "Dump.mem" );
                    WAIT; -- Stop Simulation
                    write_no_param( l );
                    write_regs (l, Reg, Zero, Carry, Negative, Overflow);
                    writeline( TraceFile, l);
                    print_tail( TraceFile );

                -- REGISTER INSTRUCTION --
                -- sometimes you use write_param, sometimes write_Param. This seems wrong.
                when code_ldc => write_Param(l,get(Memory,PC));
                                Data:=get(Memory,PC); Reg(bit_vector2natural(X)):=Data;
                                Set_Flags_Load(Data,Zero,Negative,Overflow);
                                PC:=INC(PC);
                when code_ldd => write_Param(l,get(Memory,PC));
                                Addr:=get(Memory,PC);
                                Data:=get(Memory,Addr); Reg(bit_vector2natural(X)):=Data;
                                Set_Flags_Load(Data,Zero,Negative,Overflow);
                                PC:=INC(PC);
                when code_ldr => write_no_param( l );
                                Data:=get(Memory,Reg(bit_vector2natural(Y))); Reg(bit_vector2natural(X)):=Data;
                                Set_Flags_Load(Data,Zero,Negative,Overflow);
                when code_std => write_Param(l,get(Memory,PC));
                                Addr:=get(Memory,PC);
                                set(Memory,Addr,Reg(bit_vector2natural (X)));
                                PC:=INC(PC);
                when code_str => write_no_param( l );
                                set(Memory,Reg(bit_vector2natural (Y)),Reg(bit_vector2natural ((X))));
                -- END OF REGISTER INSTRUCTION --

                -- ARITHMETIC AND LOGICAL INSTRUCTION --
                when code_not => write_no_param( l );
                                Data := "NOT" (Reg(bit_vector2natural (Y)));
                                Reg(bit_vector2natural(X)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                when code_and => write_no_param( l );
                                Data := Reg(bit_vector2natural (Y)) AND Reg(bit_vector2natural (Z));
                                Reg(bit_vector2natural (X)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                when code_or => write_no_param( l );
                                Data := Reg(bit_vector2natural (Y)) OR Reg(bit_vector2natural (Z));
                                Reg(bit_vector2natural (X)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                when code_and => write_no_param( l );
                                Data := Reg(bit_vector2natural (Y)) XOR Reg(bit_vector2natural (Z));
                                Reg(bit_vector2natural (X)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                when code_slt => write_no_param( l );
                                Data := SLT(Reg(bit_vector2natural (Y)), Reg(bit_vector2natural (Z)));
                                Reg(bit_vector2natural (X)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                when code_sltu => write_no_param( l );
                                Data := SLTU(Reg(bit_vector2natural (Y)), Reg(bit_vector2natural (Z)));
                                Reg(bit_vector2natural (X)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                when code_add => write_no_param( l );
                                EXEC_ADDC(Reg(bit_vector2natural(Y)), Reg(bit_vector2natural (Z)), '0', Reg(bit_vector2natural(X)), Zero, Carry, Negative, Overflow);
                when code_addc => write_no_param( l );
                                EXEC_ADDC(Reg(bit_vector2natural(Y)), Reg(bit_vector2natural(Z)), Carry, Reg(bit_vector2natural(X)), Zero, Carry, Negative, Overflow);
                when code_sub => write_no_param( l );
                                EXEC_SUBC(Reg(bit_vector2natural(Y)), Reg(bit_vector2natural (Z)), '0', Reg(bit_vector2natural(X)), Zero, Carry, Negative, Overflow);
                when code_subc => write_no_param( l );
                                EXEC_SUBC(Reg(bit_vector2natural(Y)), Reg(bit_vector2natural(Z)), Carry, Reg(bit_vector2natural(X)), Zero, Carry, Negative, Overflow);
                when code_srl => write_no_param( l );
                                Data := "SRL" (Reg(bit_vector2natural (Y)));
                                Reg(bit_vector2natural (X)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                when code_sra => write_no_param( l );
                                Data := "SRA" (Reg(bit_vector2natural (Y)));
                                Reg(bit_vector2natural (X)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                when code_sll => write_no_param( l );
                                Data := "SLL" (Reg(bit_vector2natural (Y)));
                                Reg(bit_vector2natural (X)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                -- END OF ARITHMETIC AND LOGICAL INSTRUCTION --

                -- JUMP INSTRUCTION --
                when code_jmp => write_param(l,Memory(bit_vector2natural(PC)));
                                PC := Memory(bit_vector2natural(PC));
                when code_jz => write_Param(l,Memory(bit_vector2natural(PC)));
                                if Zero = '1' then PC := Memory(bit_vector2natural(PC));
                                else PC := INC(PC);
                                end if;
                when code_jnz => write_param(l,Memory(bit_vector2natural(PC)));
                                if not Zero = '1' then PC := Memory(bit_vector2natural(PC));
                                else PC := INC(PC);
                                end if;
                when code_jc => write_Param(l,Memory(bit_vector2natural (PC)));
                                if Carry = '1' then PC := Memory(bit_vector2natural (PC));
                                else PC := INC(PC);
                                end if;
                when code_jnc => write_Param(l,Memory(bit_vector2natural (PC)));
                                if not Carry = '1' then PC := Memory(bit_vector2natural (PC));
                                else PC := INC(PC);
                                end if;
                when code_jn => write_Param(l,Memory(bit_vector2natural(PC)));
                                if Negative ='1' then PC := Memory(bit_vector2natural (PC));
                                else PC := INC(PC);
                                end if;
                when code_jnn => write_Param(l,Memory(bit_vector2natural(PC)));
                                if not Negative = '1' then PC := Memory(bit_vector2natural(PC));
                                else PC := INC(PC);
                                end if;
                when code_jo => write_Param(l,Memory(bit_vector2natural(PC)));
                                if Overflow = '1' then PC := Memory(bit_vector2natural (PC));
                                else PC := INC(PC);
                                end if;
                when code_jno => write_Param(l,Memory(bit_vector2natural(PC)));
                                if not Overflow = '1' then PC := Memory(bit_vector2natural(PC));
                                else PC := INC(PC);
                                end if;
                -- END OF JUMP INSTRUCTION --

                -- IN OUT INSTRUCTION --
                when code_in => write_no_param( l );
                    readline (IOInputFile, l_IOIn);
                    read (l_IOIn, X);

                when code_out =>  write_no_param( l );
                    write( l_IOOut , X );
                    writeline( IOOutputFile , l_IOOut );
                -- END OF IN OUT INSTRUCTION --

                -- LOAD STORE WITH PC INSTRUCTION --
                when code_ldpc => write_Param(l,get(Memory,PC));
                                Reg(bit_vector2natural(X)):=PC;
                                PC:=INC(PC);
                when code_stpc => write_Param(l,get(Memory,PC));
                                PC := X;
                -- END OF LOAD STORe WITH PC INSTRUCTION --

                when others => -- Illegal or not yet implemented Operations
                            assert FALSE;
                            report "Illegal Operation"
                            severity error;

            end case;
            write_regs(l, Reg, Zero, Carry, Negative, Overflow);
            writeline( TraceFile, l );
        end loop;
    end process;
end architecture;
