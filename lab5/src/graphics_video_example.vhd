library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

-- Create a simple video display to show a "ball" on a VGA monitor.

entity graphics_video_example is
port( clock_50    : in  std_logic;
      vga_red     : out std_logic_vector(3 downto 0);
      vga_green   : out std_logic_vector(3 downto 0);
      vga_blue    : out std_logic_vector(3 downto 0);
      video_blank : out std_logic;
      video_clock : out std_logic;
      horiz_sync  : out std_logic;
      vert_sync   : out std_logic;
		keys 			: in std_logic_vector(3 downto 0));
end graphics_video_example;

architecture behavior of graphics_video_example is

    component vga_sync
    port ( clock_50mhz, red, green, blue : in  std_logic := '0';
           red_out, green_out, blue_out  : out std_logic;
           horiz_sync_out, vert_sync_out : out std_logic; 
           video_on, pixel_clock         : out std_logic;
           pixel_row, pixel_column       : out unsigned(10 downto 0));
    end component;

	component ball
	generic (
	screenx : integer := 800;
	screeny : integer := 600
	);
	port(	pixel_row, pixel_column : in  unsigned(10 downto 0);
      red,green,blue          : out std_logic;
		ball_x, ball_y				: out signed(10 downto 0);
      vert_sync               : in  std_logic;
		down, up, lft, rgt 	 	: in std_logic;
		rom_clock 					: in std_logic );
	end component;
		
	component text_box
	port( 
			in_0 : in  unsigned(15 downto 0);
			in_1 : in  unsigned(15 downto 0);
			in_2 : in  unsigned(15 downto 0);
			in_3 : in  unsigned(15 downto 0);
			in_4 : in  unsigned(15 downto 0);
			in_5 : in  unsigned(15 downto 0);
			in_6 : in  unsigned(15 downto 0);
			in_7 : in  unsigned(15 downto 0);
			in_8 : in  unsigned(15 downto 0);
			in_9 : in  unsigned(15 downto 0);
			pix_row, pix_col : in  unsigned(10 downto 0);
			vga_red, vga_green,vga_blue : out std_logic;	
			vert_sync       : in std_logic;
			rom_clock 		: in std_logic
	);
	end component;
	
	component text_ram 
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	end component;
	
	--signals
    signal red_ball, green_ball, blue_ball          : std_logic; --ball rgb
	 signal red_text, green_text, blue_text			 : std_logic; -- text rgb
	 signal red_data, green_data, blue_data          : std_logic; --ball rgb
	 signal ball_x, ball_y 											 : signed(10 downto 0);
    signal vga_red_int, vga_green_int, vga_blue_int : std_logic;
    signal video_blank_int                          : std_logic;
    signal video_clock_int                          : std_logic;
    signal v_sync_int                               : std_logic;
    signal h_sync_int                               : std_logic;
    signal pixel_row, pixel_column                  : unsigned(10 downto 0);
	 
	 signal ram_addr : std_logic_vector(3 downto 0);
	 signal ram_data : std_logic_vector(15 downto 0);
	 signal ram_we   : std_logic;
	 signal ram_q 	  : std_logic_vector(15 downto 0);
	 
	 -- Register display
	 type reg_array is array(9 downto 0) of unsigned(15 downto 0);
	 signal textVals : reg_array;
	 
	 signal ram_count : unsigned(3 downto 0);

	 

begin   

	 --port mapping for the components
    vga_ball: ball 
	 generic map(
		screenx => 800,
		screeny => 600
		)
	 port map(
        pixel_row    => pixel_row,
        pixel_column => pixel_column,
        red          => red_ball,
        green        => green_ball,
        blue         => blue_ball,
		  ball_x 		=> ball_x,
		  ball_y			=> ball_y,
        vert_sync    => v_sync_int,
		  down			=> keys(0),
		  up				=> keys(1),
		  lft				=> keys(2),
		  rgt				=> keys(3),
		  rom_clock 	=> video_clock_int
		  );
		
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
	
	all_text : text_box
		port map
		(
				in_0 => textVals(0),
				in_1 => textVals(1),
				in_2 => textVals(2),
				in_3 => textVals(3),
				in_4 => textVals(4),
				in_5 => textVals(5),
				in_6 => textVals(6),
				in_7 => textVals(7),
				in_8 => textVals(8),
				in_9 => textVals(9),
				pix_row => pixel_row, 
				pix_col => pixel_column,
				vga_red => red_text, 
				vga_green => green_text,
				vga_blue => blue_text,
				vert_sync => v_sync_int,
				rom_clock	=> video_clock_int
		);
		
	 read_ram : text_ram
	 port map
	 (
		address	=> ram_addr,
		clock		=> video_clock_int,
		data		=> ram_data,
		wren		=> ram_we,
		q			=> ram_q
	 );

    vert_sync   <= v_sync_int;
    horiz_sync  <= h_sync_int;
    video_clock <= video_clock_int;
    video_blank <= video_blank_int;
	
    vga_red(3 downto 0)   <= (others => vga_red_int);
    vga_green(3 downto 0) <= (others => vga_green_int);
    vga_blue(3 downto 0)  <= (others => vga_blue_int);
	 process(pixel_row)
	 begin
		if pixel_row < 168 then
			red_data <= red_text;
			green_data <= green_text;
			blue_data <= blue_text;
		else
			red_data <= red_ball;
			green_data <= green_ball;
			blue_data <= blue_ball;
		end if;
	end process;
			
	process(video_clock_int)
	begin
		ram_we <= '1';
		case(ram_addr) is
			when "0000" =>
				ram_data <= "00000" & std_logic_vector(ball_x);
				textVals(0) <= unsigned(ram_q);
				ram_addr <= x"1";
			when "0001" =>
				ram_data <= "00000" & std_logic_vector(ball_y);
				textVals(1) <= unsigned(ram_q);
				ram_addr <= x"2";
			when "0010" =>
				ram_data <= "00000" & std_logic_vector(ball_x);
				textVals(2) <= unsigned(ram_q);
				ram_addr <= x"3";
			when "0011" =>
				ram_data <= "00000" & std_logic_vector(ball_y);
				textVals(3) <= unsigned(ram_q);
				ram_addr <= x"4";
			when "0100" =>
				ram_data <= "00000" & std_logic_vector(ball_x);
				textVals(4) <= unsigned(ram_q);
				ram_addr <= x"5";
			when "0101" =>
				ram_data <= "00000" & std_logic_vector(ball_y);
				textVals(5) <= unsigned(ram_q);
				ram_addr <= x"6";
			when "0110" =>
				ram_data <= "00000" & std_logic_vector(ball_x);
				textVals(6) <= unsigned(ram_q);
				ram_addr <= x"7";
			when "0111" =>
				ram_data <= "00000" & std_logic_vector(ball_y);
				textVals(7) <= unsigned(ram_q);
				ram_addr <= x"8";
			when "1000" =>
				ram_data <= "00000" & std_logic_vector(ball_x);
				textVals(8) <= unsigned(ram_q);
				ram_addr <= x"9";
			when "1001" =>
				ram_data <= "00000" & std_logic_vector(ball_y);
				textVals(9) <= unsigned(ram_q);
				ram_addr <= x"0";
			when others =>
				ram_addr <= "0000";
		end case;
	end process;
	
end behavior;