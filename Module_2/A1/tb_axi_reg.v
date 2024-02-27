`timescale 1ns/1ps

module tb_axi_reg;

  // Parameters
  localparam  DW = 8;

  //Ports
  reg  clk;
  reg  rst;
  reg [DW-1   :0] s_tdata=0;
  reg  s_tvalid=0;
  reg  s_tlast=0;
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

  integer i=0;
  
  initial
  begin
 
    clk=0;
    rst=1;
    m_tready=0;
    s_tlast=0;
    reset;
    
       fork
            begin
                axis_write(10);
            end

            begin
                axis_read(12);
            end
        join
        
        fork 
            begin
                 axis_write(10);
            end     
            begin
                 axis_read(11);
            end 
        join
       @(posedge clk)
     $stop();
  end

  task automatic reset;
    begin
    repeat (3) @(posedge clk);
      rst = ~rst;
    end
  endtask

  
  task automatic axis_write;
     input integer k;
        begin
        repeat (k) begin
            @(posedge clk); 
                if (!s_tready) begin 
                 s_tvalid <= 0;
                 s_tlast<=0;
                 s_tdata<=s_tdata;
                end
                else begin
                s_tvalid <= 1;
                s_tdata <= s_tdata+2;
                s_tlast <=0;
                end
               
            end
            s_tlast <=1;
            @(posedge clk);
            s_tvalid <=0;
            s_tlast <=0;
end
    endtask
  
 task automatic axis_read;
 input integer p;
        begin
    
            repeat (p) @(posedge clk) begin
               m_tready <= 1; 
            end
            @(posedge clk);
            m_tready <= 0;
        end
    endtask
    
endmodule
