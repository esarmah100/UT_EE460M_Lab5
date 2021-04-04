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
    output cs,
    output we,
    output [6:0] address,
    input [6:0] data_in,
    output [7:0] data_out,
    input [3:0] btns,
    input [7:0] swtchs,
    output [7:0] leds,
    output [6:0] segs,
    output [3:0] an
    );
    

    reg [6:0] SPR;
    reg [6:0] DAR;
    reg [7:0] DVR;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg [7:0] dataOut = 0;
    reg [6:0] addr = 0;
    reg w_en = 0;
    
    initial begin      
        SPR = 8'h7F;
        DAR = 8'h00;
        DVR = 8'h00;
        operand1 = 0;
        operand2 = 0;
    end


// State register variables
reg [3:0] current = 0;
reg [3:0] next = 0;



assign data_out = dataOut;
assign we = w_en;
assign address = addr;
always @(posedge clk) begin
        current <= next;

    case(current)
        0: begin // state 0: Waiting for Inputs
              if(btns[3:0])begin
                    case(btns) 
                        4'b0001: begin //Enter/Push
                                w_en <= 1;
                                dataOut <= swtchs;
                                addr <= SPR;
                                next <= 1;
                            end
                        4'b0010: begin //Delete/Pop
                                w_en <= 0;
                                next <= 2;
                            end
                        4'b0101: begin //Add
                                w_en <= 0;
                                addr <= SPR;
                                next <= 3;
                            end
                        4'b0110: begin //Subtract
                                w_en <= 0;
                                addr <= SPR;
                                next <= 3;
                            end
                        4'b1001: begin //Top
                                DAR <= SPR + 1;
                                next <= 8;
                            end
                        4'b1010: begin //Clear/RST
                                next <= 10;
                            end
                        4'b1101: begin //Inc Addr
                                DAR = DAR + 1;
                                next <= 8;
                            end
                        4'b1110: begin //Dec Addr
                                DAR = DAR - 1;
                                next <= 8;                  
                            end
                    endcase
                end  
            end
        1: begin // state 1: Enter/Push
                SPR <= SPR - 1;  
                next <= 0;            
            end
        2:  begin // state 2: Delete/Pop
               SPR <= SPR + 1;
               next <= 0;
            end 
        3:  begin // State 3: Addition/Subtraction Part 1
               operand1 <= data_in;
               SPR <= SPR + 1;
               next <= 4;
            end
        4:  begin // State 4: Addition/Subtraction Part 2
               addr <= SPR;
               next <= 5;               
            end 
        5:  begin // State 5: Addition/Subtraction Part 3
               operand2 <= data_in;
               if(btns ==  4'b0101) begin
                    next <= 6;
               end
               else begin
                    next <= 7;
               end
            end
        6:  begin // State 6: Addition/Subtraction Part 4
               w_en <= 1;
               addr <= SPR;
               dataOut <= operand1 + operand2;
               next <= 8;
            end
        7:  begin // State 7: Addition/Subtraction Part 5
               w_en <= 1;
               addr <= SPR;
               dataOut <= operand1 - operand2;
               next <= 8;
            end      
        8:begin // state 8: Sending DAR to address
               addr <= DAR;
               next <= 9;
            end 
        9:begin // state 9: Updating DVR
               DVR <= data_in;
               next <= 0;
            end
        10:begin // State 6: Clear/RST
                SPR = 8'h7F;
                DAR = 8'h00;
                DVR = 8'h00;
                next <= 0;
            end
    endcase
end

    
endmodule
