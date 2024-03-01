
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


      output   logic signed [DW+DW-1   :0]  m_tdata

      
    );
    

    logic signed [DW    :0] temp1;
    logic signed [DW+DW-1   :0] temp4;

    
    always @(posedge clk) begin
    if (rst) begin


    temp4<=0;
    temp1<=0;

    end
    else begin

  
    temp1<= a+b;
    temp4<= temp1*c;
  
    
    end
    end
  assign m_tdata=temp4;
  

endmodule