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

    counter_16 receiver_counter_16 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_tick_16x_en(i_tick_16x_en),
        .i_en(counter_en),
        .o_S7_now(S7_now),
        .o_S15_now(S15_now)
    );

    assign counter_en = !i_rst;


    // always_comb begin
    //     if (i_rst) begin
    //         counter_en = 0;
    //     end else begin
    //         counter_en = 1;
    //     end
    // end

endmodule
