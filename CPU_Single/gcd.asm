j Begin			# 复位态
j Timer			# 定时器中断
j Nop			# 未定义指令异常

Begin:

# 内核 -> 用户态 (PC 最高位变为0)
	lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
	addi $t6,$t6,65535	# 0x7FFFFFFF
	jal getaddr1
getaddr1:	
	addi $t7,$ra,12  	# 3 lines after //12
	and $t6,$t7,$t6 	# 让第一位变成0
	jr  $t6         	# set MSF of $PC to 0 and continue

# 定义一些常量
	add $sp, $zero, $zero	# 堆栈指针置为0，向上增长
	nor $s0, $zero, $zero 	# $s0 = 0xFFFFFFFF，常数
	lui $s1, 16384			# $s1 = 0x40000000，外设基址，常数 //11

# $s2保存UART已经收到的数据个数
# $t8, $t9分配给定时器中断程序

# Timer	
	sw $zero, 8($s1)	 	# TCON = 0
	addi $t0, $s0, -30000
	addi $t0, $t0, -30000	# $t1 = 0xFFFFFFFF - 50000
	sw $t0, 0($s1)			# TH, 10e5分频，1kHz扫描频率
	sw $s0, 4($s1)			# TL = 0xFFFFFFFF
	addi $t1, $zero, 3
	sw $t1, 8($s1)			# TCON = 3，启动定时器 !		
# led/digi，led高电平时亮，digi低电平亮
	sw $zero,  12($s1)
	sw $s0, 20($s1)
# uart
	addi $t0, $zero, 3
	sw $t0, 32($s1)			# UART_CON[1:0] = 11	
	add $s2, $zero, $zero										# 23

# UART轮询
Poll:	
	lw $t0, 32($s1) 		# 18 读取UART_CON 						# 24
	addi $t1, $zero, 8 		# 01000
	and $t2, $t0, $t1		# 读取接收中断状态位UART_CON[3]
	srl $t2, $t2, 3			# 读取接收中断状态位UART_CON[3]
	beq $t2, $zero, Poll	# 若等于0，则继续读，表示还没有接收到数据		# 28
	bgtz $s2, Calc			# 已收到两个数，分支
	lw $a0, 28($s1)			# 读取UART_RXD
	
	addi $s2, $s2, 1		# 设置一个flag
	j Poll	
Calc: 		
	lw $a1, 28($s1)			# 读取UART_RXD
 		
	add $s2, $zero, $zero
	jal GCD	
	sw $v0, 12($s1)			# led显示结果
Loop: 		
	lw $t0, 32($s1)			# 检查UART发送器状态
	addi $t1, $zero, 16 	# 10000
	and $t2, $t0, $t1		# 读取发送模块状态位
	srl $t2, $t2, 4		
	bne $t2, $zero, Loop	# 发送器忙时阻塞
	sw $v0, 24($s1)	
	j Poll					# 开始下一次轮询							# 43

# 计算最大公约数
GCD:	
	add $t0, $a0, $zero
	add $t1, $a1, $zero
	#取模运算
Mod:	
	sub $t2, $t0, $t1											# 46
	blez $t2, Break
	add $t0, $t2, $zero
	j Mod
Break:	
	beq $t2, $zero, EXIT_GCD
	add $t2, $t0, $zero
	add $t0, $t1, $zero
	add $t1, $t2, $zero
	j Mod
EXIT_GCD:	
	add $v0, $t1, $zero
	jr $ra

# 定时器中断处理# 中断禁止，中断状态位清零
Timer:	
	lw $t8, 8($s1)		# 读TCON
	addi $t9, $s0, -6	# $t9 = 0xFFFFFFF9
	and $t9, $t8, $t9  	# TCON & 0xFFFFFFF9
	sw	$t9, 8($s1)
