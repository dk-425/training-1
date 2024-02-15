`timescale 1ns / 1ps

module axis_fifo_tb;

  // Parameters
  localparam  DW = 8;
  localparam  DD = 2048;

  //Ports
  logic  clk;
  logic  rst;
  logic [DW-1   :0] s_tdata;
  logic  s_tvalid;
  logic  s_tlast;
  logic  s_tready;
  logic [DW-1   :0] m_tdata;
  logic  m_tvalid;
  logic  m_tlast;
  logic  m_tready;

  axis_fifo # (
    .DW(DW),
    .DD(DD)
  )
  axis_fifo_inst (
    .clk(clk),
    .rst(rst),
    .s_tdata(s_tdata),
    .s_tvalid(s_tvalid),
    .s_tlast(s_tlast),
    .s_tready(s_tready),
    .m_tdata(m_tdata),
    .m_tvalid(m_tvalid),
    .m_tlast(m_tlast),
    .m_tready(m_tready)
  );


always #5  clk = ! clk ;

initial begin
    clk=0;
    rst=1;
    #30
    rst=0;
    #12
    m_tready<=1;
    s_tlast<=0;
    s_tvalid=1;
    stimuli(4099);
    #10
    s_tlast<=1;
    s_tvalid=0;
    stimuli(4);
    #50
    $stop();

end



task automatic reset;
begin
  rst = ~rst;
end
endtask

task automatic stimuli(input [12:0] n);
begin
  for (integer i=0;i<n;i=i+1)
  begin
  #10;
    s_tdata=$urandom;
   // $display("%d\n",s_tdata);
  end

end
endtask

endmodule