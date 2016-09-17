// -*- coding:utf-8 -*-  
// Created by Lin, Tzu-Heng
// Created on 2016.6.24 15:40
// All rights reserved

module ALU(
	input [31:0] A,			// Op 1
	input [31:0] B,			// Op 2
	input [5:0] ALUFun,		// Function Code
	input Sign,		 		// Sign
	output reg [31:0] Z 	// Output
);
wire Zero;		// Zero
wire V; 		// Overflow
wire N; 		// Negative
wire [31:0] add_o;		//Adder output
wire [31:0] cmp_o;		//Compare output 
wire [31:0] logic_o;	//Logic output
wire [31:0] shift_o;	//Shift output
Add add_t(
	.A		(A),
	.B		(B),
	.ctrl	(ALUFun[0]),
	.Sign	(Sign),
	.Zero	(Zero),
	.V		(V),
	.N		(N),
	.add_o	(add_o)
);
Cmp cmp_t(
	.Zero	(Zero),
	.V		(V),
	.N		(N),
	.ctrl	(ALUFun[3:1]),
	.cmp_o	(cmp_o)
);
Logic logic_t(
	.A		(A),
	.B		(B), 
	.ctrl	(ALUFun[3:0]),
	.logic_o(logic_o)
);
Shift shift_t(
	.A		(A),
	.B		(B),
	.ctrl	(ALUFun[1:0]),
	.shift_o(shift_o)
);
// The last 4:1 MUX
always @(*) begin
	case (ALUFun[5:4])
		2'b00 : Z = add_o;
		2'b11 : Z = cmp_o;
		2'b01 : Z = logic_o;
		2'b10 : Z = shift_o;
		default : Z = 0;
	endcase
end
endmodule





// Add OK
module Add(
	input [31:0] A,		// Op 1
	input [31:0] B,		// Op 2
	input ctrl,			// Control 
	input Sign,			// Unsigned or not
	output Zero,		// Zero
	output V,			// Overflow
	output N,			// Negative
	output [31:0] add_o	// Output
);
// Extend to 33 bits
wire [32:0] A_t = A + 32'b0;									// Extended 33 bits A
wire [32:0] B_t = ctrl ? (~(B + 32'b0) + 1'b1) : (B + 32'b0);	// Extended 33 bits B
wire [32:0] add_o_t = A_t + B_t;								// Extended 33 bits A + B

assign add_o = add_o_t[31:0];						// A + B
assign Zero = (add_o_t == 0);						// Zero
assign V = Sign ? 
			( (~A[31] & ~B_t[31] & add_o[31]) 
				| (A_t[31] & B_t[31] & ~add_o[31]) )// Signed : 正＋正＝负， or 负＋负＝正
			: ( add_o_t[32] ) ; 					// Unsigned
assign N = Sign ? 
			( (add_o[31] & ~V) | (~add_o[31] & V) ) // Signed : 负符号位 & 没溢出 ｜ 正符号位 & 溢出
			: (ctrl & V);  							// Unsigned : 减法 & 溢出
endmodule




// Compare OK
module Cmp(
	input Zero,
	input V,
	input N,
	input [3:1] ctrl,
	output reg [31:0] cmp_o
);
always @(*) begin
	cmp_o[31:1] = 31'b0; 
	case (ctrl)
		3'b001 : cmp_o[0] = Zero ; 			// EQ  A == B
		3'b000 : cmp_o[0] = ~Zero;			// NEQ A != B
		3'b010 : cmp_o[0] = N; 				// LT  A < B
		3'b110 : cmp_o[0] = N | Zero;		// LEZ A <= 0
		3'b101 : cmp_o[0] = N;				// LTZ A < 0
		3'b111 : cmp_o[0] = ~(N | Zero);	// GTZ A > 0
		default: cmp_o[0] = 1'b0;			// else
	endcase
end
endmodule




// Logic OK
module Logic(
	input [31:0] A,
	input [31:0] B, 
	input [3:0] ctrl,
	output reg [31:0] logic_o
);
always @(*) begin
	case (ctrl)
		4'b1000 : logic_o = A & B;		// A & B
		4'b1110 : logic_o = A | B;		// A | B
		4'b0110 : logic_o = A ^ B;		// A ^ B
		4'b0001 : logic_o = ~ (A | B);	// ~(A | B)
		4'b1010 : logic_o = A;			// A
		default : logic_o = 32'b0;		// else
	endcase
end
endmodule





// Shift OK
module Shift(
	input [31:0] A,
	input [31:0] B,
	input [1:0] ctrl,
	output [31:0] shift_o
);
wire [31:0] out_16, out_8, out_4, out_2;

// 16、8、4、2、1 bits Shifts
Shift_splited #(.amount(16)) shift_16(.in_put(B),.ctrl(ctrl),.enable(A[4]),.out_put(out_16));
Shift_splited #(.amount(8)) shift_8(.in_put(out_16),.ctrl(ctrl),.enable(A[3]),.out_put(out_8));
Shift_splited #(.amount(4)) shift_4(.in_put(out_8),.ctrl(ctrl),.enable(A[2]),.out_put(out_4));
Shift_splited #(.amount(2)) shift_2(.in_put(out_4),.ctrl(ctrl),.enable(A[1]),.out_put(out_2));
Shift_splited #(.amount(1)) shift_1(.in_put(out_2),.ctrl(ctrl),.enable(A[0]),.out_put(shift_o));
endmodule





// 16, 8, 4, 2, 1 bits Shifts OK
module Shift_splited
#(
	parameter amount = 1
)
(
	input [31:0] in_put,
	input [1:0] ctrl,
	input enable,
	output reg [31:0] out_put
);
wire signed [31:0] signed_in_put = in_put;
always @(*) begin
	if (enable) begin
		case(ctrl)
			2'b00 : out_put = in_put << amount; 		// SLL 100000 S = B <<A[4:0]
			2'b01 : out_put = in_put >> amount; 		// SRL 100001 S = B >>A[4:0]
			2'b11 : out_put = signed_in_put >>> amount; // SRA 100011 S = B >>a[4:0] arithmetic shift
			default : out_put = in_put;
		endcase
	end
	else begin
		out_put = in_put;	
	end
end
endmodule



