/*
*****************************************************************************
						OOP244-Workshop-4, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 3 October, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#ifndef SDDS_RESTAURANT_H__
#define SDDS_RESTAURANT_H__
#include <iostream>

namespace sdds {

	class Reservation;

	class Restaurant
	{
		Reservation** reserve;
		size_t m_cnt;
	public:
		Restaurant();
		Restaurant(Restaurant& copy);
		Restaurant(Restaurant&& move);
		Restaurant(const Reservation* reservations[], size_t cnt);
		~Restaurant();
		Restaurant& operator=(const Restaurant& copy);
		Restaurant& operator=(Restaurant&& move);
		size_t size() const;
		void display(std::ostream& os) const;
	};

	std::ostream& operator<<(std::ostream& os, const Restaurant& reserve);

}
#endif