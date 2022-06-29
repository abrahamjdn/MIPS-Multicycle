module MIPS_multicycle (input clk, rst);

/*---------------------Define internal nets---------------------*/

wire    [31:0]  PC_w, PCNext_w, Inst_w, InstLatched_w,
                Reg1_w, Reg1Latched_w, Reg2_w, Reg2Latched_w,
                SignE_w, SrcA_w, SrcB_w, ALUResult_w, ALUOut_w,
                DataM_w, DataMLatched_w, RegWD_w;

wire    [4:0]   RegWA_w;
wire    [3:0]   ALU_Ctl_w;
wire    [1:0]   ALUSrcB_w, PCSrc_w;

wire            MemtoReg_w, RegDst_w, ALUSrcA_w,
                IRWrite_w, MemWrite_w, PCWrite_w, BEQ_w, BNE_w,
                RegWrite_w, PCEn_w, zero_w;


/*---------------------Module instantiatons---------------------*/

/////////// INSTRUCTIONS MEMORY ///////////
inst_mem MIPS_inst_mem (
        .address(PC_w),
        .inst(Inst_w)
);
/////////// FILE REGISTER ///////////
register_file MIPS_register_file (
        .clk(clk),
        .regWrite(RegWrite_w),
        .readReg1(InstLatched_w[25:21]),
        .readReg2(InstLatched_w[20:16]),
        .writeReg(RegWA_w),
        .writeData(RegWD_w),
        .readData1(Reg1_w),
        .readData2(Reg2_w)
);
/////////// ALU OPERATIONS ///////////
ALU MIPS_ALU (
        .ALU_Ctl(ALU_Ctl_w),
        .A(SrcA_w),
        .B(SrcB_w),
        .ALUOut(ALUResult_w),
        .Zero(zero_w)
);
/////////// DATA MEMORY ///////////
data_memory MIPS_data_memory (
        .clk(clk),
        .address(ALUOut_w),
        .memWrite(MemWrite_w),
        .writeData(Reg2Latched_w),
        .readData(DataM_w)
);
/////////// SIGN EXTENDER ///////////
SignExt MIPS_SignExt (
        .data_in(InstLatched_w[15:0]),
        .data_out(SignE_w)
);
/////////// BRANCH DECODER ///////////
branch_decoder MIPS_branch_decoder (
        .beq(BEQ_w),
        .bne(BNE_w),
        .pcwrite(PCWrite_w),
        .zero(zero_w),
        .ctrl(PCEn_w)
);
/////////// CONTROL UNIT ///////////
control_unit MIPS_control_unit (
        .clk(clk),
        .rst(rst),
        .Opcode(InstLatched_w[31:26]),
        .Funct(InstLatched_w[5:0]),
        .MemtoReg(MemtoReg_w),
        .RegDst(RegDst_w),
        .ALUSrcA(ALUSrcA_w),
        .ALUSrcB(ALUSrcB_w),
        .PCSrc(PCSrc_w),
        .IRWrite(IRWrite_w),
        .MemWrite(MemWrite_w),
        .PCWrite(PCWrite_w),
        .BEQ(BEQ_w),
        .BNE(BNE_w),
        .RegWrite(RegWrite_w),
        .ALU_Ctl(ALU_Ctl_w)
);

/*-------------------------Multiplexers-------------------------*/

/////////// MUX RegDst /////////// 
mux2to1 #(.WORD_LENGTH(5)) MIPS_mux_RegDst (
        .sel(RegDst_w),
        .Data_0(InstLatched_w[20:16]),
        .Data_1(InstLatched_w[15:11]),
        .Mux_Output(RegWA_w)
);
/////////// MUX MemtoReg///////////
mux2to1 MIPS_mux_MemtoReg(
        .sel(MemtoReg_w),
        .Data_0(ALUOut_w),
        .Data_1(DataMLatched_w),
        .Mux_Output(RegWD_w)
);
/////////// MUX ALUSrcA ///////////
mux2to1 MIPS_mux_ALUSrcA(
        .sel(ALUSrcA_w),
        .Data_0(PC_w),
        .Data_1(Reg1Latched_w),
        .Mux_Output(SrcA_w)
);
/////////// MUX ALUSrcB ///////////
mux3to1 MIPS_mux_ALUSrcB(
        .sel(ALUSrcB_w),
        .Data_0(Reg2Latched_w),
        .Data_1(32'd1),
        .Data_2(SignE_w),
        .Mux_Output(SrcB_w)
);
/////////// MUX PCSrc ///////////
mux3to1 MIPS_mux_PCSrc(
        .sel(PCSrc_w),
        .Data_0(ALUResult_w),
        .Data_1(ALUOut_w),
        .Data_2({PC_w[31:26], InstLatched_w[25:0]}),
        .Mux_Output(PCNext_w)
);

/*---------------------------Latches----------------------------*/

/////////// LATCH PC ///////////
latch_ MIPS_latch_PC(
        .clk(clk),
        .rst(rst),
        .en(PCEn_w),
        .in(PCNext_w),
        .out(PC_w)
);
/////////// LATCH INSTRUCTIONS ///////////
latch_ MIPS_latch_Inst(
        .clk(clk),
        .rst(rst),
        .en(IRWrite_w),
        .in(Inst_w),
        .out(InstLatched_w)
);
/////////// LATCH DATA ///////////
latch_ MIPS_latch_Data(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .in(DataM_w),
        .out(DataMLatched_w)
);
/////////// LATCH RD1 ///////////
latch_ MIPS_latch_RD1(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .in(Reg1_w),
        .out(Reg1Latched_w)
);
/////////// LATCH RD2 ///////////
latch_ MIPS_latch_RD2(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .in(Reg2_w),
        .out(Reg2Latched_w)
);
/////////// LATCH ALU///////////
latch_ MIPS_latch_ALU(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .in(ALUResult_w),
        .out(ALUOut_w)
);

endmodule