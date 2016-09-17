`timescale 1ns/1ns
module Control(Instruction, PC, IRQ2, PCSrc, RegDst, RegWr, 
	ALUSrc1, ALUSrc2, ALUFun, Sign, MemWr, MemRd, 
	MemtoReg, ExtOp, LuOp);
	output [2:0] PCSrc;
	output RegWr;
	output [1:0] RegDst;
	output MemRd;
	output MemWr;
	output Sign;
	output [1:0] MemtoReg;
	output [5:0] ALUFun;
	output ALUSrc1;
	output ALUSrc2;
	output ExtOp;
	output LuOp;
	input [31:0] Instruction;
	input IRQ2;
	input [31:0] PC;

	wire[5:0] OpCode, Funct;
	wire R,_lw,_sw,_lui,_addi,_andi,_sll,_slti,_beq,_j,_jal,_jr,_jalr,_ALU,_exp;
	wire i_nop,i_lw,i_sw,i_lui,i_add,i_addu,i_sub,i_subu,i_addi,i_addiu,i_and,i_or,i_xor,i_nor,i_andi,i_sll,i_srl,i_sra,i_slt,i_slti,i_sltiu,i_beq,i_bne,i_blez,i_bgtz,i_bltz,i_j,i_jal,i_jr,i_jalr;
  wire IRQ;
  
  //***************//
  assign IRQ=~PC[31]&IRQ2;
  //***************//
	assign OpCode = Instruction[31:26];
	assign Funct = Instruction[5:0];
	
	assign R=~OpCode[5]&~OpCode[4]&~OpCode[3]&~OpCode[2]&~OpCode[1]&~OpCode[0];

//**************//
	assign _exp=~PC[31]&~(i_lw|i_sw|i_lui|i_add|i_addu|i_sub|i_subu|i_addi|i_addiu|i_and|i_or|i_xor|i_nor|i_andi|i_sll|i_srl|i_sra|i_slt|i_slti|i_sltiu|i_beq|i_bne|i_blez|i_bgtz|i_bltz|i_j|i_jal|i_jr|i_jalr);
//**************//
	assign i_lw=OpCode[5]&~OpCode[4]&~OpCode[3]&~OpCode[2]&OpCode[1]&OpCode[0];
	assign i_sw=OpCode[5]&~OpCode[4]&OpCode[3]&~OpCode[2]&OpCode[1]&OpCode[0];
	assign i_lui=~OpCode[5]&~OpCode[4]&OpCode[3]&OpCode[2]&OpCode[1]&OpCode[0];
	assign i_add=R&(Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]);
	assign i_addu=R&(Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&Funct[0]);
	assign i_sub=R&(Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&Funct[1]&~Funct[0]);
	assign i_subu=R&(Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&Funct[1]&Funct[0]);
	assign i_addi=~OpCode[5]&~OpCode[4]&OpCode[3]&~OpCode[2]&~OpCode[1]&~OpCode[0];
	assign i_addiu=~OpCode[5]&~OpCode[4]&OpCode[3]&~OpCode[2]&~OpCode[1]&OpCode[0];
	assign i_and=R&(Funct[5]&~Funct[4]&~Funct[3]&Funct[2]&~Funct[1]&~Funct[0]);
	assign i_or=R&(Funct[5]&~Funct[4]&~Funct[3]&Funct[2]&~Funct[1]&Funct[0]);
	assign i_xor=R&(Funct[5]&~Funct[4]&~Funct[3]&Funct[2]&Funct[1]&~Funct[0]);
	assign i_nor=R&(Funct[5]&~Funct[4]&~Funct[3]&Funct[2]&Funct[1]&Funct[0]);
	assign i_andi=~OpCode[5]&~OpCode[4]&OpCode[3]&OpCode[2]&~OpCode[1]&~OpCode[0];
	assign i_sll=R&(~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]);
	assign i_srl=R&(~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&Funct[1]&~Funct[0]);
	assign i_sra=R&(~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&Funct[1]&Funct[0]);
	assign i_slt=R&(Funct[5]&~Funct[4]&Funct[3]&~Funct[2]&Funct[1]&~Funct[0]);
	assign i_slti=~OpCode[5]&~OpCode[4]&OpCode[3]&~OpCode[2]&OpCode[1]&~OpCode[0];
	assign i_sltiu=~OpCode[5]&~OpCode[4]&OpCode[3]&~OpCode[2]&OpCode[1]&OpCode[0];
	assign i_beq=~OpCode[5]&~OpCode[4]&~OpCode[3]&OpCode[2]&~OpCode[1]&~OpCode[0];
	assign i_bne=~OpCode[5]&~OpCode[4]&~OpCode[3]&OpCode[2]&~OpCode[1]&OpCode[0];
	assign i_blez=~OpCode[5]&~OpCode[4]&~OpCode[3]&OpCode[2]&OpCode[1]&~OpCode[0];
	assign i_bgtz=~OpCode[5]&~OpCode[4]&~OpCode[3]&OpCode[2]&OpCode[1]&OpCode[0];
	assign i_bltz=~OpCode[5]&~OpCode[4]&~OpCode[3]&~OpCode[2]&~OpCode[1]&OpCode[0];
	assign i_j=~OpCode[5]&~OpCode[4]&~OpCode[3]&~OpCode[2]&OpCode[1]&~OpCode[0];
	assign i_jal=~OpCode[5]&~OpCode[4]&~OpCode[3]&~OpCode[2]&OpCode[1]&OpCode[0];
	assign i_jr=R&(~Funct[5]&~Funct[4]&Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]);
	assign i_jalr=R&(~Funct[5]&~Funct[4]&Funct[3]&~Funct[2]&~Funct[1]&Funct[0]);

	assign _lw = (OpCode == 6'h23);
	assign _sw = (OpCode == 6'h2b);
	assign _lui = (OpCode == 6'h0f);
	assign _addi = (OpCode == 6'h08) | (OpCode == 6'h09);
	assign _andi = (OpCode == 6'h0c);
	assign _sll = (OpCode == 6'h00) & ((Funct == 6'h0) | (Funct == 6'h02) | (Funct == 6'h03));
	assign _slti = (OpCode == 6'h0a) | (OpCode == 6'h0b);
	assign _beq = (OpCode == 6'h04) | (OpCode == 6'h05) | (OpCode == 6'h06) | (OpCode == 6'h07) | (OpCode == 6'h01);
	assign _j = (OpCode == 6'h02);
	assign _jal = (OpCode == 6'h03);
	assign _jr = (OpCode == 6'h00) & (Funct == 6'h08);
	assign _jalr = (OpCode == 6'h00) & (Funct == 6'h09);
	assign _ALU = (OpCode == 6'h00) & ~(_sll | _jr | _jalr);

/**************/
//hzh version 如果发生中断（IRQ）时正好执行的是beq/jr/jal/jalr，就会被识别成exp
	// assign PCSrc[0]=(_beq|i_jr|i_jalr|_exp);
	// assign PCSrc[1]=(i_j|i_jal|i_jr|i_jalr);
	// assign PCSrc[2]=_exp|IRQ;
//my version
	assign PCSrc[0]=(_beq|i_jr|i_jalr|_exp) & ~IRQ;
	assign PCSrc[1]=(i_j|i_jal|i_jr|i_jalr) & ~IRQ & ~_exp;
	assign PCSrc[2]=_exp|IRQ;
/**************/

	assign RegWr = ~(_sw | _beq | _j | _jr) | IRQ | _exp;
	assign RegDst[0]=i_lw|i_lui|_addi|i_andi|_slti|_exp|IRQ;
	assign RegDst[1]=i_jal|i_jalr|_exp|IRQ;
	assign MemRd = _lw;
	assign MemWr = _sw;
	assign Sign = (_beq | _ALU | i_slti);
	assign MemtoReg[0]= _lw;
	assign MemtoReg[1]= _jal|_jalr|_exp|IRQ;
	assign ALUSrc1 = _sll;
	assign ALUSrc2 = (_lw|_sw|_lui|_addi|_andi|_slti);
	assign ExtOp = ~_andi;
	assign LuOp = _lui;
	
	assign ALUFun[0]=~(i_lw|i_sw|i_lui|i_add|i_addu|i_addi|i_addiu|i_and|i_or|i_xor|i_andi|i_sll);
	assign ALUFun[1]=(i_or|i_xor|i_sra|i_beq|i_bgtz);
	assign ALUFun[2]=(i_or|i_xor|i_slt|i_slti|i_sltiu|i_blez|i_bgtz|i_bltz);
	assign ALUFun[3]=(i_and|i_or|i_andi|i_blez|i_bgtz);
	assign ALUFun[4]=(i_and|i_or|i_xor|i_nor|i_andi|i_slt|i_slti|i_sltiu|i_beq|i_bne|i_blez|i_bgtz|i_bltz);
	assign ALUFun[5]=(i_sll|i_srl|i_sra|i_slt|i_slti|i_sltiu|i_beq|i_bne|i_blez|i_bgtz|i_bltz);
	
	
endmodule