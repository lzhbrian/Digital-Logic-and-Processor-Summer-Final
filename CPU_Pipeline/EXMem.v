 module EX_MEM(reset,clk,AddrC,AddrC_EX_MEM,MemRd_ID_EX,MemRd_EX_MEM,MemWr_ID_EX,MemWr_EX_MEM,DatabusB_ID_EX,DatabusB_EX_MEM,ALUOut,ALUOut_EX_MEM,RegWr_ID_EX,RegWr_EX_MEM,MemToReg_ID_EX,MemToReg_EX_MEM,PCNew_ID_EX,PCNew_EX_MEM,PCSrc_ID_EX,PCSrc_EX_MEM,ConBA,ConBA_EX_MEM);
input reset,clk;
input [4:0]AddrC;
input MemRd_ID_EX,MemWr_ID_EX,RegWr_ID_EX;
input [31:0]DatabusB_ID_EX,ALUOut,PCNew_ID_EX,ConBA;
input [1:0]MemToReg_ID_EX;
input [2:0]PCSrc_ID_EX;
output reg[4:0]AddrC_EX_MEM;
output reg MemRd_EX_MEM,MemWr_EX_MEM,RegWr_EX_MEM;
output reg [31:0]DatabusB_EX_MEM,ALUOut_EX_MEM,PCNew_EX_MEM,ConBA_EX_MEM;
output reg [1:0]MemToReg_EX_MEM;
output reg[2:0]PCSrc_EX_MEM;
always @(negedge reset or posedge clk)
begin
  if(~reset)
    begin
      AddrC_EX_MEM<=5'b0;
      MemRd_EX_MEM<=0;
      MemWr_EX_MEM<=0;
      RegWr_EX_MEM<=0;
      DatabusB_EX_MEM<=32'b0;
      ALUOut_EX_MEM<=32'b0;
      PCNew_EX_MEM<=32'b0;
      MemToReg_EX_MEM<=2'b0;
      PCSrc_EX_MEM<=3'b0;
      ConBA_EX_MEM<=32'b0;
    end
  else
    begin
      AddrC_EX_MEM<=AddrC;
      MemRd_EX_MEM<=MemRd_ID_EX;
      MemWr_EX_MEM<=MemWr_ID_EX;
      RegWr_EX_MEM<=RegWr_ID_EX;
      DatabusB_EX_MEM<=DatabusB_ID_EX;
      ALUOut_EX_MEM<=ALUOut;
      PCNew_EX_MEM<=PCNew_ID_EX;
      MemToReg_EX_MEM<=MemToReg_ID_EX;
      PCSrc_EX_MEM<=PCSrc_ID_EX;
      ConBA_EX_MEM<=ConBA;
    end
  end
endmodule
