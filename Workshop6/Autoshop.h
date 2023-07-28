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
#ifndef SDDS_AUTOSHOP_H
#define SDDS_AUTOSHOP_H
#include <iostream>
#include <string>
#include <vector>
#include <list>
#include "Vehicle.h"

namespace sdds
{
	class Autoshop {

		std::vector<Vehicle*> m_vehicles;
	public:
		~Autoshop();
		template<typename T>
		void select(T test, std::list<const Vehicle*>& vehicles);
		Autoshop& operator +=(Vehicle* theVehicle);
		void display(std::ostream& out) const;

	};

	template<typename T>
	void Autoshop::select(T test, std::list<const Vehicle*>& vehicles) {
		for (auto it = m_vehicles.begin(); it != m_vehicles.end(); it++)
		{
			const Vehicle* vec = *it;
			if (test(vec))
			{
				vehicles.push_back(*it);
			}
		}
	}

}

#endif