-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: Program Counter
-- Desc: Maintains the address of the next instruction to be fetched.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramCounter is
	GENERIC (n : integer := 32);
	port( 
		-- Inputs
      CLK        : in  std_logic; -- Clock signal
      reset_neg  : in  std_logic;
      next_address    : in  std_logic_vector(n - 1 downto 0);

      -- Output
      current_address : out std_logic_vector(n - 1 downto 0) 
		);
end ProgramCounter;

architecture Behavioral of ProgramCounter is
begin
  process(CLK)
  begin
    if reset_neg = '0' then
      current_address <= (others => '0'); -- Clear address on reset
    elsif rising_edge(CLK) then
      current_address <= next_address;
    end if;
  end process;
end Behavioral;