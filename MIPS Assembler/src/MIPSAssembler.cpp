#include "MIPSAssembler.h"

void Registers(std::string& reg)
{
    static const std::unordered_map<std::string, std::string> reg_map =
    {
        {"$R0", "00000"},  {"$R1", "00001"},  {"$R2", "00010"},  {"$R3", "00011"},
        {"$R4", "00100"},  {"$R5", "00101"},  {"$R6", "00110"},  {"$R7", "00111"},
        {"$R8", "01000"},  {"$R9", "01001"},  {"$R10", "01010"}, {"$R11", "01011"},
        {"$R12", "01100"}, {"$R13", "01101"}, {"$R14", "01110"}, {"$R15", "01111"},
        {"$R16", "10000"}, {"$R17", "10001"}, {"$R18", "10010"}, {"$R19", "10011"},
        {"$R20", "10100"}, {"$R21", "10101"}, {"$R22", "10110"}, {"$R23", "10111"},
        {"$R24", "11000"}, {"$R25", "11001"}, {"$R26", "11010"}, {"$R27", "11011"},
        {"$R28", "11100"}, {"$R29", "11101"}, {"$R30", "11110"}, {"$R31", "11111"}
    };

    if (reg_map.find(reg) != reg_map.end())
    {
        reg = reg_map.at(reg);
    }
    else
    {
        std::cerr << "ERROR: register can be Ri, with i=0,1,...,31\n";
        exit(EXIT_FAILURE);
    }
}

void DecToBin(std::vector<int>& bin, int dec, int n)
{
    bin.resize(n);
    for (int i = 0; i < n; i++)
    {
        bin[i] = (dec % 2 == 0) ? 0 : 1;
        dec /= 2;
    }

    std::reverse(bin.begin(), bin.end());
}

