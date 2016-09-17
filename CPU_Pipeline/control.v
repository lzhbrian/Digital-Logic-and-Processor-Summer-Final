module Control(Opcode,Funct,IRQ,PCWatch,PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);
input [5:0]Opcode;
input [5:0]Funct;
input IRQ,PCWatch;
output [5:0]ALUFun;
output [2:0]PCSrc;
output [1:0]RegDst,MemToReg;
output RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
wire R,ArithR,Shamt,ArithI,Branch,J,JR,JAL,Mem,SLT,XADR,OR_XOR;
//Current State
assign R=Opcode==6'b000000;
assign ArithR=R&(Funct[5:3]==3'b100);
assign Shamt=R&(Funct[5:2]==4'b0000)&~(~Funct[1]&Funct[0]);
assign Branch=(Opcode[5:3]==3'b0)&(Opcode[2]|(Opcode[0]&~Opcode[1]));
assign J=(Opcode[5:2]==4'b0)&Opcode[1];
assign JR=R&(Funct[5:0]==5'b001000);
assign ArithI=Opcode[5:0]==6'b000001;
assign JAL=(J&Opcode[0])|(JR&Funct[0]);
assign Mem=(Opcode[5:4]==2'b10)&(Opcode[2:0]==3'b011);
assign SLT=(R&(Funct[5:1]==5'b10101))|(ArithI&~Opcode[2]&&Opcode[1]);
assign XADR=~(PCWatch|Shamt|Branch|J|ArithI|JR|Mem|ArithR|SLT);
assign Break=~PCWatch&IRQ;
//Output
assign ALUFun[5]=Shamt|Branch| SLT;
assign ALUFun[4]=Branch|SLT|(R&Funct[2])|EXTOp;
assign ALUFun[3]=(R&Funct[2]&~Funct[1])|(EXTOp&~Opcode[1])|(Branch&(Opcode[2:0]==3'b001|Opcode[2:1]==2'b11));
assign ALUFun[2]=OR_XOR|SLT|(Branch&Opcode[2]&Opcode[1]);
assign ALUFun[1]=OR_XOR|(Shamt&Funct[0])|(Branch&(Opcode[2]^Opcode[1]^Opcode[0]));
assign ALUFun[0]=Branch|SLT|(R&Funct[1]&~OR_XOR);
assign RegDst[1]=JAL|PCSrc[2];
assign RegDst[0]=ArithI|Mem|PCSrc[2];
assign EXTOp=ArithI&Opcode[2]&~LUOp;
assign LUOp=ArithI&(Opcode[2:0]==3'b111);
assign ALUSrc1=Shamt;
assign ALUSrc2=ArithI|Mem;
assign PCSrc[2]=Break|XADR;
assign PCSrc[1]=~PCSrc[2]&(J|JR);
assign PCSrc[0]=(Branch|JR|XADR)&~Break;
assign MemWr=Mem&Opcode[3];
assign MemRd=Mem&~Opcode[3];
assign MemToReg[1]=PCSrc[2]|JAL;
assign MemToReg[0]=PCSrc[2]|MemRd;
assign RegWr=~((J|JR)|MemWr|~JAL&Branch);
assign Sign=(R&~Funct[0])|(~R&~Opcode[0])|Mem|Branch;
assign OR_XOR=(R&Funct[2]&(Funct[1]^Funct[0]))|(EXTOp&(Opcode[1]^Opcode[0]));

endmodule
