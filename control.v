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

// Clock divider - Divide-by-2
reg [15:0] count = 0;
wire slow_clk = count[15];

// State register variables
reg [3:0] current = 0;
reg [3:0] next = 0;

// Sequential logic
always @(posedge slow_clk) current <= next;


assign data_out = dataOut;
assign we = w_en;
assign address = addr;
always @(posedge clk) begin

        case(current)
        0: begin // state 0: Waiting for Inputs
              if(btns[3:0])begin
            case(btns) 
                2'b0001: begin //Enter/Push
                        next <= 1;
                    end
                2'b0010: begin //Delete/Pop
                        next <= 2;
                    end
                2'b0101: begin //Add
                        next <= 3;
                    end
                2'b0110: begin //Subtract
                        next <= 4;
                    end
                2'b1001: begin //Top
                        next <= 5;
                    end
                2'b1010: begin //Clear/RST
                        next <= 6;
                    end
                2'b1101: begin //Inc Addr
                        next <= 7;
                    end
                2'b1110: begin //Dec Addr
                        next <= 8;                  
                    end
            endcase
        end  
            end
        1: begin // state 1: Enter/Push
                w_en <= 1;
                dataOut <= swtchs;
                addr <= SPR;
                #20
                SPR <= SPR - 1;  
                next <= 0;            
            end
        2:begin // state 2: Delete/Pop
               w_en <= 0;
               SPR <= SPR + 1;
               next <= 0;
            end 
        3:begin // State 3: Add
               w_en <= 0;
               
               //retrieving first operand
               addr <= SPR;
               #20
               operand1 <= data_in;
               SPR <= SPR + 1;
               
               //retrieving second operand
               addr <= SPR;
               #20
               operand2 <= data_in;
               SPR <=  SPR + 1;
               
               //addition
               SPR <= SPR - 1;
               #20
               dataOut <= operand1 + operand2;
               w_en <= 1;
               addr <= SPR;
               
               next <= 0;  
            end
        4: begin // state 4: Subtract
               w_en <= 0;
               
               //retrieving first operand
               addr <= SPR;
               #20
               operand1 <= data_in;
               SPR <= SPR + 1;
               
               //retrieving second operand
               addr <= SPR;
               #20
               operand2 <= data_in;
               SPR <=  SPR + 1;
               
               //addition
               SPR <= SPR - 1;
               #20
               dataOut <= operand1 - operand2;
               w_en <= 1;
               addr <= SPR;
               
               next <= 0;                
            end
        5:begin // state 5: Top
               DAR <= SPR + 1;
               addr <= DAR;
               #20
               DVR <= data_in;
               
               next <= 0;
            end 
        6:begin // State 6: Clear/RST
                SPR = 8'h7F;
                DAR = 8'h00;
                DVR = 8'h00;
                
                next <= 0;
            end
        7: begin // state 7: Inc Addr
                DAR = DAR + 1;
                addr <= DAR;
                #20
                DVR <= data_in;
                
                next <= 0;
            end
        8:begin // state 2: Dec Addr
                DAR = DAR - 1;
                addr <= DAR;
                #20
                DVR <= data_in;
                
                next <= 0;      
            end 
        endcase
    end

    
endmodule
