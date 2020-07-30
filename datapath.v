

module datapath(datapath_in,  //input to datapath

                writenum,  //inputs to register file
                write,
                readnum,
                clk,

                loada,  //pipeline registers a & b
                loadb,

                shift,  //input to shifter unit

                asel,   //source opperand multiplexers
                bsel,

                ALUop,  //ALU input

                loadc,  //pipeline c
                loads,  //status register

                Z_out,  //status output
                datapath_out); //datapath output

//-------------------------------------------------------------

  //inputs and outputs

    input [15:0] datapath_in;  //input to datapath

    input [2:0] writenum;  //inputs to register file
    input write;
    input [2:0] readnum;
    input clk;

    input loada;  //pipeline registers a & b
    input loadb;

    input [1:0] shift; //input to shifter unit

    input asel;   //source opperand multiplexers
    input bsel;

    input [1:0] ALUop;  //ALU input

    input loadc;  //pipeline c
    input loads; //status register

    output Z_out;  //status output
    output [15:0] datapath_out; //datapath output

//--------------------------------------------------------------

  //Wires

    //into the regfile
    wire [15:0] data_in;
    //out of regfile
    wire [15:0] data_out;

    //wires into ALU
    wire[15:0] Ain, Bin;
    //wires out of the ALU
    wire Z;
    wire[15:0]out;

    //wire into shifter
    wire [15:0] in;
    //wire out of shifter
    wire [15:0] sout;

//------------------------------------------------------------------

    //instantiating the main datapath Modules
    regfile REGFILE(data_in,writenum,write,readnum,clk,data_out);

    ALU alu(Ain,Bin,ALUop,out,Z);

    shifter SHIFTER(in,shift,sout);

    