# 保存现场
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	addi $sp, $sp, 20
# 中断处理代码
	# 假定输入的两个数存在$a0, $a1中
	# AN3~AN0下一状态保存在$t2中
	lw $t0, 20($s1) 	# lw $t0, 20($s1) 读取数码管状态
	srl $t0, $t0, 8		# 获取AN3~AN0值
	addi $t1, $zero, 7 	# 0111
	addi $t2, $zero, 11	# 1011，AN3~AN0下一状态值
	andi $t3, $a0, 15	# $a0 & 0x0000000F，显示$a0低四位
	beq	$t0, $t1, Decode# AN3~AN0 = 0111
	
	addi $t1, $zero, 11 # 1011
	addi $t2, $zero, 13	# 1101
	andi $t3, $a1, 240	# $a1 & 0x000000F0，显示$a1高四位
	srl $t3, $t3, 4
	beq $t0, $t1, Decode
	
	addi $t1, $zero, 13	# 1101
	addi $t2, $zero, 14	# 1110
	andi $t3, $a1, 15	# $a1 & 0x0000000F，显示$a1低四位
	beq	$t0, $t1, Decode
	
	addi $t2, $zero, 7	# 0111
	andi $t3, $a0, 240	# $a0 & 0x000000F0，显示$a0高四位
	srl $t3, $t3, 4

# 七段数码管译码， DP对应高位，CA对应低位
# 译码值保存在$t5中
Decode:	
	addi $t5, $zero, 192	# 0xC0
	beq $t3, $zero, Next	# 0
	
	addi $t4, $zero, 1
	addi $t5, $zero, 249	# 0xF9
	beq $t3, $t4, Next		# 1
	
	addi $t4, $zero, 2
	addi $t5, $zero, 164	# 0xA4
	beq $t3, $t4, Next		# 2
	
	addi $t4, $zero, 3
	addi $t5, $zero, 176	# 0xB0
	beq $t3, $t4, Next		# 3
	
	addi $t4, $zero, 4
	addi $t5, $zero, 153	# 0x99
	beq $t3, $t4, Next		# 4
	
	addi $t4, $zero, 5
	addi $t5, $zero, 146	# 0x92
	beq $t3, $t4, Next		# 5
	
	addi $t4, $zero, 6
	addi $t5, $zero, 130	# 0x82
	beq $t3, $t4, Next		# 6

	addi $t4, $zero, 7
	addi $t5, $zero, 248	# 0xF8
	beq $t3, $t4, Next		# 7
	
	addi $t4, $zero, 8
	addi $t5, $zero, 128	# 0x80
	beq $t3, $t4, Next		# 8

	addi $t4, $zero, 9
	addi $t5, $zero, 144	# 0x90
	beq $t3, $t4, Next		# 9

	addi $t4, $zero, 10
	addi $t5, $zero, 136	# 0x88
	beq $t3, $t4, Next		# A

	addi $t4, $zero, 11
	addi $t5, $zero, 131	# 0x83
	beq $t3, $t4, Next		# B
	
	addi $t4, $zero, 12
	addi $t5, $zero, 198	# 0xC6
	beq $t3, $t4, Next		# C

	addi $t4, $zero, 13
	addi $t5, $zero, 161	# 0xA1
	beq $t3, $t4, Next		# D
	
	addi $t4, $zero, 14
	addi $t5, $zero, 134	# 0x86
	beq $t3, $t4, Next		# E
	
	addi $t5, $zero, 142	# 0x8E

# 将$t2, $t5的结果拼接输出
Next:	
	sll $t2, $t2, 8
	add $t0, $t2, $t5
	sw $t0, 20($s1)

# 恢复现场
	lw $t5, 0($sp)
	lw $t4, -4($sp)
	lw $t3, -8($sp)
	lw $t2, -12($sp)
	lw $t1, -16($sp)
	lw $t0, -20($sp)
	addi $sp, $sp, -20
# 使能中断
	lw $t8, 8($s1)		# 读TCON
	addi $t9, $zero, 2	# $t1 = 0x00000002
	or $t9, $t8, $t9 	# TCON | =0x00000002
	sw	$t9, 8($s1)

# 内核 -> 用户态 (PC 最高位变为0)
	lui $t6,32767  		# 0x7FFF0000 处理用户态、内核态
	addi $t6,$t6,65535	# 0x7FFFFFFF
	jal getaddr2
getaddr2:	
	addi $t7,$ra,12  	# 3 lines after
	and $t6,$t7,$t6 	# 让第一位变成0
	jr  $t6         	# set MSF of $PC to 0 and continue

# $k0: 中断前位置
# $k0 = $k0 - 4
#	addi $t7,$zero,4
#	sub $k0,$k0,$t7
# 退出中断, 返回中断前位置
	jr $k0
Nop:	
	sll $zero, $zero, 0
	
	
