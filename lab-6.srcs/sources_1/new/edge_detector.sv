`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ELEC 3500 A1
// Engineer: Axel Greavette
// 
// Create Date: 10/09/2026 04:33:10 PM
// Design Name: Edge Detector
// Module Name: edge_detector
// Project Name: UART Communication Device
// Target Devices: Nexus A7
// Tool Versions: 
// Description: Rising or falling edge detector, modular and easy to add to any project.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module edge_detector(
        input i_rst,
        input i_clk,
        input i_sig,
        output o_edge
    );
    
    logic sig, sig2;
    assign o_edge = sig && sig2;
    
    always_ff @(posedge i_clk) begin
        if(i_rst) begin
            sig <= 1'b0;
            sig2 <= 1'b0;
        end else begin
            sig <= i_sig;
            sig2 <= sig;
        end 

    end 

endmodule
