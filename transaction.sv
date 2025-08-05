`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 05:39:38
// Design Name: 
// Module Name: transaction
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

class transaction;
    rand bit [7:0] op1;
    rand bit [7:0] op2;
    rand bit enable;
    rand bit [2:0] fn;
          bit [15:0] out_put;
          bit valid;
    
    function void display();
        $display("op1=%0d, op2=%0d, enable=%0d, fn=%0d, out_put=%0d, valid=%0d", op1,op2,enable,fn,out_put,valid);
    endfunction
endclass
