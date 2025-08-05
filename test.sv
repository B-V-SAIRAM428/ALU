`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 20:45:53
// Design Name: 
// Module Name: test
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

class test;
    env e0;
    virtual inf intf;
    function new(virtual inf intf);
        this.intf = intf;
        e0 = new(intf);
    endfunction
    
    task run();
        e0.run();
    endtask
endclass
