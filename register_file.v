module register_file(
	input clk,
	input regWrite,
	input [4:0] readReg1, readReg2, writeReg,
	input [31:0] writeData,
	output [31:0] readData1, readData2
	);
	
  reg [31:0] reg_mem [31:0]; //32 registers of 32 bits
  
/*-------------------- Initialize all registers in 0-----------------*/
  initial begin
    $readmemb("regMem.txt",reg_mem);	
  end
  
/*-------------------- Save one register   --------------------------*/
  
  always @ (posedge clk) begin               
    if(regWrite) begin
      reg_mem[writeReg] = writeData;
      //$writememb("regMem.txt", reg_mem);
    end
  end  
  
/*---------------------- Read the 2 registers------------------------*/
  
  assign readData1 = reg_mem[readReg1];
  assign readData2 = reg_mem[readReg2];

endmodule