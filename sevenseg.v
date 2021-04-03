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
  input reset,
  input [31:0] step_count,
  input [15:0] distance_covered,
  input [3:0] initial_activity_count,
  input [15:0]high_activity_time,
  input [1:0]output_mode,
  output [3:0] an,
  output reg [6:0] seg
); 

wire [6:0] out_steps;
wire [6:0] out_distance;
wire [6:0] out_init_count;
wire [6:0] out_high_activity;

// BCD instantiation
reg [3:0] bcd_steps = 0; // Input to BCD, output directly tied to seg
reg [3:0] bcd_distance = 0;
reg [3:0] bcd_init_count = 0;
reg [3:0] bcd_high_activity = 0;
bcd steps (clk, bcd_steps, out_steps);
bcd distance (clk, bcd_distance, out_distance);
bcd init_count (clk, bcd_init_count, out_init_count);
bcd high_activity (clk, bcd_high_activity, out_high_activity);



// Clock divider - Divide-by-2
reg [15:0] count = 0;
wire slow_clk = count[15];


// State register variables
reg [1:0] current = 0;
reg [1:0] next = 0;

// Sequential logic
always @(posedge slow_clk) current <= next;

// Combinational logic
reg [3:0] an_buf = 0;
assign an = an_buf;
always @(posedge clk) begin
    count <= count + 1;
    seg <= (output_mode[1]) ? ((output_mode[0]) ? out_high_activity: out_init_count) : ((output_mode[0]) ? out_distance: out_steps);

    if(reset) begin // Synchronous reset
        bcd_steps <= 4'b0000;// Set outputs
        an_buf <= 4'b1110;
        next <= 0;// set next state
        end
    else begin
        case(current)
        0: begin // state 0
        
                //bcd input for step count
                bcd_steps <= ((step_count % 1000) % 100) % 10;
            
                //bcd input for distance covered
                if(distance_covered[0] == 0) begin
                    bcd_distance <= 0;
                end
                else begin
                    bcd_distance <= 5;
                end
                
                //bcd input for intial activity time over 32 steps/sec
                bcd_init_count <= initial_activity_count;
                
                //bcd input for high activity time
                bcd_high_activity <= ((high_activity_time % 1000) % 100) % 10;
            
                an_buf <= 4'b1110; 
                next <= 1; // set next state
            end
        1: begin // state 1
        
                //bcd input for step count
                bcd_steps <= ((step_count % 1000) % 100)/10;
            
                //bcd input for distance covered
                bcd_distance <= 10;      //number corresponding to underscore in bcd.v

                bcd_init_count <= 0;
                
                //bcd input for high activity time
                bcd_high_activity <= ((high_activity_time % 1000) % 100) / 10;
            
                an_buf <= 4'b1101;
                next <= 2;
            end
        2:begin
        
                //bcd input for step count
                bcd_steps <= (step_count % 1000)/100;
                
                //bcd input for distance covered
                bcd_distance <=  (distance_covered / 2) % 10;

                bcd_init_count <= 0;
                
                //bcd input for high activity time
                bcd_high_activity <= (high_activity_time % 1000) / 100;
                
                an_buf <= 4'b1011;
                next <= 3;
            end
        3:begin
        
                //bcd input for step count
                bcd_steps <= (step_count % 10000)/1000;
                
                 //bcd input for distance covered
                bcd_distance <=  (distance_covered / 2) / 10;

                bcd_init_count <= 0;
                
                //bcd input for high activity time

                bcd_high_activity <= (high_activity_time % 10000) /1000;
                
                an_buf <= 4'b0111;
                next <= 0;
            end
        default: begin
        
            //bcd input for step count
            bcd_steps <= 4'd0000;
            an_buf <= 4'b1110;
            next <= 1;
            end
        endcase
    end
end

endmodule
