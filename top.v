`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 08:12:59 PM
// Design Name: 
// Module Name: top
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


module top (clk, btns, swtchs, leds,segs,an);
input clk;
input [3:0] btns;
input [7:0] swtchs;
output [7:0] leds;
output [6:0] segs;
output [3:0] an;

//might need to change some of these from wires to regs
wire cs;
wire we;
wire [6:0] addr;
wire [7:0] data_out_mem;
wire [7:0] data_out_ctrl;
wire [7:0] data_bus;
wire [1:0] btns_dbounced;

//CHANGE THESE TWO LINES
assign data_bus = we ? data_out_ctrl : data_out_mem;    //1st driver of the data bus--tristate switches
                        //function of we and data_out_ctrl
                        //2nd driver of the data bus -- tristate switches 
                        //function of we and data_out_mem
 
memory mem(clk, cs, we, addr, data_bus, data_out_mem);
control ctrl(clk, cs, we, addr, data_bus, data_out_ctrl, {btns[3:2], btns_dbounced[1:0]}, swtchs, leds, segs, an);

//add any other functions you need
//(e.g. debouncing, multiplexing, clock-division, etc)
debounce_and_single_pulse debounce0(clk, btns[0], btns_dbounced[0]);
debounce_and_single_pulse debounce1(clk, btns[1], btns_dbounced[1]);

endmodule
