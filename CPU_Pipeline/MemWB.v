module MEM_WB(reset,clk,DataBusC,DataBusC_MEM_WB,RegWr_EX_EME,RegWr_MEM_WB,AddrC_EX_EME,AddrC_MEM_WB);
input reset,clk;
input [31:0]DataBusC;
output reg [31:0]DataBusC_MEM_WB;
input RegWr_EX_EME;
output reg RegWr_MEM_WB;
input [4:0]AddrC_EX_EME;
output reg [4:0]AddrC_MEM_WB;

always @(negedge reset or posedge clk)
begin
  if(~reset)
    begin
      DataBusC_MEM_WB<=32'b0;
      RegWr_MEM_WB<=0;
      AddrC_MEM_WB<=5'b0;
    end
  else
    begin
      DataBusC_MEM_WB<=DataBusC;
      RegWr_MEM_WB<=RegWr_EX_EME;
      AddrC_MEM_WB<=AddrC_EX_EME;
    end
  end
endmodule
