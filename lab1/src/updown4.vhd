library ieee;
use ieee.std_logic_1164.all; -- used to allow for std_logic data types
use ieee.numeric_std.all; -- used to allow for unsigned data types

entity updown4 is
  port (
	clock 	: in std_logic;
	dir	: in std_logic;
	q	: out unsigned(3 downto 0)
  ) ;
end entity ; -- updown4

architecture arch of updown4 is
	signal count : unsigned(3 downto 0) := '0000'; -- internal signal that can be iteratively modified
begin
	q <= count; --mapping "count" to "q"
	process(clock) --process re-evaluated on every edge of clock
	begin
		if rising_edge(clock) then --on only rising edge
			case dir is --if key is pressed
				when '1' => count <= count+1; --count up
				when others => count <= count-1; --if key is not pressed, count down
			end case;
		end if;
	end process;
end architecture ; -- arch
