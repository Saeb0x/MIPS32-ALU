-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: Adder
-- Desc: Adds two input operands together.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder is
  GENERIC(n : integer := 32);
  port( 
		  -- Inputs
        operand_1 : in  std_logic_vector(n - 1 downto 0);
        operand_2 : in  std_logic_vector(n - 1 downto 0);

        -- Output
        result    : out std_logic_vector(n - 1 downto 0) 
		 );
end Adder;

architecture Behavioral of Adder is
begin
  result <= std_logic_vector(unsigned(operand_1) + unsigned(operand_2));
end Behavioral;