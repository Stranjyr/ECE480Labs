library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.clkmux;
use work.debounce;
use work.clk_div;
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

	--button debounce signals
	signal key_debounce : std_logic_vector(3 downto 0);

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
	signal mem_addr 	: unsigned(9 downto 0);
	signal mem_addr_pc_rd : unsigned(9 downto 0);

	signal mem_data_rd 	: unsigned(15 downto 0);
	signal mem_data_rd_std : std_logic_vector(15 downto 0);
	signal mem_data_wr 	: unsigned(15 downto 0);
	signal mem_data_pc_rd : unsigned(15 downto 0);
	signal mem_data_pc_rd_std : std_logic_vector(15 downto 0);

	signal mem_en_wr 	: std_logic;
	signal mem_clk		: std_logic; --runs much faster than the program clock
	constant addr_mask : unsigned(15 downto 0) := "0000001111111111";

	--Components
	component clkmux
	port ( 	clk0	: in 	std_logic := '0';
			clk1	: in 	std_logic := '0';
			sel		: in 	std_logic := '0';
			clkout	: out 	std_logic);
	end component;
	
	component debounce
	generic(
	    counter_size  :  integer := 20); 			-- counter size (20 bits gives approx. 20ms debounce with 50mhz clock)
	port(
	    clk     		: in  std_logic := '0'; -- input clock (50 MHz)
	    button  		: in  std_logic := '0'; -- input signal to be debounced
	    debounced_button : out std_logic);       -- debounced output signal
	end component;

	component main_memory
	port
	(
		address_a : in std_logic_vector(9 downto 0);
		address_b : in std_logic_vector(9 downto 0);
		clock 		: in std_logic;
		data_a 		: in std_logic_vector(15 downto 0);
		data_b 		: in std_logic_vector(15 downto 0);
		wren_a 		: in std_logic;
		wren_b 		: in std_logic;
		q_a 		: out std_logic_vector(15 downto 0);
		q_b 		: out std_logic_vector(15 downto 0)
	);
	end component;

	component clk_div
	port(	clock_50mhz			: in	std_logic;
     	clock_12p5mhz		: out	std_logic;
		clock_1mhz		: out	std_logic;
		clock_100khz		: out	std_logic;
		clock_10khz		: out	std_logic;
		clock_1khz		: out	std_logic;
		clock_100hz		: out	std_logic;
		clock_10hz		: out	std_logic;
		clock_1hz		: out	std_logic);
	end component;


