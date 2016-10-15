#Instruction 
##Base Instructions
These instructions are default to all 480 Microcomputer Projects.
They are all in R format.  


| Name  | OP Code | Notes                  |
|-------|---------|------------------------|
| ADD   | x00     | Adds R to Addr         |
| STR   | x01     | Puts R in Addr         |
| LDR   | x02     | Puts Addr in R         |
| JMP   | x03     | Jump PC to Addr        |
| JN    | x04     | Jump PC to Addr if R<0 |
| SUB   | x05     | Subtract $SD from R    |
| INC   | x06     | Add 1 to R             |
| OR    | x07     | Sets R to R or Addr    |
| AND   | x08     | Sets R to R and Addr   |
| NOT   | x09     | Sets R to not R        |
| JP    | x0A     | Jump PC to Addr if R>0 |
| JZ    | x0B     | Jump PC to Addr if R=0 |
| SHL   | x0C     | Shift R one bit left   |
| SHR   | x0D     | Shift R one bit right  |
| IN    | x0E     | R(7 - 0) <- SW(7 - 0)  |
| OUT   | x0F     | LED(7 - 0) <= R(7 - 0) |

##Added Instructions
As we add instructions, we will put them here


| Name  | OP Code | Format |Notes                  |
|-------|---------|--------|-----------------------|

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