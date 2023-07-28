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
#ifndef SDDS_CAR_H
#define SDDS_CAR_H
#include <iostream>
#include <string>
#include "Vehicle.h"

namespace sdds
{
	class Car : public Vehicle {

		std::string m_maker;
		std::string m_condition;
		double m_topspeed;
	public:
		Car(std::istream& file);
		std::string condition() const;
		double topSpeed() const;
		void display(std::ostream& out) const;

	};
}

#endif