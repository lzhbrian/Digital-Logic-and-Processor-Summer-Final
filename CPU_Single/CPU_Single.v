`timescale 1ns/1ns
module CPU_Single(sysclk,reset,uartrx,uarttx,ledout,switch,digi);
	input sysclk,reset,uartrx;
	input[7:0] switch;
	output uarttx;
	output[7:0] ledout;
	output[11:0] digi; 
	wire[31:0] PCP4,EXT32,ConBA;
	wire[15:0] imm16;
	wire[30:0] PCin;
	reg[31:0] PC;
	wire[31:0] Instruction;
	wire IRQ,RegWr,Sign,MemWr,MemRd,ExtOp,LuOp;
  wire[5:0] ALUFun;
  wire[2:0] PCSrc;
  wire[1:0] RegDst,MemtoReg;
  wire[4:0] AddrC;
  wire[31:0] DataBusC;
  wire[31:0] DataBusA,DataBusB,Read_Data,ReadData1,ReadData2,ReadData3,ALUOut;
  wire ALUSrc1,ALUSrc2;
  wire[31:0] ALUin1,ALUin2;


  	wire clk;
	//clock_10_sys clock_10_sys_uut(sysclk,clk);
	assign clk = sysclk;


	assign imm16=Instruction[15:0];
	assign PCP4={PC[31],PC[30:0]+31'h4};
	assign EXT32=ExtOp?{{16{imm16[15]}},imm16}:{16'h0,imm16};
	assign ConBA = PCP4 + (EXT32<<2);
	
	always @(posedge clk, negedge reset) begin
	   if (~reset)
	     PC<=32'h80000000;
	   else begin
	     case (PCSrc)
	         3'h0: PC<=PCP4;
	         3'h1: PC<=ALUOut[0]?ConBA:PCP4;
	         3'h2: PC<={PC[31:28],Instruction[25:0],2'h0};
	         3'h3: PC<=DataBusA;
	         3'h4: PC<=32'h80000004;
	         3'h5: PC<=32'h80000008;
	         default:;
	     endcase
	   end
	   
	end
	  	
	assign PCin=PC[30:0];
	ROM rom(PCin,Instruction);
  
  
	Control con(Instruction, PC, IRQ, PCSrc, RegDst, RegWr, ALUSrc1, 
	   ALUSrc2, ALUFun, Sign, MemWr, MemRd, 
	   MemtoReg, ExtOp, LuOp);
	assign Read_Data = (ALUOut<=32'h000003FF)?ReadData1:
                   (ALUOut<=32'h40000014 && ALUOut>=32'h40000000)?ReadData2:
						 (ALUOut<=32'h40000023 && ALUOut>=32'h40000018)?ReadData3:32'b0;
						 
	assign AddrC=(RegDst==2'b11)?5'd26:((RegDst==2'b10)?5'd31:((RegDst==2'b01)?Instruction[20:16]:Instruction[15:11]));
	
	assign DataBusC=(MemtoReg[1]==1'b1)?PCP4:((MemtoReg[0]==1'b1)?Read_Data:ALUOut);
	
	assign ALUin1=(ALUSrc1==1'b1)?({27'h0,Instruction[10:6]}):DataBusA;
	assign ALUin2=(ALUSrc2==1'b1)?(LuOp?{imm16,16'h0}:EXT32):DataBusB;
	
	RegFile regfile(reset,clk,Instruction[25:21],DataBusA,Instruction[20:16],DataBusB,RegWr,AddrC,DataBusC);
	
	DataMem datamem(reset,clk,MemRd,MemWr,ALUOut,DataBusB,ReadData1);
	
	ALU alu(ALUin1,ALUin2,ALUFun,Sign,ALUOut);
	
	Peripheral peripheral(reset,clk,MemRd,MemWr,ALUOut,DataBusB,ReadData2,ledout,switch,digi,IRQ);

	UART uart(sysclk, clk, reset, MemRd, MemWr, ALUOut, DataBusB, ReadData3, uartrx, uarttx);


endmodule