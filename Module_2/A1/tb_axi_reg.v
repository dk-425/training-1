`timescale 1ns/1ps

module tb_axi_reg;

  // Parameters
  localparam  DW = 8;

  //Ports
  reg  clk;
  reg  rst;
  reg [DW-1   :0] s_tdata;
  reg  s_tvalid;
  reg  s_tlast;
  wire  s_tready;
  wire [DW-1   :0] m_tdata;
  wire  m_tvalid;
  wire  m_tlast;
  reg  m_tready;

  axi_reg # (
            .DW(DW)
          )
          axi_reg_inst (
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

  always #5  clk = ~ clk ;

  integer i;
  
  initial
  begin
    clk=1;
    rst=1;
    #11
    m_tready=1;
    s_tlast=0;
    #10
     reset;
    // fork begin
    s_tvalid=1;
    stimuli(9);
    //end
    //join
    #10
    s_tvalid=0;
    stimuli(4);
    #10
     reset;
    s_tvalid=1;
    stimuli(3);
    #10
     reset;
    s_tvalid=1;
    stimuli(6);
    #10
     s_tlast=1;
     s_tvalid=1;
     stimuli(5);
    #10
     $stop();
  end

  task automatic reset;
    begin
      rst = ~rst;
    end
  endtask

  task automatic stimuli(input [5:0] n);
    begin
      for (i=0;i<n;i=i+1)
      begin
      #10;
        s_tdata=$urandom;
        //$display("%d\n",s_tdata);
      end

    end
  endtask
  

endmodule
