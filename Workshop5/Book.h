/*
*****************************************************************************
						OOP244-Workshop-5, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 10 October, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#ifndef SDDS_RESTAURANT_H__
#define SDDS_RESTAURANT_H__
#include <iostream>
#include <string>
#include "SpellChecker.h"

namespace sdds {

	class Book {

		std::string m_author;
		std::string m_title;
		std::string m_country;
		size_t m_year;
		double m_price;
		std::string m_des;
	public:
		Book();
		Book(const std::string& strBook);
		const std::string& author() const;
		const std::string& title() const;
		const std::string& country() const;
		const size_t& year() const;
		double& price();
		const std::string& description() const;
		template<typename T>
		void fixSpelling(T& spellChecker);

	};

	std::ostream& operator<<(std::ostream& os, Book book);

	template<typename T>
	void Book::fixSpelling(T& spellChecker) {
		spellChecker(m_des);
	}

}
#endif