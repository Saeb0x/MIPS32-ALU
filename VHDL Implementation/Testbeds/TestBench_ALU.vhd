-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Testbench for ALU module

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Testbench_ALU is
end Testbench_ALU;    

architecture Testbench of Testbench_ALU is
	-- Constants 
	constant N_WIDTH : integer := 32;
	constant DELAY_PERIOD : time := 10 ns;

	-- Signals 
	signal operand_1_tb : std_logic_vector(N_WIDTH - 1 downto 0);
	signal operand_2_tb : std_logic_vector(N_WIDTH - 1 downto 0);
	signal ALU_control_tb : std_logic_vector(3 downto 0);
	signal result_tb : std_logic_vector(N_WIDTH - 1 downto 0);
	signal zero_tb : std_logic;
begin
	-- Instantiate ALU  
	ALU_inst : entity work.ALU
		generic map (n => N_WIDTH)
		port map (
				operand_1 => operand_1_tb,
				operand_2 => operand_2_tb,
				ALU_control => ALU_control_tb,
				result => result_tb,
				zero => zero_tb
			);

    -- Stimulus process
    stimulus : process
    begin
        -- Test case for Addition
    	operand_1_tb <= "00000000000000000000000000000100";
        operand_2_tb <= "00000000000000000000000000000101";
        ALU_control_tb <= "0000";
        wait for DELAY_PERIOD;

         -- Test case for Subtraction 
        operand_1_tb <= "00000000000000000000000000001000";
        operand_2_tb <= "00000000000000000000000000000100";
        ALU_control_tb <= "0001";
        wait for DELAY_PERIOD;

        -- Test case for AND
        operand_1_tb <= "00000000000000000000000000001111";
        operand_2_tb <= "00000000000000000000000000001100";
        ALU_control_tb <= "0010";
        wait for DELAY_PERIOD;

        -- Test case for OR 
        operand_1_tb <= "00000000000000000000000000001010";
        operand_2_tb <= "00000000000000000000000000001100";
        ALU_control_tb <= "0011";
        wait for DELAY_PERIOD;

        -- Test case for NOR 
        operand_1_tb <= "00000000000000000000000000001010";
        operand_2_tb <= "00000000000000000000000000001100";
        ALU_control_tb <= "0100";
        wait for DELAY_PERIOD;

        -- Test case for NAND
        operand_1_tb <= "00000000000000000000000000001010";
        operand_2_tb <= "00000000000000000000000000001100";
        ALU_control_tb <= "0101";
        wait for DELAY_PERIOD;

        -- Test case for XOR
        operand_1_tb <= "00000000000000000000000000001010";
        operand_2_tb <= "00000000000000000000000000001100";
        ALU_control_tb <= "0110";
        wait for DELAY_PERIOD;

         -- Test case for Shift Left Logical (SLL)
        operand_1_tb <= "00000000000000000000000000001010";
        operand_2_tb <= "00000000000000000000000000000010"; -- Shift by 2
        ALU_control_tb <= "0111";
        wait for DELAY_PERIOD;

        -- Test case for Shift Right Logical (SRL)
        operand_1_tb <= "00000000000000000000000000001010";
        operand_2_tb <= "00000000000000000000000000000010"; 
        ALU_control_tb <= "1000";
        wait for DELAY_PERIOD;

	-- Test case to check the zero flag
 	operand_1_tb <= "00000000000000000000000000001001";
 	operand_2_tb <= "00000000000000000000000000001001";
    	ALU_control_tb <= "0001"; -- Subtraction
	wait for DELAY_PERIOD;

	-- End simulation
        wait;
    end process stimulus;    
end Testbench;