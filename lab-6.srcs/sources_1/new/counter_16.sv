`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ciaran McDonald-Jensen (SN 101228856)
// 
// Create Date: 10/26/2026 05:01:11 PM
// Design Name: 
// Module Name: counter_16
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Revision: 1.0 - Oct 29 2026 - Basic version made which just increments
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter_16(
    input logic i_clk,
    input logic i_rst,
    input logic i_tick_16x_en,
    input logic i_en,
    output logic o_S7_now,
    output logic o_S15_now
    );

    // TODO - can make state be an enum with 16 states and instead of incrementing it can make our own encoding, the case statement would need to be much longer

    logic [3:0] state;

    always_ff @(posedge clock) begin
        if (i_rst) begin
            state <= 4b'0000;
        end else begin
            // Just keep incrementing state every tick. Locks at S0 if en is off
            case (state)
                4b'0000: if (i_tick_16x_en && i_en) state <= state+1;
                default: if (i_tick_16x_en) state <= state+1;
            endcase
        end
    end

endmodule
