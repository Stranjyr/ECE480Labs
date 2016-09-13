library ieee;
use ieee.std_logic_1164.all;

entity b2g_convert is
	port(A,B,C,D	:	in std_logic; 		--4 bit input in binary
			Q,R,S,T	:	out std_logic); 	-- 4 bit output in gray code
			
end b2g_convert;

architecture behavior of b2g_convert is
	signal Qs,Rs,Ss,Ts:	std_logic; 		-- signals to allow us to itteratively define outputs
	begin
		process(A,B,C,D) 						--process whenever any input is altered
			begin
				Qs<=A; 							--First binary bit is unchanged
				Rs<= Qs xor B;					--Each further gray bit is formed by XOR'ing the next
				Ss<= Rs xor C; 				--binary bit with the previously created gray bit
				Ts<= Ss xor D;
		end process;
	Q<=Qs; 										--intermediate signals remapped to outputs
	R<=Rs;
	S<=Ss;
	T<=Ts;
end behavior;