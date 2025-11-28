// Testbench for 8bit vedic multiplier

module tb;
  reg [7:0] a,b;
  wire [16:0]p;
  vedic8x8 dut(a,b,p);
  initial begin
    a=8'd0;b=8'd0;
    #2 a=8'd100;b=8'd50;
    #2 a=8'd140;b=8'd2;
    #2 a=8'd128;b=8'd128;
    #2 $finish;
  end
  initial begin
    $monitor("[%0t],a=%0d b=%0d p=%0d",$time,a,b,p);
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule
