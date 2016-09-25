 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port (clk			:in std_logic; -- Clock Signal
			Aen			:in std_logic; --Enable for A flipflop
			ALU_CTL		:in	std_logic_vector(3 downto 0); -- Control signal
			ALU_CTLen	:in 	std_logic; --Enable for control flipflop
			Cen			:in std_logic;	--Enable for output flipflop
			ALUin			:in std_logic_vector(7 downto 0); --Input Signal
			ALUout		:out std_Logic_vector(7 downto 0)); --Output Signal

end entity;

architecture behavior of alu is --Behavioral
	signal FF_Out_8,ALU_out_8	:std_logic_vector(7 downto 0); -- Output signals for A flipflop and ALU
	signal FF_Out_4				:std_logic_vector(3 downto 0); -- Output signal for control Flipflop
				
begin

	process(clk,Aen,ALU_CTLen,Cen) --FlipFlop Process
		begin
		if rising_edge(clk) then --Flipflop only moves on rising edge
		if Aen = '1' then	 --If Flipflop A is enabled, push ALUin through
			FF_Out_8<=ALUin;
			else null;
			end if;
			
			if ALU_CTLen = '1' then --If Control Flipflop is enabled, push control signal through
				FF_Out_4 <=ALU_CTL;
			else null;
			end if;
			
			if Cen = '1' then		--If Output Flipflop is enabled, push output through
				ALUout<=ALU_Out_8;
			else null;
			end if;
		else null;
		end if;
	end process;

--	FF_Out_8<="10000101";
	
	with (ALU_CTL) select	--Function depending on control signal
		ALU_Out_8<=
						std_logic_vector(unsigned(FF_Out_8) + unsigned(ALUin)) 	when "0000", -- A+B
						std_logic_vector(unsigned(FF_Out_8) - unsigned(ALUin)) 	when "0001", -- A-B
						FF_Out_8 AND ALUin					 	 							when "0010", -- A AND B
						FF_Out_8 OR ALUin						 	 							when "0011", -- A OR B
						'0'&ALUin(7 downto 1)				 								when "0100", -- Shift B Right
						ALUin(7)&ALUin(7 downto 1)			  	 							when "0101", -- Arithmatic Shift B Right
						ALUin(6 downto 0)&'0'				  	 							when "0110", -- Shift B Left
						NOT ALUin								  	 							when "0111", -- NOT B
						ALUin 									  	 							when "1000", -- C=B
						std_logic_vector(unsigned(ALUin)+1)								when "1001", --Increment B
						ALU_Out_8								  	 							when others; --If none of these, change nothing
end architecture;