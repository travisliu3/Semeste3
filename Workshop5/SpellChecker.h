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
#ifndef SDDS_SPELLCHECKER_H__
#define SDDS_SPELLCHECKER_H__
#include <iostream>
#include <string>

namespace sdds {

	class SpellChecker {
		
		std::string m_badWords[6];
		std::string m_goodWords[6];
		size_t m_errors[6];
	public:
		SpellChecker(const char* filename);
		void operator()(std::string& text);
		void showStatistics(std::ostream& out) const;

	};

}
#endif