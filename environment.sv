`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 19:39:47
// Design Name: 
// Module Name: environment
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

class env;
    generator gen;
    driver div;
    monitor mon;
    scoreboard sb;
    
    mailbox gen2dri;
    mailbox mo2sb;
    
    virtual inf intf;
    
    function new(virtual inf intf);
        this.intf = intf;
        gen2dri = new();
        mo2sb = new();
        
        gen = new(gen2dri);
        div = new(intf,gen2dri);
        mon = new(intf,mo2sb);
        sb = new(mo2sb);
        
    endfunction
    
    task run();
        fork
            gen.run();
            div.run();
            mon.run();
            sb.run();
        join_none
    endtask
endclass
