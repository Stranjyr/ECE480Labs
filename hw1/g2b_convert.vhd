library ieee;
use ieee.std_logic_1164.all;

entity g2b_convert is
	port(A,B,C,D	:	in std_logic; 		--4 bit input in gray code
			Q,R,S,T	:	out std_logic); 	-- 4 bit output in binary
			
end g2b_convert;

architecture behavior of g2b_convert is
	begin
	
		Q<=A;										--First binary bit is unchanged
		R<= A xor B;							--Each binary bit is the xor of 
		S<= B xor C; 							--current and previous gray code bit
		T<= C xor D;
	
end behavior;