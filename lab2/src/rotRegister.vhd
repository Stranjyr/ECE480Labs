library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--rotRegister is a 2 to 256 bit rotating
--register with a parrallel asynchronos input
entity rotRegister is
  generic(
  	size : integer range 2 to 256 := 8
  	);
  port (
	clock : in std_logic;
	dir 	: in std_logic; --set the rotation direction, 1 for right, 0 for left
	set 	: in std_logic; --strobe to set q to inReg
	inReg	: in std_logic_vector(size -1 downto 0); --set starting registers
	q		: out std_logic_vector(size-1 downto 0)
  ) ;
end entity ; -- rotRegister

architecture arch of rotRegister is
	signal currReg : std_logic_vector(size-1 downto 0) := (0 =>'1', others => '0'); --default value
begin
	q <= currReg;

	process(clock, set)
	begin
		if set = '1' then --blocking async input
			currReg <= inReg;
		elsif rising_edge(clock) then --rotation code
			case dir is
				when '0' =>
					currReg <= currReg(size-2 downto 0) & currReg(size-1); 	--shifts left
				when others =>
					currReg <= currReg(0) & currReg(size-1 downto 1);		--shifts right
				end case;
			end if;
		end process;
end architecture ; -- arch