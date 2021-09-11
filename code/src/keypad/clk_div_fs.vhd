----------------------------------------------------------------------------------
-- Company: Ratner Engineering
-- Engineer: bryan mealy
--
-- Create Date:    15:27:40 04/27/2007
-- Design Name:
-- Module Name:    CLK_DIV_FS
-- Project Name:
-- Description: This divides the input clock frequency into two slower
--              frequencies. The frequencies are set by the the MAX_COUNT
--              constant in the declarative region of the architecture.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-----------------------------------------------------------------------
-- Module to divide the clock
-----------------------------------------------------------------------
entity clk_div_fs is
    Port (       clk : in std_logic;
             clk_out : out std_logic);
end clk_div_fs;

architecture my_clk_div of clk_div_fs is
   constant period : integer := 100000;  -- clock divider for 50% duty cycle
   signal tmp_clks : std_logic := '0';

begin

    my_div_slow: process (clk,tmp_clks)
    variable div_cnt : integer := 0;
    begin

    -- Clock Stuff
    if (rising_edge(clk)) then
       if (div_cnt >= period) then --2.5ms
         tmp_clks <= not tmp_clks;
         div_cnt := 0;
       else
         div_cnt := div_cnt + 1;
       end if;
    end if;
    clk_out <= tmp_clks;

    end process;

end my_clk_div;
