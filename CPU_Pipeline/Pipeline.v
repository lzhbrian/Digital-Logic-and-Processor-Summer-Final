module top(reset,sysclk,led,switch,digi,uart_rx,uart_tx);
  input reset,sysclk,uart_rx;
  input [7:0]switch;
  output [7:0]led;
  output [11:0]digi;
  output uart_tx;  
  wire clk;

  assign clk=sysclk;
  reg [31:0] PC;
  wire [31:0]PC_IF_ID,PC_ID_OUT,PC_ID_EX,PC_EX_MEM,PC_MEM_WB,ConBA,
  ConBA_EX_MEM,DatabusA,DatabusA_ID_EX,DatabusB,DatabusB_ID_EX,DatabusB_EX_OUT,DatabusB_EX_MEM,
  Instruction,Instruction_IF_ID,imm32,imm32_ID_EX,PCNext,ReadData1,ReadData2,ReadData3;
  wire [2:0]PCSrc,PCSrc_ID_EX,PCSrc_EX_MEM;//
  wire IRQ;
  wire [1:0]RegDst,RegDst_ID_EX,MemToReg,MemToReg_ID_EX,MemToReg_EX_MEM,MemToReg_MEM_WB;
  wire [5:0]ALUFun,ALUFun_ID_EX;
  wire RegWr,RegWr_ID_EX,RegWr_EX_MEM,RegWr_MEM_WB,ALUSrc1,ALUSrc1_ID_EX,ALUSrc2,ALUSrc2_ID_EX,
  Sign,Sign_ID_EX,MemWr,MemWr_ID_EX,MemWr_EX_MEM,MemRd,MemRd_ID_EX,MemRd_EX_MEM,EXTOp,LUOp;
  wire [4:0]AddrC,AddrC_EX_MEM,AddrC_MEM_WB;
  wire [31:0]ALUin1,ALUin2,ALUOut,ALUOut_EX_MEM,ALUOut_MEM_WB,ReadMemData,ReadMemData_MEM_WB,
  DataBusC,DataBusC_MEM_WB;
  wire [25:0]JT,JT_ID_EX;
  wire [15:0]imm16;
  wire [4:0]shamt,shamt_ID_EX,Rd,Rd_ID_EX,Rt,Rt_ID_EX,Rs,Rs_ID_EX;
  wire [1:0]forwardA,forwardB;
  wire IF_ID_Flush,newIF_ID_Flush;
  wire ID_EX_Flush,newID_EX_Flush,PCWrite,KU_State;
  wire [6:0] Opcode,Funct;//
    
  Hazard hazard(MemRd,Rt,Instruction,IF_ID_Flush,PCWrite,PCSrc_ID_EX,ALUOut[0],ID_EX_Flush,PCSrc);

  //IF
  assign  PCNext=(PCSrc==3'b100)?32'h80000004:
          (PCSrc==3'b101)?32'h80000008:
          (PCSrc_ID_EX==3'b001&ALUOut[0])?ConBA:
          (PCSrc==3'b010)?{PC[31:28],JT,2'b0}:
          (PCSrc==3'b011)?DatabusA:(PCWrite?PC:PC+4);
 // PC pc(reset,clk,PC,PCNext);//register
always @(negedge reset or posedge clk)
      PC<=(~reset)?32'b00000000:PCNext;


  ROM Instructionion_memory(PC[30:0],Instruction);
  //IF_ID
  IF_ID IF_ID(reset,clk,Instruction,Instruction_IF_ID,PC,PC_IF_ID,IF_ID_Flush);//register
  //ID
  assign Opcode=Instruction_IF_ID[31:26];
  assign Funct=Instructino_IF_ID[5:0];
  assign Rd=Instruction_IF_ID[15:11];
  assign Rt=Instruction_IF_ID[20:16];
  assign Rs=Instruction_IF_ID[25:21];
  assign JT=Instruction_IF_ID[25:0];
  assign imm16=Instruction_IF_ID[15:0];
  assign shamt=Instruction_IF_ID[10:6];
  assign KU_State = PC[31];
  Control control(Opcode,Funct,IRQ,KU_State,PCSrc,
    RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);              
  RegisterFile rf(reset,clk,RegWr_MEM_WB,Rs,Rt,AddrC_MEM_WB,DataBusC_MEM_WB,DatabusA,DatabusB);//register
  assign imm32=LUOp?{imm16,16'b0}:{{16{~EXTOp&imm16[15]}},imm16};
  assign PC_ID_OUT=(PCSrc[2]&(Instruction_IF_ID==32'b0))?PC:(PCSrc[2]&(PCSrc_ID_EX==3'b001)&ALUOut[0])?PCNext:PC_IF_ID;
  //ID_EX
  ID_EX ID_EX(reset,clk,Rs,Rs_ID_EX,Rd,Rd_ID_EX,Rt,Rt_ID_EX,DatabusA,DatabusA_ID_EX,DatabusB,
    DatabusB_ID_EX,PC_ID_OUT,PC_ID_EX,RegDst,RegDst_ID_EX,ALUSrc1,ALUSrc1_ID_EX,ALUSrc2,
    ALUSrc2_ID_EX,ALUFun,ALUFun_ID_EX,Sign,Sign_ID_EX,MemRd,MemRd_ID_EX,MemWr,MemWr_ID_EX,MemToReg,
    MemToReg_ID_EX,RegWr,RegWr_ID_EX,shamt,shamt_ID_EX,imm32,imm32_ID_EX,PCSrc,PCSrc_ID_EX,JT,JT_ID_EX,
    ID_EX_Flush);
  //EX
  Forward forward(AddrC_EX_MEM,AddrC_MEM_WB,Rs_ID_EX,Rt_ID_EX,forwardA,forwardB,RegWr_EX_MEM,
    RegWr_MEM_WB);
  assign ConBA=PC_ID_EX+32'b100+{imm32_ID_EX[29:0],2'b00};
  assign AddrC=(RegDst_ID_EX==2'b00)?Rd_ID_EX:
               (RegDst_ID_EX==2'b01)?Rt_ID_EX:
               (RegDst_ID_EX==2'b10)?5'b11111:5'b11010;
  assign ALUin1=ALUSrc1_ID_EX?{27'b0,shamt_ID_EX}:
                (forwardA==2'b00)?DatabusA_ID_EX:
                (forwardA==2'b01)?DataBusC_MEM_WB:ALUOut_EX_MEM;
  assign ALUin2=ALUSrc2_ID_EX?imm32_ID_EX:
                (forwardB==2'b00)?DatabusB_ID_EX:
                (forwardB==2'b01)?DataBusC_MEM_WB:ALUOut_EX_MEM;
  assign DatabusB_EX_OUT=(forwardB==2'b00)?DatabusB_ID_EX:
                (forwardB==2'b01)?DataBusC_MEM_WB:ALUOut_EX_MEM;

  ALU alu(ALUin1,ALUin2,ALUFun_ID_EX,Sign_ID_EX,ALUOut);
  //EX_MEM
  EX_MEM EX_MEM(reset,clk,AddrC,AddrC_EX_MEM,MemRd_ID_EX,MemRd_EX_MEM,MemWr_ID_EX,MemWr_EX_MEM,
  DatabusB_EX_OUT,DatabusB_EX_MEM,ALUOut,ALUOut_EX_MEM,RegWr_ID_EX,RegWr_EX_MEM,MemToReg_ID_EX,
  MemToReg_EX_MEM,PC_ID_EX,PC_EX_MEM,PCSrc_ID_EX,PCSrc_EX_MEM,ConBA,ConBA_EX_MEM);
  //Mem
  DataMem DataMem(reset,clk,MemRd_EX_MEM,MemWr_EX_MEM,ALUOut_EX_MEM,DatabusB_EX_MEM,ReadData1);
  Peripheral pf(reset,clk,MemRd_EX_MEM,MemWr_EX_MEM,ALUOut_EX_MEM,DatabusB_EX_MEM,ReadData2,led,switch,digi,IRQ);
  UART uart_ctl(sysclk,clk,reset,MemRd_EX_MEM,MemWr_EX_MEM,ALUOut_EX_MEM,DatabusB_EX_MEM,ReadData3,uart_rx,uart_tx);
  assign ReadMemData=(ALUOut_EX_MEM<32'h000003FF)?ReadData1:(ALUOut_EX_MEM<=32'h40000014 && ALUOut_EX_MEM>=32'h40000000)?ReadData2:(ALUOut_EX_MEM<=32'h40000023 && ALUOut_EX_MEM>=32'h40000018)?ReadData3:32'b0;
  assign DataBusC=(MemToReg_EX_MEM==2'b00)?ALUOut_EX_MEM:(MemToReg_EX_MEM==2'b01)?ReadMemData:(MemToReg_EX_MEM==2'b10)?PC_EX_MEM+32'b100:PC_EX_MEM;
  
  //MEM_WB
  MEM_WB MEM_WB(reset,clk,DataBusC,DataBusC_MEM_WB,RegWr_EX_MEM,RegWr_MEM_WB,AddrC_EX_MEM,
    AddrC_MEM_WB);
  
  //WB
  
  endmodule
  
