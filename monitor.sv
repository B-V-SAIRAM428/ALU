`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 16:06:47
// Design Name: 
// Module Name: monitor
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


class monitor;
  virtual inf intf;
  mailbox mo2sb;
  typedef struct {
    bit [7:0] op1;
    bit [7:0] op2;
    bit enable;
    bit [2:0] fn;
  } input_t;

  input_t input_queue[$];

  function new(virtual inf intf, mailbox mo2sb);
    this.intf = intf;
    this.mo2sb = mo2sb;
  endfunction

  task run();
    transaction trans;
    forever begin
      @(posedge intf.clk);
      // Latch inputs when enable==1 on this cycle
      if (intf.rst == 1) begin
        input_queue = {};
        continue;
      end
      if (intf.enable) begin
        input_t i;
        i.op1 = intf.op1;
        i.op2 = intf.op2;
        i.enable = intf.enable;
        i.fn = intf.fn;
        input_queue.push_back(i);
      end
      // When output is valid, pair with oldest input
      if (intf.valid) begin
        if (input_queue.size() > 0) begin
          input_t q = input_queue.pop_front();
          trans = new();
          trans.op1 = q.op1;
          trans.op2 = q.op2;
          trans.enable = q.enable;
          trans.fn = q.fn;
          trans.out_put = intf.out_put;
          trans.valid = intf.valid;
          trans.display();
          mo2sb.put(trans);
        end else begin
          $display("Monitor warning: no input queued for this 'valid'!");
        end
      end
    end
  endtask
endclass
