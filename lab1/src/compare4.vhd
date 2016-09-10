library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compare4 is
	port(
		a, b 	: in unsigned(3 downto 0);
		AeqB	: out std_logic;
		AltB	: out std_logic;
		AgtB	: out std_logic
		);
end compare4;

architecture arch of compare4 is

begin
	AeqB <= '1' when a = b else '0';
	AltB <= '1' when a < b else '0';
	AgtB <= '1' when a > b else '0';

end architecture ; -- arch