`timescale 1ns / 1ps

module mux_2_1 #(parameter DW = 8)(

    input   logic               clk,
    input   logic               rst,

    input   logic               sel,

    input   logic [DW-1   :0]   s1_tdata,
    input   logic               s1_tvalid,
    input   logic               s1_tlast,
    output  logic               s1_tready,

    input   logic [DW-1   :0]   s2_tdata,
    input   logic               s2_tvalid,
    input   logic               s2_tlast,
    output  logic               s2_tready,

    output  logic [DW-1   :0]   m_tdata,
    output  logic               m_tvalid,
    output  logic               m_tlast,
    input   logic               m_tready
  );


  always @(posedge clk)
  begin
    if (rst)
    begin
      m_tdata <= 0;
      m_tvalid <=0;
      m_tlast <=0;
    end
    else
    begin
      if(sel)                                                //sel?s1:s2
      begin
        if (s1_tvalid && s1_tready && ~s1_tlast)
        begin
          m_tdata <= s1_tdata;
          m_tvalid <= s1_tvalid;
        end
        else
        begin
          m_tvalid<=0;
          m_tlast <= 1;
        end

      end
      else
      begin
        if (s2_tvalid && s2_tready && ~s2_tlast)
        begin
          m_tdata <= s2_tdata;
          m_tvalid <= s2_tvalid;
        end
        else
        begin
          m_tvalid <=0;
            m_tlast <=1;
        end
      end
    end
  end

  assign s1_tready=rst?0: m_tready;
  assign s2_tready=rst?0: m_tready;

endmodule
