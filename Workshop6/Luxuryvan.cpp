/*
*****************************************************************************
						OOP244-Workshop-6, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 4 November, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#include <iostream>
#include "Luxuryvan.h"

using namespace std;

namespace sdds {

	Luxuryvan::Luxuryvan(std::istream& in): Van(in) {
		getline(in, m_consumption);

		while (m_consumption[0] == ',' || m_consumption[0] == ' ')
		{
			m_consumption.erase(0, 1);
		}
		while (m_consumption[m_consumption.length() - 1] == ' ')
		{
			m_consumption.erase(m_consumption.length() - 1, 1);
		}
		if (m_consumption == "g")
		{
			throw std::runtime_error("Invalid record!");
		}
	}

	void Luxuryvan::display(std::ostream& out) const {
		Van::display(out);
		out << " electric van  *";
	}

	std::string Luxuryvan::consumption() const {
		return m_consumption;
	}

}