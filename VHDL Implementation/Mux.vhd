-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: MUX
-- Desc: Selects one of two input signals based on a control signal.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mux is
  GENERIC(n : integer := 32);
  port( 
		  -- Inputs
        input_1    : in std_logic_vector(n - 1 downto 0);
        input_2    : in std_logic_vector(n - 1 downto 0);
        mux_select : in std_logic; -- Control signal for selecting input

        -- Output
        output     : out std_logic_vector(n - 1 downto 0) 
		 );
end Mux;

architecture Behavioral of Mux is
begin
with mux_select select
  output <= input_1 when '0', input_2 when others;
end Behavioral;