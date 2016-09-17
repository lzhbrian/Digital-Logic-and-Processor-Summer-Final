`timescale 1ns/1ps

module ROM (addr,Instruction);
input [30:0] addr;
output [31:0] Instruction;
reg [31:0] Instruction;
localparam ROM_SIZE = 32;
reg [31:0] ROM_DATA[ROM_SIZE-1:0];

always@(*)
	case(addr[9:2])	//Address Must Be Word Aligned.

// // 100000 for 50MHz
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -100000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h7960};
// 				//addi $t0, $t0, -100000	# $t1 = 0xFFFFFFFF - 100000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h7960};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};


// // 50000 for 100MHz gcd成功，digi失败
// 	//j Begin			# 复位态
// 	8'h00:    Instruction <= {6'h02, 26'h0000003};
// 		//j Timer			# 定时器中断
// 	8'h01:    Instruction <= {6'h02, 26'h0000039};
// 		//j Nop			# 未定义指令异常
// 	8'h02:    Instruction <= {6'h02, 26'h000009a};
// 		//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 	8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 		//addi $t6,$t6,65535	# 0x7FFFFFFF
// 	8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 		//jal getaddr1
// 	8'h05:    Instruction <= {6'h03, 26'h0000006};
// 		//addi $t7,$ra,12  	# 3 lines after
// 	8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 		//and $t6,$t7,$t6 	# 让第一位变成0
// 	8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 		//jr  $t6         	# set MSF of $PC to 0 and continue
// 	8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 		//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 	8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 		//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 	8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 		//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 	8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 		//sw $zero, 8($s1)	 	# TCON = 0
// 	8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 		//addi $t0, $s0, -50000
// 	8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h3cb0};
// 		//addi $t0, $t0, -50000	# $t1 = 0xFFFFFFFF - 50000
// 	8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h3cb0};
// 		//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 	8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 		//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 	8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 		//addi $t1, $zero, 3
// 	8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 		//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 	8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 		//sw $zero,  12($s1)
// 	8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 		//sw $s0, 20($s1)
// 	8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 		//addi $t0, $zero, 3
// 	8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 		//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 	8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 		//add $s2, $zero, $zero
// 	8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 		//lw $t0, 32($s1) 	# 18 读取UART_CON
// 	8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 		//addi $t1, $zero, 8 	# 01000
// 	8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 		//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 	8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 		//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 	8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 		//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 	8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 		//bgtz $s2, Calc		# 已收到两个数，分支
// 	8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 		//lw $a0, 28($s1)		# 读取UART_RXD
// 	8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 		//addi $s2, $s2, 1	# 设置一个flag
// 	8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 		//j Poll
// 	8'h20:    Instruction <= {6'h02, 26'h0000018};
// 		//lw $a1, 28($s1)		# 读取UART_RXD
// 	8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 		//add $s2, $zero, $zero
// 	8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 		//jal GCD
// 	8'h23:    Instruction <= {6'h03, 26'h000002c};
// 		//sw $v0, 12($s1)		# led显示结果
// 	8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 		//lw $t0, 32($s1)		# 检查UART发送器状态
// 	8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 		//addi $t1, $zero, 16 # 10000
// 	8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 		//and $t2, $t0, $t1	# 读取发送模块状态位
// 	8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 		//srl $t2, $t2, 4	
// 	8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 		//bne $t2, $zero, Loop# 发送器忙时阻塞
// 	8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 		//sw $v0, 24($s1)
// 	8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 		//j Poll				# 开始下一次轮询
// 	8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 		//add $t0, $a0, $zero
// 	8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 		//add $t1, $a1, $zero
// 	8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 		//sub $t2, $t0, $t1
// 	8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 		//blez $t2, Break
// 	8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 		//add $t0, $t2, $zero
// 	8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 		//j Mod
// 	8'h31:    Instruction <= {6'h02, 26'h000002e};
// 		//beq $t2, $zero, EXIT_GCD
// 	8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 		//add $t2, $t0, $zero
// 	8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 		//add $t0, $t1, $zero
// 	8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 		//add $t1, $t2, $zero
// 	8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 		//j Mod
// 	8'h36:    Instruction <= {6'h02, 26'h000002e};
// 		//add $v0, $t1, $zero
// 	8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 		//jr $ra
// 	8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 		//lw $t8, 8($s1)		# 读TCON
// 	8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 		//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 	8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 		//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 	8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 		//sw	$t9, 8($s1)
// 	8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 		//sw $t0, 0($sp)
// 	8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 		//sw $t1, 4($sp)
// 	8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 		//sw $t2, 8($sp)
// 	8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 		//sw $t3, 12($sp)
// 	8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 		//sw $t4, 16($sp)
// 	8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 		//sw $t5, 20($sp)
// 	8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 		//addi $sp, $sp, 20
// 	8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 		//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 	8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 		//srl $t0, $t0, 8		# 获取AN3~AN0值
// 	8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 		//addi $t1, $zero, 7 	# 0111
// 	8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 		//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 	8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 		//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 	8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 		//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 	8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 		//addi $t1, $zero, 11 # 1011
// 	8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 		//addi $t2, $zero, 13	# 1101
// 	8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 		//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 	8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 		//srl $t3, $t3, 4
// 	8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 		//beq $t0, $t1, Decode
// 	8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 		//addi $t1, $zero, 13	# 1101
// 	8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 		//addi $t2, $zero, 14	# 1110
// 	8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 		//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 	8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 		//beq	$t0, $t1, Decode
// 	8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 		//addi $t2, $zero, 7	# 0111
// 	8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 		//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 	8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 		//srl $t3, $t3, 4
// 	8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 		//addi $t5, $zero, 192	# 0xC0
// 	8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 		//beq $t3, $zero, Next	# 0
// 	8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 		//addi $t4, $zero, 1
// 	8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 		//addi $t5, $zero, 249	# 0xF9
// 	8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 		//beq $t3, $t4, Next		# 1
// 	8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 		//addi $t4, $zero, 2
// 	8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 		//addi $t5, $zero, 164	# 0xA4
// 	8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 		//beq $t3, $t4, Next		# 2
// 	8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 		//addi $t4, $zero, 3
// 	8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 		//addi $t5, $zero, 176	# 0xB0
// 	8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 		//beq $t3, $t4, Next		# 3
// 	8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 		//addi $t4, $zero, 4
// 	8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 		//addi $t5, $zero, 153	# 0x99
// 	8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 		//beq $t3, $t4, Next		# 4
// 	8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 		//addi $t4, $zero, 5
// 	8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 		//addi $t5, $zero, 146	# 0x92
// 	8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 		//beq $t3, $t4, Next		# 5
// 	8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 		//addi $t4, $zero, 6
// 	8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 		//addi $t5, $zero, 130	# 0x82
// 	8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 		//beq $t3, $t4, Next		# 6
// 	8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 		//addi $t4, $zero, 7
// 	8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 		//addi $t5, $zero, 248	# 0xF8
// 	8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 		//beq $t3, $t4, Next		# 7
// 	8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 		//addi $t4, $zero, 8
// 	8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 		//addi $t5, $zero, 128	# 0x80
// 	8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 		//beq $t3, $t4, Next		# 8
// 	8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 		//addi $t4, $zero, 9
// 	8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 		//addi $t5, $zero, 144	# 0x90
// 	8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 		//beq $t3, $t4, Next		# 9
// 	8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 		//addi $t4, $zero, 10
// 	8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 		//addi $t5, $zero, 136	# 0x88
// 	8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 		//beq $t3, $t4, Next		# A
// 	8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 		//addi $t4, $zero, 11
// 	8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 		//addi $t5, $zero, 131	# 0x83
// 	8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 		//beq $t3, $t4, Next		# B
// 	8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 		//addi $t4, $zero, 12
// 	8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 		//addi $t5, $zero, 198	# 0xC6
// 	8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 		//beq $t3, $t4, Next		# C
// 	8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 		//addi $t4, $zero, 13
// 	8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 		//addi $t5, $zero, 161	# 0xA1
// 	8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 		//beq $t3, $t4, Next		# D
// 	8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 		//addi $t4, $zero, 14
// 	8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 		//addi $t5, $zero, 134	# 0x86
// 	8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 		//beq $t3, $t4, Next		# E
// 	8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 		//addi $t5, $zero, 142	# 0x8E
// 	8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 		//sll $t2, $t2, 8
// 	8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 		//add $t0, $t2, $t5
// 	8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 		//sw $t0, 20($s1)
// 	8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 		//lw $t5, 0($sp)
// 	8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 		//lw $t4, -4($sp)
// 	8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 		//lw $t3, -8($sp)
// 	8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 		//lw $t2, -12($sp)
// 	8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 		//lw $t1, -16($sp)
// 	8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 		//lw $t0, -20($sp)
// 	8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 		//addi $sp, $sp, -20
// 	8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 		//lw $t8, 8($s1)		# 读TCON
// 	8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 		//addi $t9, $zero, 2	# $t1 = 0x00000002
// 	8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 		//or $t9, $t8, $t9 	# TCON | =0x00000002
// 	8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 		//sw	$t9, 8($s1)
// 	8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 		//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 	8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 		//addi $t6,$t6,65535	# 0x7FFFFFFF
// 	8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 		//jal getaddr2
// 	8'h93:    Instruction <= {6'h03, 26'h0000094};
// 		//addi $t7,$ra,12  	# 3 lines after
// 	8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 		//and $t6,$t7,$t6 	# 让第一位变成0
// 	8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 		//jr  $t6         	# set MSF of $PC to 0 and continue
// 	8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 		//addi $t7,$zero,4
// 	8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 		//sub $k0,$k0,$t7
// 	8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 		//jr $k0
// 	8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 		//sll $zero, $zero, 0
// 	8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 5000 for 10MHz

// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -5000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'hec78};
// 				//addi $t0, $t0, -5000	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'hec78};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};
// // 80000
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -80000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'hc780};
// 				//addi $t0, $t0, -80000	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'hc780};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 70000
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -70000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'hee90};
// 				//addi $t0, $t0, -70000	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'hee90};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 25000
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -25000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h9e58};
// 				//addi $t0, $t0, -25000	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h9e58};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 10000
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -10000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'hd8f0};
// 				//addi $t0, $t0, -10000	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'hd8f0};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// 30000 gcd失败，digi 成功
			//j Begin			# 复位态
			8'h00:    Instruction <= {6'h02, 26'h0000003};
				//j Timer			# 定时器中断
			8'h01:    Instruction <= {6'h02, 26'h0000039};
				//j Nop			# 未定义指令异常
			8'h02:    Instruction <= {6'h02, 26'h000009a};
				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
				//addi $t6,$t6,65535	# 0x7FFFFFFF
			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
				//jal getaddr1
			8'h05:    Instruction <= {6'h03, 26'h0000006};
				//addi $t7,$ra,12  	# 3 lines after
			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
				//and $t6,$t7,$t6 	# 让第一位变成0
			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
				//jr  $t6         	# set MSF of $PC to 0 and continue
			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
				//sw $zero, 8($s1)	 	# TCON = 0
			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
				//addi $t0, $s0, -30000
			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h8ad0};
				//addi $t0, $t0, -30000	# $t1 = 0xFFFFFFFF - 50000
			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h8ad0};
				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
				//addi $t1, $zero, 3
			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
				//sw $zero,  12($s1)
			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
				//sw $s0, 20($s1)
			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
				//addi $t0, $zero, 3
			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
				//add $s2, $zero, $zero
			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
				//lw $t0, 32($s1) 	# 18 读取UART_CON
			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
				//addi $t1, $zero, 8 	# 01000
			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
				//bgtz $s2, Calc		# 已收到两个数，分支
			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
				//lw $a0, 28($s1)		# 读取UART_RXD
			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
				//addi $s2, $s2, 1	# 设置一个flag
			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
				//j Poll
			8'h20:    Instruction <= {6'h02, 26'h0000018};
				//lw $a1, 28($s1)		# 读取UART_RXD
			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
				//add $s2, $zero, $zero
			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
				//jal GCD
			8'h23:    Instruction <= {6'h03, 26'h000002c};
				//sw $v0, 12($s1)		# led显示结果
			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
				//lw $t0, 32($s1)		# 检查UART发送器状态
			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
				//addi $t1, $zero, 16 # 10000
			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
				//and $t2, $t0, $t1	# 读取发送模块状态位
			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
				//srl $t2, $t2, 4	
			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
				//bne $t2, $zero, Loop# 发送器忙时阻塞
			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
				//sw $v0, 24($s1)
			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
				//j Poll				# 开始下一次轮询
			8'h2b:    Instruction <= {6'h02, 26'h0000018};
				//add $t0, $a0, $zero
			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
				//add $t1, $a1, $zero
			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
				//sub $t2, $t0, $t1
			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
				//blez $t2, Break
			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
				//add $t0, $t2, $zero
			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
				//j Mod
			8'h31:    Instruction <= {6'h02, 26'h000002e};
				//beq $t2, $zero, EXIT_GCD
			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
				//add $t2, $t0, $zero
			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
				//add $t0, $t1, $zero
			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
				//add $t1, $t2, $zero
			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
				//j Mod
			8'h36:    Instruction <= {6'h02, 26'h000002e};
				//add $v0, $t1, $zero
			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
				//jr $ra
			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
				//lw $t8, 8($s1)		# 读TCON
			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
				//sw	$t9, 8($s1)
			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
				//sw $t0, 0($sp)
			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
				//sw $t1, 4($sp)
			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
				//sw $t2, 8($sp)
			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
				//sw $t3, 12($sp)
			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
				//sw $t4, 16($sp)
			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
				//sw $t5, 20($sp)
			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
				//addi $sp, $sp, 20
			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
				//srl $t0, $t0, 8		# 获取AN3~AN0值
			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
				//addi $t1, $zero, 7 	# 0111
			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
				//addi $t1, $zero, 11 # 1011
			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
				//addi $t2, $zero, 13	# 1101
			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
				//srl $t3, $t3, 4
			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
				//beq $t0, $t1, Decode
			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
				//addi $t1, $zero, 13	# 1101
			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
				//addi $t2, $zero, 14	# 1110
			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
				//beq	$t0, $t1, Decode
			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
				//addi $t2, $zero, 7	# 0111
			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
				//srl $t3, $t3, 4
			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
				//addi $t5, $zero, 192	# 0xC0
			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
				//beq $t3, $zero, Next	# 0
			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
				//addi $t4, $zero, 1
			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
				//addi $t5, $zero, 249	# 0xF9
			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
				//beq $t3, $t4, Next		# 1
			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
				//addi $t4, $zero, 2
			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
				//addi $t5, $zero, 164	# 0xA4
			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
				//beq $t3, $t4, Next		# 2
			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
				//addi $t4, $zero, 3
			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
				//addi $t5, $zero, 176	# 0xB0
			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
				//beq $t3, $t4, Next		# 3
			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
				//addi $t4, $zero, 4
			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
				//addi $t5, $zero, 153	# 0x99
			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
				//beq $t3, $t4, Next		# 4
			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
				//addi $t4, $zero, 5
			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
				//addi $t5, $zero, 146	# 0x92
			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
				//beq $t3, $t4, Next		# 5
			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
				//addi $t4, $zero, 6
			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
				//addi $t5, $zero, 130	# 0x82
			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
				//beq $t3, $t4, Next		# 6
			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
				//addi $t4, $zero, 7
			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
				//addi $t5, $zero, 248	# 0xF8
			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
				//beq $t3, $t4, Next		# 7
			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
				//addi $t4, $zero, 8
			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
				//addi $t5, $zero, 128	# 0x80
			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
				//beq $t3, $t4, Next		# 8
			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
				//addi $t4, $zero, 9
			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
				//addi $t5, $zero, 144	# 0x90
			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
				//beq $t3, $t4, Next		# 9
			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
				//addi $t4, $zero, 10
			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
				//addi $t5, $zero, 136	# 0x88
			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
				//beq $t3, $t4, Next		# A
			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
				//addi $t4, $zero, 11
			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
				//addi $t5, $zero, 131	# 0x83
			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
				//beq $t3, $t4, Next		# B
			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
				//addi $t4, $zero, 12
			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
				//addi $t5, $zero, 198	# 0xC6
			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
				//beq $t3, $t4, Next		# C
			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
				//addi $t4, $zero, 13
			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
				//addi $t5, $zero, 161	# 0xA1
			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
				//beq $t3, $t4, Next		# D
			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
				//addi $t4, $zero, 14
			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
				//addi $t5, $zero, 134	# 0x86
			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
				//beq $t3, $t4, Next		# E
			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
				//addi $t5, $zero, 142	# 0x8E
			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
				//sll $t2, $t2, 8
			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
				//add $t0, $t2, $t5
			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
				//sw $t0, 20($s1)
			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
				//lw $t5, 0($sp)
			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
				//lw $t4, -4($sp)
			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
				//lw $t3, -8($sp)
			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
				//lw $t2, -12($sp)
			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
				//lw $t1, -16($sp)
			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
				//lw $t0, -20($sp)
			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
				//addi $sp, $sp, -20
			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
				//lw $t8, 8($s1)		# 读TCON
			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
				//addi $t9, $zero, 2	# $t1 = 0x00000002
			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
				//or $t9, $t8, $t9 	# TCON | =0x00000002
			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
				//sw	$t9, 8($s1)
			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
				//addi $t6,$t6,65535	# 0x7FFFFFFF
			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
				//jal getaddr2
			8'h93:    Instruction <= {6'h03, 26'h0000094};
				//addi $t7,$ra,12  	# 3 lines after
			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
				//and $t6,$t7,$t6 	# 让第一位变成0
			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
				//jr  $t6         	# set MSF of $PC to 0 and continue
			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
				//addi $t7,$zero,4
			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
				//sub $k0,$k0,$t7
			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
				//jr $k0
			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
				//sll $zero, $zero, 0
			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00}; 

// // 40000 gcd 成功，digi失败
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -40000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h63c0};
// 				//addi $t0, $t0, -40000	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h63c0};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 35000 gcd 成功，digi失败
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -35000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h7748};
// 				//addi $t0, $t0, -35000	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h7748};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00}; 

// // 32000 gcd失败，digi成功 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h8300};
// 				//addi $t0, $t0, -32000	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h8300};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 33000 gcd成功，digi失败 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -33000
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h7f18};
// 				//addi $t0, $t0, -33000	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h7f18};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32500 gcd失败，digi成功 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32500
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h810c};
// 				//addi $t0, $t0, -32500	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h810c};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32700 gcd失败，digi成功 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32700
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h8044};
// 				//addi $t0, $t0, -32700	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h8044};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32850 gcd成功，digi失败 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32850
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h7fae};
// 				//addi $t0, $t0, -32850	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h7fae};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32775 gcd成功，digi失败 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32775
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h7ff9};
// 				//addi $t0, $t0, -32775	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h7ff9};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32730 gcd失败，digi成功 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32730
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h8026};
// 				//addi $t0, $t0, -32730	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h8026};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32750 gcd失败，digi成功 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32750
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h8012};
// 				//addi $t0, $t0, -32750	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h8012};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32767 gcd失败，digi成功 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32767
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h8001};
// 				//addi $t0, $t0, -32767	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h8001};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32770 gcd成功，digi失败 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32770
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h7ffe};
// 				//addi $t0, $t0, -32770	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h7ffe};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32768 
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32768
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h8000};
// 				//addi $t0, $t0, -32768	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h8000};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32769
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h000009a};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32769
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h7fff};
// 				//addi $t0, $t0, -32769	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h7fff};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//addi $t7,$zero,4
// 			8'h97:    Instruction <= {6'h08, 5'd00, 5'd15, 16'h0004};
// 				//sub $k0,$k0,$t7
// 			8'h98:    Instruction <= {6'h00, 5'd26, 5'd15, 5'd26, 11'h22};
// 				//jr $k0
// 			8'h99:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h9a:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};

// // 32769 k0 没有－4
// 			//j Begin			# 复位态
// 			8'h00:    Instruction <= {6'h02, 26'h0000003};
// 				//j Timer			# 定时器中断
// 			8'h01:    Instruction <= {6'h02, 26'h0000039};
// 				//j Nop			# 未定义指令异常
// 			8'h02:    Instruction <= {6'h02, 26'h0000098};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h03:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h04:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr1
// 			8'h05:    Instruction <= {6'h03, 26'h0000006};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h06:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h07:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h08:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
// 			8'h09:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd29, 11'h20};
// 				//nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
// 			8'h0a:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd16, 11'h27};
// 				//lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数
// 			8'h0b:    Instruction <= {6'h0f, 5'h00, 5'd17, 16'h4000};
// 				//sw $zero, 8($s1)	 	# TCON = 0
// 			8'h0c:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h0008};
// 				//addi $t0, $s0, -32769
// 			8'h0d:    Instruction <= {6'h08, 5'd16, 5'd08, 16'h7fff};
// 				//addi $t0, $t0, -32769	# $t1 = 0xFFFFFFFF - 50000
// 			8'h0e:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h7fff};
// 				//sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
// 			8'h0f:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0000};
// 				//sw $s0, 4($s1)			# TL = 0xFFFFFFFF
// 			8'h10:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0004};
// 				//addi $t1, $zero, 3
// 			8'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0003};
// 				//sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
// 			8'h12:    Instruction <= {6'h2b, 5'd17, 5'd09, 16'h0008};
// 				//sw $zero,  12($s1)
// 			8'h13:    Instruction <= {6'h2b, 5'd17, 5'd00, 16'h000c};
// 				//sw $s0, 20($s1)
// 			8'h14:    Instruction <= {6'h2b, 5'd17, 5'd16, 16'h0014};
// 				//addi $t0, $zero, 3
// 			8'h15:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
// 				//sw $t0, 32($s1)			# UART_CON[1:0] = 11	
// 			8'h16:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0020};
// 				//add $s2, $zero, $zero
// 			8'h17:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//lw $t0, 32($s1) 	# 18 读取UART_CON
// 			8'h18:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 8 	# 01000
// 			8'h19:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0008};
// 				//and $t2, $t0, $t1	# 读取接收中断状态位UART_CON[3]
// 			8'h1a:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 3		# 读取接收中断状态位UART_CON[3]
// 			8'h1b:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h03, 6'h02};
// 				//beq $t2, $zero, Poll# 若等于0，则继续读，表示还没有接收到数据
// 			8'h1c:    Instruction <= {6'h04, 5'd10, 5'd00, 16'hfffb};
// 				//bgtz $s2, Calc		# 已收到两个数，分支
// 			8'h1d:    Instruction <= {6'h07, 5'd18, 5'h00, 16'h0003};
// 				//lw $a0, 28($s1)		# 读取UART_RXD
// 			8'h1e:    Instruction <= {6'h23, 5'd17, 5'd04, 16'h001c};
// 				//addi $s2, $s2, 1	# 设置一个flag
// 			8'h1f:    Instruction <= {6'h08, 5'd18, 5'd18, 16'h0001};
// 				//j Poll
// 			8'h20:    Instruction <= {6'h02, 26'h0000018};
// 				//lw $a1, 28($s1)		# 读取UART_RXD
// 			8'h21:    Instruction <= {6'h23, 5'd17, 5'd05, 16'h001c};
// 				//add $s2, $zero, $zero
// 			8'h22:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd18, 11'h20};
// 				//jal GCD
// 			8'h23:    Instruction <= {6'h03, 26'h000002c};
// 				//sw $v0, 12($s1)		# led显示结果
// 			8'h24:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h000c};
// 				//lw $t0, 32($s1)		# 检查UART发送器状态
// 			8'h25:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0020};
// 				//addi $t1, $zero, 16 # 10000
// 			8'h26:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0010};
// 				//and $t2, $t0, $t1	# 读取发送模块状态位
// 			8'h27:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h24};
// 				//srl $t2, $t2, 4	
// 			8'h28:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h04, 6'h02};
// 				//bne $t2, $zero, Loop# 发送器忙时阻塞
// 			8'h29:    Instruction <= {6'h05, 5'd10, 5'd00, 16'hfffb};
// 				//sw $v0, 24($s1)
// 			8'h2a:    Instruction <= {6'h2b, 5'd17, 5'd02, 16'h0018};
// 				//j Poll				# 开始下一次轮询
// 			8'h2b:    Instruction <= {6'h02, 26'h0000018};
// 				//add $t0, $a0, $zero
// 			8'h2c:    Instruction <= {6'h00, 5'd04, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $a1, $zero
// 			8'h2d:    Instruction <= {6'h00, 5'd05, 5'd00, 5'd09, 11'h20};
// 				//sub $t2, $t0, $t1
// 			8'h2e:    Instruction <= {6'h00, 5'd08, 5'd09, 5'd10, 11'h22};
// 				//blez $t2, Break
// 			8'h2f:    Instruction <= {6'h06, 5'd10, 5'h00, 16'h0002};
// 				//add $t0, $t2, $zero
// 			8'h30:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd08, 11'h20};
// 				//j Mod
// 			8'h31:    Instruction <= {6'h02, 26'h000002e};
// 				//beq $t2, $zero, EXIT_GCD
// 			8'h32:    Instruction <= {6'h04, 5'd10, 5'd00, 16'h0004};
// 				//add $t2, $t0, $zero
// 			8'h33:    Instruction <= {6'h00, 5'd08, 5'd00, 5'd10, 11'h20};
// 				//add $t0, $t1, $zero
// 			8'h34:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd08, 11'h20};
// 				//add $t1, $t2, $zero
// 			8'h35:    Instruction <= {6'h00, 5'd10, 5'd00, 5'd09, 11'h20};
// 				//j Mod
// 			8'h36:    Instruction <= {6'h02, 26'h000002e};
// 				//add $v0, $t1, $zero
// 			8'h37:    Instruction <= {6'h00, 5'd09, 5'd00, 5'd02, 11'h20};
// 				//jr $ra
// 			8'h38:    Instruction <= {6'h00, 5'd31, 21'h08};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h39:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
// 			8'h3a:    Instruction <= {6'h08, 5'd16, 5'd25, 16'hfffa};
// 				//and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
// 			8'h3b:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h24};
// 				//sw	$t9, 8($s1)
// 			8'h3c:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//sw $t0, 0($sp)
// 			8'h3d:    Instruction <= {6'h2b, 5'd29, 5'd08, 16'h0000};
// 				//sw $t1, 4($sp)
// 			8'h3e:    Instruction <= {6'h2b, 5'd29, 5'd09, 16'h0004};
// 				//sw $t2, 8($sp)
// 			8'h3f:    Instruction <= {6'h2b, 5'd29, 5'd10, 16'h0008};
// 				//sw $t3, 12($sp)
// 			8'h40:    Instruction <= {6'h2b, 5'd29, 5'd11, 16'h000c};
// 				//sw $t4, 16($sp)
// 			8'h41:    Instruction <= {6'h2b, 5'd29, 5'd12, 16'h0010};
// 				//sw $t5, 20($sp)
// 			8'h42:    Instruction <= {6'h2b, 5'd29, 5'd13, 16'h0014};
// 				//addi $sp, $sp, 20
// 			8'h43:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0014};
// 				//lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
// 			8'h44:    Instruction <= {6'h23, 5'd17, 5'd08, 16'h0014};
// 				//srl $t0, $t0, 8		# 获取AN3~AN0值
// 			8'h45:    Instruction <= {11'h00, 5'd08, 5'd08, 5'h08, 6'h02};
// 				//addi $t1, $zero, 7 	# 0111
// 			8'h46:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0007};
// 				//addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
// 			8'h47:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000b};
// 				//andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
// 			8'h48:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode# AN3~AN0 = 0111
// 			8'h49:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h000c};
// 				//addi $t1, $zero, 11 # 1011
// 			8'h4a:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000b};
// 				//addi $t2, $zero, 13	# 1101
// 			8'h4b:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000d};
// 				//andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
// 			8'h4c:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h4d:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//beq $t0, $t1, Decode
// 			8'h4e:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0007};
// 				//addi $t1, $zero, 13	# 1101
// 			8'h4f:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h000d};
// 				//addi $t2, $zero, 14	# 1110
// 			8'h50:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h000e};
// 				//andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
// 			8'h51:    Instruction <= {6'h0c, 5'd05, 5'd11, 16'h000f};
// 				//beq	$t0, $t1, Decode
// 			8'h52:    Instruction <= {6'h04, 5'd08, 5'd09, 16'h0003};
// 				//addi $t2, $zero, 7	# 0111
// 			8'h53:    Instruction <= {6'h08, 5'd00, 5'd10, 16'h0007};
// 				//andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
// 			8'h54:    Instruction <= {6'h0c, 5'd04, 5'd11, 16'h00f0};
// 				//srl $t3, $t3, 4
// 			8'h55:    Instruction <= {11'h00, 5'd11, 5'd11, 5'h04, 6'h02};
// 				//addi $t5, $zero, 192	# 0xC0
// 			8'h56:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c0};
// 				//beq $t3, $zero, Next	# 0
// 			8'h57:    Instruction <= {6'h04, 5'd11, 5'd00, 16'h002b};
// 				//addi $t4, $zero, 1
// 			8'h58:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 249	# 0xF9
// 			8'h59:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f9};
// 				//beq $t3, $t4, Next		# 1
// 			8'h5a:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0028};
// 				//addi $t4, $zero, 2
// 			8'h5b:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0002};
// 				//addi $t5, $zero, 164	# 0xA4
// 			8'h5c:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a4};
// 				//beq $t3, $t4, Next		# 2
// 			8'h5d:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0025};
// 				//addi $t4, $zero, 3
// 			8'h5e:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
// 				//addi $t5, $zero, 176	# 0xB0
// 			8'h5f:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00b0};
// 				//beq $t3, $t4, Next		# 3
// 			8'h60:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0022};
// 				//addi $t4, $zero, 4
// 			8'h61:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0004};
// 				//addi $t5, $zero, 153	# 0x99
// 			8'h62:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0099};
// 				//beq $t3, $t4, Next		# 4
// 			8'h63:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001f};
// 				//addi $t4, $zero, 5
// 			8'h64:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0005};
// 				//addi $t5, $zero, 146	# 0x92
// 			8'h65:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0092};
// 				//beq $t3, $t4, Next		# 5
// 			8'h66:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h001c};
// 				//addi $t4, $zero, 6
// 			8'h67:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0006};
// 				//addi $t5, $zero, 130	# 0x82
// 			8'h68:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0082};
// 				//beq $t3, $t4, Next		# 6
// 			8'h69:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0019};
// 				//addi $t4, $zero, 7
// 			8'h6a:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0007};
// 				//addi $t5, $zero, 248	# 0xF8
// 			8'h6b:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00f8};
// 				//beq $t3, $t4, Next		# 7
// 			8'h6c:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0016};
// 				//addi $t4, $zero, 8
// 			8'h6d:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0008};
// 				//addi $t5, $zero, 128	# 0x80
// 			8'h6e:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0080};
// 				//beq $t3, $t4, Next		# 8
// 			8'h6f:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0013};
// 				//addi $t4, $zero, 9
// 			8'h70:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0009};
// 				//addi $t5, $zero, 144	# 0x90
// 			8'h71:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0090};
// 				//beq $t3, $t4, Next		# 9
// 			8'h72:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0010};
// 				//addi $t4, $zero, 10
// 			8'h73:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000a};
// 				//addi $t5, $zero, 136	# 0x88
// 			8'h74:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0088};
// 				//beq $t3, $t4, Next		# A
// 			8'h75:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000d};
// 				//addi $t4, $zero, 11
// 			8'h76:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000b};
// 				//addi $t5, $zero, 131	# 0x83
// 			8'h77:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0083};
// 				//beq $t3, $t4, Next		# B
// 			8'h78:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h000a};
// 				//addi $t4, $zero, 12
// 			8'h79:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000c};
// 				//addi $t5, $zero, 198	# 0xC6
// 			8'h7a:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00c6};
// 				//beq $t3, $t4, Next		# C
// 			8'h7b:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0007};
// 				//addi $t4, $zero, 13
// 			8'h7c:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000d};
// 				//addi $t5, $zero, 161	# 0xA1
// 			8'h7d:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h00a1};
// 				//beq $t3, $t4, Next		# D
// 			8'h7e:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0004};
// 				//addi $t4, $zero, 14
// 			8'h7f:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h000e};
// 				//addi $t5, $zero, 134	# 0x86
// 			8'h80:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0086};
// 				//beq $t3, $t4, Next		# E
// 			8'h81:    Instruction <= {6'h04, 5'd11, 5'd12, 16'h0001};
// 				//addi $t5, $zero, 142	# 0x8E
// 			8'h82:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h008e};
// 				//sll $t2, $t2, 8
// 			8'h83:    Instruction <= {11'h00, 5'd10, 5'd10, 5'h08, 6'h00};
// 				//add $t0, $t2, $t5
// 			8'h84:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd08, 11'h20};
// 				//sw $t0, 20($s1)
// 			8'h85:    Instruction <= {6'h2b, 5'd17, 5'd08, 16'h0014};
// 				//lw $t5, 0($sp)
// 			8'h86:    Instruction <= {6'h23, 5'd29, 5'd13, 16'h0000};
// 				//lw $t4, -4($sp)
// 			8'h87:    Instruction <= {6'h23, 5'd29, 5'd12, 16'hfffc};
// 				//lw $t3, -8($sp)
// 			8'h88:    Instruction <= {6'h23, 5'd29, 5'd11, 16'hfff8};
// 				//lw $t2, -12($sp)
// 			8'h89:    Instruction <= {6'h23, 5'd29, 5'd10, 16'hfff4};
// 				//lw $t1, -16($sp)
// 			8'h8a:    Instruction <= {6'h23, 5'd29, 5'd09, 16'hfff0};
// 				//lw $t0, -20($sp)
// 			8'h8b:    Instruction <= {6'h23, 5'd29, 5'd08, 16'hffec};
// 				//addi $sp, $sp, -20
// 			8'h8c:    Instruction <= {6'h08, 5'd29, 5'd29, 16'hffec};
// 				//lw $t8, 8($s1)		# 读TCON
// 			8'h8d:    Instruction <= {6'h23, 5'd17, 5'd24, 16'h0008};
// 				//addi $t9, $zero, 2	# $t1 = 0x00000002
// 			8'h8e:    Instruction <= {6'h08, 5'd00, 5'd25, 16'h0002};
// 				//or $t9, $t8, $t9 	# TCON | =0x00000002
// 			8'h8f:    Instruction <= {6'h00, 5'd24, 5'd25, 5'd25, 11'h25};
// 				//sw	$t9, 8($s1)
// 			8'h90:    Instruction <= {6'h2b, 5'd17, 5'd25, 16'h0008};
// 				//lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
// 			8'h91:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
// 				//addi $t6,$t6,65535	# 0x7FFFFFFF
// 			8'h92:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
// 				//jal getaddr2
// 			8'h93:    Instruction <= {6'h03, 26'h0000094};
// 				//addi $t7,$ra,12  	# 3 lines after
// 			8'h94:    Instruction <= {6'h08, 5'd31, 5'd15, 16'h000c};
// 				//and $t6,$t7,$t6 	# 让第一位变成0
// 			8'h95:    Instruction <= {6'h00, 5'd15, 5'd14, 5'd14, 11'h24};
// 				//jr  $t6         	# set MSF of $PC to 0 and continue
// 			8'h96:    Instruction <= {6'h00, 5'd14, 21'h08};
// 				//jr $k0
// 			8'h97:    Instruction <= {6'h00, 5'd26, 21'h08};
// 				//sll $zero, $zero, 0
// 			8'h98:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};



// hzh test
			// 	//j begin
			// 5'h00:    Instruction <= {6'h02, 26'h0000008};
			// 	//j timer
			// 5'h01:    Instruction <= {6'h02, 26'h0000003};
			// 	//j exception  #dead loop
			// 5'h02:    Instruction <= {6'h02, 26'h0000002};
			// 	//andi $t2,$t2,65529 #0x0000FFF9
			// 5'h03:    Instruction <= {6'h0c, 5'd10, 5'd10, 16'hfff9};
			// 	//addi $t0,$t0,1  #increase $t0
			// 5'h04:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h0001};
			// 	//addi $t5,$zero,2
			// 5'h05:    Instruction <= {6'h08, 5'd00, 5'd13, 16'h0002};
			// 	//or $t2,$t2,$t5  #enable timer interrupt
			// 5'h06:    Instruction <= {6'h00, 5'd10, 5'd13, 5'd10, 11'h25};
			// 	//jr $k0
			// 5'h07:    Instruction <= {6'h00, 5'd26, 21'h08};
			// 	//lui $t6,32767  #0x7FFF0000
			// 5'h08:    Instruction <= {6'h0f, 5'h00, 5'd14, 16'h7fff};
			// 	//addi $t6,$t6,65535 #0x7FFFFFFF
			// 5'h09:    Instruction <= {6'h08, 5'd14, 5'd14, 16'hffff};
			// 	//jal getaddr
			// 5'h0a:    Instruction <= {6'h03, 26'h000000b};
			// 	//addi $t5,$ra,12  #3 lines after
			// 5'h0b:    Instruction <= {6'h08, 5'd31, 5'd13, 16'h000c};
			// 	//and $t6,$t5,$t6 
			// 5'h0c:    Instruction <= {6'h00, 5'd13, 5'd14, 5'd14, 11'h24};
			// 	//jr  $t6         #set MSF of $PC to 0 and continue
			// 5'h0d:    Instruction <= {6'h00, 5'd14, 21'h08};
			// 	//add $t0,$zero,$zero
			// 5'h0e:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd08, 11'h20};
			// 	//lui $t2,16384  #0x4000,TH
			// 5'h0f:    Instruction <= {6'h0f, 5'h00, 5'd10, 16'h4000};
			// 	//add $t3,$zero,$zero
			// 5'h10:    Instruction <= {6'h00, 5'd00, 5'd00, 5'd11, 11'h20};
			// 	//addi $t1,$zero,20
			// 5'h11:    Instruction <= {6'h08, 5'd00, 5'd09, 16'h0014};
			// 	//sub $t3,$t3,$t1
			// 5'h12:    Instruction <= {6'h00, 5'd11, 5'd09, 5'd11, 11'h22};
			// 	//sw  $t3,0($t2)
			// 5'h13:    Instruction <= {6'h2b, 5'd10, 5'd11, 16'h0000};
			// 	//sw  $t3,4($t2)
			// 5'h14:    Instruction <= {6'h2b, 5'd10, 5'd11, 16'h0004};
			// 	//addi $t4,$zero,3
			// 5'h15:    Instruction <= {6'h08, 5'd00, 5'd12, 16'h0003};
			// 	//addi $t2,$t2,8
			// 5'h16:    Instruction <= {6'h08, 5'd10, 5'd10, 16'h0008};
			// 	//sw  $t4,0($t2)
			// 5'h17:    Instruction <= {6'h2b, 5'd10, 5'd12, 16'h0000};


		default: Instruction <= 32'h0800_0000;
	endcase
endmodule
