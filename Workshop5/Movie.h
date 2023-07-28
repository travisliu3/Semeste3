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
#ifndef SDDS_MOVIE_H__
#define SDDS_MOVIE_H__
#include <iostream>
#include <string>
#include "SpellChecker.h"

namespace sdds {

	class Movie {

		std::string m_title;
		int m_year;
		std::string m_des;
	public:
		Movie();
		Movie(const std::string& strMovie);
		const std::string& title() const;
		const int& year() const;
		const std::string& description() const;
		template<typename T>
		void fixSpelling(T& spellChecker);

	};

	std::ostream& operator<<(std::ostream& os, const Movie& movie);

	template<typename T>
	void Movie::fixSpelling(T& spellChecker) {
		spellChecker(m_title);
		spellChecker(m_des);
	}

}
#endif