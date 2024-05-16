#pragma once

#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <vector>
#include <unordered_map>
#include <algorithm>

const int NUMBIT = 16;

void Registers(std::string& reg);
void DecToBin(std::vector<int>& bin, int dec, int n);
int EncodeInstructions(const std::string& inputFile, const std::string& outputFile);

