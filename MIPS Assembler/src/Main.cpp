#include "MIPSAssembler.h"

int main(int argc, char* argv[])
{
	if (argc != 3)
	{
		std::cerr << "USAGE: MIPSAssembler <input_file.ext> <output_file_name.ext>\n";
		return EXIT_FAILURE;
	}

	return EncodeInstructions(argv[1], argv[2]);
}