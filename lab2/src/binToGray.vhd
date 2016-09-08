library ieee;
use ieee.std_logic_1164.all;

entity binToGray is
  generic(
  	size : integer range 1 to 256 := 4
  	);
  port (
	bin : in std_logic_vector(size-1 downto 0);
	gray : out std_logic_vector(size-1 downto 0)
  ) ;
end entity ; -- binToGray

architecture arch of binToGray is
begin
	gray(size-1) <= bin(size-1);
	


end architecture ; -- arch