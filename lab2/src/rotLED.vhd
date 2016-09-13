library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.rotRegister;
use work.clk_div;

entity rotLED is
  port (
	clk50	: in std_logic;
	speed	: in std_logic;
	dir	: in std_logic;
	leds	: out std_logic_vector(7 downto 0)
  ) ;

end entity ; -- rotLED

architecture arch of rotLED is
	signal led_state : std_logic_vector(7 downto 0);
	signal clk10 : std_logic;
	signal clk1  : std_logic;
	signal regClock : std_logic;
begin
	leds <= led_state;
	regClock <= clk10 when speed = '0' else clk1;
	configClock : clk_div
	port map(
		clock_50mhz		=> clk50,
		clock_1mhz		=> open,
		clock_100khz	=> open,
		clock_10khz		=> open,
		clock_1khz		=> open,
		clock_100hz		=> open,
		clock_10hz		=> clk10,
		clock_1hz		=> clk1);
	
	ledReg : rotRegister
	port map(
		clock 	=> regClock,
		dir 	=> dir,
		set 	=> '0',
		inReg	=> (others => '0'),
		q		=> led_state
		);
end architecture ; -- arch