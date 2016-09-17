module IF_ID (reset,clk,Instruction,Instruction_IF_ID,PC,PC_IF_ID,IF_ID_flush);
input reset,clk,IF_ID_flush;
input [31:0] Instruction,PC;
output reg [31:0] Instruction_IF_ID,PC_IF_ID;

always @(posedge clk or negedge reset) begin
  if (~reset) begin
    Instruction_IF_ID <= 32'b0;
    PC_IF_ID <= 32'b0;    
  end
  else if (IF_ID_flush)
  begin
  	Instruction_IF_ID <= 32'b0;
    PC_IF_ID <= 32'b0;  
  end

  else begin
    Instruction_IF_ID <= Instruction;
    PC_IF_ID <= PC;
  end
end

endmodule
