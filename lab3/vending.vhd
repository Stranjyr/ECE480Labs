library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.sevenSeg;

entity vending is
  port (
	clock : in std_logic;
	n : in std_logic; --active low
	d : in std_logic; --active low
	q : in std_logic; --active low
	--outputs
	p : out std_logic;
	total : out std_logic_vector(13 downto 0)
  ) ;
end entity ; -- vending

architecture arch of vending is

	signal total_in : integer range 0 to 50;
	type vendState is (zero, five, ten, fifteen, twenty, twentyfive, thirty, thirtyfive, fourty, fourtyfive);
	signal state : vendState := zero;
	signal total_out : std_logic_vector(13 downto 0);


begin
	display : sevenSeg
		port map(total_in, total_out);

	--invert output of sevenSeg component
	total <= not total_out;
	--main state machine process
	process(clock)
	begin
		if rising_edge(clock) then
			p <= '0'; --reset output every clock
			case(state) is
				when zero =>
					
					if n = '0' then
						state <= five;
					elsif d = '0' then
						state <= ten;
					elsif q = '0' then
						state <= twentyfive;
					end if;
				when five =>
					
					if n = '0' then
						state <= ten;
					elsif d = '0' then
						state <= fifteen;
					elsif q = '0' then
						state <= thirty;
					end if;
				when ten =>
					
					if n = '0' then
						state <= fifteen;
					elsif d = '0' then
						state <= twenty;
					elsif q = '0' then
						state <= thirtyfive;
					end if;
				when fifteen =>
					
					if n = '0' then
						state <= twenty;
					elsif d = '0' then
						state <= twentyfive;
					elsif q = '0' then
						state <= fourty;
					end if;
				when twenty =>
					
					if n = '0' then
						state <= twentyfive;
					elsif d = '0' then
						state <= thirty;
					elsif q = '0' then
						state <= fourtyfive;
					end if;
				when twentyfive =>
					
					if n = '0' then
						state <= thirty;
					elsif d = '0' then
						state <= thirtyfive;
					elsif q = '0' then
						p <= '1';
						state <= zero;
					end if;
				when thirty =>
					
					if n = '0' then
						state <= thirtyfive;
					elsif d = '0' then
						state <= fourty;
					elsif q = '0' then
						p <= '1';
						state <= five;
					end if;
				when thirtyfive =>
					
					if n = '0' then
						state <= fourty;
					elsif d = '0' then
						state <= fourtyfive;
					elsif q = '0' then
						p <= '1';
						state <= ten;
					end if;
				when fourty =>
					
					if n = '0' then
						state <= fourtyfive;
					elsif d = '0' then
						p <= '1';
						state <= zero;
					elsif q = '0' then
						p <= '1';
						state <= fifteen;
					end if;
				when fourtyfive =>
					
					if n = '0' then
						p <= '1';
						state <= zero;
					elsif d = '0' then
						p <= '1';
						state <= five;
					elsif q = '0' then
						p <= '1';
						state <= twenty;
					end if;
			end case;
		end if;
	end process;
	with state select
		total_in <= 0 when zero,
					5 when five,
					10 when ten,
					15 when fifteen,
					20 when twenty,
					25 when twentyfive,
					30 when thirty,
					35 when thirtyfive,
					40 when fourty,
					45 when fourtyfive;

end architecture ; -- arch