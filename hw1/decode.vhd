library ieee;
use ieee.std_logic_1164.all;

entity decode is
	Port (G1_n,G2_n:	in std_logic;
			ABCD		:	in std_logic_vector(3 downto 0);
			q			:	out std_logic_vector(0 to 15));
end decode;

architecture behavior of decode is

			signal a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p : std_logic :='1';

begin
	q<=a&b&c&d&e&f&g&h&i&j&k&l&m&n&o&p;
	
	process (G1_n,G2_n,ABCD)
	begin
		if (G1_n = '0' and G2_n='0') then
			
			case ABCD is
				when "0000"=> a<='0';
				when "0001"=> b<='0';
				when "0010"=> c<='0';
				when "0011"=> d<='0';
				when "0100"=> e<='0';
				when "0101"=> f<='0';
				when "0110"=> g<='0';
				when "0111"=> h<='0';
				when "1000"=> i<='0';
				when "1001"=> j<='0';
				when "1010"=> k<='0';
				when "1011"=> l<='0';
				when "1100"=> m<='0';
				when "1101"=> n<='0';
				when "1110"=> o<='0';
				when "1111"=> p<='0';
				when others=> null;
			end case;
		else null;
		end if;
	end process;
end architecture;