 module ID_EX (reset,clk,Rs,Rs_ID_EX,Rd,Rd_ID_EX,Rt,Rt_ID_EX,DatabusA,DatabusA_ID_EX,DatabusB,DatabusB_ID_EX,PC_IF_ID,PC_ID_EX,RegDst,RegDst_ID_EX,ALUSrc1,ALUSrc1_ID_EX,ALUSrc2,ALUSrc2_ID_EX,ALUFun,ALUFun_ID_EX,Sign,Sign_ID_EX,MemRd,MemRd_ID_EX,MemWr,MemWr_ID_EX,MemToReg,MemToReg_ID_EX,RegWr,RegWr_ID_EX,shamt,shamt_ID_EX,imm32,imm32_ID_EX,PCSrc,PCSrc_ID_EX,JT,JT_ID_EX,ID_EX_flush);

input reset,clk,ID_EX_flush,ALUSrc2,ALUSrc1,Sign,MemRd,MemWr,RegWr;
input [4:0] Rs,Rd,Rt,shamt;
input [31:0] DatabusB,DatabusA,PC_IF_ID,imm32;
input [1:0] RegDst,MemToReg;
input [5:0] ALUFun;
input [2:0] PCSrc;
input [25:0] JT;

output reg ALUSrc2_ID_EX,ALUSrc1_ID_EX,Sign_ID_EX,MemRd_ID_EX,MemWr_ID_EX,RegWr_ID_EX;
output reg [4:0] Rs_ID_EX,Rd_ID_EX,Rt_ID_EX,shamt_ID_EX;
output reg [31:0] DatabusB_ID_EX,DatabusA_ID_EX,PC_ID_EX,imm32_ID_EX;
output reg [1:0] RegDst_ID_EX,MemToReg_ID_EX;
output reg [5:0] ALUFun_ID_EX;
output reg [2:0] PCSrc_ID_EX;
output reg [25:0] JT_ID_EX;

always @(posedge clk or negedge reset) begin
  if (~reset) begin
    Rs_ID_EX<= 5'b0;
    Rd_ID_EX<= 5'b0;
    Rt_ID_EX<= 5'b0;
    shamt_ID_EX<= 5'b0;
    ALUSrc2_ID_EX<=0;
    ALUSrc1_ID_EX<=0;
    Sign_ID_EX<=0;
    MemRd_ID_EX<=0;
    MemWr_ID_EX<=0;
    RegWr_ID_EX<=0;
    DatabusB_ID_EX<=32'b0;
    DatabusA_ID_EX<=32'b0;
    PC_ID_EX<=32'b0;
    imm32_ID_EX<=32'b0;
    RegDst_ID_EX<=2'b0;
    MemToReg_ID_EX<=2'b0;
    ALUFun_ID_EX<=6'b0;
    PCSrc_ID_EX<=3'b0;
    JT_ID_EX<=26'b0;
  end
  else if (ID_EX_flush)
begin
        Rs_ID_EX<= 5'b0;
    Rd_ID_EX<= 5'b0;
    Rt_ID_EX<= 5'b0;
    shamt_ID_EX<= 5'b0;
    ALUSrc2_ID_EX<=0;
    ALUSrc1_ID_EX<=0;
    Sign_ID_EX<=0;
    MemRd_ID_EX<=0;
    MemWr_ID_EX<=0;
    RegWr_ID_EX<=0;
    DatabusB_ID_EX<=32'b0;
    DatabusA_ID_EX<=32'b0;
    PC_ID_EX<=32'b0;
    imm32_ID_EX<=32'b0;
    RegDst_ID_EX<=2'b0;
    MemToReg_ID_EX<=2'b0;
    ALUFun_ID_EX<=6'b0;
    PCSrc_ID_EX<=3'b0;
    JT_ID_EX<=26'b0;
end

  else begin
    Rs_ID_EX<= Rs;
    Rd_ID_EX<= Rd;
    Rt_ID_EX<= Rt;
    shamt_ID_EX<= shamt;
    ALUSrc2_ID_EX<=ALUSrc2;
    ALUSrc1_ID_EX<=ALUSrc1;
    Sign_ID_EX<=Sign;
    MemRd_ID_EX<=MemRd;
    MemWr_ID_EX<=MemWr;
    RegWr_ID_EX<=RegWr;
    DatabusB_ID_EX<=DatabusB;
    DatabusA_ID_EX<=DatabusA;
    PC_ID_EX<=PC_IF_ID;
    imm32_ID_EX<=imm32;
    RegDst_ID_EX<=RegDst;
    MemToReg_ID_EX<=MemToReg;
    ALUFun_ID_EX<=ALUFun;
    PCSrc_ID_EX<=PCSrc;
    JT_ID_EX<=JT;
  end
end
endmodule