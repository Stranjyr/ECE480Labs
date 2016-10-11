library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Mem_toplevel is
  port (
	clk50 		: in std_logic;
	sw 			: in std_logic_vector(9 downto 0); -- sw 9-0
	key 		: in std_logic_vector(3 downto 0); -- keys 3-0
	sevenSeg	: out std_logic_vector(27 downto 0) --seven seg outputs
  ) ;
end entity ; -- Mem_toplevel

architecture arch of Mem_toplevel is

	--clock signals
	signal clk1 	: std_logic;
	signal clk10 	: std_logic;
	signal clk100 	: std_logic;
	--signals for the memory component
	signal mem_input 	: std_logic_vector(5 downto 0);
	signal mem_wr_addr 	: std_logic_vector(5 downto 0);
	signal mem_rd_addr 	: std_logic_vector(5 downto 0);
	signal mem_output  	: std_logic_vector(5 downto 0);
	--upcounter signals
	signal upcount_data 	: unsigned(5 downto 0);
	signal upcount_data_clk : std_logic;
	signal upcount_addr_rd 	: unsigned(5 downto 0);
	signal upcount_addr_rd_clk : std_logic;
	signal upcount_addr_wr 	: unsigned(5 downto 0);
	signal upcount_addr_wr_clk : std_logic;
	--Components
	component sevenSeg_2bit
	port (
		value : in unsigned(7 downto 0);
		segments : out std_logic_vector(13 downto 0)
		);
	end component;

	component clk_div
	port(	
		clock_50mhz		: in	std_logic;
		clock_1mhz		: out	std_logic;
		clock_100khz	: out	std_logic;
		clock_10khz		: out	std_logic;
		clock_1khz		: out	std_logic;
		clock_100hz		: out	std_logic;
		clock_10hz		: out	std_logic;
		clock_1hz		: out	std_logic);
	end component;

begin
	--clock selectors
	upcount_data_clk <= clk100 when sw(7) = '1' else key(0);
	upcount_addr_wr_clk <= clk10 when sw(9) = '1' else key(0);
	upcount_addr_rd_clk <= clk1 when sw(8) = '1' else key(0);

	--mem_input selectors
	mem_input <= upcount_data when key(1) = '1' else sw(5 downto 0);
	mem_wr_addr <= upcount_addr_wr when key(2) = '1' else sw(5 downto 0);
	mem_rd_addr <= upcount_addr_rd when key(3) = '1' else sw(5 downto 0);

	--upcounter processes
	uc_data : process(upcount_data_clk)
	begin
		if rising_edge(upcount_data_clk) then
			upcount_data <= upcount_data + 1;
		end if;
	end process;

	uc_addr_wr : process(upcount_addr_wr_clk)
	begin
		if rising_edge(upcount_addr_wr_clk) then
			upcount_addr_wr <= upcount_addr_wr + 1;
		end if;
	end process;

	uc_addr_rd : process(upcount_addr_rd_clk)
	begin
		if rising_edge(upcount_addr_rd_clk) then
			upcount_addr_rd <= upcount_addr_rd + 1;
		end if;
	end process;

	--Seven Segment Setup
	data_out_ss: sevenSeg_2bit
	port map(
		value => mem_output,
		segments => sevenSeg(13 downto 0)
		);
	
	rd_addr_ss : sevenSeg_2bit
	port map(
		value => mem_rd_addr,
		segments => sevenSeg(27 downto 14)
		);

	--clock setup
	main_clock : clk_div
	port map (	
		clock_50mhz		=> clk50,
		clock_1mhz		=> open,
		clock_100khz	=> open,
		clock_10khz		=> open,
		clock_1khz		=> open,
		clock_100hz		=> clk100,
		clock_10hz		=> clk10,
		clock_1hz		=> clk1);

	--memory setup
	

end architecture ; -- arch