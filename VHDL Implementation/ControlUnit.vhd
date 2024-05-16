-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: Control Unit
-- Desc: Generates control signals for various components within the processor based on the input instruction and other control signals.

library IEEE;
use IEEE.std_logic_1164.all;

entity ControlUnit is
  port( 
		  -- Inputs
        instruction : in std_logic_vector(31 downto 0);
        ZeroCarry   : in std_logic;

        -- Outputs (Control Signals)
        RegDst      : out std_logic;
        Jump        : out std_logic;
        Branch      : out std_logic;
        MemRead     : out std_logic;
        MemToReg    : out std_logic;
        ALUOp       : out std_logic_vector (3 downto 0);
        MemWrite    : out std_logic;
        ALUSrc      : out std_logic;
        RegWrite    : out std_logic 
       );
end ControlUnit;

architecture Behavioral of ControlUnit is
  signal data : std_logic_vector(11 downto 0);  -- To set the control signals
begin
  -- According to the standard MIPS32 instruction reference
  -- R-type: Addition
  data <= "100000000001" when (instruction(31 downto 26) = "000000" and
                               instruction(10 downto 0)  = "00000100000") else
  -- R-type: Subtraction
  "100000001001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100010") else
  -- R-type: AND
  "100000010001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100100") else
  -- R-type: OR
  "100000011001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100101") else
  -- R-type: NOR
  "100000100001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100111") else
  -- R-type: XOR
  "100000110001" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "100110") else
  -- R-type: SLL (Shift Left Logical) 
  "100000111011" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "000000") else
  -- R-type: SRL (Shift Right Logical)
  "100001000011" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "000010") else
  -- R-type: SLT (Set Less Than)
  "100001001001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000101010") else
  -- I-type: Addition Immediate
  "000000000011" when instruction(31 downto 26) = "001000" else
  -- I-type: LW (Load Word)
  "000110000011" when instruction(31 downto 26) = "100011" else
  -- I-type: SW (Store Word)
  "000000000110" when instruction(31 downto 26) = "101011" else
  -- I-type: ANDI (AND Immediate)
  "000000010011" when instruction(31 downto 26) = "001100" else
  -- I-type: ORI (OR Immediate)
  "000000011011" when instruction(31 downto 26) = "001101" else
  -- I-type: BEQ (Branch on Equal)
  "001000001000" when instruction(31 downto 26) = "000100" else
  -- I-type: BNE (Branch on Not Equal)
  "001000110010" when instruction(31 downto 26) = "000101" else
  -- I-type: SLTI (Set Less Than Immediate)
  "000001001011" when instruction(31 downto 26) = "001010" else
  -- J-type: J (Jump)
  "010000000000" when instruction(31 downto 26) = "000010" else
  -- Otherwise
  (others =>'0');

  -- Set control signals based on the decoded data
  RegDst   <= data(11);
  Jump     <= data(10);
  -- AND port included considering the LSB of BEG and BNE
  Branch   <= data(9) AND (ZeroCarry XOR instruction(26));
  MemRead  <= data(8);
  MemToReg <= data(7);
  ALUOp    <= data(6 downto 3);
  MemWrite <= data(2);
  ALUSrc   <= data(1);
  RegWrite <= data(0);

end Behavioral;