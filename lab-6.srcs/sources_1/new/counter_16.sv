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

    logic [3:0] state, next_state;

    always_ff @(posedge i_clk) begin
        // state progression logic
        if (i_rst) begin
            state <= 4'b0000;
        end else begin
            // NOTE: state only changes on a tick of the baud generator (other than in reset)
            if (i_tick_16x_en) state <= next_state;
        end
    end

    always_comb begin
        // Next state logic
        if (i_rst) begin
            next_state = 4'b0000;
        end else begin
            // Just keep incrementing state every tick. Locks at S0 if en is off
            case (state)
                4'b0000: if (i_en) next_state = state+1; else next_state = 4'b0000;
                default: next_state = state+1;
            endcase
        end


        // output signal logic
        case (state)
            4'b0111: o_S7_now = 1;
            default: o_S7_now = 0;
        endcase
        case (state)
            4'b1111: o_S15_now = 1;
            default: o_S15_now = 0;
        endcase
    end

endmodule
