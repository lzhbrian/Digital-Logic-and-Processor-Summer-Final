	# 
	# Add/Sub
	# 
	# ADD: S = A + B
	# ALUFun: 000000
	#     Z:          27, A:          15, B:          12
	# SUB: S = A - B
	# ALUFun: 000001
	#     Z:           3, A:          15, B:          12
	# 
	# 
	# Logic
	# 
	# AND: S = A & B
	# ALUFun: 011000
	#     Z:          12, A:          15, B:          12
	# OR: S = A | B
	# ALUFun: 011110
	#     Z:          15, A:          15, B:          12
	# XOR: S = A ^ B
	# ALUFun: 010110
	#     Z:           3, A:          15, B:          12
	# NOR: S = ~(A | B)
	# ALUFun: 010001
	#     Z:         -16, A:          15, B:          12
	# "A": S = A
	# ALUFun: 011010
	#     Z:          15, A:          15, B:          12
	# 
	# 
	# Shift
	# 
	# SLL: S = B << A[4:0]
	# ALUFun: 100000
	#     Z:          60, A:           2, B:          15
	# SRL: S = B >> A[4:0]
	# ALUFun: 100001
	#     Z:           3, A:           2, B:          15
	#     Z:   536870911, A:           3, B:          -1
	# SRA: S = B >> A[4:0]
	# ALUFun: 100011
	#     Z:           1, A:           3, B:          10
	#     Z:          -1, A:           3, B:          -1
	# 
	# 
	# Compare
	# 
	# EQ: if (A == B) S = 1 else S = 0
	# ALUFun: 110011
	#     Z:           1, A:           1, B:           1
	#     Z:           0, A:           1, B:           0
	#     Z:           0, A:           0, B:           1
	# NEQ: if (A != B) S = 1 else S = 0
	# ALUFun: 110001
	#     Z:           0, A:           1, B:           1
	#     Z:           1, A:           1, B:           0
	#     Z:           1, A:           0, B:           1
	# LT: if (A < B) S = 1 else S = 0
	# ALUFun: 110101
	#     Z:           0, A:           1, B:           1
	#     Z:           0, A:           1, B:           0
	#     Z:           1, A:           0, B:           1
	# Unsigned LT: if (A < B) S = 1 else S = 0
	# ALUFun: 110101
	#     Z:           1, A:           1, B: 4294967295
	#     Z:           0, A:           1, B:          0
	#     Z:           1, A:           1, B: 3221225472
	# LEZ: if (A <= 0) S = 1 else S = 0
	# ALUFun: 111101
	#     Z:           1, A:          -1, B:           0
	#     Z:           0, A:           1, B:           0
	#     Z:           1, A:           0, B:           0
	# LTZ: if (A < 0) S = 1 else S = 0
	# ALUFun: 111011
	#     Z:           1, A:          -1, B:           0
	#     Z:           0, A:           1, B:           0
	#     Z:           0, A:           0, B:           0
	# GTZ: if (A > 0) S = 1 else S = 0
	# ALUFun: 111111
	#     Z:           0, A:          -1, B:           0
	#     Z:           1, A:           1, B:           0
	#     Z:           0, A:           0, B:           0
