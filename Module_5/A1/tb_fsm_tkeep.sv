
module fsm_tkeep_tb;

  // Parameters
  localparam  DW = 16;
  localparam  KW = 8;

  //Ports
  reg  clk;
  reg  rst;
  reg  s_tvalid;
  reg [DW-1 :0] s_tdata;
  reg  s_tlast;
  reg [KW-1 :0] s_tkeep;
  wire  s_tready;
  wire  m_tvalid;
  wire [DW-1 :0] m_tdata;
  wire  m_tlast;
  wire [KW-1 :0] m_tkeep;
  reg  m_tready;

  fsm_tkeep # (
    .DW(DW),
    .KW(KW)
  )
  fsm_tkeep_inst (
    .clk(clk),
    .rst(rst),
    .s_tvalid(s_tvalid),
    .s_tdata(s_tdata),
    .s_tlast(s_tlast),
    .s_tkeep(s_tkeep),
    .s_tready(s_tready),
    .m_tvalid(m_tvalid),
    .m_tdata(m_tdata),
    .m_tlast(m_tlast),
    .m_tkeep(m_tkeep),
    .m_tready(m_tready)
  );

always #5  clk = ! clk ;

task automatic reset;
  begin
   repeat (3) @(negedge clk);
      rst = ~rst;
    end
  endtask

  task automatic axis_write(input [AW:0] n);
    file = $fopen("input_dat.csv", "r");
    repeat (n)
    begin
      if (file == 0)
      begin
        $stop("Error in Opening file !!");
      end
      else
      begin
        @(negedge clk);
        $fscanf(file,"%d,%d,%b",s_tdata,s_tkeep,s_tlast);
        s_tvalid<=1;
      //  $display("%d,%b",s_tdata,s_tlast);
      end
    end
    s_tvalid<=0;
    $fclose(file);
  endtask

endmodule