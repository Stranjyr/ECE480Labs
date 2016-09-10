library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift74164 is
  port (
	A 		: in std_logic;
	B 		: in std_logic;
	clk 	: in std_logic;
	clr_n 	: in std_logic;
	--Q outputs broken out to match datasheet
	Qa		: out std_logic;
	Qb		: out std_logic;
	Qc		: out std_logic;
	Qd		: out std_logic;
	Qe		: out std_logic;
	Qf		: out std_logic;
	Qg		: out std_logic;
	Qh		: out std_logic
  ) ;
end entity ; -- shift74164

architecture arch of shift74164 is
	--Signal vector for colating all the q bits
	signal q_vector	: std_logic_vector(7 downto 0);

begin
	--output assignements
	Qa <= q_vector(7);
	Qb <= q_vector(6);
	Qc <= q_vector(5);
	Qd <= q_vector(4);
	Qe <= q_vector(3);
	Qf <= q_vector(2);
	Qg <= q_vector(1);
	Qh <= q_vector(0);

	--Shifting process
	process(clk, clr_n)
	begin
		--active low clear
		if clr_n = '0' then
			q_vector <= (others => '0');
		--shift register
		elsif rising_edge(clk) then
			--the input is the value of a & b
			--this could be done with the line
			--q_vector = (a and b) & q_vector(7 downto 1);
			--but is done with an if statement for clarity
			if a = '1' and b = '1' then
				q_vector <= '1' & q_vector(7 downto 1);
			else
				q_vector <= '0' & q_vector(7 downto 1);
			end if;
		end if;
	end process;
end architecture ; -- arch