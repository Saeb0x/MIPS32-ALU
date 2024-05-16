-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: ALU
-- Desc: Performs arithmetic and logical operations on two input operands based on the given control signal.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
	GENERIC(n : integer := 32);
	port(
		-- Inputs
		operand_1 : in std_logic_vector(n - 1 downto 0);
		operand_2 : in std_logic_vector(n - 1 downto 0);
		ALU_control: in std_logic_vector(3 downto 0); -- 9 Operations

		-- Outputs
		result : out std_logic_vector(n - 1 downto 0);
		zero : out std_logic
		);
end ALU;

architecture Behavioral of ALU is
	signal temp : std_logic_vector(n - 1 downto 0);
	signal shift_amount : integer range 0 to n - 1;
	signal is_zero : std_logic;
begin
	-- Determine shift amount, using bits 10 downto 6, limited to the size of the data
	shift_amount <= to_integer(unsigned(operand_2(10 downto 6)));

	-- ALU Operations
	with ALU_control select
		temp <= std_logic_vector(unsigned(operand_1) + unsigned(operand_2)) after 1 ns when "0000",
				  std_logic_vector(unsigned(operand_1) - unsigned(operand_2)) after 1 ns when "0001",
			     operand_1 AND operand_2 after 1 ns when "0010",
              operand_1 OR operand_2 after 1 ns when "0011",
              operand_1 NOR operand_2 after 1 ns when "0100",
              operand_1 NAND operand_2 after 1 ns when "0101",
              operand_1 XOR operand_2 after 1 ns when "0110",
			     std_logic_vector(shift_left(unsigned(operand_1), shift_amount)) after 1 ns when "0111",
              std_logic_vector(shift_right(unsigned(operand_1), shift_amount)) after 1 ns when "1000",
             (others => '0') when others;
			
	-- Zero Detection
	process(temp)
	begin
		is_zero <= '1';
		for i in 0 to n - 1 loop
			if temp(i) /= '0' then
				is_zero <= '0';
				exit;
			end if;
		end loop;	
	end process;
	
	zero <= is_zero;
	
	-- Output Result
	result <= temp;
end Behavioral;