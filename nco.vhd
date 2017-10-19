-------------------------------------------------------------------------
-- nco.vhd - Numerically Controlled Oscillator
--
-- Author: Rick Kimball rick@kimballsoftware.com
-- Date: 10/19/2017
-- Version: 1
--
-- vim: set ts=3 sw=3 expandtab
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-------------------------------------------------------------------------
--
--
entity nco is
   generic(
      clk_freq : integer := 100000000; -- input frequency
      freq     : integer := 100000     -- desired output frequency
   );

   port(
      reset    : in  std_logic; -- active low
      clk_in   : in  std_logic; -- input clock of clk_freq
      clk_out  : out std_logic  -- output square wave of freq
   );
end nco;

-------------------------------------------------------------------------
--
--
architecture behavior of nco is
   constant increment  : integer := (freq*2)-clk_freq;
   signal accumulator  : integer range increment to (freq*2):= 0;
   signal phase_change : std_logic := '0';
   
begin

   process(clk_in, reset)
   begin
      if (reset = '0') then 
         accumulator <= 0;
         phase_change <= '0';
      elsif rising_edge(clk_in) then
         if ( accumulator + increment >= 0 ) then
            accumulator <= accumulator + increment;
            phase_change <= not phase_change;
            clk_out <= phase_change;
         else
            accumulator <= accumulator + increment + clk_freq;
         end if;
      end if;

   end process;

end behavior;
