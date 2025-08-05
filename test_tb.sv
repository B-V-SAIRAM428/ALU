`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 22:45:55
// Design Name: 
// Module Name: test_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

    `include "transaction.sv"
    `include "generator.sv"
    `include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"
    `include "environment.sv"
    `include "test.sv"
module test_top(

    );
    reg clk;
    reg rst; 
    inf intf (clk,rst);
    test t0;
    alucon dut(.clk(clk), .rst(rst),.op1(intf.op1), .op2(intf.op2), .enable(intf.enable),.fn(intf.fn),.out_put(intf.out_put), .valid(intf.valid));
    
    always #5 clk = ~clk;
    initial begin
        clk =0 ; rst = 1;
        #10 rst = 0;
        
        t0 = new(intf);
        t0.run();
        
        #100 $finish;
    end
    
endmodule
