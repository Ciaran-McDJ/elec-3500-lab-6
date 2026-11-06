`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ELEC 3500 A1
// Engineer: Axel Greavette (SN 101298645)
// 
// Create Date: 11/05/2026
// Design Name: UART_TRANSMITTER
// Module Name: transmitter
// Project Name: UART Communication Device
// Target Devices: Nexus A7
// Description: UART transmitter module
// 
// Dependencies: uart_counter
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module transmitter(
    input logic i_clk,
    input logic i_rst,
    input logic i_tick_16x_en,
    input logic i_transmit,
    input logic [7:0] i_tx_data,
    output logic o_uart_tx_out = 1'b1
    );

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

    logic [10:0] bit_state_raw;
    state_t bit_state;
    assign bit_state = state_t'(bit_state_raw); //explicit casting to state_t. otherwise wont work for implementation 
    logic S7_now;

    // Rising edge detector on i_transmit
    logic sig = 1'b0, sig2 = 1'b0;
    logic transmit_edge;
    assign transmit_edge = sig && !sig2;

    always_ff @(posedge i_clk) begin
        if (i_rst) begin
            sig <= 1'b0;
            sig2 <= 1'b0;
        end else begin
            sig <= i_transmit;
            sig2 <= sig;
        end
    end

    uart_counter transmitter_counter (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_tick_16x_en(i_tick_16x_en),
        .i_start_counting(!transmit_edge), // Active low signal: drops to 0 on rising edge of i_transmit
        .o_S7_now(S7_now),
        .o_bit_state(bit_state_raw)
    );

    always_ff @(posedge i_clk) begin
        if (i_rst) begin
            o_uart_tx_out <= 1'b1;
        end else begin
            case (bit_state)
                S_IDLE:  o_uart_tx_out <= 1'b1;
                S_START: o_uart_tx_out <= 1'b0;
                S_BIT0:  o_uart_tx_out <= i_tx_data[0];
                S_BIT1:  o_uart_tx_out <= i_tx_data[1];
                S_BIT2:  o_uart_tx_out <= i_tx_data[2];
                S_BIT3:  o_uart_tx_out <= i_tx_data[3];
                S_BIT4:  o_uart_tx_out <= i_tx_data[4];
                S_BIT5:  o_uart_tx_out <= i_tx_data[5];
                S_BIT6:  o_uart_tx_out <= i_tx_data[6];
                S_BIT7:  o_uart_tx_out <= i_tx_data[7];
                S_STOP:  o_uart_tx_out <= 1'b1;
                default: o_uart_tx_out <= 1'b1;
            endcase
        end
    end

endmodule
