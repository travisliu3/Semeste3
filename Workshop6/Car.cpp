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
#include "Car.h"

using namespace std;

namespace sdds {

	Car::Car(std::istream& file) {

		if (file)
		{
			getline(file, m_maker, ',');
			while (m_maker[0] == ' ')
			{
				m_maker.erase(0, 1);
			}
			while (m_maker[m_maker.length() - 1] == ' ')
			{
				m_maker.erase(m_maker.length() - 1, 1);
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
				file.ignore(1000, '\n');
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

	std::string Car::condition() const {
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

	double Car::topSpeed() const {
		return m_topspeed;
	}

	void Car::display(std::ostream& out) const {
		out << "| ";
		out.width(10);
		out << m_maker << " | ";
		out.setf(ios::left);
		out.width(6);
		out << condition();
		out << " | ";
		out.setf(ios::fixed);
		out.width(6);
		out.precision(2);
		out << topSpeed() << " |";
		out.unsetf(ios::fixed);
		out.unsetf(ios::left);
	}

}