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

  reg [DW-1:0] buffer_dat [DD-1:0];
  reg [DW-1:0] refer_dat [DD-1:0];
  reg [DW-1:0] sufer_dat [DD-1:0];
  reg [DW-1:0] k,len;
  reg buffer_last [DD-1:0];
  reg [31:0] index=0,indo=0;
  reg m_tlast_i, flag;
  wire flag1;
  reg [1:0] q=0;
  logic [DW-1   :0]   s_tdata_i;
  assign flag1 = flag;
  assign {k,len} = config_packet;
  integer i;


  initial
  begin
    for(i = 0; i < DD; i = i + 1)
    begin
      buffer_dat[i] = 0;
      refer_dat[i] =0;
    end
    m_tlast<=0;
    m_tvalid<=0;
    m_tdata<=0;
  end
  always@(posedge clk)
  begin
    if (rst)
    begin
      m_tlast_i<=0;
      s_tdata_i<=0;
      s_tready <=0;
    end
    else
    begin
      s_tready <=1;
      m_tlast_i<=s_tlast;
      s_tdata_i<=s_tdata;
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
        buffer_dat[index] <= s_tdata_i;
        buffer_last[index] <= m_tlast_i;
        sufer_dat[index] <= refer_dat[index];
        if (index>len-1-k)
        begin
          refer_dat[q]<=s_tdata_i;
          q<=q+1;
        end
        else
          q<=0;
        index <= index + 1;
        if (m_tlast_i)
        begin
          index <= 0;
          flag<=1;

        end
      end
      if (m_tready)
      begin
        if (flag1)
        begin
          m_tvalid<=1;
          m_tdata<=buffer_dat[indo]+sufer_dat[indo];
          m_tlast<=buffer_last[indo];

          indo<=indo+1;
          if (indo==len-1)
            indo<=0;
        end
      end
      else
        m_tvalid<=0;
    end

  end


endmodule
