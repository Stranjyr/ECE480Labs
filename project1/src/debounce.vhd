--------------------------------------------------------------------------------
--
--   FileName:         debounce.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 3/26/2012 Scott Larson
--     Initial Public Release
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--   FileName:         debounce.vhd
--   Dependencies:     none
--   Design Software:  Quartus Prime 64-bit Version 16.0
--
--   Modified by Jeff Jackson to use ieee.numeric_std and for readability
--   Version 1.1 10/12/2016 Jeff Jackson

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--   FileName:         debounce.vhd
--   Dependencies:     none
--   Design Software:  Quartus Prime 64-bit Version 16.0
--
--   Modified by Luke Haynes & William Hampton to [Any changes we make]
--   Version 1.0 10/20/2016 Luke Haynes & William Hampton 
--------------------------------------------------------------------------------

library 	ieee;
use 		ieee.std_logic_1164.all;
use 		ieee.numeric_std.all;

entity debounce is
  generic(
    counter_size  :  integer := 20); 			-- counter size (20 bits gives approx. 20ms debounce with 50mhz clock)
  port(
    clk     			: in  std_logic := '0'; -- input clock (50 MHz)
    button  			: in  std_logic := '0'; -- input signal to be debounced
    debounced_button : out std_logic);       -- debounced output signal
end debounce;

architecture logic of debounce is
  signal ff   			: std_logic_vector(2 downto 0) := (others => '0');  		-- flip flops used to debounce signal
  signal counter_set : std_logic;                                          	-- sync reset to zero
  signal counter_out : unsigned(counter_size downto 0) := (others => '0'); 	-- counter output
begin

  debounced_button <= ff(2);
  counter_set <= ff(0) xor ff(1);   -- determine when to start/reset counter
  
  process(clk)
  begin
    if(rising_edge(clk)) then
      ff(1 downto 0) <= ff(0) & button;
      if(counter_set = '1') then                  -- reset counter because input is changing
        counter_out <= (others => '0');
      elsif(counter_out(counter_size) = '0') then -- stable input time is not yet met
        counter_out <= counter_out + 1;
      else                                        -- stable input time is met
        ff(2) <= ff(1);
      end if;    
    end if;
  end process;
end logic;
