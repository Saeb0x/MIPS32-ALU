-- Author: Saeb K. H. Naser
-- Project: 32-bit MIPS ALU based on RISC
-- Module: Top Level
-- Desc: Coordinates the flow of instructions, control signals, and data between different components to execute instructions and perform desired operations.

library IEEE;
use IEEE.std_logic_1164.all;

entity TopLevel is
	GENERIC (n : integer := 32);
	port( 
			-- Inputs
			CLK, reset_neg : in std_logic 
		  );
end TopLevel;

architecture Behavioral of TopLevel is

	component ControlUnit is
	port( 
			-- Inputs
			instruction : in std_logic_vector(31 downto 0);
			ZeroCarry   : in std_logic;

			-- Output(Control Signals)
			RegDst      : out std_logic;
			Jump        : out std_logic;
			Branch      : out std_logic;
			MemRead     : out std_logic;
			MemToReg    : out std_logic;
			ALUOp       : out std_logic_vector (3 downto 0);  -- 9 Operations
			MemWrite    : out std_logic;
			ALUSrc      : out std_logic;
			RegWrite    : out std_logic 
		  );
	end component;

	component DataPath is
	port( 
			-- Inputs
			CLK, reset_neg    : in std_logic;
			instruction       : in std_logic_vector(31 downto 0);
			
			-- Control Signals
			RegDst            : in std_logic;
			Jump              : in std_logic;
			Branch            : in std_logic;
			MemRead           : in std_logic;
			MemToReg          : in std_logic;
			ALUOp             : in std_logic_vector(3 downto 0);
			MemWrite          : in std_logic;
			ALUSrc            : in std_logic;
			RegWrite          : in std_logic;

			-- Outputs
			next_instruction  : out std_logic_vector(31 downto 0);
			ZeroCarry         : out std_logic 
		  );
	end component;

	component InstructionMemory is
	port( 
			-- Input
			register_addr : in  std_logic_vector(31 downto 0);

			-- Output
			instruction   : out std_logic_vector(31 downto 0) 
		  );
	end component;

	signal RegDst_TL, Jump_TL, Branch_TL, MemRead_TL, MemToReg_TL : std_logic;
	signal MemWrite_TL, ALUSrc_TL, RegWrite_TL , ZeroCarry_TL : std_logic;
	signal ALUOp_TL : std_logic_vector(3 downto 0);
	signal NextInstruction, instr : std_logic_vector(31 downto 0);
begin
	CU : ControlUnit  port map( instr,
	ZeroCarry_TL,
	RegDst_TL,
	Jump_TL,
	Branch_TL,
	MemRead_TL,
	MemToReg_TL,
	ALUOp_TL,
	MemWrite_TL,
	ALUSrc_TL,
	RegWrite_TL );

	DP : DataPath     port map( CLK,
	reset_neg,
	instr,
	RegDst_TL,
	Jump_TL,
	Branch_TL,
	MemRead_TL,
	MemToReg_TL,
	ALUOp_TL,
	MemWrite_TL,
	ALUSrc_TL,
	RegWrite_TL,
	NextInstruction,
	ZeroCarry_TL );

	I  : InstructionMemory  port map( NextInstruction, instr );
end Behavioral;