library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

-- Create a video display to show a user-controlled "ball" on the bottom half of a  VGA monitor
-- and text on the top half.

entity lab5 is
port( clock_50    : in  std_logic;
		button_left : in 	std_logic;
		button_right: in 	std_logic;
		button_up	: in	std_logic;
		button_down	: in	std_logic;
      vga_red     : out std_logic_vector(3 downto 0);
      vga_green   : out std_logic_vector(3 downto 0);
      vga_blue    : out std_logic_vector(3 downto 0);
      video_blank : out std_logic;
      video_clock : out std_logic;
      horiz_sync  : out std_logic;
      vert_sync   : out std_logic);
end lab5;

architecture behavior of lab5 is

    component vga_sync
    port ( clock_50mhz, red, green, blue : in  std_logic := '0';
           red_out, green_out, blue_out  : out std_logic;
           horiz_sync_out, vert_sync_out : out std_logic; 
           video_on, pixel_clock         : out std_logic;
           pixel_row, pixel_column       : out unsigned(9 downto 0));
    end component;

	component ball
	port( pixel_row, pixel_column 	: in  unsigned(9 downto 0);
      red,green,blue          		: out std_logic;
      vert_sync, horiz_sync   		: in  std_logic
		button_left, button_right		: in std_logic;
		button_up, button_down			: in std_logic);
	end component;
		
    signal red_data, green_data, blue_data          : std_logic;
    signal vga_red_int, vga_green_int, vga_blue_int : std_logic;
    signal video_blank_int                          : std_logic;
    signal video_clock_int                          : std_logic;
    signal v_sync_int                               : std_logic;
    signal h_sync_int                               : std_logic;
    signal pixel_row, pixel_column                  : unsigned(9 downto 0);

begin   

    vga_ball: ball port map(
        pixel_row    => pixel_row,
        pixel_column => pixel_column,
        red          => red_data,
        green        => green_data,
        blue         => blue_data,
        vert_sync    => v_sync_int);
		
    vga_sync_inst: vga_sync port map (
        clock_50mhz    => clock_50,
        red            => red_data,
        green          => green_data,
        blue           => blue_data,
        red_out        => vga_red_int,
        blue_out       => vga_blue_int,
        green_out      => vga_green_int,
        horiz_sync_out => h_sync_int,
        vert_sync_out  => v_sync_int,
        video_on       => video_blank_int,
        pixel_clock    => video_clock_int,
        pixel_row      => pixel_row,
        pixel_column   => pixel_column
	);	
	
    vert_sync   <= v_sync_int;
    horiz_sync  <= h_sync_int;
    video_clock <= video_clock_int;
    video_blank <= video_blank_int;
	
    vga_red(3 downto 0)   <= (others => vga_red_int);
    vga_green(3 downto 0) <= (others => vga_green_int);
    vga_blue(3 downto 0)  <= (others => vga_blue_int);
	
end behavior;