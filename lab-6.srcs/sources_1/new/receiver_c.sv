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

    typedef enum logic [10:0] { //one hot except IDLE state is 10'b0
        S_IDLE = 10'b00000000001,
        S_START = 10'b00000000010,
        S_BIT0 = 10'b00000000100,
        S_BIT1 = 10'b00000001000,
        S_BIT2 = 10'b00000010000,
        S_BIT3 = 10'b00000100000,
        S_BIT4 = 10'b00001000000,
        S_BIT5 = 10'b00010000000,
        S_BIT6 = 10'b00100000000,
        S_BIT7 = 10'b01000000000,
        S_STOP = 10'b10000000000
    } state_t;

    state_t bit_state;

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

    always_ff @(posedge i_clk) begin
        if (i_rst) begin
            o_rx_data <= 8'b00000000;
            o_frame_error <= 1'b0;
        end
        else if (S7_now) begin
            case (bit_state)
                S_BIT0: o_rx_data[0] <= i_uart_rx_in;
                S_BIT1: o_rx_data[1] <= i_uart_rx_in;
                S_BIT2: o_rx_data[2] <= i_uart_rx_in;
                S_BIT3: o_rx_data[3] <= i_uart_rx_in;
                S_BIT4: o_rx_data[4] <= i_uart_rx_in;
                S_BIT5: o_rx_data[5] <= i_uart_rx_in;
                S_BIT6: o_rx_data[6] <= i_uart_rx_in;
                S_BIT7: o_rx_data[7] <= i_uart_rx_in;
                S_STOP: if (i_uart_rx_in != 1) o_frame_error <= 1;
            endcase
        end
    end

endmodule
