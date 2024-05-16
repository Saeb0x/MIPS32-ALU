# 32-Bit MIPS ALU based on RISC
This repository houses designs and code for my Final Year Project, centered on designing a 32-bit MIPS Arithmetic Logic Unit (ALU) tailored to meet the demands of the hardware realization of the MIPS CPU datapath. It contains Logisim designs for foundational understanding, VHDL implementations of a Single-Cycle MIPS CPU, and a MIPS Assembler written in C++ to enable users to define and execute custom test programs. 

### Logisim Design

### VHDL Implementation
In my implementation of the Single-Cycle MIPS CPU, which includes the Control Unit and every Functional Unit of the datapath (Program Counter, Adders, Instruction Memory, Data Memory, Multiplexers, Registers, Shifters, and a Sign Extender), I followed this diagram!

<img width="970" alt="32-Bit Single-Cycle MIPS Diagram" src="https://github.com/Saeb0x/MIPS32-ALU/assets/56490771/515664e5-1f38-4ba3-8508-ce10a26bebef">

This CPU is capable of executing a range of instructions from the MIPS instruction set, including register and immediate arithmetic-logical operations like add, sub, and, or, nor, xor, addi, andi, and ori. It also handles shift operations such as sll and srl, set operations like slt and slti, branch and jump commands including beq, bne, and j, as well as memory operations with lw and sw.

In a **single-cycle** CPU, each instruction must finish in one clock cycle, so the cycle's length is based on the time it takes for the slowest instruction. This is usually determined by the longest path an instruction takes, often the load word (lw) instruction.

### MIPS Assembler [C++]
You can define your own program in MIPS Assembly, and then pass it to the MIPS Assembler, which will encode all the instructions into machine code. Afterwards, you can load the encoded instructions into the instruction memory.

In the assembler directory, I'll include both the C++ source code and the executable binary. You can use the executable binary as follows:
```
$ MIPSAssembler <input_file_name>.ext <output_file_name>.ext
```
![Assembler](https://github.com/Saeb0x/MIPS32-ALU/assets/56490771/627ac9b5-5c8d-4cda-b9e0-e9fc3a0bd364)

If you're interested in more details, check out this [motivation](https://saebnaser.com/post/32-bit-mips-alu-motivation/) and [design](https://saebnaser.com/post/32-bit-mips-alu-design/) blog posts, where I provide a thorough breakdown of everything I did.
