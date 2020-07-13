

module regfile(data_in,writenum,write,readnum,clk,data_out);

//Ins/Outs
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output [15:0] data_out;

//Wires
    wire [7:0] decToAnd; //wire from the decoder to And gates
    wire [7:0] andToReg= {decToAnd[7]&write, decToAnd[6]&write,
                        decToAnd[5]&write,decToAnd[4]&write,
                        decToAnd[3]&write,decToAnd[2]&write,
                        decToAnd[1]&write,decToAnd[0]&write}; //wires from the And gates to register
    wire [7:0] regToMux;//wire form the register to the multiplexer
    wire [7:0] decToMux;

//different Modules

  //initialized the input decoder
  Dec #(3,8) DecIn(writenum,decToAnd);

  //instantiating the registers
  vDFFE #(16) R7(clk,andToReg[7],data_in,regToMux[7]);
  vDFFE #(16) R6(clk,andToReg[6],data_in,regToMux[6]);
  vDFFE #(16) R5(clk,andToReg[5],data_in,regToMux[5]);
  vDFFE #(16) R4(clk,andToReg[4],data_in,regToMux[4]);
  vDFFE #(16) R3(clk,andToReg[3],data_in,regToMux[3]);
  vDFFE #(16) R2(clk,andToReg[2],data_in,regToMux[2]);
  vDFFE #(16) R1(clk,andToReg[1],data_in,regToMux[1]);
  vDFFE #(16) R0(clk,andToReg[0],data_in,regToMux[0]);

  //decoder for input to the multiplexer
  Dec #(3,8) DecMux(readnum,decToMux);

  //mux for the outputs from the registers
  Mux8 #(16) MuxOut(regToMux[7],regToMux[6], //register inputs
                    regToMux[5],regToMux[4],
                    regToMux[3],regToMux[2],
                    regToMux[1],regToMux[0],
                     decToMux //select
                     , data_out) ; //output


endmodule



//-----------------Modules Used--------------------------------//

// a - binary input   (n bits wide)
// b - one hot output (m bits wide)
module Dec(a, b) ;
  parameter n=2 ;
  parameter m=4 ;

  input  [n-1:0] a ;
  output [m-1:0] b ;

  wire [m-1:0] b = 1 << a ;
endmodule


//REGISTER with load enable
module vDFFE(clk,load,in,out);
  parameter n=1;
  input clk, load;
  input [n-1:0] in;
  output [n-1:0] out;
  reg [n-1:0] out;

  reg [n-1:0] D;

  always @(*) begin //this block checks the load input and accordingly changes the output
    case(load)
      1'b0: D= out; //when load is 0
      1'b1: D= in;  //when load is 1
      default: D= {n{1'bx}}; //detects errors
    endcase
  end

  always @(posedge clk)
    out <= D;
endmodule


//multiplexer
module Mux8(a7, a6, a5, a4, a3, a2, a1, a0, s, b) ;//s is select, b is output
  parameter k = 1 ;
  input [k-1:0] a7, a6, a5, a4, a3, a2, a1, a0;  // inputs
  input [7:0]   s ; // one-hot select
  output[k-1:0] b ;
  reg [k-1:0] b ;

  always @(*) begin
    case(s)
      8'b00000001: b = a0 ;
      8'b00000010: b = a1 ;
      8'b00000100: b = a2 ;
      8'b00001000: b = a3 ;
      8'b00010000: b = a4 ;
      8'b00100000: b = a5 ;
      8'b01000000: b = a6 ;
      8'b10000000: b = a7 ;
      default: b =  {k{1'bx}} ;
    endcase
  end
endmodule