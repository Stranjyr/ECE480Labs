library ieee;
use ieee.std_logic_1164.all;

entity pwm_4 is
  port (
	clk50 : in std_logic;
	cycle : in std_logic_vector(3 downto 0);
	led   : out std_logic
  ) ;
end entity ; -- pwm_4

architecture arch of pwm_4 is
	signal pulse_counter : unsigned(4 downto 0);
	signal clk1hz : std_logic := 0;


begin
	process(clk1hz)
	begin
		if pulse_counter = 9 then
			pulse_counter = 0;
		else
			pulse_counter <= pulse_counter + 1;
		if pulse_counter > unsigned()


end architecture ; -- arch