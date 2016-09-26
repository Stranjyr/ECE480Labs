library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenSeg is
  port (
	value : in integer range 0 to 99;
	segments : out std_logic_vector(13 downto 0)
  ) ;
end entity ; -- sevenSeg

architecture arch of sevenSeg is
	signal upperSeg : integer range 0 to 9;
	signal lowerSeg : integer range 0 to 9;
	--sevenseg table
	-- 0
	--5 1
	-- 6
	--4 2
	-- 3
	--0 : 0111111
	--1 : 0000110
	--2 : 1011011
	--3 : 1001111
	--4 : 1100110
	--5 : 1101101
	--6 : 1111101
	--7 : 0000111
	--8 : 1111111
	--9 : 1100111
begin
	upperSeg <= value/10;
	lowerSeg <= value mod 10;
	with upperSeg select
		segments(13 downto 7) <= "0111111" when 0,
								 "0000110" when 1,
								 "1011011" when 2,
								 "1001111" when 3,
								 "1100110" when 4,
								 "1101101" when 5,
								 "1111101" when 6,
								 "0000111" when 7,
								 "1111111" when 8,
								 "1100111" when 9,
								 "0000000" when others;
	with lowerSeg select
		segments(6 downto 0) <=  "0111111" when 0,
								 "0000110" when 1,
								 "1011011" when 2,
								 "1001111" when 3,
								 "1100110" when 4,
								 "1101101" when 5,
								 "1111101" when 6,
								 "0000111" when 7,
								 "1111111" when 8,
								 "1100111" when 9,
								 "0000000" when others;


end architecture ; -- arch