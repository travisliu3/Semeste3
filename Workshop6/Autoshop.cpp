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
#include "Autoshop.h"

using namespace std;

namespace sdds {

	Autoshop::~Autoshop() {
		for (auto it = m_vehicles.begin(); it != m_vehicles.end(); it++)
		{
			delete (*it);
		}
	}

	Autoshop& Autoshop::operator +=(Vehicle* theVehicle) {
		m_vehicles.push_back(move(theVehicle));
		return *this;
	}

	void Autoshop::display(std::ostream& out) const {
		for (auto it = m_vehicles.begin(); it != m_vehicles.end(); it++)
		{
			(*it)->display(out);
			out << endl;
		}
	}

}