int EncodeInstructions(const std::string& inputFile, const std::string& outputFile) {
    std::ifstream fpin(inputFile);
    if (!fpin) {
        std::cerr << "Error opening input file\n";
        return EXIT_FAILURE;
    }

    std::ofstream fpout(outputFile);
    if (!fpout) {
        std::cerr << "Error opening output file\n";
        return EXIT_FAILURE;
    }

    std::string line, code, rd, rs, rt;
    int dec, cnt = 0;
    std::vector<int> b(NUMBIT);

    while (fpin >> code) {
        if (!strcmp(code.c_str(), "add")) { // add $R1 $R2 $R3
            fpin >> rd >> rs >> rt;

            fpout << "-- add " << rd << "," << rs << "," << rt << "\n";

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fpout << cnt++ << " => \"000000" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n"
                << cnt++ << " => \"" << rd << "000\",\n"
                << cnt++ << " => \"00100000\",\n\n";
        }
        else if (!strcmp(code.c_str(), "sub")) { // sub $R1 $R2 $R3
            fpin >> rd >> rs >> rt;

            fpout << "-- sub " << rd << "," << rs << "," << rt << "\n";

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fpout << cnt++ << " => \"000000" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n"
                << cnt++ << " => \"" << rd << "000\",\n"
                << cnt++ << " => \"00100010\",\n\n";
        }
        else if (!strcmp(code.c_str(), "addi")) { // addi $R1 $R2 50
            fpin >> rt >> rs >> dec;

            fpout << "-- addi " << rt << "," << rs << "," << dec << "\n";

            Registers(rt);
            Registers(rs);
            DecToBin(b, dec, NUMBIT);

            fpout << cnt++ << " => \"001000" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n";

            for (int j = 0; j < 2; ++j) {
                fpout << cnt++ << " => \"";
                for (int i = j * NUMBIT / 2; i < (j + 1) * NUMBIT / 2; ++i) {
                    fpout << b[i];
                }
                fpout << "\",\n";
            }
            fpout << "\n";
        }
        else if (!strcmp(code.c_str(), "lw")) { // lw $R1 50 $R2
            fpin >> rt >> dec >> rs;

            fpout << "-- lw " << rt << "," << dec << "(" << rs << ")\n";

            Registers(rt);
            DecToBin(b, dec, NUMBIT);
            Registers(rs);

            fpout << cnt++ << " => \"100011" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n";

            for (int j = 0; j < 2; ++j) {
                fpout << cnt++ << " => \"";
                for (int i = j * NUMBIT / 2; i < (j + 1) * NUMBIT / 2; ++i) {
                    fpout << b[i];
                }
                fpout << "\",\n";
            }
            fpout << "\n";
        }
        else if (!strcmp(code.c_str(), "sw")) { // sw $R1 50 $R2
            fpin >> rt >> dec >> rs;

            fpout << "-- sw " << rt << "," << dec << "(" << rs << ")\n";

            Registers(rt);
            DecToBin(b, dec, NUMBIT);
            Registers(rs);

            fpout << cnt++ << " => \"101011" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n";

            for (int j = 0; j < 2; ++j) {
                fpout << cnt++ << " => \"";
                for (int i = j * NUMBIT / 2; i < (j + 1) * NUMBIT / 2; ++i) {
                    fpout << b[i];
                }
                fpout << "\",\n";
            }
            fpout << "\n";
        }
        else if (!strcmp(code.c_str(), "and")) { // and $R1 $R2 $R3
            fpin >> rd >> rs >> rt;

            fpout << "-- and " << rd << "," << rs << "," << rt << "\n";

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fpout << cnt++ << " => \"000000" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n"
                << cnt++ << " => \"" << rd << "000\",\n"
                << cnt++ << " => \"00100100\",\n\n";
        }
        else if (!strcmp(code.c_str(), "or")) { // or $R1 $R2 $R3
            fpin >> rd >> rs >> rt;

            fpout << "-- or " << rd << "," << rs << "," << rt << "\n";

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fpout << cnt++ << " => \"000000" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n"
                << cnt++ << " => \"" << rd << "000\",\n"
                << cnt++ << " => \"00100101\",\n\n";
        }
        else if (!strcmp(code.c_str(), "nor")) { // nor $R1 $R2 $R3
            fpin >> rd >> rs >> rt;

            fpout << "-- nor " << rd << "," << rs << "," << rt << "\n";

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fpout << cnt++ << " => \"000000" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n"
                << cnt++ << " => \"" << rd << "000\",\n"
                << cnt++ << " => \"00100111\",\n\n";
        }
        else if (!strcmp(code.c_str(), "andi")) { // andi $R1 $R2 50
            fpin >> rt >> rs >> dec;

            fpout << "-- andi " << rt << "," << rs << "," << dec << "\n";

            Registers(rt);
            Registers(rs);
            DecToBin(b, dec, NUMBIT);

            fpout << cnt++ << " => \"001100" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n";

            for (int j = 0; j < 2; ++j) {
                fpout << cnt++ << " => \"";
                for (int i = j * NUMBIT / 2; i < (j + 1) * NUMBIT / 2; ++i) {
                    fpout << b[i];
                }
                fpout << "\",\n";
            }
            fpout << "\n";
        }
        else if (!strcmp(code.c_str(), "ori")) { // ori $R1 $R2 50
            fpin >> rt >> rs >> dec;

            fpout << "-- ori " << rt << "," << rs << "," << dec << "\n";

            Registers(rt);
            Registers(rs);
            DecToBin(b, dec, NUMBIT);

            fpout << cnt++ << " => \"001101" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n";

            for (int j = 0; j < 2; ++j) {
                fpout << cnt++ << " => \"";
                for (int i = j * NUMBIT / 2; i < (j + 1) * NUMBIT / 2; ++i) {
                    fpout << b[i];
                }
                fpout << "\",\n";
            }
            fpout << "\n";
        }
        else if (!strcmp(code.c_str(), "xor")) { // xor $R1 $R2 $R3
            fpin >> rd >> rs >> rt;

            fpout << "-- xor " << rd << "," << rs << "," << rt << "\n";

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fpout << cnt++ << " => \"000000" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n"
                << cnt++ << " => \"" << rd << "000\",\n"
                << cnt++ << " => \"00100110\",\n\n";
        }
        else if (!strcmp(code.c_str(), "sll")) { // sll $R1 $R2 10
            fpin >> rd >> rt >> dec;

            fpout << "-- sll " << rd << "," << rt << "," << dec << "\n";

            Registers(rd);
            Registers(rt);
            DecToBin(b, dec, NUMBIT);

            fpout << cnt++ << " => \"000000" << rt[0] << rt[1] << "\",\n"
                << cnt++ << " => \"" << rt[2] << rt[3] << rt[4] << "00000\",\n"
                << cnt++ << " => \"" << rd << b[11] << b[12] << b[13] << "\",\n"
                << cnt++ << " => \"" << b[14] << b[15] << "000000\",\n\n";
        }
        else if (!strcmp(code.c_str(), "srl")) { // srl $R1 $R2 10
            fpin >> rd >> rt >> dec;

            fpout << "-- srl " << rd << "," << rt << "," << dec << "\n";

            Registers(rd);
            Registers(rt);
            DecToBin(b, dec, NUMBIT); 

            fpout << cnt++ << " => \"000000" << rt[0] << rt[1] << "\",\n"
                << cnt++ << " => \"" << rt[2] << rt[3] << rt[4] << "00000\",\n"
                << cnt++ << " => \"" << rd << b[11] << b[12] << b[13] << "\",\n"
                << cnt++ << " => \"" << b[14] << b[15] << "000010\",\n\n";
        }
        else if (!strcmp(code.c_str(), "beq")) { // beq $R1 $R2 25
            fpin >> rs >> rt >> dec;

            fpout << "-- beq " << rs << "," << rt << "," << dec << "\n";

            Registers(rs);
            Registers(rt);
            DecToBin(b, dec, NUMBIT);

            fpout << cnt++ << " => \"000100" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n";

            for (int j = 0; j < 2; ++j) {
                fpout << cnt++ << " => \"";
                for (int i = j * NUMBIT / 2; i < (j + 1) * NUMBIT / 2; ++i) {
                    fpout << b[i];
                }
                fpout << "\",\n";
            }
            fpout << "\n";
        }
        else if (!strcmp(code.c_str(), "bne")) { // bne $R1 $R2 25
            fpin >> rs >> rt >> dec;

            fpout << "-- bne " << rs << "," << rt << "," << dec << "\n";

            Registers(rs);
            Registers(rt);
            DecToBin(b, dec, NUMBIT);

            fpout << cnt++ << " => \"000101" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n";

            for (int j = 0; j < 2; ++j) {
                fpout << cnt++ << " => \"";
                for (int i = j * NUMBIT / 2; i < (j + 1) * NUMBIT / 2; ++i) {
                    fpout << b[i];
                }
                fpout << "\",\n";
            }
            fpout << "\n";
        }
        else if (!strcmp(code.c_str(), "slt")) { // slt $R1 $R2 $R3
            fpin >> rd >> rs >> rt;

            fpout << "-- slt " << rd << "," << rs << "," << rt << "\n";

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fpout << cnt++ << " => \"000000" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n"
                << cnt++ << " => \"" << rd << "000\",\n"
                << cnt++ << " => \"00101010\",\n\n";
        }
        else if (!strcmp(code.c_str(), "slti")) { // slti $R1 $R2 50
            fpin >> rt >> rs >> dec;

            fpout << "-- slti " << rt << "," << rs << "," << dec << "\n";

            Registers(rt);
            Registers(rs);
            DecToBin(b, dec, NUMBIT);

            fpout << cnt++ << " => \"001010" << rs[0] << rs[1] << "\",\n"
                << cnt++ << " => \"" << rs[2] << rs[3] << rs[4] << rt << "\",\n";

            for (int j = 0; j < 2; ++j) {
                fpout << cnt++ << " => \"";
                for (int i = j * NUMBIT / 2; i < (j + 1) * NUMBIT / 2; ++i) {
                    fpout << b[i];
                }
                fpout << "\",\n";
            }
            fpout << "\n";
        }
        else if (!strcmp(code.c_str(), "j")) { // j 2500
            fpin >> dec;

            fpout << "-- j " << dec << "\n";

            DecToBin(b, dec, 26);

            fpout << cnt++ << " => \"000010" << b[0] << b[1] << "\",\n";

            for (int j = 0; j < 3; ++j) {
                fpout << cnt++ << " => \"";
                for (int i = 2 + j * 8; i < 10 + j * 8; ++i) {
                    fpout << b[i];
                }
                fpout << "\",\n";
            }
            fpout << "\n";
        }
        else {
            std::cerr << "Instruction error!\n";
            return EXIT_FAILURE;
        }
    }

    return EXIT_SUCCESS;
}

