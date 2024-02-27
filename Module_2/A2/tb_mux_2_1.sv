
module mux_2_1_tb;

  // Parameters
  localparam  DW = 8;

  //Ports
  reg  clk=0;
  reg  rst=1;
  reg  sel;
  reg [DW-1   :0] s1_tdata=0;
  reg  s1_tvalid=0;
  reg  s1_tlast=0;
  wire  s1_tready;
  reg [DW-1   :0] s2_tdata=0;
  reg  s2_tvalid=0;
  reg  s2_tlast=0;
  wire  s2_tready;
  wire [DW-1   :0] m_tdata;
  wire  m_tvalid;
  wire  m_tlast;
  reg  m_tready=0;

  mux_2_1 # (
    .DW(DW)
  )
  mux_2_1_inst (
    .clk(clk),
    .rst(rst),
    .sel(sel),
    .s1_tdata(s1_tdata),
    .s1_tvalid(s1_tvalid),
    .s1_tlast(s1_tlast),
    .s1_tready(s1_tready),
    .s2_tdata(s2_tdata),
    .s2_tvalid(s2_tvalid),
    .s2_tlast(s2_tlast),
    .s2_tready(s2_tready),
    .m_tdata(m_tdata),
    .m_tvalid(m_tvalid),
    .m_tlast(m_tlast),
    .m_tready(m_tready)
  );

always #5  clk = ! clk ;

integer i=0;
  
  initial
  begin
 
    reset;
    
       fork
            begin
                axis_write(10);
            end

            begin
                axis_read(11);
            end
        join
        
        fork 
            begin
                 axis_write(20);
            end     
            begin
                 axis_read(22);
            end 
        join

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
        begin: write
        repeat (k) begin
            @(posedge clk); 
                if (!s1_tready) begin 
                 s1_tvalid <= 0;
                 s1_tlast<=0;
                 s1_tdata<=s1_tdata;
                 end
                 else begin
                s1_tvalid <= 1;
                s1_tdata <= s1_tdata+2;
                s1_tlast <=0;
                end
                 if (!s2_tready) begin 
                 s2_tvalid <= 0;
                 s2_tlast<=0;
                 s2_tdata<=s2_tdata;
                end
                else begin
                s2_tvalid <= 1;
                s2_tdata <= s2_tdata+3;
                s2_tlast <=0;
                end
               
            end
            s1_tlast <=sel?1:0;
            s2_tlast <=~sel?1:0;
            @(posedge clk);
            s1_tvalid <=0;
            s1_tlast <=0;
            s2_tvalid <=0;
            s2_tlast <=0;
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
initial begin
    sel=0;
    #200
    sel=1;
    #100
    sel=0;
    #50
    sel=1;
    #60
    sel=0;
   end
endmodule