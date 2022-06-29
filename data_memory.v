module data_memory (

	input clk,
  	input [31:0] address,
	input memWrite,
	input [31:0] writeData, 
	
	output [31:0] readData
	);
	
  reg [31:0] mem[0:255]; //32 bits memory with 256 entries

	initial begin
      $readmemb("data_mem.txt", mem);//***ESCRITURA
	end
	
	always @ (posedge clk) begin
	
      	if (memWrite) begin
          mem[address] = writeData;
      		//$writememb("data_mem.txt", mem);
        end
	end
	
	
  assign readData = mem[address];
	
endmodule