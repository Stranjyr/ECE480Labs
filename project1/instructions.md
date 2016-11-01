#Instruction 
##Base Instructions
These instructions are default to all 480 Microcomputer Projects.
They are all in R format.  


| Name  | OP Code | Notes                  |
|-------|---------|------------------------|
| ADD   | 00000   | Adds R to Addr         |
| STR   | 00001   | Puts R in Addr         |
| LDR   | 00010   | Puts Addr in R         |
| JMP   | 00011   | Jump PC to Addr        |
| JN    | 00100   | Jump PC to Addr if R<0 |
| SUB   | 00101   | Subtract $SD from R    |
| INC   | 00110   | Add 1 to R             |
| OR    | 00111   | Sets R to R or Addr    |
| AND   | 01000   | Sets R to R and Addr   |
| NOT   | 01001   | Sets R to not R        |
| JP    | 01010   | Jump PC to Addr if R>0 |
| JZ    | 01011   | Jump PC to Addr if R=0 |
| SHL   | 01100   | Shift R one bit left   |
| SHR   | 01101   | Shift R one bit right  |
| IN    | 01110   | R(7 - 0) <- SW(7 - 0)  |
| OUT   | 01111   | LED(7 - 0) <= R(7 - 0) |

##Added Instructions
As we add instructions, we will put them here


| Name   | OP Code | Format |Notes                  |
|--------|---------|--------|-----------------------|
| ADD_i  | 10000   | R      | Add val Addr to R     |
| ADDe_i | 10001   | I      | Add imid to SDL       |
| ADDe_r | 10010   | D      | Add SDR, SDG, Put SDL |
| SUB_i  | 10011   | R      | Sub val addr from R   |
| SUBe_i | 10100   | I      | Sub imid from SDL     |
| SUBe_r | 10101   | D      | SDL <= SDR-SDG        |
| LW     | 10110   | D      | SDL <= SDR[SDG]       |
| SW     | 10111   | D      | SDR[SDG] <= SDL       |
| JAL    | 11000   | R      | JMP to addr, store RA |
| BNEe_r | 11001   | D      | JMP to SDL if SDR!=SDG|
| BEQe_r | 11010   | D      | JMP to SDL if SDR=SDG |
  
##Instruction Formats
As we create new formats, we will put them here
###Regular Format (R format)
| Op Code | $R     | Addr            |
|---------|--------|-----------------|
| 5 Bits  | 1 Bit  | 10 Bits         |

- Op Code is the 5 bit op code
- R is the value of the general use register to use
- Addr is the address to use in memory

This format is the default format for the 480 project UC. It can only access the 2 general use registers, but is good for operations requiring use of the RAM memory.  

###Direct Register (D Format)
| Op Code | $SDL   | $SDR   | $SDG   | 
|---------|--------|--------|--------|
| 5 bits  | 4 bits | 4 bits | 3 bit  |

- Op code is 5 bit op code.  
- SDL is the desitination Register  
- SDR is the Direct Register  
- SDG is the General Register  

This format is used for opperations directly on the full list of registers. SDL and SDR are any register in the table, and SDG is any of the general, saved, or temporary registers.  

###Immediate Format (I Format)
| Op Code | $SDL   | Immediate |
|---------|--------|-----------|
| 5 bits  | 3 bits | 8 bits    |

- Op Code is the 5 bit op code
- SDL is the desination register
- Immediate is the Immediate value to process

This format is used for operations that need easy access to an immediate value without resorting to memory lookup.  

##Quick Reference
###Register Table
| Name | Value | Use        |
|------|-------|------------|
| R0   | 0     | General    |
| R1   | 1     | General    |
| S0   | 2     | Saved      |
| S1   | 3     | Saved      |
| S2   | 4     | Saved      |
| T0   | 5     | Temporary  |
| T1   | 6     | Temporary  |
| T2   | 7     | Temporary  |
| Zero | 8     | Zero Val   |
| RA   | 9     | Return Pos |
| PC   | 10    | Prog Count |
| A0   | 11    | Parameter  |
| A1   | 12    | Parameter  |
| A2   | 13    | Parameter  |
| V0   | 14    | Return Val |
| ST   | 15    | Stack Count|
