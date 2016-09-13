library ieee;
use ieee.std_logic_1164.all;

entity b2g_convert is
	port(A,B,C,D	:	in std_logic;
			Q,R,S,T	:	out std_logic);
			
end b2g_convert;

architecture behavior of b2g_convert is
	signal Qs,Rs,Ss,Ts:	std_logic;
	begin
		process(A,B,C,D)
			begin
				Qs<=A;
				Rs<= Qs xor B;
				Ss<= Rs xor C;
				Ts<= Ss xor D;
		end process;
	Q<=Qs;
	R<=Rs;
	S<=Ss;
	T<=Ts;
end behavior;