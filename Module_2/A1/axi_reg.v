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

  reg  m_tvalid_i,m_tlast_i,s_tready_i;
  reg [DW-1:0] m_tdata_i='d0;

  always @(posedge clk)
  begin
    if (rst)
    begin
      m_tvalid_i<=0;
      m_tlast_i <=0;
    end
    else if (s_tvalid && s_tready)
    begin
      m_tdata_i <= s_tdata;
      m_tvalid_i <= s_tvalid;
      m_tlast_i <= s_tlast;
    end
    else
    begin
      m_tvalid_i<=0;
    end

  end
  always @(posedge clk) begin
      if (rst)
    begin
      s_tready_i<=0;
    end
    else begin
    s_tready_i<=m_tready;
    end
  end

  assign m_tvalid = m_tvalid_i;
  assign m_tdata = m_tdata_i;
  assign m_tlast = m_tlast_i;
  assign s_tready = s_tready_i;

endmodule




