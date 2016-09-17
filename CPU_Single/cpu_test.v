`timescale 1ns/1ns

module cpu_test;
reg clk=0,reset=1;
wire uartrx,uarttx;
// wire[7:0] ledout=8'h0,switch=8'h0;
// wire[11:0] digi=12'h0;
wire[7:0] ledout,switch;
wire[11:0] digi;

reg uartrx_r = 1;
assign uartrx = uartrx_r;

CPU_Single cpu(clk,reset,uartrx,uarttx,ledout,switch,digi);

initial begin
    forever #5  clk=~clk;
end

initial begin
	#3 reset=0;
	#2 reset=1; 

// First Test
    #500000 uartrx_r=1;
    #104160 uartrx_r=0;

    // 58: 00111010, (39)16
    #104160 uartrx_r=0;//1
    #104160 uartrx_r=1;//2
    #104160 uartrx_r=0;//3
    #104160 uartrx_r=1;//4
    #104160 uartrx_r=1;//5
    #104160 uartrx_r=1;//6
    #104160 uartrx_r=0;//7
    #104160 uartrx_r=0;//8

    #104160 uartrx_r=1;
    #104160 uartrx_r=0; 
    
    // 87: 01010111, (57)16
    #104160 uartrx_r=1;//1
    #104160 uartrx_r=1;//2
    #104160 uartrx_r=1;//3
    #104160 uartrx_r=0;//4
    #104160 uartrx_r=1;//5
    #104160 uartrx_r=0;//6
    #104160 uartrx_r=1;//7
    #104160 uartrx_r=0;//8

    // 58, 87 -> 29

    #104160 uartrx_r=1;
    #104160 uartrx_r=1;

// Second Test
    #500000 uartrx_r=1;
    #104160 uartrx_r=0;

    // 104: 01101000, (68)16
    #104160 uartrx_r=0;//1
    #104160 uartrx_r=0;//2
    #104160 uartrx_r=0;//3
    #104160 uartrx_r=1;//4
    #104160 uartrx_r=0;//5
    #104160 uartrx_r=1;//6
    #104160 uartrx_r=1;//7
    #104160 uartrx_r=0;//8

    #104160 uartrx_r=1;
    #104160 uartrx_r=0; 
    
    // 78: 01001110, (4E)16
    #104160 uartrx_r=0;//1
    #104160 uartrx_r=1;//2
    #104160 uartrx_r=1;//3
    #104160 uartrx_r=1;//4
    #104160 uartrx_r=0;//5
    #104160 uartrx_r=0;//6
    #104160 uartrx_r=1;//7
    #104160 uartrx_r=0;//8

    // 104, 78 -> 26

    #104160 uartrx_r=1;
    #104160 uartrx_r=1;



end

endmodule
