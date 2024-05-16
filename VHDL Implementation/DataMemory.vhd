-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: Data Memory
-- Desc: Stores and retrieves data based on memory addresses. Used for load and store instructions.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataMemory is
  GENERIC(n : integer := 32);
  port( 
		  -- Inputs
        CLK            : in std_logic;
        reset_neg      : in std_logic;
        memory_address : in std_logic_vector(n - 1 downto 0);
        MemWrite       : in std_logic;
        MemRead        : in std_logic;
        data_in        : in std_logic_vector(n - 1 downto 0);

        -- Output
        data_out       : out std_logic_vector(n - 1 downto 0) 
		 );
end DataMemory;

architecture Behavioral of DataMemory is
  type mem_type is array  (127 downto 0) of std_logic_vector(n - 1 downto 0); -- Holds 128 individual 32-bit values
  signal mem: mem_type;

begin
  process(CLK, reset_neg)
  begin
	 if reset_neg = '0' then
      mem <= (others => (others => '0'));
    elsif rising_edge(CLK) then
      if MemWrite = '1' then
        mem(to_integer(unsigned(memory_address))) <= data_in;
      end if;
    end if;
  end process;

  -- Continuous assignment for reading
  data_out <= (mem(to_integer(unsigned(memory_address)))) when MemRead = '1' else (others => '0');
end Behavioral;