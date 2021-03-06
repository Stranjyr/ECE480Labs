library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ball_rom is
    generic( address_width : integer := 6;
             data_width    : integer := 8);
    port( clock              : in  std_logic;
          frame				  : in  std_logic_vector(2 downto 0);
          frame_row, frame_col : in  std_logic_vector(2 downto 0);
          rom_mux_output     : out std_logic);
end ball_rom;

architecture behavior of ball_rom is
  type       rom is array(0 to 2**address_width-1) of std_logic_vector(data_width-1 downto 0);
  signal     rom_block : rom;
  attribute  ram_init_file : string;
  attribute  ram_init_file of rom_block : signal is "ball.mif";
	
  signal     rom_data    : std_logic_vector(data_width-1 downto 0);
  signal     rom_address : std_logic_vector(address_width-1 downto 0);
begin
  -- small 8 by 8 character generator rom for video display
  -- each character is 8 8-bits words of pixel data
  rom_address <= frame & frame_row;

  -- mux to pick off correct rom data bit from 8-bit word
  -- for on screen character generation
  rom_mux_output <= rom_data(to_integer(unsigned(not frame_col(2 downto 0))));

  process (clock)
  begin
    if rising_edge(clock) then
      rom_data <= rom_block(to_integer(unsigned(rom_address)));
    end if;
  end process;
  
end behavior;