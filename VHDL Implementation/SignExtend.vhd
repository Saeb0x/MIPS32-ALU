-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: Sign Extend
-- Desc: Extends a 16-bit input value to a 32-bit signed value by sign-extending the most significant bit.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SignExtend is
  port( 
		  -- Input
        input  : in std_logic_vector(15 downto 0); -- 16-bit

        -- Output
        output : out std_logic_vector(31 downto 0) -- 32-bit sign-extended
		 );
end SignExtend;

architecture Behavioral of SignExtend is
begin
 -- Based on the MSB of the input
 output <= "0000000000000000" & input when (input(15) = '0') else
           "1111111111111111" & input;
end Behavioral;