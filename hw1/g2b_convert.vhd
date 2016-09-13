library ieee;
use ieee.std_logic_1164.all;

entity g2b_convert is
	port(A,B,C,D	:	in std_logic;
			Q,R,S,T	:	out std_logic);
			
end g2b_convert;

architecture behavior of g2b_convert is
	begin
	
		Q<=A;
		R<= A xor B;
		S<= B xor C;
		T<= C xor D;
	
end behavior;