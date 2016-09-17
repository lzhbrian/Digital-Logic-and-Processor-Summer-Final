import re
from data import *

insts = []
labels = {}
address = 0
def bindigits(n, bits):
    s = bin(n & int("1"*bits, 2))[2:]
    return ("{0:0>%s}" % (bits)).format(s)
asmfile = open("/Users/mark/Desktop/instructions.txt","r")          #Open Assembly File
binaryfile = open("/Users/mark/Desktop/binary.txt","w")             #Open Machine Code File
asms = asmfile.readlines()#Read Assembly Codes
class instruction:
    address = 0
    label = ""                                                    #Store labels
    asm = ""                                                      #Assembly
    binary = ""                                                   #Store binary
    def __init__(self,asmstring,no):                                #Construction Function
        self.asm = asmstring
        self.address = no
for asmstring in asms:
    insts.append(instruction(asmstring,address))                    #Build "insts" list containing all instructions
    address += 1                                                    #Increment of address

#First Loop:Deal with labels
for inst in insts:
    location = inst.asm.find(":")
    if location != -1:
        inst.label = inst.asm[0:location]                           #Store labels
        inst.asm = inst.asm[location:]                              #Store real instructions
        labels[inst.label]=inst.address                             #Build label dict

#Second Loop:
for inst in insts:                                                  #For each instruction
    inst.asm = re.split("\s+",inst.asm.replace(","," ").replace(":"," ").strip())    #remove "," and split instructions
    dic = {}                                                        #instruction operator dict
    operator = inst.asm[0]                                          #operator of the instruction
    inst.binary = inst_type[operator][0][:]                         #machine code template
    binary_parameter = inst_type[operator][1]                       #assembly code template
    for i,part in enumerate(inst.asm):                              #Deal with offset parameter
        if "($" in part:                                            #if it is offset,split the offset format to "rs" and "offset"
            location = part.find("($")
            offset = part[0:location]
            rs = part[location+1:-1]
            inst.asm[i] = rs
            inst.asm.append(offset)
    for i,part in enumerate(inst.asm):#Begin interpretion
        if part.replace("-","").isdigit():#Deal with imm and shamt
                inst.asm[i] = bindigits(int(part),5 if "shamt" in binary_parameter else 16)
        if part in regs.keys():#Deal with register files
            inst.asm[i] = regs[part]
        if part in labels.keys():#Deal with labels
            if inst.asm[0]=="j" or inst.asm[0]=="jal":
                inst.asm[i] = bindigits(int(labels[part]),26)#Interpret labels in j or jal
            else:
                inst.asm[i] = bindigits(4*(int(labels[part])-int(inst.address)),16)#Interpret labels in others
    for j,com in enumerate(inst.binary):                    #Put rs,rt,rd into right place of the machine code
        if com in binary_parameter:                         #according to the template "inst_type"
            location = binary_parameter.index(com)
            dic[com] = inst.asm[1+location]
            inst.binary[j] = dic[com]
    binaryfile.write("".join(inst.binary)+"\n")             #Write results into file

asmfile.close();                                            #Close files
binaryfile.close();