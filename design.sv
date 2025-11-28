// Design for 8 bit vedic multiplier

module ha(a,b,s,c);
  input a,b;
  output s,c;
  assign s=a^b;
  assign c=a&b;
endmodule

module vedic2x2(a,b,p);
  input[1:0]a,b;
  output [3:0]p;
  wire x1,x2,x3,x4;
  assign p[0]=a[0]&b[0];
  assign x1=a[1]&b[0];
  assign x2=a[0]&b[1];
  assign x4=a[1]&b[1];
  ha h1(x1,x2,p[1],x3);
  ha h2(x3,x4,p[2],p[3]);
endmodule

module fa(a,b,c,s,cry);
  input a,b,c;
  output s,cry;
  assign s=a^b^c;
  assign cry=(a&b)|(b&c)|(c&a);
endmodule

module rca(a,b,c,sum,cout);
  input [3:0]a,b;
  input c;
  output[3:0] sum;
  output cout;
  wire c0,c1,c2;
  fa f1(a[0],b[0],c,sum[0],c0);
  fa f2(a[1],b[1],c0,sum[1],c1);
  fa f3(a[2],b[2],c1,sum[2],c2);
  fa f4(a[3],b[3],c2,sum[3],cout);
endmodule
  
module vedic4x4(a,b,p);
  input [3:0]a,b;
  output [7:0]p;
  wire [3:0] m1,m2,m3,m4;
  wire [3:0] t1,t2;
  wire c1,c2,c3,c_or;
  vedic2x2 v1(a[1:0],b[1:0],m1);
  vedic2x2 v2(a[1:0],b[3:2],m2);
  vedic2x2 v3(a[3:2],b[1:0],m3);
  vedic2x2 v4(a[3:2],b[3:2],m4);
  
  
  rca r1(m2,m3,1'b0,t1,c1);
  rca r2({2'b00,m1[3:2]},t1,1'b0,t2,c2);
  assign c_or=c1|c2;
    rca r3({1'b0,c_or,t2[3:2]},m4,1'b0,p[7:4],c3);
  
  assign p[1:0]=m1[1:0];
  assign p[3:2]=t2[1:0];
endmodule
  
module rca8(input [7:0]a,b,input c,output[7:0]sum,output cry);
  wire w1;
  rca r1(a[3:0],b[3:0],c,sum[3:0],w1);
  rca r2(a[7:4],b[7:4],w1,sum[7:4],cry);
endmodule

module vedic8x8(input [7:0]a,b,output[15:0]p);
  wire [7:0]s1,s2,s3,s4;
  wire [7:0]t1,t2;
  wire c1,c2,c3;
  vedic4x4 v1(a[3:0],b[3:0],s1);
  vedic4x4 v2(a[3:0],b[7:4],s2);
  vedic4x4 v3(a[7:4],b[3:0],s3);
  vedic4x4 v4(a[7:4],b[7:4],s4);
  rca8 r1(s2,s3,1'b0,t1,c1);
  rca8 r2({4'b0000,s1[7:4]},t1[7:0],1'b0,t2,c2);
  rca8 r3(s4,{c1,3'b000,t2[7:4]},1'b0,p[15:8],c3);
  assign p[3:0]=s1[3:0];
  assign p[7:4]=t2[3:0];
endmodule 
