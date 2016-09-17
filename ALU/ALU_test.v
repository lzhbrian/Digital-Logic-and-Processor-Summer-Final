module ALU_tb;

wire signed [31:0] Z;           // Output
reg signed [31:0] A = 0, B = 0; // Op1, Op2
wire [31:0] uA = A, uB = B;     // Unsigned A, B.
reg [5:0] ALUFun = 0;           // ALU Function Code 
reg Sign = 1;                   // Signed Op or not

ALU ALU_t(
    .Z     (Z),
    .A     (A),
    .B     (B),
    .ALUFun(ALUFun),
    .Sign  (Sign)
);

initial begin

// Add, Sub
    $display("\nAdd/Sub\n");

    A = 15; // 1111
    B = 12; // 1100

    // ADD
    ALUFun = 6'b000000; // Expected 27
    #5 $display("ADD: S = A + B\nALUFun: %b", ALUFun);
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B);
    
    // SUB
    ALUFun = 6'b000001; // Expected 3
    $display("SUB: S = A - B\nALUFun: %b", ALUFun);
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B);



// Logic
    $display("\n\nLogic\n");

    A = 15; // 1111
    B = 12; // 1100

    // AND
    ALUFun = 6'b011000; // Expected 1100 = 12
    $display("AND: S = A & B\nALUFun: %b", ALUFun);
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B);

    // OR
    ALUFun = 6'b011110; // Expected 1111 = 15
    $display("OR: S = A | B\nALUFun: %b", ALUFun);
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B);

    // XOR
    ALUFun = 6'b010110; // Expected 0011 = 3
    $display("XOR: S = A ^ B\nALUFun: %b", ALUFun);
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B);

    // NOR
    ALUFun = 6'b010001; // Expected 111....1110000 = -16
    $display("NOR: S = ~(A | B)\nALUFun: %b", ALUFun);
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B);

    // S = A
    ALUFun = 6'b011010; // Expected 1111 = 15
    $display("\"A\": S = A\nALUFun: %b", ALUFun);
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B);



//Shift
    $display("\n\nShift\n");

    A = 2;
    B = 15; // 1111

    // SLL
    ALUFun = 6'b100000;
    $display("SLL: S = B << A[4:0]\nALUFun: %b", ALUFun);
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // Expected 111100 = 60

    // SRL
    ALUFun = 6'b100001; 
    $display("SRL: S = B >> A[4:0]\nALUFun: %b", ALUFun);
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // Expected 11 = 3
    A = 3;  
    B = -1; // 111...11
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // Expected 000111...111 = 536870911

    // SRA
    ALUFun = 6'b100011;
    $display("SRA: S = B >> A[4:0]\nALUFun: %b", ALUFun);
    A = 3;
    B = 10; // 1010
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // Expected 1
    A = 3;  
    B = -1; // 111...111
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // Expected -1



// Compare

    $display("\n\nCompare\n");

    // EQ
    ALUFun = 6'b110011;
    $display("EQ: if (A == B) S = 1 else S = 0\nALUFun: %b", ALUFun);
    A = 1;
    B = 1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 1
    A = 1;
    B = 0;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0
    A = 0;
    B = 1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0

    // NEQ
    ALUFun = 6'b110001;
    $display("NEQ: if (A != B) S = 1 else S = 0\nALUFun: %b", ALUFun);
    A = 1;
    B = 1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0
    A = 1;
    B = 0;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 1
    A = 0;
    B = 1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 1

    // LT
    ALUFun = 6'b110101;
    $display("LT: if (A < B) S = 1 else S = 0\nALUFun: %b", ALUFun);
    A = 1;
    B = 1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0
    A = 1;
    B = 0;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0
    A = 0;
    B = 1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 1

    // Unsigned LT
    Sign = 0;
    ALUFun = 6'b110101;
    $display("Unsigned LT: if (A < B) S = 1 else S = 0\nALUFun: %b", ALUFun);
    A = 1;
    B = -1;
    #5 $display("    Z: %d, A:  %d, B: %d", Z, uA, uB); // 1
    A = 1;
    B = 0;
    #5 $display("    Z: %d, A:  %d, B: %d", Z, uA, uB); // 0
    A = 1;
    B = (1'b1 << 31) + (1'b1 << 30);
    #5 $display("    Z: %d, A:  %d, B: %d", Z, uA, uB); // 1

    // LEZ
    Sign = 1;
    ALUFun = 6'b111101;
    $display("LEZ: if (A <= 0) S = 1 else S = 0\nALUFun: %b", ALUFun);
    B = 0;
    A = -1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 1
    A = 1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0
    A = 0;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 1

    // LTZ
    ALUFun = 6'b111011;
    $display("LTZ: if (A < 0) S = 1 else S = 0\nALUFun: %b", ALUFun);
    A = -1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 1
    A = 1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0
    A = 0;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0

    // GTZ
    ALUFun = 6'b111111;
    $display("GTZ: if (A > 0) S = 1 else S = 0\nALUFun: %b", ALUFun);
    A = -1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0
    A = 1;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 1
    A = 0;
    #5 $display("    Z: %d, A: %d, B: %d", Z, A, B); // 0

end
endmodule

