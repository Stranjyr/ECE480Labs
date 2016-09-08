library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.rotRegister;

entity rotLED is
  port (
	clk50	: in std_logic;
	speed	: in std_logic;
	dir		: in std_logic;
	leds	: out std_logic_vector(7 downto 0)
  ) ;

end entity ; -- rotLED

architecture arch of rotLED is
	--TODO: Change this for the Cock_div program or similar
	--to get 10 Hz instead of MHz
	component pllClock
		port(
			refclk 	: in std_logic; -- 50 MHz
			rst		: in std_logic;
			outclk_0 : out std_logic; --10 MHz
			outclk_1 : out std_logic  -- 1 MHz
			);
	end component;
	signal led_state : std_logic_vector(7 downto 0);
	signal clk10 : std_logic;
	signal clk1  : std_logic;
	signal regClock : std_logic;
begin
	leds <= led_state;
	regClock <= clk10 when speed = '1' else clk1;

	configClock : pllClock
	port map(
		refclk => clk50,
		rst => '0',
		outclk_0 => clk10,
		outclk_1 => clk1
		);
	ledReg : rotRegister
	port map(
		clock 	=> regClock,
		dir 	=> dir,
		set 	=> '0'
		inReg	=> (others => '0')
		q		=> led_state
		);
end architecture ; -- arch