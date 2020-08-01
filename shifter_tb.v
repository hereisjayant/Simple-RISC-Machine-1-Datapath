

module shifter_tb();

  reg [15:0] in;
  reg [1:0] shift;
  reg err;
  wire [15:0] sout;

  shifter DUT(in,shift,sout);

  initial begin
    err = 1'b0;//Sets the err signal to 0 initially
    in = 16'b1111_0000_1100_1111; // Input value to be tested
    #5;

  //Case 1: Do nothing shift = 2'b00
    $display("Do nothing: shift = 2'b00");
    shift = 2'b00; //Do nothing
    #5;
    if( sout !== 16'b1111_0000_1100_1111 ) begin
      $display("ERROR ** The sout is %b, expected %b", sout, 16'b1111_0000_1100_1111 );
      err = 1'b1;
    end

  //Case 2: B shifted left 1-bit, least significant bit is zero. shift = 2'b01
    $display("B shifted left 1-bit, least significant bit is zero. shift = 2'b01");
    shift = 2'b01;
    #5;
    if( sout !== 16'b1110_0001_1001_1110 ) begin
      $display("ERROR ** The sout is %b, expected %b", sout, 16'b1110_0001_1001_1110 );
      err = 1'b1;
    end

  //Case 3: B shifted right 1-bit, most significant bit, MSB, is 0. shift = 2'b10
    $display("B shifted right 1-bit, most significant bit, MSB, is 0. shift = 2'b10");
    shift = 2'b10;
    #5;
    if( sout !== 16'b0111_1000_0110_0111) begin
      $display("ERROR ** The sout is %b, expected %b", sout, 16'b0111_1000_0110_0111 );
      err = 1'b1;
    end

  //Case 4: B shifted right 1-bit, MSB is copy of B[15]. shift = 2'b11
    $display("B shifted right 1-bit, MSB is copy of B[15]. shift = 2'b11");
    shift = 2'b11;
    #5;
    if( sout !== 16'b1111_1000_0110_0111 ) begin
      $display("ERROR ** The sout is %b, expected %b", sout, 16'b1111_1000_0110_0111 );
      err = 1'b1;
    end

    if( ~err ) $display("*ALL THE TESTS HAVE BEEN PASSED*");
    $stop;

  end

endmodule
