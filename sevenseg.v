`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2021 07:03:34 AM
// Design Name: 
// Module Name: sevenseg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: provides time multiplexing for 4 sevenseg displays and modulo for upto 4 digit numbers 

// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sevenseg(
  input clk,
  input [15:0] in,
  output [3:0] an,
  output reg [6:0] seg
); 

wire [6:0] out;

// BCD instantiation
reg [3:0] bcd_in = 0; // Input to BCD, output directly tied to seg
bcd counter (clk, bcd_in, out);

// Clock divider - Divide-by-2
reg [15:0] count = 0;
wire slow_clk = count[15];

// State register variables
reg [1:0] current = 0;
reg [1:0] next = 0;

always @(posedge slow_clk) current <= next;


// Combinational logic
reg [3:0] an_buf = 0;
assign an = an_buf;
always @(posedge clk) begin
    seg <= out;
    count <= count + 1;

    case(current)
    0: begin // state 0  
            an_buf <= 4'b1110; 
            //bcd input for count
            //bcd_in <= ((in % 1000) % 100) % 10;
            bcd_in <= in[3:0];
            next <= 1; // set next state
        end
    1: begin // state 1
            an_buf <= 4'b1101;
            //bcd input for count
            // bcd_in <= ((in % 1000) % 100)/10;  
            bcd_in <= in[7:4];
            next <= 2;
        end
    2:begin
            an_buf <= 4'b1011;  
            //bcd input for count
            // bcd_in <= (in % 1000)/100;
            bcd_in <= in[11:8];
            next <= 3;
        end
    3:begin
            an_buf <= 4'b0111;
            //bcd input for count
            // bcd_in <= (in % 10000)/1000;
            bcd_in <= in[15:12];
            next <= 0;
        end
    default: begin
            //bcd input for step count
            bcd_in <= 0;
            an_buf <= 4'b1110;
            next <= 1;
        end
    endcase
end

endmodule
