library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity updown4 is
  port (
	clock 	: in std_logic;
	dir		: in std_logic;
	q	: out unsigned(3 downto 0)

  ) ;
end entity ; -- updown4

architecture arch of updown4 is
	signal count : unsigned(3 downto 0) := '0000';
begin
	q <= count;
	process(clock)
	begin
		if rising_edge(clock) then
			case dir is
				when '1' => count <= count+1;
				when others => count <= count-1;
			end case;
		end if;
	end process;

end architecture ; -- arch