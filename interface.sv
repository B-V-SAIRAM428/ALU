`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 05:29:27
// Design Name: 
// Module Name: interface
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

interface inf(input logic clk, rst);
    logic [7:0] op1;
    logic [7:0] op2;
    logic enable;
    logic [2:0] fn;
    logic [15:0] out_put;
    logic valid;
endinterface