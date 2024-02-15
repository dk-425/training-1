`timescale 1ns / 1ps

module axis_fifo_tb;

  // Parameters
  localparam  DW = 16;
  localparam  DD = 2048;

  //Ports
  logic  clk;
  logic  rst;
  logic [DW-1   :0] s_tdata='d0;
  logic  s_tvalid=0;
  logic  s_tlast=0;
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
    clk=1;
    rst=1;
    #30
    rst=0;
    #20
    m_tready<=1;
    s_tlast<=0;
    s_tvalid=1;
    stimuli(4096);
    s_tlast<=1;
    s_tvalid=0;
    #10
    stimuli(4);
    #1ms
    $stop();

end

always @* begin
if (m_tlast) m_tready=0;
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
  
    s_tdata=n-i;
    #10;
   // $display("%d\n",s_tdata);
  end

end
endtask

endmodule



/*
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


`timescale 1ns / 1ps

module axis_fifo #(

    parameter DW = 8,
    parameter DD = 2048)(

      input   logic               clk,
      input   logic               rst,

      input   logic [DW-1   :0]   s_tdata,
      input   logic               s_tvalid,
      input   logic               s_tlast,
      output  logic               s_tready,

      output  logic [DW-1   :0]   m_tdata,
      output  logic               m_tvalid,
      output  logic               m_tlast,
      input   logic               m_tready
    );

  logic [DW-1 :0] fifo1 [DD-1 :0];
  logic [DW-1 :0] fifo2 [DD-1 :0];
  logic fifo1_rw_en=0,fifo2_rw_en=0;   //0-r,1-w
  integer read_idx=0, write_idx=0;
  reg flag=0;

     generate 
		if(DD == 2048) begin
		 initial begin
			  for(integer i = 0; i < DD; i = i + 1) begin
					fifo1[i] = 0;
					fifo2[i] = 0;
			  end
		 end		
		end
	 endgenerate

  always @(posedge clk) begin
    if (rst) begin
          m_tdata <= 0;
          m_tvalid <= 0;
          m_tlast <= 1;
         // s_tready <= 0;
          read_idx<=0;
          write_idx<=0;
    end
    else begin
     
      if (s_tvalid && s_tready && ~s_tlast)
          begin
            if (read_idx==4095)
            begin
              read_idx <=0;
              flag<=1;
            //  s_tready<=0;
            end

            else
            begin
            //  s_tready<=1;
              read_idx<=read_idx+1;
              if (read_idx<2048) begin
                fifo1[read_idx] <= s_tdata;
              end
              else begin
                fifo2[read_idx-2048] <= s_tdata;
              end
              
            end
            
          end

          else
          begin
            // s_tready <=1;
          end
    end

  end

  always @(posedge clk) begin
    if (rst) s_tready <=0;
    else s_tready <=1;
  end

  always @(posedge clk) begin
    if (m_tready && flag)
        begin
          if (write_idx==4095)
          begin
            write_idx <=0;
            flag <=0;
            m_tlast <=1;
            m_tvalid <=0;
          end
          else
          begin
            m_tvalid<=1;
            write_idx <= write_idx+1;
            if (write_idx<2047)
              m_tdata <= fifo1[write_idx];
            else
              m_tdata <= fifo2[write_idx-2048];

          end
          
        end
        else
        begin
          m_tvalid<=0;
        end
      end

  
endmodule
*/



