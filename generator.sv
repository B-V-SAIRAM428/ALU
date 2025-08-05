`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 05:59:55
// Design Name: 
// Module Name: generator
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


class generator;
    mailbox gen2dri;
    event done;
    int count =10;
    function new(mailbox gen2dri);
        this.gen2dri = gen2dri;             /// get both env mailbox and generator mailbox togethor
    endfunction
    
    task run();
        for( int i = 0; i < count; i++) begin       //help to generate in stimulus 10 time
            transaction trans = new();
            if(!trans.randomize())
                $display("Randomization falied");
            gen2dri.put(trans);
            ->done;
        end
    endtask
endclass