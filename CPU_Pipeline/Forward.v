module Forward(AddrC_EX_MEM,AddrC_MEM_WB,Rs_ID_EX,Rt_ID_EX,ForwardA,ForwardB,RegWr_EX_MEM,RegWr_MEM_WB);
input RegWr_EX_MEM,RegWr_MEM_WB;
input [4:0]AddrC_EX_MEM,AddrC_MEM_WB,Rs_ID_EX,Rt_ID_EX;
output reg [1:0]ForwardA;
output reg [1:0]ForwardB;
always @(*)
  begin
    if((AddrC_EX_MEM!=0)&&(AddrC_EX_MEM==Rs_ID_EX)&&RegWr_EX_MEM)
      ForwardA=2'b10;//从EX_MEM转发
    else begin
      if((AddrC_MEM_WB!=0)&&(AddrC_MEM_WB==Rs_ID_EX)&&RegWr_MEM_WB)
        ForwardA=2'b01;//从MEM_WB转发
      else
        ForwardA=2'b00;//正常
      end
      end
always @(*)
  begin
    if((AddrC_EX_MEM!=0)&&(AddrC_EX_MEM==Rt_ID_EX)&&RegWr_EX_MEM)
      ForwardB=2'b10;//从EX_MEM转发
    else begin
      if((AddrC_MEM_WB!=0)&&(AddrC_MEM_WB==Rt_ID_EX)&&RegWr_MEM_WB)
        ForwardB=2'b01;//从MEM_WB转发
      else
        ForwardB=2'b00;//正常
      end  
    end    
endmodule
