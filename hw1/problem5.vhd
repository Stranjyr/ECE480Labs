library ieee;
use ieee.std_logic_1164.all;

entity problem5 is
  port (
	a, b, c, d : in std_logic;
	y1, y2 : out std_logic
  ) ;
end entity ; -- problem5

architecture arch of problem5 is
begin
	y1 <= (not a) or b or (not c and not d) or (c and d);
	y2 <= (a and not b and d) or (a and not b and c);
end architecture ; -- arch