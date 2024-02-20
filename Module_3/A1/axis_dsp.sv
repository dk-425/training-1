`timescale 1ns/1ps

module dsp #(
        parameter DEPTH = 32,
        parameter ADDR_WIDTH = 5,
        parameter DATA_WIDTH = 16
    )
    (
        input clk,
        input rst,
        input logic [DATA_WIDTH-1:0] a,
        input logic [DATA_WIDTH-1:0] b,
        input logic [DATA_WIDTH-1:0] c,
        input logic [DATA_WIDTH-1:0] d,
        output logic pd,
        output logic [DATA_WIDTH - 1:0] p,
        output logic  xored
    );

    logic [DATA_WIDTH-1:0] temp1;
    logic [DATA_WIDTH-1:0] temp2;
    
    always @(posedge clk) begin
     temp1 <= d+a;
     temp2 <= temp1*b;
     if (temp2==c) pd<=1;
     else pd<=0;
     p<=temp2;
 //    xored <= ^ temp2;

end



endmodule
