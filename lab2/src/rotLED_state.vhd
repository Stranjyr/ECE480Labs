library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.rotRegister;
use work.clk_div;

entity rotLED is
  port (
	clk50	: in std_logic;
	speed	: in std_logic;
	dir	: in std_logic;
	leds	: out std_logic_vector(7 downto 0)
  ) ;

end entity ; -- rotLED

architecture arch of rotLED is
	type fsm_state is (left1, left10, right1, right10);
	signal state : fsm_state;
	signal led_state : std_logic_vector(7 downto 0);
	signal clk10 : std_logic;
	signal clk1  : std_logic;
	signal regClock : std_logic;
	signal regDir : std_logic;
	signal dirspeed : std_logic_vector(1 downto 0);
begin
	leds <= led_state;
	dirspeed <= dir & speed;
	process(clk50) --FSM runs on a clock much faster than our LED update
	begin
		if rising_edge(clk50) then
			case state is
				when left1 => 
					case (dirspeed) is --exit the state based on direction and speed
						when "11" =>
							state <= right1;
						when "10" =>
							state <= right10;
						when "01" => 
							state <= left1;
						when others =>
							state <= left10;
					end case;
				when left10 => 
					case (dirspeed) is
						when "11" =>
							state <= right1;
						when "10" =>
							state <= right10;
						when "01" => 
							state <= left1;
						when others =>
							state <= left10;
					end case;
				when right1 => 
					case (dirspeed) is
						when "11" =>
							state <= right1;
						when "10" =>
							state <= right10;
						when "01" => 
							state <= left1;
						when others =>
							state <= left10;
					end case;
				when right10 => 
					case (dirspeed) is
						when "11" =>
							state <= right1;
						when "10" =>
							state <= right10;
						when "01" => 
							state <= left1;
						when others =>
							state <= left10;
					end case;
			end case;
		end if;
	end process;
	
	process(state) --use the current state to determine the direction and clock to pass
					-- to the rotate register
	begin
		case state is
			when left1 =>
				regDir <= '0';
				regClock <= clk1;
			when right1 =>
				regDir <= '1';
				regClock <= clk1;
			when left10 =>
				regDir <= '0';
				regClock <= clk10;
			when right10 =>
				regDir <= '1';
				regClock <= clk10;
		end case;
	end process;				

	configClock : clk_div --use existing clock divider
	port map(
		clock_50mhz		=> clk50,
		clock_1mhz		=> open,
		clock_100khz	=> open,
		clock_10khz		=> open,
		clock_1khz		=> open,
		clock_100hz		=> open,
		clock_10hz		=> clk10,
		clock_1hz		=> clk1);
	
	ledReg : rotRegister --map signals to rotate register
	port map(
		clock 	=> regClock, --clock switched on state
		dir 	=> regDir,   --direction switched on state
		set 	=> '0', --We don't reset the rotate register
		inReg	=> (others => '0'), --dito
		q		=> led_state --output of leds drawn from rotate register
		);
end architecture ; -- arch