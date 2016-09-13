library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.clk_div;

entity pwm_4 is
  port (
	clk50 : in std_logic;
	cycle : in std_logic_vector(3 downto 0);
	led   : out std_logic
  ) ;
end entity ; -- pwm_4

architecture arch of pwm_4 is
	signal pulse_counter : unsigned(3 downto 0) :="0000"; --counter
	signal clk1hz : std_logic := '0'; 


begin
	process(clk1hz)
	begin
		if rising_edge(clk1hz) then
			if pulse_counter = 9 then
				pulse_counter <= "0000"; --wrap the upcounter at 10 counts
			else
				pulse_counter <= pulse_counter + 1;
			end if;
			if pulse_counter < unsigned(cycle) then --check which part of the duty cycle we are in
				led <= '1'; 
			else
				led <= '0';
			end if;
		end if;	
	end process;

	configClock : clk_div
	port map(
		clock_50mhz		=> clk50,
		clock_1mhz		=> open,
		clock_100khz	=> open,
		clock_10khz		=> open,
		clock_1khz		=> open,
		clock_100hz		=> open,
		clock_10hz		=> open,
		clock_1hz		=> clk1hz);


end architecture ; -- arch