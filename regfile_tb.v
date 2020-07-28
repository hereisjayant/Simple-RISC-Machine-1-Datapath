module regfile_tbc();

    //Ins/Outs
  reg [15:0] data_in;
  reg [2:0] writenum, readnum;
  reg write, clk;
  wire [15:0] data_out;

  //clock
  initial begin
    KEY[0] = 1; #5; //the clock starts with a 0 i.e. equivalent to 1 here
    forever begin
      KEY[0] = 0; #5;
      KEY[0] = 1; #5;
    end
  end
