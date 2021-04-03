`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 08:19:20 PM
// Design Name: 
// Module Name: memory
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


module memory(
    input clock,
    input cs,
    input we,
    input [6:0] address,
    output [7:0] data_in,
    output reg [7:0] data_out
    );
    
    reg [7:0] RAM[0:127];

    always @ (negedge clock)begin
        if((we == 1) && (cs == 1))
            RAM[address] <= data_in[7:0];

        data_out <= RAM[address]; 
    end
    
endmodule
