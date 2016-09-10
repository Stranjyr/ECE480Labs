library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity up32 is
  port (
	clock	: in std_logic;
	enable	: in std_logic;
	upper4	: out unsigned(3 downto 0)
  ) ;
end entity ; -- up32

architecture arch of up32 is
signal counter	: unsigned(31 downto 0);
begin
	upper4 <= counter(31 downto 28);
	process(clock, enable)
	begin
		if enable = '0' then null;
		elsif rising_edge(clock) then
			counter <= counter + 1;
		end if;
	end process;
end architecture ; -- arch