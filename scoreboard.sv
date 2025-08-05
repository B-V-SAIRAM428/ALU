`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 16:32:01
// Design Name: 
// Module Name: scoreboard
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

class scoreboard;
    mailbox mo2sb;
    function new(mailbox mo2sb);
        this.mo2sb = mo2sb;
    endfunction
    
    task run();
        transaction trans;
        bit [15:0] expected_out;
        forever begin
            mo2sb.get(trans);
            if (trans.enable == 1 && trans.valid == 1) begin
                case(trans.fn)
                    3'b000: expected_out = trans.op1 + trans.op2;
                    3'b001: expected_out = trans.op1 - trans.op2;
                    3'b010: expected_out = trans.op1 * trans.op2;
                    3'b011: expected_out = trans.op1 ^ trans.op2;
                    3'b100: expected_out = trans.op1 & trans.op2;
                    3'b101: expected_out = trans.op1 | trans.op2;
                    3'b110: expected_out = ~(trans.op1 ^ trans.op2);
                    3'b111: expected_out = ~(trans.op1 & trans.op2);
                    default: expected_out = 0;
                endcase
                
                if(expected_out == trans.out_put)
                    $display("PASS: fn=%0d, expected=%0d, got=%0d", trans.fn, expected_out, trans.out_put);
                else
                    $display("FAIL: fn=%0d, expected=%0d, got=%0d", trans.fn, expected_out, trans.out_put);
           end
        end
        
    endtask
endclass
