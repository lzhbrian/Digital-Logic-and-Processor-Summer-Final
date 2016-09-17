#This file stores format of machine codes and assembly codes
inst_type = {
  "add":    [["000000","rs", "rt", "rd","00000","100000"],["rd","rs","rt"]],
  "addu":   [["000000","rs", "rt", "rd","00000","100001"],["rd","rs","rt"]],
  "and":    [["000000","rs", "rt", "rd","00000","100100"],["rd","rs","rt"]],
  "jalr":   [["000000", "rs","000000","rd","00000","001001"],["rd","rs"]],
  "nor":    [["000000","rs", "rt", "rd","00000","100111"],["rd","rs","rt"]],
  "or":     [["000000","rs", "rt", "rd","00000","100101"],["rd","rs","rt"]],
  "sll":    [["000000","00000","rt", "rd","shamt","000000"],["rd","rt","shamt"]],
  "sllv":   [["000000","00000","rt", "rt","shamt","000100"],["rd","rt","shamt"]],
  "slt":    [["000000","rs", "rt", "rd","00000","101010"],["rd","rs","rt"]],
  "sltu":   [["000000","rs", "rt", "rd","00000","101011"],["rd","rs","rt"]],
  "sra":    [["000000","00000","rt", "rd","shamt","000011"],["rd","rt","shamt"]],
  "srl":    [["000000","00000","rt", "rd","shamt","000010"],["rd","rt","shamt"]],
  "sub":    [["000000","rs", "rt", "rd","00000","100010"],["rd","rs","rt"]],
  "subu":   [["000000","rs", "rt", "rd","00000","100011"],["rd","rs","rt"]],
  "xor":    [["000000","rs", "rt", "rd","00000","100110"],["rd","rs","rt"]],
  "jr":     [["000000","rs","000000000000000","001000"],["rs"]],
  "addi":   [["001000","rs","rt","imm"],["rt","rs","imm"]],
  "addiu":  [["001001","rs","rt","imm"],["rt","rs","imm"]],
  "andi":   [["001100","rs","rt","imm"],["rt","rs","imm"]],
  "beq":    [["000100","rs","rt","label"],["rs","rt","label"]],
  "bgtz":   [["000111","rs","00000","label"],["rs","label"]],
  "blez":   [["000110","rs","00000","label"],["rs","label"]],
  "bltz":   [["000001","rs","00000","label"],["rs","label"]],
  "bne":    [["000101","rs","rt","label"],["rs","rt","label"]],
  "lui":    [["001111","00000","rt","imm"],["rt","imm"]],
  "lw":     [["100011","rs","rt","offset"],["rt","rs","offset"]],
  "slti":   [["001010","rs","rt","imm"],["rt","rs","imm"]],
  "sltiu":  [["001011","rs","rt","imm"],["rt","rs","imm"]],
  "sw":     [["101011","rs","rt","offset"],["rt","rs","offset"]],
  "j":      [["000010","target"],["target"]],
  "jal":    [["000011","target"],["target"]],
  "nop":    [["00000000000000000000000000000000"],[""]]
}
regs = {
    "$zero":"00000",
    "$at":"00001",
    "$v0":"00010",
    "$v1":"00011",
    "$a0":"00100",
    "$a1":"00101",
    "$a2":"00110",
    "$a3":"00111",
    "$t0":"01000",
    "$t1":"01001",
    "$t2":"01010",
    "$t3":"01011",
    "$t4":"01100",
    "$t5":"01101",
    "$t6":"01110",
    "$t7":"01111",
    "$s0":"10000",
    "$s1":"10001",
    "$s2":"10010",
    "$s3":"10011",
    "$s4":"10100",
    "$s5":"10101",
    "$s6":"10110",
    "$s7":"10111",
    "$t8":"11000",
    "$t9":"11001",
    "$k0":"11010",
    "$k1":"11011",
    "$gp":"11100",
    "$sp":"11101",
    "$fp":"11110",
    "$ra":"11111",
}