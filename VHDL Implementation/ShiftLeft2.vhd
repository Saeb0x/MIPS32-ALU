-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: Shift Left 2
-- Desc: Shifts the input value to the left by two positions, effectively multiplying it by 4.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftLeft2 is
  port( 
		  -- Input
        input  : in std_logic_vector(31 downto 0);

        -- Output
        output : out std_logic_vector(31 downto 0) 
		 );
end ShiftLeft2;

architecture Behavioral of ShiftLeft2 is
begin
  output <= std_logic_vector(unsigned(input) sll 2);
end Behavioral;