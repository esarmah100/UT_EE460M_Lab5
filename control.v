`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 08:26:14 PM
// Design Name: 
// Module Name: control
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

module control(
    input clk,
    input cs,
    input we,
    input [6:0] addr,
    input [7:0] data_bus,
    output data_out_ctrl,
    output [3:0] btns,
    output [7:0] swtchs,
    output [7:0] leds,
    output [6:0] segs,
    output [3:0] an
    );
    
    
endmodule
