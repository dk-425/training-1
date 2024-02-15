module kmap(   //m(0,1,2,4,6,7,8,9,11,15)
    input a,
    input b,
    input c,
    input d,
    output out  );
  assign out = ~b && ~c || ~a && c && ~d || ~a && b && ~d || b && c && d || a && c && d;
endmodule
