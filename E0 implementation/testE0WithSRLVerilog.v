`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Docquois Arthur
// 
// Create Date: 06/13/2022 12:50:36 PM
// Module Name: testE0WithSRLVerilog
// Project Name: E0 implementation
//////////////////////////////////////////////////////////////////////////////////


module testE0WithSRLVerilog(

    );
        wire clk,rst;
    E0WithSRL E0(.clk(clk), .rst(rst));
    testE0WithSRL test(.clk(clk), .rst(rst));
endmodule
