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
#include "Van.h"

using namespace std;

namespace sdds {

	Van::Van(std::istream& file) {

		if (file)
		{
			file.ignore();
			getline(file, m_maker, ',');
			while (m_maker[0] == ' ')
			{
				m_maker.erase(0, 1);
			}
			while (m_maker[m_maker.length() - 1] == ' ')
			{
				m_maker.erase(m_maker.length() - 1, 1);
			}
			getline(file, m_type, ',');
			while (m_type[0] == ' ')
			{
				m_type.erase(0, 1);
			}
			while (m_type[m_type.length() - 1] == ' ')
			{
				m_type.erase(m_type.length() - 1, 1);
			}
			if (m_type != "p" && m_type != "m" && m_type != "c")
			{
				throw std::runtime_error("Invalid record!");
			}
			getline(file, m_purpose, ',');
			while (m_purpose[0] == ' ')
			{
				m_purpose.erase(0, 1);
			}
			while (m_purpose[m_purpose.length() - 1] == ' ')
			{
				m_purpose.erase(m_purpose.length() - 1, 1);
			}
			if (m_purpose != "d" && m_purpose != "p" && m_purpose != "c")
			{
				throw std::runtime_error("Invalid record!");
			}
			getline(file, m_condition, ',');
			while (m_condition[0] == ' ')
			{
				m_condition.erase(0, 1);
			}
			if (m_condition.size() == 0)
			{
				m_condition = "n";
			}
			else
			{
				while (m_condition[m_condition.length() - 1] == ' ')
				{
					m_condition.erase(m_condition.length() - 1, 1);
				}
			}
			if (m_condition != "n" && m_condition != "u" && m_condition != "b")
			{
				throw std::runtime_error("Invalid record!");
			}
			string speed{};
			file >> speed;
			while (speed[speed.length() - 1] == ' ' || speed[speed.length() - 1] == ',')
			{
				speed.erase(speed.length() - 1, 1);
			}
			m_topspeed = stod(speed);
			file.ignore();
		}

	}

	std::string Van::condition() const {
		string con{};
		switch (m_condition[0])
		{
		case 'n':
			con = "new";
			break;
		case 'u':
			con = "used";
			break;
		case 'b':
			con = "broken";
			break;
		}
		return con;
	}

	double Van::topSpeed() const {
		return m_topspeed;
	}

	std::string Van::type() const {
		string typ{};
		switch (m_type[0])
		{
		case 'p':
			typ = "pickup";
			break;
		case 'm':
			typ = "mini-bus";
			break;
		case 'c':
			typ = "camper";
			break;
		}
		return typ;
	}

	std::string Van::usage() const {
		string typ{};
		switch (m_purpose[0])
		{
		case 'd':
			typ = "delivery";
			break;
		case 'p':
			typ = "passenger";
			break;
		case 'c':
			typ = "camping";
			break;
		}
		return typ;
	}

	void Van::display(std::ostream& out) const {
		cout << "| ";
		cout.width(8);
		cout << m_maker << " | ";
		cout.setf(ios::left);
		cout.width(12);
		cout << type() << " | ";
		cout.width(12);
		cout << usage() << " | ";
		cout.width(6);
		cout << condition() << " | ";
		cout.setf(ios::fixed);
		cout.width(6);
		cout.precision(2);
		cout << topSpeed() << " |";
		cout.unsetf(ios::fixed);
		cout.unsetf(ios::left);
	}

}