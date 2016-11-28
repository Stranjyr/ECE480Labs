-- Moving Object Display 
library 	ieee;
use 		ieee.std_logic_1164.all;
use  		ieee.numeric_std.all;

entity object is
port( pixel_row, pixel_column 	: in  unsigned(9 downto 0);
      red,green,blue          	: out std_logic;
      vert_sync, horiz_sync   	: in  std_logic
		button_left, button_right	: in std_logic;
		button_up, button_down		: in std_logic);
end ball;

architecture behavior of object is
    -- Video Display Signals   
    signal ball_on, 				    		: std_logic;
    signal size                   		: signed(9 downto 0);  
    signal ball_y_motion, ball_x_motion: signed(9 downto 0);
    signal ball_y_pos, ball_x_pos 		: signed(9 downto 0);
begin           
    size       <= to_signed(8,10);
    ball_x_pos <= to_signed(320,10);
	
    -- Colors for pixel data on video signal
    red <=  '1';
    -- Turn off Green and Blue when displaying ball (red "ball" on white background)
    green <= not ball_on;
    blue <=  not ball_on;	

    rgb_display: process(ball_x_pos, ball_y_pos, pixel_column, pixel_row, size)
    begin
      -- Set Ball_on ='1' to display ball
      if (ball_x_pos <= signed(pixel_column) + size) and (ball_x_pos + size >= signed(pixel_column)) and
         (ball_y_pos <= signed(pixel_row)    + size) and (ball_y_pos + size >= signed(pixel_row)) then
            ball_on <= '1';
      else
        ball_on <= '0';
      end if;
    end process rgb_display;	

    move_ball_vert: process(vert_sync)
    begin
      -- Move ball once every vertical sync
      if rising_edge(vert_sync) then
			if button_up and ((ball_y_pos) < 540 - size) then
				ball_y_motion <= to_signed(2,10);
			elsif button_down and ((ball_y_pos > size)) then
				ball_y_motion <= to_signed(-2,10);
			else
				ball_y_motion <= to_signed (2,0);
			end if;
        -- Compute next ball Y position
        ball_y_pos <= ball_y_pos + ball_y_motion;
      end if;		
    end process move_ball_vert;
	 
    move_ball_horiz: process(horiz_sync)
    begin
      -- Move ball once every horizontal sync
      if rising_edge(horiz_sync) then
			if button_right and ((ball_x_pos) < 800 - size) then
				ball_x_motion <= to_signed(2,10);
			elsif button_left and ((ball_x_pos > size)) then
				ball_x_motion <= to_signed(-2,10);
			else
				ball_x_motion <= to_signed (2,0);
			end if;
        -- Compute next ball X position
        ball_x_pos <= ball_x_pos + ball_x_motion;
      end if;		
    end process move_ball_horiz; 
	 

end behavior;