

`timescale 1ns / 1ps
//using clk and reset
module dsp #(
    parameter DW = 8
  )(

    input                  clk,
    input                  rst,


    input    logic signed [DW-1   :0]   a,
    input    logic signed [DW-1   :0]   b,
    input    logic signed [DW-1   :0]   c,
    input    logic signed [DW-1   :0]   d,
    output   logic signed [DW-1   :0]  m_tdata,
    output overflow


  );


  logic signed [DW    :0] temp1,temp3,temp11,temp12,temp13;
  logic signed [DW+DW-1   :0] temp4;
  logic               opm;

  always @(posedge clk)
  begin
    if (rst)
    begin


      temp4<=0;
      temp1<=0;
      temp13<=0;

    end
    else
    begin

      temp1<= a-d;
      temp4<= temp1*b;
      temp13<=temp4+c;


    end
  end
  assign m_tdata=temp13[DW:1];
  assign overflow=temp13[0];

endmodule
