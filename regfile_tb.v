//NOTE: This is how you write to the register file
//  1. Put the data you want to write on the input bus (data_in)
//  2. Put the register number on writenum (NOTE: only 3 bits!)
//  3. When clk goes high, the data is written



module regfile_tb();

    //Ins/Outs
  reg [15:0] data_in;
  reg [2:0] writenum, readnum;
  reg write, clk;
  reg err; // This siganl tests for errors
  wire [15:0] data_out;

  regfile dut(data_in,writenum,write,readnum,clk,data_out); //creating a module

  //clock
  initial begin
    clk = 0; #5; //the clock starts with a 0
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
  end

  initial begin
  //setting readnum to xxx to catch errors
    readnum = 3'bxxx;

  //Test 1: storing the number 5 in R0
    //the data_in has the value 5
    data_in = 16'd5;
    //selecting R0
    writenum = 3'b000;
    //turning on write
    write = 1'b1;
    //setting error to zero initially
    err = 1'b0;
    //waiting for 10 time steps, for the clock to rise and store 5 in R0
    #10;

    // check whether the expected value has been written to R0
    $display("Writing 5 to R0");

//-----------------------------------------------

  //Test 2: storing the number 7 in R1
    //the data_in has the value 7
    data_in = 16'd7;
    //selecting R1
    writenum = 3'b001;
    //turning on write
    write = 1'b1;
   //waiting for 10 time steps, for the clock to rise and store 7 in R1
    #10;

    // check whether the expected value has been written to R1
    $display("Writing 7 to R1");

//-----------------------------------------------

  //Test 3: storing the number 12 in R7
    //the data_in has the value 7
    data_in = 16'd12;
    //selecting R1
    writenum = 3'b111;
    //turning on write
    write = 1'b1;
    //waiting for 10 time steps, for the clock to rise and store 12 in R7
    #10;

    // check whether the expected value has been written to R7
    $display("Writing 12 to R7");

//-----------------------------------------------

  //Test 4: trying to update a value in R1 with write OFF
    //turning OFF write
    write = 1'b0;
    //the data_in has the value 3
    data_in = 16'd3;
    //selecting R1
    writenum = 3'b001;
    //waiting for 10 time steps, for the clock to rise and store 12 in R7
    #10;

    // check whether the expected value has not been written to R1
    $display("Not writing 3 to R1");

//-----------------------------------------------

  //Now reading from the different register files:

    //Reading R0
    readnum = 3'b000;
    #10;
    if( data_out !== 16'd5 ) begin
       $display("ERROR ** The data_out is %b, expected %b", data_out, 16'b00000000_00000101 );
       err = 1'b1;
    end


    //Reading R1
    readnum = 3'b001;
    #10;
    if( data_out !== 16'd7 ) begin
      $display("ERROR ** The data_out is %b, expected %b", data_out, 16'b00000000_00000111 );
      err = 1'b1;
    end


    //Reading R7
    readnum = 3'b111;
    #10;
    if( data_out !== 16'd12 ) begin
      $display("ERROR ** The data_out is %b, expected %b", data_out, 16'b00000000_00001100 );
      err = 1'b1;
    end



    if( ~err ) $display("*ALL THE TESTS HAVE BEEN PASSED*");
    $stop;
    end

endmodule
