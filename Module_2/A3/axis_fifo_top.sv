module axis_fifo_top #(
    parameter AW = 12,
    parameter DW = 16,
    parameter DD = 2048)(

      input                  clk,
      input                  rst,

      input    [DW-1   :0]   s_tdata,
      input                  s_tvalid,
      input                  s_tlast,
      output                 s_tready,

      output   [DW-1   :0]   m_tdata,
      output                 m_tvalid,
      output                 m_tlast,
      input                  m_tready


    );

  logic [DW-1   :0]   m_tdata_1,m_tdata_2,m_tdata_reg;
  logic m_tvalid_1,m_tlast_1,s_tready_1;
  logic m_tvalid_2,m_tlast_2,s_tready_2;
  logic m_tvalid_reg,m_tlast_reg,s_tready_reg;
  logic empty1,empty2,full1,full2;


  axis_fifo # (
              .AW(AW),
              .DW(DW),
              .DD(DD)
            )
            axis_fifo_inst_1 (
              .clk(clk),
              .rst(rst),
              .s_tdata(s_tdata),
              .s_tvalid(s_tvalid),
              .s_tlast(s_tlast),
              .s_tready(s_tready),
              .m_tdata(m_tdata_1),
              .m_tvalid(m_tvalid_1),
              .m_tlast(m_tlast_1),
              .m_tready(s_tready_2),
              .full(full1),
              .empty(empty1)
            );

  always @(posedge clk)
  begin
    m_tvalid_reg <= m_tvalid_1;
    s_tready_reg <= s_tready_1;
  end

  assign m_tvalid_2 = m_tvalid_reg;
  assign m_tlast_2  = m_tlast_1;
  assign s_tready_2 = s_tready_reg;
  assign m_tdata_2  = m_tdata_1;

  axis_fifo # (
              .AW(AW),
              .DW(DW),
              .DD(DD)
            )
            axis_fifo_inst_2 (
              .clk(clk),
              .rst(rst),
              .s_tdata(m_tdata_2),
              .s_tvalid(m_tvalid_2),
              .s_tlast(m_tlast_2),
              .s_tready(s_tready_1),
              .m_tdata(m_tdata),
              .m_tvalid(m_tvalid),
              .m_tlast(m_tlast),
              .m_tready(m_tready),
              .full(full2),
              .empty(empty2)
            );



endmodule
