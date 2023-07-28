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
#ifndef SDDS_UTILITIES_H
#define SDDS_UTILITIES_H
#include <iostream>
#include "Vehicle.h"
namespace sdds
{
	Vehicle* createInstance(std::istream& in);
}

#endif