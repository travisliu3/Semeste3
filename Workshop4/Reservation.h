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
#ifndef SDDS_RESERVATION_H__
#define SDDS_RESERVATION_H__
#include <iostream>

namespace sdds {

	class Reservation
	{

		std::string reserveid;
		std::string name;
		std::string email;
		int nopeople;
		int m_day;
		int hour;
	public:
		Reservation();
		Reservation(const std::string& res);
		void update(int day, int time);
		void display(std::ostream& os) const;
	};

	std::ostream& operator<<(std::ostream& os, const Reservation& reserve);

}
#endif