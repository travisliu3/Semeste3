/*
*****************************************************************************
						OOP244-Workshop-3, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 27 September, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#ifndef SDDS_DICTIONATY_H__
#define SDDS_DICTIONATY_H__
#include <iostream>
#include <cstring>

namespace sdds {

	class Dictionary
	{
		std::string m_term{};
		std::string m_definition{};
	public:
		const std::string& getTerm() const { return m_term; }
		const std::string& getDefinition() const { return m_definition; }
		Dictionary(const std::string& term, const std::string& definition) : m_term{ term }, m_definition{ definition } {}

		// TODO: Code the missing prototype functions and operators
		//       that the class needs in order to work with the Queue class.
		//       Implement them in the Dictionary.cpp file.
		Dictionary();
		bool operator==(const Dictionary& copy);
	};

	std::ostream& operator<<(std::ostream& os, Dictionary& dic);

}
#endif