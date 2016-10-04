library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.clk_div;

entity pwm_8 is
  port (
	clk50 : in std_logic;
	cycle : in std_logic_vector(7 downto 0);
	led   : out std_logic
  ) ;
end entity ; -- pwm_8

architecture arch of pwm_8 is
	signal pulse_counter : unsigned(7 downto 0) :="00000000";
	signal clk100 : std_logic := '0';
	signal FourSec:	unsigned(1 downto 0) :="00";

begin
	process(clk100)
	begin
		if rising_edge(clk100) then
			if (pulse_counter = 255 and foursec = 3) then --wrap the pulse counter
				pulse_counter <= "00000000";
			else
				if FourSec = 0 then  --increment pulse_counter every .04 seconds (since 10/255 ~= .04)
					pulse_counter <= pulse_counter + 1;
				end if;
				
				if pulse_counter < unsigned(cycle) then --check what part 
					led <= '1';
				else
					led <= '0';
				end if;
			end if;	
			FourSec<=FourSec+1;
		end if;	
	end process;

	configClock : clk_div
	port map(
		clock_50mhz		=> clk50,
		clock_1mhz		=> open,
		clock_100khz	=> open,
		clock_10khz		=> open,
		clock_1khz		=> open,
		clock_100hz		=> clk100,
		clock_10hz		=> open,
		clock_1hz		=> open);


end architecture ; -- arch