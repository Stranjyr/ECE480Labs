library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ucomp is
  port (
	clk50	: in std_logic;
	sw		: in std_logic_vector(9 downto 0);
	keys 	: in std_logic_vector(3 downto 0);
	leds 	: out std_logic_vector(9 downto 0)
  ) ;
end entity ; -- ucomp

architecture arch of ucomp is
	--Clock divider signals
	signal clock 	: std_logic; --clock selected by multipler
	signal clk125 	: std_logic;
	signal clk_step	: std_logic;

	--Registers
	type logic_array is array(0 to 15) of unsigned(15 downto 0);
	--Register Table
	--|===========================|
	--| Name | Value | Use        |
	--| R0   | 0     | General    |
	--| R1   | 1     | General    |
	--| Zero | 2     | Zero Val   |
	--| RA   | 3     | Return Pos |
	--| PC   | 4     | Prog Count |
	--| S0   | 5     | Saved      |
	--| S1   | 6     | Saved      |
	--| S2   | 7     | Saved      |
	--| T0   | 8     | Temporary  |
	--| T1   | 9     | Temporary  |
	--| T2   | 10    | Temporary  |
	--| A0   | 11    | Parameter  |
	--| A1   | 12    | Parameter  |
	--| A2   | 13    | Parameter  |
	--| V0   | 14    | Return Val |
	--| ST   | 15    | Stack Count|
	--|===========================|
	signal register_array : logic_array;

	--Stack Signals
	signal pc : unsigned(15 downto 0);
	signal current_address : unsigned(9 downto 0);
	signal next_address : unsigned(9 downto 0);
	signal pc_advance	: std_logic; --end of instruction flag

	--Memory Signals
	signal mem_addr_rd 	: unsigned(9 downto 0);
	signal mem_addr_wr 	: unsigned(9 downto 0);
	signal mem_data_rd 	: unsigned(15 downto 0);
	signal mem_data_wr 	: unsigned(15 downto 0);
	signal mem_en_wr 	: std_logic;
	signal mem_clk		: std_logic; --runs much faster than the program clock


