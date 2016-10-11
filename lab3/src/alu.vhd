library ieee;
use ieee.std_logic_1164;
use ieee.numeric_std;

entity alu is
  port (
	clk 		: in std_logic;
	Aen_n 		: in std_logic;
	ALU_ctl		: in std_logic_vector(3 downto 0);
	ALU_ctl_en	: in std_logic;
	Cen_n 		: in std_logic;
	ALU_in 		: in std_logic_vector(7 downto 0);
	ALU_out		: out std_logic_vector(7 downto 0)
  ) ;
end entity ; -- alu

architecture arch of alu is

	signal A, B, C 	: std_logic_vector(7 downto 0);
	signal alu_command 	: std_logic_vector(3 downto 0);
	signal new_command 	: std_logic;
	constant add 		: std_logic_vector(3 downto 0) := x"0";
	constant sub 		: std_logic_vector(3 downto 0) := x"1";
	constant logic_and 	: std_logic_vector(3 downto 0) := x"2";
	constant logic_or 	: std_logic_vector(3 downto 0) := x"3";
	constant shift_r 	: std_logic_vector(3 downto 0) := x"4";
	constant ar_shift_r : std_logic_vector(3 downto 0) := x"5";
	constant shift_l	: std_logic_vector(3 downto 0) := x"6";
	constant logic_not	: std_logic_vector(3 downto 0) := x"7";
	constant logic_eq	: std_logic_vector(3 downto 0) := x"8";
	constant inc		: std_logic_vector(3 downto 0) := x"9";
begin
	
	clock_inputs : process(clk)
	begin
		if rising_edge(clk) then
			B <= ALU_in;
			--set A
			if Aen_n = '0' then
				A <= ALU_in;
			end if;
			--set C
			if Cen_n = '0' then
				ALU_out <= C;
			end if;
		end if;
	end process;

	alu_commands : process(ALU_ctl_en)




end architecture ; -- arch