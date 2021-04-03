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
    



    always @ (posedge clk)begin
        

        if(btns[1:0])begin
            case(btns) 
                2'b0001: begin //Enter/Push

                    end
                2'b0010: begin //Delete/Pop
                        
                    end
                2'b0101: begin //Add

                    end
                2'b0110: begin //Subtract
                        
                    end
                2'b1001: begin //Top

                    end
                2'b1010: begin //Clear/RST
                        
                    end
                2'b1101: begin //Inc Addr

                    end
                2'b1110: begin //Dec Addr
                        
                    end
                default: begin
                    
                end
            endcase
        end
    end 
    
endmodule