begin
	--Always have current pc from memory
	mem_addr_pc_rd <= register_array(10)(9 downto 0);
	pc <= mem_data_pc_rd;

	
	--make sure our std read map to the unsigned
	mem_data_rd <= unsigned(mem_data_rd_std);
	mem_data_pc_rd <= unsigned(mem_data_pc_rd_std);
	
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
		variable instr_step : integer range 0 to 7 := 0; --tracks the part of the 
													 --instruction for multi-clock instructions
	begin
	
		if key_debounce(1) = '0'then
			register_array(10) <= x"0000";
			
		elsif rising_edge(clock) then
		--See Instructions.md for a list of instructions and formats
			case(pc(15 downto 11)) is
				--ADD address and Register
				when "00000" => 
					case(instr_step) is
						when 0 =>
							mem_addr <= pc(9 downto 0);
							instr_step := 1;
						when 1 =>
							register_array(to_integer(pc(10 downto 10))) <= register_array(to_integer(pc(10 downto 10))) + mem_data_rd;
							instr_step := 0;
							pc_advance <= '1';
						when others =>
							null;
					end case;
				--STR (Store R Register)
				when "00001" =>
					case(instr_step) is
						when 0 =>
							mem_data_wr <= register_array(to_integer(pc(10 downto 10)));
							mem_addr <= pc(9 downto 0);
							mem_en_wr <= '1';
							instr_step := 1;
						when 1 =>
							mem_en_wr <= '0';
							instr_step := 0;
							pc_advance <= '1';
						when others =>
							null;
					end case;
				--LDR (Load R Register)
				when "00010" =>
					case(instr_step) is
						when 0 =>
							mem_addr <= pc(9 downto 0);
							instr_step := 1;
						when 1 =>
							register_array(to_integer(pc(10 downto 10))) <= mem_data_rd;
							instr_step := 0;
							pc_advance <= '1';
						when others =>
							null;
					end case;
				--JMP
				when "00011" =>
					register_array(10) <= pc and addr_mask;
					--don't advance the pc: we just set it!
				--JN (Jump if Negitive)
				when "00100" =>
					--if register is negitive, jump. Else, advance pc
					if signed(register_array(to_integer(pc(10 downto 10)))) < 0 then
						register_array(10) <= pc and addr_mask;
						--don't advance the pc: we just set it!
					else
						pc_advance <= '1';
					end if;
				--SUB
				when "00101" =>
					case(instr_step) is
						when 0 =>
							mem_addr <= pc(9 downto 0);
							instr_step := 1;
						when 1 =>
							register_array(to_integer(pc(10 downto 10))) <= register_array(to_integer(pc(10 downto 10))) - mem_data_rd;
							instr_step := 0;
							pc_advance <= '1';
						when others =>
							null;
					end case;
				--INC
				when "00110" =>
					register_array(to_integer(pc(10 downto 10))) <= register_array(to_integer(pc(10 downto 10))) + 1;
					pc_advance <= '1';
				--OR
				when "00111" =>
					case(instr_step) is
						when 0 =>
							mem_addr <= pc(9 downto 0);
							instr_step := 1;
						when 1 =>
							register_array(to_integer(pc(10 downto 10))) <= register_array(to_integer(pc(10 downto 10))) or mem_data_rd;
							instr_step := 0;
							pc_advance <= '1';
						when others =>
							null;
					end case;
				--AND
				when "01000" =>
					case(instr_step) is
						when 0 =>
							mem_addr <= pc(9 downto 0);
							instr_step := 1;
						when 1 =>
							register_array(to_integer(pc(10 downto 10))) <= register_array(to_integer(pc(10 downto 10))) and mem_data_rd;
							instr_step := 0;
							pc_advance <= '1';
						when others =>
							null;
					end case;
				--NOT
				when "01001" =>
					register_array(to_integer(pc(10 downto 10))) <= not register_array(to_integer(pc(10 downto 10)));
				--JP (Jump if Positive)
				when "01010" =>
					--if register is positive, jump. Else, advance pc
					if signed(register_array(to_integer(pc(10 downto 10)))) > 0 then
						register_array(10) <= pc and addr_mask;
						--don't advance the pc: we just set it!
					else
						pc_advance <= '1';
					end if;
				--JZ (Jump if Zero)
				when "01011" =>
					--if register is 0, jump. Else, advance pc
					if register_array(to_integer(pc(10 downto 10))) = 0 then
						register_array(10) <= pc and addr_mask;
						--don't advance the pc: we just set it!
					else
						pc_advance <= '1';
					end if;
				--SHL
				when "01100" =>
					register_array(to_integer(pc(10 downto 10))) <= register_array(to_integer(pc(10 downto 10))) sll 1;
					pc_advance <= '1';
				--SHR
				when "01101" =>
					register_array(to_integer(pc(10 downto 10))) <= register_array(to_integer(pc(10 downto 10))) srl 1;
					pc_advance <= '1';
				--IN (Fill From Switches
				when "01110" =>
					register_array(to_integer(pc(10 downto 10)))(7 downto 0) <= unsigned(sw(7 downto 0));
					pc_advance <= '1';
				--OUT (Light LEDs)
				when "01111" =>
					leds(7 downto 0) <= std_logic_vector(register_array(to_integer(pc(10 downto 10)))(7 downto 0));
					pc_advance <= '1';
				--Add_i (Add val address to R)
				when "10000" =>
					register_array(to_integer(pc(10 downto 10))) <= register_array(to_integer(pc(10 downto 10))) + pc(9 downto 0);
					pc_advance <= '1';
				--ADDe_i
				when "10001" =>
					register_array(to_integer(pc(10 downto 8))) <= register_array(to_integer(pc(10 downto 8))) + pc(7 downto 0);
					pc_advance <= '1';
				--ADDe_r
				when "10010" =>
					register_array(to_integer(pc(10 downto 7))) <= register_array(to_integer(pc(6 downto 3))) + register_array(to_integer(pc(2 downto 0)));
					pc_advance <= '1';
			     	--SUB_i
			   when "10011" =>
			     	register_array(to_integer(pc(10 downto 10))) <= register_array(to_integer(pc(10 downto 10))) - pc(9 downto 0);
			     	pc_advance <= '1';
				--SUBe_i
			   when "10100" =>
			     	register_array(to_integer(pc(10 downto 8))) <= register_array(to_integer(pc(10 downto 8))) - pc(7 downto 0);
			     	pc_advance <= '1';
			     	--SUBe_r
			   when "10101" =>
			     	register_array(to_integer(pc(10 downto 7))) <=register_array(to_integer(pc(6 downto 3))) - register_array(to_integer(pc(2 downto 0)));
					pc_advance <= '1';
				--LW
				when "10110" =>
					case(instr_step) is
						when 0 =>
							mem_addr <= register_array(to_integer(pc(6 downto 3)))(9 downto 0) + register_array(to_integer(pc(2 downto 0)))(9 downto 0);
							instr_step := 1;
						when 1 =>
							register_array(to_integer(pc(10 downto 7))) <= mem_data_rd;
							instr_step := 0;
							pc_advance <= '1';
						when others =>
							null;
					end case;
				--SW
				when "10111" =>
					case(instr_step) is
						when 0 =>
							mem_data_wr <= register_array(to_integer(pc(10 downto 7)));
							mem_addr <= register_array(to_integer(pc(6 downto 3)))(9 downto 0) + register_array(to_integer(pc(2 downto 0)))(9 downto 0);
							mem_en_wr <= '1';
							instr_step := 1;
						when 1 =>
							mem_en_wr <= '0';
							instr_step := 0;
							pc_advance <= '1';
						when others =>
							null;
					end case;

				--JAL
				when "11000" =>
					register_array(9) <= register_array(10);
					register_array(10) <= pc;
					--dont advance pc
								  
				--BNEe_r
				when "11001" =>
					--if SDR is equal to SDG, advance pc. Else, branch to SDL
					if register_array(to_integer(pc(6 downto 3))) = register_array(to_integer(pc(2 downto 0))) then
						pc_advance <= '1';
					else
						register_array(10) <= register_array(to_integer(pc(10 downto 7)));
						--Don't advance pc
					end if;
				--BEQe_r
				when "11010" =>
					--if SDR is equal to SDG, branch to SDL. Else, advance pc.
					if register_array(to_integer(pc(6 downto 3))) = register_array(to_integer(pc(2 downto 0))) then
						register_array(10) <= register_array(to_integer(pc(10 downto 7)));
						--Don't advance pc
					else
						pc_advance <= '1';
					end if;	
				when others =>
					null;
			end case;
			--Advance the pc if needed
			if pc_advance = '1' then
				register_array(10) <= register_array(10) + 1;
				pc_advance <= '0';
			end if;
		end if;
	end process;
	
	clock_choose : clkmux
	port map
	(
		clk0	=> key_debounce(0),
		clk1	=> clk125,
		sel		=> sw(9),
		clkout	=> clock
	);
	
	debounce_key0 : debounce
	port map
	(
		clk => clk50,
		button => keys(0),
		debounced_button => key_debounce(0)
	);

	debounce_key1 : debounce
	port map
	(
		clk => clk50,
		button => keys(1),
		debounced_button => key_debounce(1)
	);

	main_mem_ram : main_memory
	port map
	(
		address_a => std_logic_vector(mem_addr),
		address_b => std_logic_vector(mem_addr_pc_rd),
		clock 	  => clk50,
		data_a 	  => std_logic_vector(mem_data_wr),
		data_b 	  => (others => '0'),
		wren_a 	  => mem_en_wr,
		wren_b 	  => '0',
		q_a 	  => mem_data_rd_std,
		q_b 	  => mem_data_pc_rd_std
	);

	clock_div : clk_div
	port map (

	clock_50mhz		=> clk50,	
	clock_12p5mhz	=> clk125,
	clock_1mhz		=> open,
	clock_100khz	=> open,
	clock_10khz		=> open,
	clock_1khz		=> open,
	clock_100hz		=> open,
	clock_10hz		=> open,
	clock_1hz		=> open
	);
	
end architecture ; -- arch
