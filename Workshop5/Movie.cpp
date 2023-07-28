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
#include <iostream>
#include <string>
#include <cstring>
#include "Movie.h"

using namespace std;

namespace sdds {

	Movie::Movie() :m_title{}, m_year{}, m_des{} {}

	Movie::Movie(const string& strMovie) :m_title{}, m_year{}, m_des{} {

		m_title = strMovie;
		while (m_title[0] == ' ')
		{
			m_title.erase(0, 1);
		}
		while (m_title[m_title.find(',') - 1] == ' ')
		{
			m_title.erase(m_title.find(',') - 1, 1);
		}
		m_title.erase(m_title.find(','));

		string year = strMovie.substr(strMovie.find(m_title) + strlen(m_title.c_str()));
		year.erase(0, year.find(',') + 1);
		year.erase(year.find(','));
		m_year = stoi(year);

		m_des = strMovie.substr(strMovie.find(year) + strlen(year.c_str()));
		while (m_des[0] == ' ' || m_des[0] == ',')
		{
			m_des.erase(0, 1);
		}

	}

	const std::string& Movie::title() const {
		return m_title;
	}

	const int& Movie::year() const {
		return m_year;
	}

	const string& Movie::description() const {
		return m_des;
	}

	ostream& operator<<(ostream& os, const Movie& movie) {
		cout.width(40);
		cout << movie.title() << " | " << movie.year() << " | " << movie.description() << endl;
		return os;
	}

}