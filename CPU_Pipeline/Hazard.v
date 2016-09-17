module Hazard(MemRd,Rt,Instruct,IF_ID_flush,PCWrite,PCSrc_ID_EX,ALUOut0,ID_EX_flush,PCSrc);
  input [2:0]PCSrc_ID_EX,PCSrc;
  input [31:0]Instruct;
  input [4:0]Rt;
  input MemRd,ALUOut0;
  output IF_ID_flush;
  output PCWrite;
  output ID_EX_flush;
  wire JR_Hazard;
  assign JR_Hazard=Instruction_IF_ID[31:26]==6'b000000&Instruction_IF_ID[5:1]==5'b00100&Rd_ID_EX==Instruction_IF_ID[25:21];
  assign IF_ID_flush=((PCSrc_ID_EX==3'b001)&&ALUOut0)||(PCSrc>3'b001)||(MemRd&&(Rt==Instruct[20:16]||Rt==Instruct[25:21])&&(Rt!=0));
  assign ID_EX_flush=(PCSrc_ID_EX==3'b001)&&ALUOut0||JR_Hazard;
  assign PCWrite=MemRd&&(Rt==Instruct[20:16]||Rt==Instruct[25:21])&&(Rt!=0)||JR_Hazard;
endmodule
