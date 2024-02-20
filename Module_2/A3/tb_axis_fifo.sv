`timescale 1ns / 1ps

module axis_fifo_tb;

  // Parameters
  localparam  DW = 16;
  localparam  DD = 2048;
  localparam AW = 12;

  //Ports
  logic  clk;
  logic  rst;
  logic [DW-1   :0] s_tdata='d0;//,s_tdata_i;
  logic  s_tvalid=0;
  logic  s_tlast=0;//,s_tlast_i;
  logic  s_tready;
  logic [DW-1   :0] m_tdata;
  logic  m_tvalid;
  logic  m_tlast;
  logic  m_tready=0;
  logic full,empty;

  axis_fifo # (
              .DW(DW),
              .DD(DD),
              .AW(AW)
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
              .m_tready(m_tready),
              .full(full),
              .empty(empty)
            );


  always #5  clk = ! clk ;

  initial
  begin
    clk=1;
    rst=1;
    #30
     rst=0;
    #20
     // m_tready<=1;
     fork
       begin

         axis_write(2049);
       end
       //    begin
       //    axis_read(2048);
       //    end
     join
     // m_tready<=1;
     // enb=1;
     #10
      // s_tvalid=0;
      m_tready=1;

    #30

     #20450
     m_tready<=0;
    // axis_write(4);
    #1ms



     $stop();

  end

  integer file;//,file2,file3;

  task automatic reset;
    begin
      rst = ~rst;
    end
  endtask

  task automatic axis_write(input [12:0] n);
    file = $fopen("map_out.csv", "r");
    repeat (n)
    begin
      if (file == 0)
      begin
        $stop("Error in Opening file !!");
      end
      else
      begin
        @(posedge clk);
        $fscanf(file,"%d,%b",s_tdata,s_tlast);
        s_tvalid<=1;
        $display("%d,%b\n",s_tdata,s_tlast);
      end
      //$display("%d\n",s_tdata);
    end
    s_tvalid<=0;
    $fclose(file);
  endtask

  //task automatic axis_read(input [12:0] n);
  //file3 = $fopen("map_out.csv", "r");
  //file2 = $fopen("output.csv", "w");
  //repeat (n) begin
  //        if (file == 0) begin
  //            $stop("Error in Opening file !!");
  //        end
  //        else begin
  //        if (m_tready) begin
  //        @(posedge clk);
  //        $fscanf(file,"%h,%b",s_tdata_i,s_tlast_i);
  //        if (m_tdata==s_tdata_i && m_tlast==s_tlast_i)
  //        $display("pass, %h,%b\n",m_tdata,m_tlast);
  //        else $display("fail, %h,%b\n",m_tdata,m_tlast);
  //        end
  //        end
  //    //$display("%d\n",s_tdata);
  //  end

  //$fclose(file3);
  //$fclose(file2);
  //endtask

endmodule





