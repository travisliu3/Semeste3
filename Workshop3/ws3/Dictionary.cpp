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
#include <iostream>
#include "Dictionary.h"

using namespace std;

namespace sdds {

	Dictionary::Dictionary() : m_term{}, m_definition{} { }

	bool Dictionary::operator==(const Dictionary& copy) {
		return (copy.m_definition == m_definition && copy.m_term == m_term);
	}

	std::ostream& operator<<(std::ostream& os, Dictionary& dic) {
		cout.width(20);
		os << dic.getTerm() << ": ";
		os << dic.getDefinition();
		return os;
	}

}