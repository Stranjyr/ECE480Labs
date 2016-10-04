 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port (clk				:in std_logic; -- Clock Signal
			Aen_n			:in std_logic; --Enable for A flipflop
			ALU_CTLen_n		:in 	std_logic; --Enable for control flipflop
			Cen_n			:in std_logic;	--Enable for output flipflop
			ALUin			:in std_logic_vector(7 downto 0); --Input Signal
			ALUout			:out std_Logic_vector(7 downto 0)); --Output Signal

end entity;

architecture behavior of alu is --Behavioral
	signal A, B, C	:std_logic_vector(7 downto 0); -- Output signals for A flipflop and ALU
	signal ALU_CTL				:std_logic_vector(3 downto 0); -- Control signal
				
begin
	B <= ALUin;
	process(clk) --FlipFlop Process
		begin
		if rising_edge(clk) then --Flipflop only moves on rising edge
			if Aen_n = '0' then	 --If Flipflop A is enabled, push ALUin through
				A<=ALUin;
			end if;
			
			if ALU_CTLen_n = '0' then --If Control Flipflop is enabled, push control signal through
				ALU_CTL <= ALUin (3 downto 0);
			end if;
			
			if Cen_n = '0' then		--If Output Flipflop is enabled, push output through
				ALUout<=C;
			end if;
		end if;
	end process;
	
	with (ALU_CTL) select	--Function depending on control signal
		C <=
						std_logic_vector(unsigned(A) + unsigned(B)) 	when "0000", -- A+B
						std_logic_vector(unsigned(A) - unsigned(B)) 	when "0001", -- A-B
						A AND B					 	 					when "0010", -- A AND B
						A OR B						 	 				when "0011", -- A OR B
						'0'&B(7 downto 1)				 				when "0100", -- Shift B Right
						B(7)&B(7 downto 1)			  	 				when "0101", -- Arithmatic Shift B Right
						B(6 downto 0)&'0'				  	 			when "0110", -- Shift B Left
						NOT B								  	 		when "0111", -- NOT B
						B 									  	 		when "1000", -- C=B
						std_logic_vector(unsigned(B)+1)					when "1001", --Increment B
						C								  	 			when others; --If none of these, change nothing
end architecture;
