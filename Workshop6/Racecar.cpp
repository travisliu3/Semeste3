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
#include "Racecar.h"

using namespace std;

namespace sdds {

	Racecar::Racecar(std::istream& in): Car(in) {
		string boost{};
		getline(in, boost);
		while (boost[0] == ',' || boost[0] == ' ')
		{
			boost.erase(0, 1);
		}
		m_booster = stod(boost);
	}

	void Racecar::display(std::ostream& out) const {
		Car::display(out);
		out << "*";
	}

	double Racecar::topSpeed() const {
		return Car::topSpeed() + (m_booster * Car::topSpeed());
	}

}