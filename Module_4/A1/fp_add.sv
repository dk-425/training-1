`timescale 1ns / 1ps

module fp_add#(
    parameter i1 = 2,
    parameter f1 = 14,
    parameter s1=0,
    parameter i2 = 2,
    parameter f2 = 14,
    parameter s2 =0,
    parameter i3 = 2,
    parameter f3 = 14
  )(
    input [i1+f1-1 :0] a,
    input [i2+f2-1 :0] b,
    output [i3+f3-1 :0] c,
    output reg overflow,
    output reg underflow
  );
  reg [i3+f3 :0] tmp1,tmp2;
  reg [i1+f1-1 :0] ta;
  reg [i2+f2-1 :0] tb;
  reg signed [i3+f3 :0] signed_max = 1.99;
  reg signed [i3+f3 :0] signed_min = -2;
  reg sres = s1 || s2;


  always_comb
  begin
    if (sres)
    begin
      if (s1)
        ta = $signed(a);
      else
        ta = a;
      if (s2)
        tb = $signed(b);
      else
        tb = b;
      tmp2=$signed(ta)+ $signed(tb);

    end
    else
    begin
      tmp1=a+b;
      overflow = tmp1[i3+f3];
      underflow = tmp1<0?1:0;
    end


  end

  assign c = sres?tmp2:tmp1[i3+f3-1:0];

endmodule
