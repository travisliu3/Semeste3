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
#ifndef SDDS_CONFIRMATIONSENDER_H__
#define SDDS_CONFIRMATIONSENDER_H__
#include <iostream>

namespace sdds {

	class Reservation;

	class ConfirmationSender {
		const Reservation** m_pReserations;
		size_t m_cnt;
	public:
		ConfirmationSender();
		ConfirmationSender(ConfirmationSender& copy);
		ConfirmationSender(ConfirmationSender&& move);
		~ConfirmationSender();
		size_t size() const;
		void display(std::ostream& os) const;
		ConfirmationSender& operator=(const ConfirmationSender& copy);
		ConfirmationSender& operator=(ConfirmationSender&& move);
		ConfirmationSender& operator+=(const Reservation& res);
		ConfirmationSender& operator-=(const Reservation& res);
	};

	std::ostream& operator<<(std::ostream& os, const ConfirmationSender& confirm);

}
#endif