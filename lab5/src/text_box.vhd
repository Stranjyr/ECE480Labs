-- Create a simple video display to show the value of a 16-bit register (R) on
-- a VGA monitor.

library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.numeric_std.all;

entity text_box is
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
			vga_red, vga_green,vga_blue : out std_logic;
			pix_row, pix_col : in  unsigned(10 downto 0);
			vert_sync      : in std_logic;
			rom_clock		: in std_logic
	);
end text_box;

architecture behavior of text_box is

    signal pixel_row, pixel_column         : unsigned(10 downto 0);
    signal char_address                    : unsigned(5 downto 0);
    signal char_rom_output                 : std_logic;
    signal red_data, green_data, blue_data : std_logic;
	
	-- Define 16-bit register (R) to display on VGA screen
	 type reg_array is array(9 downto 0) of unsigned(15 downto 0);
	 signal r : reg_array;
	
    component char_rom
    port( clock              : in  std_logic := '0';
          character_address  : in  std_logic_vector(5 downto 0) := (others => '0');
          font_row, font_col : in  std_logic_vector(2 downto 0) := (others => '0');
          rom_mux_output     : out std_logic);
	end component;
	
begin

    
	
    red_data    <= '0';
    blue_data   <= '1';
    -- Output will be green text on a black backgorund
    green_data  <= char_rom_output;
	 pixel_row <= pix_row;
	 pixel_column <= pix_col;
    vga_red   <= red_data;
    vga_green <= green_data;
    vga_blue  <= blue_data;
    char_rom_inst: char_rom port map (
        clock             => rom_clock,
        character_address => std_logic_vector(char_address),
        font_row          => std_logic_vector(pixel_row(2 downto 0)),
        font_col          => std_logic_vector(pixel_column(2 downto 0)),
        rom_mux_output    => char_rom_output
    );
	

	


    -- Use pixel column and row values from the VGA_sync module to determine
    -- when to output the register value. For this code, the output will be on
    -- the second character row (pixel rows 8 through 15) and in the second four
    -- character columns (pixel columns 32 through 63).

    process(pixel_column,pixel_row,r)
    begin
      if (pixel_column >= 32 and (pixel_row >= 8  and pixel_row <= 15)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(0)(15 downto 12) + "110000";
            when "01"   => char_address <= r(0)(11 downto  8) + "110000";
            when "10"   => char_address <= r(0)( 7 downto  4) + "110000";
            when others => char_address <= r(0)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
      elsif (pixel_column >= 32 and (pixel_row >= 24  and pixel_row <= 31)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(1)(15 downto 12) + "110000";
            when "01"   => char_address <= r(1)(11 downto  8) + "110000";
            when "10"   => char_address <= r(1)( 7 downto  4) + "110000";
            when others => char_address <= r(1)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
		  
		 elsif (pixel_column >= 32 and (pixel_row >= 40  and pixel_row <= 47)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(2)(15 downto 12) + "110000";
            when "01"   => char_address <= r(2)(11 downto  8) + "110000";
            when "10"   => char_address <= r(2)( 7 downto  4) + "110000";
            when others => char_address <= r(2)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
		 
		 
		 elsif (pixel_column >= 32 and (pixel_row >= 56  and pixel_row <= 63)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(3)(15 downto 12) + "110000";
            when "01"   => char_address <= r(3)(11 downto  8) + "110000";
            when "10"   => char_address <= r(3)( 7 downto  4) + "110000";
            when others => char_address <= r(3)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
		  
		  elsif (pixel_column >= 32 and (pixel_row >= 72  and pixel_row <= 79)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(4)(15 downto 12) + "110000";
            when "01"   => char_address <= r(4)(11 downto  8) + "110000";
            when "10"   => char_address <= r(4)( 7 downto  4) + "110000";
            when others => char_address <= r(4)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
		  
		  elsif (pixel_column >= 32 and (pixel_row >= 88  and pixel_row <= 95)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(5)(15 downto 12) + "110000";
            when "01"   => char_address <= r(5)(11 downto  8) + "110000";
            when "10"   => char_address <= r(5)( 7 downto  4) + "110000";
            when others => char_address <= r(5)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
		  
		  elsif (pixel_column >= 32 and (pixel_row >= 104  and pixel_row <= 111)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(6)(15 downto 12) + "110000";
            when "01"   => char_address <= r(6)(11 downto  8) + "110000";
            when "10"   => char_address <= r(6)( 7 downto  4) + "110000";
            when others => char_address <= r(6)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
		  
		  elsif (pixel_column >= 32 and (pixel_row >= 120  and pixel_row <= 127)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(7)(15 downto 12) + "110000";
            when "01"   => char_address <= r(7)(11 downto  8) + "110000";
            when "10"   => char_address <= r(7)( 7 downto  4) + "110000";
            when others => char_address <= r(7)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
		  
		  elsif (pixel_column >= 32 and (pixel_row >= 136  and pixel_row <= 143)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(8)(15 downto 12) + "110000";
            when "01"   => char_address <= r(8)(11 downto  8) + "110000";
            when "10"   => char_address <= r(8)( 7 downto  4) + "110000";
            when others => char_address <= r(8)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
		  
		  elsif (pixel_column >= 32 and (pixel_row >= 152  and pixel_row <= 159)) then
        if (pixel_column <= 63) then
          -- Use pixel_col bits 3 and 4 to determine which 4-bit field of
          -- R to display. Adding "110000" to the 4-bit field from the register
          -- will generate the character address to get pixel data from
          -- using the tcgrom.mif data and char_rom.vhd.
          case pixel_column(4 downto 3) is
            when "00"   => char_address <= r(9)(15 downto 12) + "110000";
            when "01"   => char_address <= r(9)(11 downto  8) + "110000";
            when "10"   => char_address <= r(9)( 7 downto  4) + "110000";
            when others => char_address <= r(9)( 3 downto  0) + "110000";
          end case;
        else
          -- If we are past the first 4 character columns then display a space character.
          char_address <= "100000";
        end if;
		 else
        -- If we are not in a character row, then display a space character.
        char_address <= "100000";
      end if;
    end process;
	 
	 process(vert_sync)
	 begin
		if(rising_edge(vert_sync)) then
			r(0) <= in_0;
			r(1) <= in_1;
			r(2) <= in_2;
			r(3) <= in_3;
			r(4) <= in_4;
			r(5) <= in_5;
			r(6) <= in_6;
			r(7) <= in_7;
			r(8) <= in_8;
			r(9) <= in_9;
		end if;
	 end process;

end behavior;