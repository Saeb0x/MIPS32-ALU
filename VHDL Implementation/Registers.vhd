-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: Registers
-- Desc: Stores data and operands temporarily during program execution.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Registers is
  GENERIC(n : integer := 32);
  port( 
		  -- Inputs
        CLK          : in std_logic;
        reset_neg    : in std_logic;
        address_in_1 : in std_logic_vector(4 downto 0);
        address_in_2 : in std_logic_vector(4 downto 0);
        address_out  : in std_logic_vector(4 downto 0);

        write_data   : in std_logic_vector(n - 1 downto 0);
        RegWrite     : in std_logic;  -- Control signal

        -- Outputs
        register_1   : out std_logic_vector(n - 1 downto 0);
        register_2   : out std_logic_vector(n - 1 downto 0) 
		 );
end Registers;

architecture Behavioral of Registers is
  type registers_type is array (0 to 31) of std_logic_vector(n - 1 downto 0);
  signal reg : registers_type := ((others => (others => '0')));
begin
  -- Process for handling reset and write operations
  process(CLK)
  begin
    if reset_neg = '0' then
      reg(to_integer(unsigned(address_out))) <= (others => '0');
      else if rising_edge(CLK) and RegWrite = '1' then
        reg(to_integer(unsigned(address_out))) <= write_data;
      end if;
    end if;
  end process;

  register_1 <= reg(to_integer(unsigned(address_in_1)));  -- Read in address 1
  register_2 <= reg(to_integer(unsigned(address_in_2)));  -- Read in address 2
end Behavioral;