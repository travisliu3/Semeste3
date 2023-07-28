/*
*****************************************************************************
						OOP244-Workshop-1, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 11 September, 2022
Section    : ZCC

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#ifndef SDDS_CARADS_H__
#define SDDS_CARADS_H__
#include <iostream>

extern double g_taxrate;
extern double g_discount;

namespace sdds {

	class Cars
	{
		char* brand{};
		char* model{};
		int year{};
		double price{};
		char status{};
		char discount{};
		bool dis{};
	public:
		Cars();
		~Cars();
		void operator=(const Cars& car);
		void read(std::istream& is);
		void display(bool reset) const;
		char getStatus();
		operator bool()const;
	};
	void listArgs(int argc, char** argv);
	std::istream& operator>>(std::istream& is, Cars& car);
	void operator>>(const Cars& car1, Cars& car2);
}
#endif