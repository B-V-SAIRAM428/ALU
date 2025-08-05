`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 21:09:26
// Design Name: 
// Module Name: alucon
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


module alucon(
    input clk,
    input rst,
    input [7:0] op1,
    input [7:0] op2,
    input enable,
    input [2:0] fn,
    output reg [15:0]out_put,
    output reg valid
    );
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_put=16'b0;
            valid=1'b0;
        end else if (enable==1'b1 && fn==3'd0) begin
            out_put=op1+op2;
            valid=1'b1;
        end else if (enable==1'b1 && fn==3'd1) begin
            out_put=op1-op2;
            valid=1'b1;
        end else if (enable==1'b1 && fn==3'd2) begin
            out_put=op1*op2;
            valid=1'b1;
        end else if (enable==1'b1 && fn==3'd3) begin
            out_put=op1^op2;
            valid=1'b1;
        end else if (enable==1'b1 && fn==3'd4) begin
            out_put=op1 & op2;
            valid=1'b1;
        end else if (enable==1'b1 && fn==3'd5) begin
            out_put=op1|op2;
            valid=1'b1;
        end else if (enable==1'b1 && fn==3'd6) begin
            out_put=~(op1^op2);
            valid=1'b1;
        end else if (enable==1'b1 && fn==3'd7) begin
            out_put=~(op1 & op2);
            valid=1'b1;
        end else  begin
            valid=1'b0;
        end
    end
endmodule
