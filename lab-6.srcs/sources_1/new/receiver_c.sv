`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 01:13:13 PM
// Design Name: 
// Module Name: receiver_c
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


module receiver_c(
    input logic i_clk,
    input logic i_rst,
    input logic i_tick_16x_en,
    output logic [7:0] o_rx_data,
    input logic i_uart_rx_in,
    output logic o_frame_error
    );

    logic counter_en;
    logic S7_now, S15_now;

    logic [10:0] bit_state;

    typedef enum logic {
        S_IDLE = 1'b0,
        S_DETECTING = 1'b1
    } state_t;

    state_t state, next_state;

    counter_16 receiver_counter_16 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_tick_16x_en(i_tick_16x_en),
        .i_en(counter_en),
        .o_S7_now(S7_now),
        .o_S15_now(S15_now)
    );

    bit_counter receiver_bit_counter (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_tick_16x_en(i_tick_16x_en),
        .i_start(i_uart_rx_in), // Stays at 1 when not using the counter and drops to 0 when counter is supposed to start
        .o_counter_en(counter_en),
        .i_S15_now(S15_now),
        .o_bit_state(bit_state) // This is 1-hot encoded the 11 states that the system goes through (10 bits and IDLE)
    );

    // always_ff @(posedge clk) begin
    //     if (rst)
    //     if (S7_now) begin
    //         case (bit_n)
    //             7'b0000000: o_rx_data[0] <= 1
    //             default: ;
    //         endcase
    //     end
    // end

endmodule
