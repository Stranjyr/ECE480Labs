-- Glitch-free clock switching for unrelated clocks
-- Models glitch free clock multiplexing circuit given in
-- http://www.eetimes.com/electronics-news/4138692/Techniques-to-make-clock-switching-glitch-free

--Code provided by Dr. Jackson
library ieee;
use ieee.std_logic_1164.all;

entity clkmux is
port ( 	clk0	: in 	std_logic := '0';
		clk1	: in 	std_logic := '0';
		sel		: in 	std_logic := '0';
		clkout	: out 	std_logic);
end clkmux;

architecture behavior of clkmux is
	signal clk0_reg : std_logic_vector(1 downto 0) := "00";
	signal clk1_reg : std_logic_vector(1 downto 0) := "00";
begin
	clkout <= (clk0 and clk0_reg(1)) or (clk1 and clk1_reg(1));
	process(clk0)
	begin
		if rising_edge(clk0) then
			clk0_reg(0) <= (not sel) and (not clk1_reg(1));
		end if;
		if falling_edge(clk0) then
			clk0_reg(1) <= clk0_reg(0);
		end if;	
	end process;
	process(clk1)
	begin
		if rising_edge(clk1) then
			clk1_reg(0) <= (sel) and (not clk0_reg(1));
		end if;
		if falling_edge(clk1) then
			clk1_reg(1) <= clk1_reg(0);
		end if;	
	end process;	
end behavior;