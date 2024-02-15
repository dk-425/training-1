`timescale 1ns / 1ps

module axi_reg #(parameter DW = 8)(

    input                       clk,
    input                       rst,

    input   [DW-1   :0]         s_tdata,
    input                       s_tvalid,
    input                       s_tlast,
    output                      s_tready,

    output  [DW-1   :0]         m_tdata,
    output                      m_tvalid,
    output                      m_tlast,
    input                       m_tready
  );

  reg  m_tvalid_i=0,m_tlast_i=0;
  reg [DW-1:0] m_tdata_i='d0;

  always @(posedge clk)
  begin
    if (rst)
    begin
      m_tdata_i <= 0;
      m_tvalid_i<=0;
      m_tlast_i <=0;
    end
    else
    begin
      if (s_tvalid && s_tready && ~s_tlast)
      begin
        m_tdata_i <= s_tdata;
        m_tvalid_i <= s_tvalid;
      end
      else
      begin 
        m_tlast_i <= 1;
        m_tvalid_i<=0;
      end
    end
  end

  assign m_tvalid = m_tvalid_i;
  assign m_tdata = m_tdata_i;
  assign m_tlast = m_tlast_i;
  assign s_tready = rst ? 0 : m_tready;

endmodule




