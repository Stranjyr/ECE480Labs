library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up32 is
  port (
  	--Rising edge clock
	clock	: in std_logic;
	--Active high enable
	enable	: in std_logic;
	--4 bit led driver (active high)
	upper4	: out unsigned(3 downto 0)
  ) ;
end entity ; -- up32

architecture arch of up32 is
--Counter Signal
signal counter	: unsigned(31 downto 0);

begin
	--Output top 4 bits to LEDs
	upper4 <= counter(31 downto 28);
	--Clock based proccess with async enable
	process(clock, enable)
	begin
		--Enable before clock to halt
		if enable = '0' then null;
		--Because processes are sequential,
		--This bit is only reached if
		--enable is 0
		elsif rising_edge(clock) then
			counter <= counter + 1;
		end if;
	end process;
end architecture ; -- arch