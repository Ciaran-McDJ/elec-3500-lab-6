`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 07:06:23 PM
// Design Name: 
// Module Name: uart_counter
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


module uart_counter(
    input logic i_clk,
    input logic i_rst,
    input logic i_tick_16x_en,
    input logic i_start_counting, //Active low signal. Stays high in IDLE, when drops the counter starts, this signal is then ignored until system returns to IDLE
    output logic o_S7_now,
    output logic [10:0] o_bit_state // This is 1-hot encoded the 11 states that the system goes through (10 bits and IDLE)
    );

    logic counter_en;
    logic S15_now;

    counter_16 uart_counter_16 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_tick_16x_en(i_tick_16x_en),
        .i_en(counter_en),
        .o_S7_now(o_S7_now),
        .o_S15_now(S15_now)
    );

    bit_counter uart_bit_counter (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_tick_16x_en(i_tick_16x_en),
        .i_start_counting(i_start_counting), // Stays at 1 when not using the counter and drops to 0 when counter is supposed to start
        .o_counter_en(counter_en),
        .i_S15_now(S15_now),
        .o_bit_state(o_bit_state) // This is 1-hot encoded the 11 states that the system goes through (10 bits and IDLE)
    );

endmodule
