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
#include "Utilities.h"
#include "Car.h"
#include "Racecar.h"
#include "Van.h"
#include "Luxuryvan.h"

using namespace std;

namespace sdds {

	Vehicle* createInstance(std::istream& in) {
		string vehicle{};
		getline(in, vehicle, ',');
		while (vehicle[0] == ' ')
		{
			vehicle.erase(0, 1);
		}
		while (vehicle[0] == 'g')
		{
			vehicle.erase(0, 2);
		}
		if (in)
		{
			switch (vehicle[0])
			{
			case 'c':
				return move(new Car(in));
			case 'C':
				return move(new Car(in));
			case 'v':
				return move(new Van(in));
			case 'V':
				return move(new Van(in));
			case 'r':
				return move(new Racecar(in));
			case 'R':
				return move(new Racecar(in));
			case 'l':
				return move(new Luxuryvan(in));
			case 'L':
				return move(new Luxuryvan(in));
			default:
				throw "Unrecognized record type: [" + vehicle + "]";
			}
		}
		return nullptr;
	}

}