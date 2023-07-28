/*
*****************************************************************************
						OOP244-Workshop-5, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 10 October, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include "SpellChecker.h"

using namespace std;

namespace sdds {

	SpellChecker::SpellChecker(const char* filename) : m_badWords{}, m_goodWords{}, m_errors{} {
		std::ifstream in(filename);
		if (in)
		{
			for (size_t i = 0; i < 6; i++)
			{
				in >> m_badWords[i] >> m_goodWords[i];
			}
		}
		else
		{
			throw "Bad file name!";
		}
	}

	void SpellChecker::operator()(string& text) {
		for (size_t i = 0; i < 6; i++)
		{
			int start = text.find(m_badWords[i]);
			while (start != -1)
			{
				text.replace(start, strlen(m_badWords[i].c_str()), m_goodWords[i]);
				m_errors[i]++;
				start = text.find(m_badWords[i], start + 1);
			}
		}
	}

	void SpellChecker::showStatistics(std::ostream& out) const {
		cout << "Spellchecker Statistics" << endl;
		for (size_t i = 0; i < 6; i++)
		{
			cout.width(15);
			cout << m_badWords[i] << ": " << m_errors[i] << " replacements" << endl;
		}
	}

}