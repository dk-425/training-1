`timescale 1ns / 1ps
module packet_add #(
    parameter DW = 8,
    parameter DD = 64)(

      input                         clk,
      input                         rst,

      input           [DW-1   :0]   s_tdata,
      input                         s_tvalid,
      input                         s_tlast,
      output    logic               s_tready,
      input            [DW+DW-1 :0] config_packet,
      output    logic  [DW-1   :0]  m_tdata,
      output    logic               m_tvalid,
      output    logic               m_tlast,
      input                         m_tready
    );

  reg [DW-1:0] mem_dat1 [DD-1:0];
  reg [DW-1:0] mem_dat2 [DD-1:0];
  reg [DW-1:0] k,len;
  reg mem_last1 [DD-1:0];
  reg [31:0] index=0,indo=0;
  reg flag=0;
  reg [1:0] q=0;

  assign {k,len} = config_packet;
  integer i;


  initial
  begin
    for(i = 0; i < DD; i = i + 1)
    begin
      mem_dat1[i] = 0;
      mem_dat2[i] = 0;
      mem_last1[i] = 0;
    end
  end


  always@(posedge clk)
  begin
    if (rst)
    begin

      s_tready <=0;

    end
    else
    begin
      s_tready <=1;
     
    end
  end


  always @(posedge clk)
  begin
    if (rst)
    begin
      index <= 0;
    end
    else
    begin


      if (s_tvalid && s_tready)
      begin
        mem_dat1[index] <= s_tdata;
        mem_last1[index] <= s_tlast;
        if (index>len-1-k)
        begin
          mem_dat2[q]<=s_tdata;
          q<=q+1;
        end
        else
        begin
          q<=0;
        end
        index <= index + 1;
        flag<=1;
        if (s_tlast)
        begin
          index <= 0;
        end

      end

    end

  end

  always@(posedge clk)
  begin
    if (rst)
    begin
      indo<=0;
      m_tdata<=0;
      m_tlast<=0;
      m_tvalid<=0;
    end
    else
    begin
      if (m_tready && flag)
      begin

        m_tvalid<=1;
        m_tdata<=mem_dat1[indo]+mem_dat2[indo];
        m_tlast<=mem_last1[indo];

        indo<=indo+1;
        if (indo==len-1)
          indo<=0;
      end
      else
        m_tvalid<=0;
    end
  end
endmodule
