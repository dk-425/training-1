//Build a decade counter that counts from 0 through 9, inclusive, with a period of 10. The reset input is synchronous, and should reset the counter to 0. We want to be able to pause the counter rather than always incrementing every clock cycle, so the slowena input indicates when the counter should increment.

module slow_counter (
    input clk,
    input slowena,
    input reset,
    output [3:0] q);
  reg [3:0] nq;
  always @(posedge clk)
  begin
    if (reset)
      nq<=4'h0;
    else
    begin
      if (slowena)
      begin
        if (nq==4'h9)
          nq<=4'd0;
        else
          nq<=nq+4'h1;
      end
      else
        nq<=nq;
    end
  end
  assign q=nq;
endmodule
