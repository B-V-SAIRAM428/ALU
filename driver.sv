`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 07:59:25
// Design Name: 
// Module Name: driver
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

class driver;
    mailbox gen2dri;
    virtual inf intf;
    event done;
    
    function new(virtual inf intf, mailbox gen2dri);
        this.intf = intf;
        this.gen2dri = gen2dri;
    endfunction
    
    task run();
        transaction trans;
        forever begin
            @(posedge intf.clk);
            if(intf.rst == 1) begin
                intf.op1 <= 0;
                intf.op2 <= 0;
                intf.enable <= 0;
                intf.fn <= 0;
                continue;
            end else begin
                gen2dri.get(trans);
                trans.display();
                intf.op1 <= trans.op1;
                intf.op2 <= trans.op2;
                intf.enable <= trans.enable;
                intf.fn <= trans.fn;
                -> done;
           end
       end
    endtask
endclass

