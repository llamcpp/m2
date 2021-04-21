`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2021 03:42:50 PM
// Design Name: 
// Module Name: accumulator
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


module accumulator #(parameter N = 4) (
    input [N - 1:0] X,
    input clk, add_n, reset_n, load,
    output [N - 1:0] Q
    );
    
    wire [N - 1:0] Q0, Q1, Q2;
    reg [N - 1:0] state_reg0, state_next0, state_reg1, state_next1, state_reg2, state_next2,
                  Q_reg;
    
    adder_subtractor #(.n(N)) as0 (
        .x(state_reg0),
        .y(X),
        .add_n(add_n),
        .s(Q0)
       // .c_out(),
       // .overflow()
    );
    
    adder_subtractor #(.n(N)) as1 (
        .x(state_reg1),
        .y(Q0),
        .add_n(add_n),
        .s(Q1)
       // .c_out(),
       // .overflow()
    );
        
    adder_subtractor #(.n(N)) as2 (
        .x(state_reg2),
        .y(Q1),
        .add_n(add_n),
        .s(Q2)
       // .c_out(),
       // .overflow()
    );
    
    // Sequential state registers
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
        begin
            state_reg0 <= 'b0;
            state_reg1 <= 'b0;
            state_reg2 <= 'b0;
            Q_reg <= 'b0;
        end
        else if (load)
        begin
            state_reg0 <= state_next0;
            state_reg1 <= state_next1;
            state_reg2 <= state_next2;
            Q_reg <= Q2;
        end
        begin
            state_reg0 <= state_reg0;
            state_reg1 <= state_reg1;
            state_reg2 <= state_reg2;
            Q_reg <= Q_reg;
        end
    end
    
    // Next state logic
    always @(load)
    begin
        if (load)
        begin
            state_next2 = state_reg1;
            state_next1 = state_reg0;
            state_next0 = X;
        end
    end
    
    assign Q = Q_reg;
    
endmodule
