////////////////////////////////////////////////////////////////////////
// TESTBENCH =>  TOP MODULE FOR MIPS multicycle OPERATION
////////////////////////////////////////////////////////////////////////

//`timescale 1ns/1ns

module MIPS_multicycle_tb;

reg clk_tb, rst_tb;
integer i;

MIPS_multicycle UUT (.clk(clk_tb), .rst(rst_tb));


initial begin

    clk_tb = 0;//initialize clock
    rst_tb = 1;//activate reset
    #2;

    rst_tb = 0;//deactivate reset
    #1080;
  
  
  for (i=0; i <32; i=i+1) begin
    $display("------------------------------------------------------------------------------------");
    $display("PC=%d :: REG MEMORY=>%d :: DATA MEMORY=>%d", i, UUT.MIPS_register_file.reg_mem[i], UUT.MIPS_data_memory.mem[i]);
  end
  
    $finish();
end

always forever #1 clk_tb = ~clk_tb;

initial begin
  	$dumpvars(3, MIPS_multicycle_tb);
    $dumpfile("dump.vcd");
end

endmodule