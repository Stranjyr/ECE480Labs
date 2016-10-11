library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenSeg_2bit is
  port (
	value : in unsigned(7 downto 0);
	segments : out std_logic_vector(13 downto 0)
  ) ;
end entity ; -- sevenSeg

architecture arch of sevenSeg is
	signal upperSeg : unsigned(3 downto 0);
	signal lowerSeg : unsigned(3 downto 0);
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
	--A : 1110111
	--b : 1111100
	--C : 0111001
	--d : 1011110
	--E : 1111001
	--F : 1110001
begin
	upperSeg <= value(7 downto 4);
	lowerSeg <= value(3 downto 0);
	with upperSeg select
		segments(13 downto 7) <= "0111111" when x"0",
								 "0000110" when x"1",
								 "1011011" when x"2",
								 "1001111" when x"3",
								 "1100110" when x"4",
								 "1101101" when x"5",
								 "1111101" when x"6",
								 "0000111" when x"7",
								 "1111111" when x"8",
								 "1100111" when x"9",
								 "1110111" when x"A",
								 "1111100" when x"B",
								 "0111001" when x"C",
								 "1011110" when x"D",
								 "1111001" when x"E",
								 "1110001" when x"F",
								 "0000000" when others;
	with lowerSeg select
		segments(6 downto 0) <=  "0111111" when x"0",
								 "0000110" when x"1",
								 "1011011" when x"2",
								 "1001111" when x"3",
								 "1100110" when x"4",
								 "1101101" when x"5",
								 "1111101" when x"6",
								 "0000111" when x"7",
								 "1111111" when x"8",
								 "1100111" when x"9",
								 "1110111" when x"A",
								 "1111100" when x"B",
								 "0111001" when x"C",
								 "1011110" when x"D",
								 "1111001" when x"E",
								 "1110001" when x"F",
								 "0000000" when others;


end architecture ; -- arch