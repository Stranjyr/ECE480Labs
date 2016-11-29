-- Bouncing Ball Video 
library 	ieee;
use 		ieee.std_logic_1164.all;
use  		ieee.numeric_std.all;

entity ball is
generic (
	screenx : integer := 800;
	screeny : integer := 600
	);
port( pixel_row, pixel_column : in  unsigned(10 downto 0);
      red,green,blue          : out std_logic;
		ball_x, ball_y				: out signed(10 downto 0);
      vert_sync               : in  std_logic;
		down, up, lft, rgt 	 	: in std_logic;
		rom_clock 					: in std_logic;
		i_frame 						: in std_logic_vector(2 downto 0));
end ball;

architecture behavior of ball is
    -- Video Display Signals   
    signal ball_on     : std_logic;
	 signal frame 			: std_logic_vector(2 downto 0);
	 signal frame_out		: std_logic;
	 signal frame_row, frame_col 	 : std_logic_vector(2 downto 0);
    signal size                   : signed(10 downto 0);  
    signal ball_y_motion          : signed(10 downto 0);
	 signal ball_x_motion          : signed(10 downto 0);
    signal ball_y_pos : signed(10 downto 0) := to_signed(200, 11);
	 signal ball_x_pos : signed(10 downto 0) := to_signed(200, 11);
	 component ball_rom
	 generic( address_width : integer := 6;
             data_width    : integer := 8);
    port( clock              : in  std_logic;
          frame				  : in  std_logic_vector(2 downto 0);
          frame_row, frame_col : in  std_logic_vector(2 downto 0);
          rom_mux_output     : out std_logic);
	end component;
begin

	 animation : ball_rom
	 port map
	 (
		clock => rom_clock,
		frame => frame,
		frame_row => frame_row,
		frame_col => frame_col,
		rom_mux_output => frame_out
	 );
    size       <= to_signed(4,11);
	 frame_row <= std_logic_vector(pixel_row(2 downto 0) - unsigned(ball_y_pos(2 downto 0))+ 4);
	 frame_col <= std_logic_vector(pixel_column(2 downto 0) - unsigned(ball_x_pos(2 downto 0)) + 4);
    -- Colors for pixel data on video signal
    red <=  '1';
    -- Turn off Green and Blue when displaying ball (red "ball" on white background)
    green <=  not ball_on;
    blue <=   not ball_on;	
	 frame <= i_frame;
	 ball_x <= ball_x_pos; --output the position for consumption
	 ball_y <= ball_y_pos; --output the position for consumption
    rgb_display: process(ball_x_pos, ball_y_pos, pixel_column, pixel_row, size)
    begin
      -- Set Ball_on ='1' to display ball
      if (ball_x_pos <= signed(pixel_column) + size) and (ball_x_pos + size - 1 >= signed(pixel_column)) and
         (ball_y_pos <= signed(pixel_row)    + size) and (ball_y_pos + size - 1 >= signed(pixel_row)) then
            ball_on <= frame_out;
      else
        ball_on <= '0';
      end if;
    end process rgb_display;	

    move_ball: process(vert_sync)
    begin
      -- Move ball once every vertical sync
      if rising_edge(vert_sync) then
			--Y movement
        -- Stop at the edges of the screen
        if (ball_y_pos) > screeny - size -size then
          ball_y_pos <= to_signed(screeny, 11) - size -size;
        elsif ball_y_pos < 170+size then
          ball_y_pos <= 170+size;
			 --check which way to mov the ball based on switches
			else
				if down = '0' then
					ball_y_motion <= to_signed(2, 11);
				elsif up = '0' then
					ball_y_motion <= to_signed(-2, 11);
				else
					ball_y_motion <= to_signed(0, 11);
				end if;
				ball_y_pos <= ball_y_pos + ball_y_motion;
        end if;
        -- Compute next ball Y position
       
		  
		  
		  --x movement
        -- Stop at the edges of the screen
        if (ball_x_pos) > screenx - size - size -4 then
          ball_x_pos <= to_signed(screenx, 11) - size - size -4;
        elsif ball_x_pos < size+size then
          ball_x_pos <= size+size;
			 --check which way to mov the ball based on switches
			else
				if lft = '0' then
					ball_x_motion <= to_signed(2, 11);
				elsif rgt = '0' then
					ball_x_motion <= to_signed(-2, 11);
				else
					ball_x_motion <= to_signed(0, 11);
				end if;
				ball_x_pos <= ball_x_pos + ball_x_motion;
        end if;
		 end if;
    end process move_ball;

end behavior;