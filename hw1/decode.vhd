library ieee;
use ieee.std_logic_1164.all;

entity decode is
	Port (G1_n,G2_n:	in std_logic;							--Enable inputs
			ABCD		:	in std_logic_vector(3 downto 0);	--4-bit input to be decoded
			q			:	out std_logic_vector(0 to 15));	--decoded 16 bit output
end decode;

architecture behavior of decode is



begin

	process (G1_n,G2_n,ABCD)									--process triggered on changing enables or inputs
	begin
		if (G1_n = '0' and G2_n='0') then					--if both enable bits are low
			
			case ABCD is											--For each possible input, a single output bit is
				when "0000"=> q<=(0=>'0',others =>'1');	--driven low while all others are driven high
				when "0001"=> q<=(1=>'0',others =>'1');
				when "0010"=> q<=(2=>'0',others =>'1');
				when "0011"=> q<=(3=>'0',others =>'1');
				when "0100"=> q<=(4=>'0',others =>'1');
				when "0101"=> q<=(5=>'0',others =>'1');
				when "0110"=> q<=(6=>'0',others =>'1');
				when "0111"=> q<=(7=>'0',others =>'1');
				when "1000"=> q<=(8=>'0',others =>'1');
				when "1001"=> q<=(9=>'0',others =>'1');
				when "1010"=> q<=(10=>'0',others =>'1');
				when "1011"=> q<=(11=>'0',others =>'1');
				when "1100"=> q<=(12=>'0',others =>'1');
				when "1101"=> q<=(13=>'0',others =>'1');
				when "1110"=> q<=(14=>'0',others =>'1');
				when "1111"=> q<=(15=>'0',others =>'1');
				when others=> null;								--There are no other cases
			end case;
		else q<=(others=>'1');									--If either enable bit is high, all outputs are high
		
		end if;
	end process;
end architecture;