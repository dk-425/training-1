`timescale 1ns / 1ps
//assigning (a+b)c
module dsp #(
    parameter DW = 8
  )(

   // input                  clk,
   // input                  rst,

    input    logic signed [DW-1   :0]   A,
    input    logic signed [DW-1   :0]   B,
    input    logic signed [DW-1   :0]   C,


    output   logic signed [DW+DW-1   :0]  m_tdata


  );

  assign m_tdata=(A+B)*C;


endmodule