begin
	--This will synthisize out, but renaming the pc makes
	--it easier to program
	pc <= register_array(10);

	--Main loop for processing instructions.
	mainLoop : process(clock)
		variable instr_step : integer range 0 to 15; --tracks the part of the 
													 --instruction for multi-clock instructions
	begin
		--See Instructions.md for a list of instructions and formats
		case(pc(15 downto 11) is
			--ADD address and Register
			when x"00" => 
				case(instr_step) is
					when 0 =>
						mem_addr_rd <= pc(9 downto 0);
						instr_step <= 1;
					when 1 =>
						register_array(to_integer(pc(10))) <= register_array(to_integer(pc(10))) + mem_data_rd;
						instr_step <= 0;
						pc_advance <= '1';
				end case;
			--STR (Store R Register)
			when x"01" =>
				case(instr_step) is
					when 0 =>
						mem_data_wr <= register_array(to_integer(pc(10)));
						mem_addr_wr <= pc(9 downto 0);
						mem_en_wr <= '1';
						instr_step <= 1;
					when 1 =>
						mem_en_wr <= '0';
						instr_step <= 0;
						pc_advance <= '1';
				end case;
			--LDR (Load R Register)
			when x"02" =>
				case(instr_step) is
					when 0 =>
						mem_addr_rd <= pc(9 downto 0);
						instr_step <= 1;
					when 1 =>
						register_array(to_integer(pc(10))) <= mem_data_rd;
						instr_step <= 0;
						pc_advance <= '1';
				end case;
			--JMP
			when x"03" =>
				case(instr_step) is
					when 0 =>
						mem_addr_rd <= pc(9 downto 0);
						instr_step <= 1;
					when 1 =>
						--to write pc, use its register reference
						register_array(10) <= mem_data_rd;
						instr_step <= 0;
						--don't advance the pc: we just set it!
				end case;
			--JN (Jump if Negitive)
			when x"04" =>
				case(instr_step) is
					when 0 =>
						--if register is negitive, jump. Else, advance pc
						if register_array(to_integer(pc(10))) < 0 then
							mem_addr_rd <= pc(9 downto 0);
							instr_step <= 1;
						else
							pc_advance <= '1';
						end if;
					when 1 =>
						--to write pc, use its register reference
						register_array(10) <= mem_data_rd;
						instr_step <= 0;
						--don't advance the pc: we just set it!
				end case;
			--SUB
			when x"05" =>
				case(instr_step) is
					when 0 =>
						mem_addr_rd <= pc(9 downto 0);
						instr_step <= 1;
					when 1 =>
						register_array(to_integer(pc(10))) <= register_array(to_integer(pc(10))) - mem_data_rd;
						instr_step <= 0;
						pc_advance <= '1';
				end case;
			--INC
			when x"06" =>
				register_array(to_integer(pc(10))) <= register_array(to_integer(pc(10))) + 1;
				pc_advance <= '1';
			--OR
			when x"07" =>
				case(instr_step) is
					when 0 =>
						mem_addr_rd <= pc(9 downto 0);
						instr_step <= 1;
					when 1 =>
						register_array(to_integer(pc(10))) <= register_array(to_integer(pc(10))) or mem_data_rd;
						instr_step <= 0;
						pc_advance <= '1';
				end case;
			--AND
			when x"08" =>
				case(instr_step) is
					when 0 =>
						mem_addr_rd <= pc(9 downto 0);
						instr_step <= 1;
					when 1 =>
						register_array(to_integer(pc(10))) <= register_array(to_integer(pc(10))) and mem_data_rd;
						instr_step <= 0;
						pc_advance <= '1';
				end case;
			--NOT
			when x"09" =>
				register_array(to_integer(pc(10))) <= not register_array(to_integer(pc(10)));
			--JP (Jump if Positive)
			when x"0A" =>
				case(instr_step) is
					when 0 =>
						--if register is negitive, jump. Else, advance pc
						if register_array(to_integer(pc(10))) > 0 then
							mem_addr_rd <= pc(9 downto 0);
							instr_step <= 1;
						else
							pc_advance <= '1';
						end if;
					when 1 =>
						--to write pc, use its register reference
						register_array(10) <= mem_data_rd;
						instr_step <= 0;
						--don't advance the pc: we just set it!
				end case;
			--JZ (Jump if Zero)
			when x"0B" =>
				case(instr_step) is
					when 0 =>
						--if register is negitive, jump. Else, advance pc
						if register_array(to_integer(pc(10))) = 0 then
							mem_addr_rd <= pc(9 downto 0);
							instr_step <= 1;
						else
							pc_advance <= '1';
						end if;
					when 1 =>
						--to write pc, use its register reference
						register_array(10) <= mem_data_rd;
						instr_step <= 0;
						--don't advance the pc: we just set it!
				end case;
			--SHL
			when x"0C" =>
				register_array(to_integer(pc(10))) <= register_array(to_integer(pc(10))) sll 1;
				pc_advance <= '1';
			--SHR
			when x"0D" =>
				register_array(to_integer(pc(10))) <= register_array(to_integer(pc(10))) srl 1;
				pc_advance <= '1';
			--IN (Fill From Switches
			when x"0E" =>
				register_array(to_integer(pc(10)))(7 downto 0) <= sw(7 downto 0);
				pc_advance <= '1';
			--OUT (Light LEDs)
			when x"0E" =>
				leds(7 downto 0) <= register_array(to_integer(pc(10)))(7 downto 0);
				pc_advance <= '1';
		end case;

		--Advance the pc if needed
		if pc_advance = '1' then
			register_array(10) <= register_array(10) + 1;
			pc_advance <= '0';
		end if;
	end process;
end architecture ; -- arch
