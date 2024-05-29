-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: TopLevel Testbench
-- Desc: A testbench for the TopLevel.

library IEEE;
use IEEE.std_logic_1164.all;

entity TopLevel_tb is
    -- No ports required
end TopLevel_tb;

architecture behavior of TopLevel_tb is
    component TopLevel
        GENERIC (n : integer := 32);
        port(
            CLK, reset_neg : in std_logic
        );
    end component;

    signal CLK, reset_neg : std_logic := '0';

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: TopLevel
        generic map (n => 32)
        port map (
            CLK => CLK,
            reset_neg => reset_neg
        );

    -- Clock generation
    clocking: process
    begin
        for i in 1 to 20 loop  -- Each cycle is 20 ns, 20*10 ns = 200 ns for 10 instructions
            CLK <= not CLK;  -- Toggle clock
            wait for 10 ns;  -- Half period of 20 ns cycle
        end loop;
        wait;  -- Stop after the last cycle
    end process;

    initial_setup: process
    begin
        reset_neg <= '0';  -- Assert 
        wait for 20 ns;    -- Hold reset for initialization
        reset_neg <= '1';  -- Deassert 
        wait;              -- Continue until simulation stops after 200 ns
    end process;

end behavior;


