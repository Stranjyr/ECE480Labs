library ieee;
use  ieee.std_logic_1164.all;
use  ieee.numeric_std.all;

entity clk_div is
port(	clock_50mhz		: in	std_logic;
		clock_1mhz		: out	std_logic;
		clock_100khz	: out	std_logic;
		clock_10khz		: out	std_logic;
		clock_1khz		: out	std_logic;
		clock_100hz		: out	std_logic;
		clock_10hz		: out	std_logic;
		clock_1hz		: out	std_logic);
end clk_div;

architecture behavior of clk_div is
	signal	count_1mhz								: integer range 0 to 63 := 0; 
	signal	count_100khz, count_10khz, count_1khz 	: integer range 0 to 7  := 0;
	signal	count_100hz, count_10hz, count_1hz 		: integer range 0 to 7  := 0;
	signal	clock_1mhz_int, clock_100khz_int		: std_logic := '0';
	signal	clock_10khz_int, clock_1khz_int			: std_logic := '0'; 
	signal	clock_100hz_int, clock_10hz_int			: std_logic := '0';
	signal	clock_1hz_int 							: std_logic := '0';
begin
	process 
	begin
-- divide by 50
		wait until clock_50mhz'event and clock_50mhz = '1';
			if count_1mhz < 49 then
				count_1mhz <= count_1mhz + 1;
			else
				count_1mhz <= 0;
			end if;
			if count_1mhz < 24 then
				clock_1mhz_int <= '0';
			else
				clock_1mhz_int <= '1';
			end if;	

-- ripple clocks are used in this code to save prescalar hardware
-- sync all clock prescalar outputs back to master clock signal
			clock_1mhz 		<= clock_1mhz_int;
			clock_100khz 	<= clock_100khz_int;
			clock_10khz 	<= clock_10khz_int;
			clock_1khz 		<= clock_1khz_int;
			clock_100hz 	<= clock_100hz_int;
			clock_10hz 		<= clock_10hz_int;
			clock_1hz 		<= clock_1hz_int;
	end process;	

	-- divide by 10
	process 
	begin
		wait until clock_1mhz_int'event and clock_1mhz_int = '1';
			if count_100khz /= 4 then
				count_100khz <= count_100khz + 1;
			else
				count_100khz <= 0;
				clock_100khz_int <= not clock_100khz_int;
			end if;
	end process;	

	-- divide by 10
	process
	begin
		wait until clock_100khz_int'event and clock_100khz_int = '1';
			if count_10khz /= 4 then
				count_10khz <= count_10khz + 1;
			else
				count_10khz <= 0;
				clock_10khz_int <= not clock_10khz_int;
			end if;
	end process;	

	-- divide by 10
	process 
	begin
		wait until clock_10khz_int'event and clock_10khz_int = '1';
			if count_1khz /= 4 then
				count_1khz <= count_1khz + 1;
			else
				count_1khz <= 0;
				clock_1khz_int <= not clock_1khz_int;
			end if;
	end process;	

	-- divide by 10
	process 
	begin
		wait until clock_1khz_int'event and clock_1khz_int = '1';
			if count_100hz /= 4 then
				count_100hz <= count_100hz + 1;
			else
				count_100hz <= 0;
				clock_100hz_int <= not clock_100hz_int;
			end if;
	end process;	

	-- divide by 10
	process 
	begin
		wait until clock_100hz_int'event and clock_100hz_int = '1';
			if count_10hz /= 4 then
				count_10hz <= count_10hz + 1;
			else
				count_10hz <= 0;
				clock_10hz_int <= not clock_10hz_int;
			end if;
	end process;	

	-- divide by 10
	process
	begin
		wait until clock_10hz_int'event and clock_10hz_int = '1';
			if count_1hz /= 4 then
				count_1hz <= count_1hz + 1;
			else
				count_1hz <= 0;
				clock_1hz_int <= not clock_1hz_int;
			end if;
	end process;	
end behavior;
