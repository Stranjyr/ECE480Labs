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
	--| Name | Value | Use        |
	--|------|-------|------------|
	--| R0   | 0     | General    |
	--| R1   | 1     | General    |
	--| S0   | 2     | Saved      |
	--| S1   | 3     | Saved      |
	--| S2   | 4     | Saved      |
	--| T0   | 5     | Temporary  |
	--| T1   | 6     | Temporary  |
	--| T2   | 7     | Temporary  |
	--| Zero | 8     | Zero Val   |
	--| RA   | 9     | Return Pos |
	--| PC   | 10    | Prog Count |
	--| A0   | 11    | Parameter  |
	--| A1   | 12    | Parameter  |
	--| A2   | 13    | Parameter  |
	--| V0   | 14    | Return Val |
	--| ST   | 15    | Stack Count|
	signal register_array : logic_array;

	--program count Signals
	signal pc : unsigned(15 downto 0);
	signal pc_advance	: std_logic; --end of instruction flag

	--Memory Signals
	signal mem_addr_rd 	: unsigned(9 downto 0);
	signal mem_addr_wr 	: unsigned(9 downto 0);
	signal mem_addr_pc_rd : unsigned(9 downto 0);

	signal mem_data_rd 	: unsigned(15 downto 0);
	signal mem_data_wr 	: unsigned(15 downto 0);
	signal mem_data_pc_rd : unsigned(15 downto 0);

	signal mem_en_wr 	: std_logic;
	signal mem_clk		: std_logic; --runs much faster than the program clock


begin
	--Always have current pc from memory
	mem_addr_pc_rd <= register_array(10)(9 downto 0);
	pc <= mem_data_pc_rd;

	--Keep the zero register locked to zero
	register_array(8) <= (others => '0');
	
	--Instruction Formats
	--R Format
	--:| OP Code    |$R| Addr     |
	--:|15 downto 11|10|9 downto 0| 
	--D Format
	--:|OP Code     | $SDL      | $SDR     | $SDG     |
	--:|15 downto 11|10 downto 7|6 downto 3|2 downto 1|
	--I Format
	--:|OP Code     | $SDL      | Imid     |
	--:|15 downto 11|10 downto 8|7 downto 0|

	--Main loop for processing instructions.
	mainLoop : process(clock)
		variable instr_step : integer range 0 to 15; --tracks the part of the 
													 --instruction for multi-clock instructions
	begin
		if rising_edge(clock) then
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
					register_array(10) <= (9 downto 0 => pc(9 downto 0), others => '0');
					--don't advance the pc: we just set it!
				--JN (Jump if Negitive)
				when x"04" =>
					--if register is negitive, jump. Else, advance pc
					if register_array(to_integer(pc(10))) < 0 then
						register_array(10) <= (9 downto 0 => pc(9 downto 0), others => '0');
						--don't advance the pc: we just set it!
					else
						pc_advance <= '1';
					end if;
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
					--if register is positive, jump. Else, advance pc
					if register_array(to_integer(pc(10))) < 0 then
						register_array(10) <= (9 downto 0 => pc(9 downto 0), others => '0');
						--don't advance the pc: we just set it!
					else
						pc_advance <= '1';
					end if;
				--JZ (Jump if Zero)
				when x"0B" =>
					--if register is 0, jump. Else, advance pc
					if register_array(to_integer(pc(10))) < 0 then
						register_array(10) <= (9 downto 0 => pc(9 downto 0), others => '0');
						--don't advance the pc: we just set it!
					else
						pc_advance <= '1';
					end if;
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
				--Add_i (Add val address to R)
				when x"10" =>
					register_array(to_integer(pc(10))) <= register_array(to_integer(pc(10))) + pc(9 downto 0);
					pc_advance <= '1';
				--ADDe_i
				when x"11" =>
					register_array(to_integer(pc(10 downto 8))) <= register_array(to_integer(pc(10 downto 8))) + pc(7 downto 0);
					pc_advance <= '1';
				--ADDe_r
				when x"12" =>
					register_array(to_integer(pc(10 downto 7))) <= register_array(to_integer(pc(6 downto 3))) + register_array(to_integer(pc(2 downto 0)));
					pc_advance <= '1';
				--SUB_i
				when x"13" =>
					register_array(to_integer(pc(10))) <=register_array(to_integer(pc(10)))-pc(9 downto 0);
					pc_advance <= '1';
				--Sube_i
				when x"14" =>
					register_array(to_integer(pc(10))) <= register_array(to_integer(pc(10 downto 8))- pc(7 downto 0));
					pc_advance =>'1';
				--SUBe_r
				when x"15" =>
					register_array(to_integer(pc(10 downto 7) <= register_array(to_integer(pc(6 downto 3)))-register_array(to_integer(pc(2 downto 0)));
					pc_advance =>'1';
				--LW
				when x"16" =>
					case(instr_step) is
						when 0 =>
							mem_addr_rd <= register_array(to_integer(pc(6 downto 3)))(9 downto 0) + register_array(to_integer(pc(2 downto 0)))(9 downto 0);
							instr_step <= 1;
						when 1 =>
							register_array(to_integer(pc(10 downto 7))) <= mem_data_rd;
							instr_step <= 0;
							pc_advance = '1';
					end case;
				--TODO: SW (see STR)
				--when x"17" =>
				--JAL
				when x"18" =>
					register_array(9) <= register_array(10);
					register_array(10) <= (9 downto 0 => pc(9 downto 0), others => '0');
					--dont advance pc
					
				--TODO: BNEe_r, BEQe_r (see adde_r and JZ)

			end case;
			--Advance the pc if needed
			if pc_advance = '1' then
				register_array(10) <= register_array(10) + 1;
				pc_advance <= '0';
			end if;
		end if;

		
	end process;
end architecture ; -- arch