'''
480 Assembler
(C) 2016 William Hampton
wchampton@crimson.ua.edu

Usage:
This program will assemble assembly language text files
into the 480 project 1 machine code. Run it with 
'python assmebler.py' and enter your file when prompted.
By default, assembled machine code will be saved as a.out.

---------------------------------------------------------

Changing the Language:
If you extend the assmebly language, you can allow the 
assembler to read your new language with only 2 changes.
First, add any instructions to the assembler i dictionary
by calling the addInst method with your new instruction code.
Second, if your instruction is a new format, add the shape
of the format to the assembler table dictionary with the
addType method. For examples of adding a new instruction
and type, see the Extension Examples.

--------------------------------------------------------

Extension Examples:
#add this to main
#adding a new 'R' format instruction
a.addInstr('TST', '10000', 'R')

#adding a new 'T' format & instruction
#T - |op-code|ExtReg|address|
#	 |5      |4     |7      |
a.addType('T', 5, 4, 7)
a.addInstr('ADD_EX', '10001', 'T')

-------------------------------------------------------

Assembly Language Definition:
The assembly language accepts line deliniated instructions.
Each instruction must be have its fields space seperated.
The assembler does not care about case, so capitalize at will.
Integer fields can be filled in with binary or hexidecimal. Hex
entries must begin with the symbol 'x'. If a field is left blank
or not enough digits are entered into a field, the blank bits will
be zero filled. If a field is overfilled, the assembler will 
throw an error. Every line must have an instruction on it.
Comments my be added to the end of a line by leading them with
the symbol '--'. For an example file, see Assembly Language Example.

-------------------------------------------------------

Assembly Language Example:
add 1 x0 --This is a comment
add 0 xAA
str 1 xAB
LDR 0 x31A 
jmp x3FF --x3FF fills all 10 digits of the address
'''


'''
Formats:
	R-format
		|op-code|Reg|address|
		|5      |1  |10     |
	J-format
		|op-code|address|
		|5      |11     |

'''

#Helper Data Class
class Inst:
		def __init__(self, name, code, tag):
			self.name = name
			self.tag = tag
			self.code = code

#Main Assembler Class
class Assembler:
	def __init__(self, i = {}, table = {}, default = True):
		#Load the default table in
		if default == True:
			self.i = {}
			self.i['ADD'] = Inst('ADD', '00000', 'R')
			self.i['STR'] = Inst('STR', '00001', 'R')
			self.i['LDR'] = Inst('LDR', '00010', 'R')
			self.i['JMP'] = Inst('JMP', '00011', 'J')
			self.i['JN' ] = Inst('JN' , '00100', 'R')
			self.i['SUB'] = Inst('SUB', '00101', 'R')
			self.i['INC'] = Inst('INC', '00110', 'R')
			self.i['OR' ] = Inst('OR' , '00111', 'R')
			self.i['AND'] = Inst('AND', '01000', 'R')
			self.i['NOT'] = Inst('NOT', '01001', 'R')
			self.i['JP' ] = Inst('JP' , '01010', 'R')
			self.i['JZ' ] = Inst('JZ' , '01011', 'R')
			self.i['SHL'] = Inst('SHL', '01100', 'R')
			self.i['SHR'] = Inst('SHR', '01101', 'R')
			self.i['IN' ] = Inst('IN' , '01110', 'R')
			self.i['OUT'] = Inst('OUT', '01111', 'R')
			#Add instructions here to make them
			#part of the default set

			#table lists what the length of the fields are for
			#each Instruction type
			#format is (#fields, len_1, len_2, ... len_n)
			self.table = {}
			self.table['R'] = (3, 5, 1, 10)
			self.table['J'] = (2, 5, 11)
			#if you add any new instruction types to the
			#default set, make sure to add a matching table
			#entry

		else: #custom load instructions and types
			self.i = i
			self.table = table

	def addInst(self, name, code, tag):
		self.i[name] = Inst(name, code, tag)

	def addType(self, tag, *nums):
		n = list(nums)
		n.insert(0, len(nums))
		self.table[tag] = tuple(n)

	def bin2Hex(self, hexD, length):
		return bin(int(hexD, 16))[2:].zfill(length)
	def parseLine(self, line):
		line = line.split("--")[0] #remove comments
		if line.strip() == "": #If we had nothing but a comment on the line, return
			return ""
		ops = line.upper().strip().split(" ") #split out the elements
		print(ops)
		#set up variables to use outside of the try/except
		t = None 
		s = None

		try:
			s = self.i[ops[0]].code #the first section of code is always the op code
		except Exception:
			raise NameError('Instruction not Found : {}'.format(ops[0]))
		try:
			t = self.table[self.i[ops[0]].tag] #what type of Instruction do we have?
		except Exception:
			raise NameError('Type not found : {}'.format(self.i[ops[0]].tag))

		for sec in range(1, t[0]):
			if len(ops) > sec: #check if the field is filled out
				if ops[sec][0] == 'X': #allow for hexidecimal assembly
					s+=self.bin2Hex('0'+ops[sec], t[sec+1])
				else:
					if len(ops[sec]) <= t[sec+1]:
						s+=ops[sec].zfill(t[sec+1])
					else:
						raise NameError('Too many bits for element {} of instruction {}'.format(sec, ops[0]))

			else:
				s+=''.zfill(t[sec+1]) # fill in 0's for d.c. fields
		return s + '\n'
		
	def parseFile(self, infile, outfile = "a.out"):
		with open(infile, "r") as f:
			with open(outfile, "w") as o:
				o.write(self.parseLine(line.strip()))
		print('{} written'.format(outfile))
	def parseToMif(self, infile, outfile = 'a.mif'):
		with open(infile, "r") as f:
			s = ''
			for line in f:
				s+=self.parseLine(line.strip())
			s = s.strip().split('\n') #read into memory: we need to know how many lines there are
			print(s)
			with open(outfile, "w") as o:
				o.write('DEPTH = {};\n'.format(len(s)))
				o.write('WIDTH = 16;\n')
				o.write('ADDRESS_RADIX = UNS;\n')
				o.write('DATA_RADIX = BIN;\n')
				o.write('CONTENT\n')
				o.write('BEGIN\n')
				for ind in range(0, len(s)):
					o.write('{} : {};\n'.format(str(ind), s[ind]))
				o.write('END;')
		print('{} written'.format(outfile))


def main():
	a = Assembler() #load default assembler
	#add new instructions here

	#start parsing
	#a.parseFile((raw_input("Enter your assembly file name:: ")))
	a.parseToMif((raw_input("Enter your assembly file name:: ")))
if __name__ == '__main__':
	main()

