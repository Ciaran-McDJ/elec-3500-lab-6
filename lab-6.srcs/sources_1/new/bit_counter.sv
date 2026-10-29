`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ciaran McDonald-Jensen (SN 101228856)
// 
// Create Date: 10/29/2026 01:14:50 PM
// Design Name: 
// Module Name: bit_counter
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


module bit_counter(
    input logic i_clk,
    input logic i_rst,
    input logic i_tick_16x_en,
    input logic i_start, // Stays at 1 when not using the counter and drops to 0 when counter is supposed to start
    output logic o_counter_en,
    input logic i_S15_now,
    output logic [10:0] o_bit_state
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

    state_t state, next_state;
    assign o_bit_state = state; //Since using 1-hot, no combinational logic necessary, outputs is just the output of each register of the state

    always_ff @(posedge i_clk) begin
        if (i_rst) state <= S_IDLE;
        else state <= next_state;
    end

    always_comb begin
        // next_state logic
        if (i_rst) next_state = S_IDLE;
        else case (state)
            S_IDLE: if (!i_start) next_state = S_START; else next_state = S_IDLE; //NOTE: This transition doesn't have to happen on a tick, this is so it can detect a super short button press signal. This means that when transmitting, the start bit will be a tiny bit less than one period
            S_START: if (i_S15_now && i_tick_16x_en) next_state = S_BIT1; else next_state = S_START;
            S_BIT1: if (i_S15_now && i_tick_16x_en) next_state = S_BIT2; else next_state = S_BIT1;
            S_BIT2: if (i_S15_now && i_tick_16x_en) next_state = S_BIT3; else next_state = S_BIT2;
            S_BIT3: if (i_S15_now && i_tick_16x_en) next_state = S_BIT4; else next_state = S_BIT3;
            S_BIT4: if (i_S15_now && i_tick_16x_en) next_state = S_BIT5; else next_state = S_BIT4;
            S_BIT5: if (i_S15_now && i_tick_16x_en) next_state = S_BIT6; else next_state = S_BIT5;
            S_BIT6: if (i_S15_now && i_tick_16x_en) next_state = S_BIT7; else next_state = S_BIT6;
            S_BIT7: if (i_S15_now && i_tick_16x_en) next_state = S_STOP; else next_state = S_BIT7;
            S_STOP: if (i_S15_now && i_tick_16x_en) next_state = S_IDLE; else next_state = S_STOP;
            default: next_state = S_IDLE;
        endcase
        
        // output logic
        // NOTE: Output logic using one hot to make combinational logic involving it simple
        // if (state==S_IDLE) o_counter_en = 0; else o_counter_en = 1;
        // if (state==S_START) o_bit_start = 1; else o_bit_start = 0;
        // case (state)
        //     S_BIT0: o_bit_n = 8'b00000001;
        //     S_BIT1: o_bit_n = 8'b00000010;
        //     S_BIT2: o_bit_n = 8'b00000100;
        //     S_BIT3: o_bit_n = 8'b00001000;
        //     S_BIT4: o_bit_n = 8'b00010000;
        //     S_BIT5: o_bit_n = 8'b00100000;
        //     S_BIT6: o_bit_n = 8'b01000000;
        //     S_BIT7: o_bit_n = 8'b10000000;
        //     default: o_bit_n = 8'b00000000;
        // endcase
        // if (state==S_STOP) o_bit_stop = 1; else o_bit_stop = 0;
    end

endmodule


// NOTE: end of S7 is used for measuring in the middle of a bit
// NOTE: end of S15 used to switch to next bit when transmitting