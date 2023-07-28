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
#include "Book.h"

using namespace std;

namespace sdds {

	Book::Book() :m_author{}, m_title{}, m_country{}, m_year{}, m_price{}, m_des{} { }

	Book::Book(const std::string& strBook) :m_author{}, m_title{}, m_country{}, m_year{}, m_price{}, m_des{} {

		m_author = strBook;
		while (m_author[0] == ' ')
		{
			m_author.erase(0, 1);
		}
		while (m_author[m_author.find(',') - 1] == ' ')
		{
			m_author.erase(m_author.find(',') - 1, 1);
		}
		m_author.erase(m_author.find(','));

		m_title = strBook.substr(strBook.find(',') + 1);
		while (m_title[0] == ' ')
		{
			m_title.erase(0, 1);
		}
		while (m_title[m_title.find(',') - 1] == ' ')
		{
			m_title.erase(m_title.find(',') - 1, 1);
		}
		m_title.erase(m_title.find(','));

		m_country = strBook.substr(strBook.find(m_title) + strlen(m_title.c_str()));
		while (m_country[0] == ' ' || m_country[0] == ',')
		{
			m_country.erase(0, 1);
		}
		while (m_country[m_country.find(',') - 1] == ' ')
		{
			m_country.erase(m_country.find(',') - 1, 1);
		}
		m_country.erase(m_country.find(','));

		string price = strBook.substr(strBook.find(m_title) + strlen(m_title.c_str()));
		price.erase(0, price.find(',') + 1);
		price.erase(0, price.find(',') + 1);
		price.erase(price.find(','));
		m_price = stod(price);

		string year = strBook.substr(strBook.find(m_country) + strlen(m_country.c_str()));
		year.erase(0, year.find(',') + 1);
		year.erase(0, year.find(',') + 1);
		year.erase(year.find(','));
		m_year = stoi(year);

		m_des = strBook.substr(strBook.find(year) + strlen(year.c_str()));
		while (m_des[0] == ' ' || m_des[0] == ',')
		{
			m_des.erase(0, 1);
		}

	}

	const std::string& Book::author() const {
		return m_author;
	}

	const std::string& Book::title() const {
		return m_title;
	}

	const std::string& Book::country() const {
		return m_country;
	}

	const size_t& Book::year() const {
		return m_year;
	}

	double& Book::price() {
		return m_price;
	}

	const std::string& Book::description() const {
		return m_des;
	}

	ostream& operator<<(ostream& os, Book book) {
		cout.width(20);
		cout << book.author() << " | ";
		cout.width(22);
		cout << book.title() << " | ";
		cout.width(5);
		cout << book.country() << " | ";
		cout.width(4);
		cout << book.year() << " | ";
		cout.width(6);
		cout.setf(std::ios::fixed);
		cout.width(6);
		cout.precision(2);
		cout << book.price() << " | ";
		cout.unsetf(std::ios::fixed);
		cout << book.description() << endl;
		return os;
	}

}