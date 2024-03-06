//7 lut,1 reg,1 dsp

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
      output   logic                     sel,
      output   logic signed [DW+DW   :0]  m_tdata,
      output overflow

      
    );
    

    logic signed [DW    :0] temp1,temp3,temp11,temp12,temp13;
    logic signed [DW+DW-1   :0] temp4;
    logic               opm;
    
    always @(posedge clk) begin
    if (rst) begin


    temp4<=0;
    temp1<=0;
    temp13<=0;
  //  temp11<=0;
  //  temp12<=0;
    end
    else begin

    temp1<= a+d;
    temp4<= temp1*b;
    opm<=sel;
    if (temp4==c) sel<=1;
    else sel<=0;
   // temp11<=temp4-c;
    //temp12<=sel?temp13:temp11;
  
    end
    end
  assign m_tdata=temp4[DW+DW-1:0];
  assign overflow=temp4[DW+DW];

endmodule