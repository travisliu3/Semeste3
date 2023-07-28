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
#include <iostream>
#include <string>
#include <cstring>
#include "Reservation.h"

using namespace std;

namespace sdds {

	Reservation::Reservation() :reserveid{}, name{}, email{}, nopeople{}, m_day{}, hour{} { }

	Reservation::Reservation(const string& res) {

		reserveid = res;
		while (reserveid[0] == ' ')
		{
			reserveid.erase(0, 1);
		}
		while (reserveid[reserveid.find(':') - 1] == ' ')
		{
			reserveid.erase(reserveid.find(':') - 1, 1);
		}
		reserveid.erase(reserveid.find(':'));


		name = res.substr(res.find(':') + 1);
		while (name[0] == ' ')
		{
			name.erase(0, 1);
		}
		while (name[name.find(',') - 1] == ' ')
		{
			name.erase(name.find(',') - 1, 1);
		}
		name.erase(name.find(','));


		email = res.substr(res.find(name) + strlen(name.c_str()));
		while (email[0] == ' ' || email[0] == ',')
		{
			email.erase(0, 1);
		}
		while (email[email.find(',') - 1] == ' ')
		{
			email.erase(email.find(',') - 1, 1);
		}
		email.erase(email.find(','));


		string people = res.substr(res.find(name) + strlen(name.c_str()));
		people.erase(0, people.find(',') + 1);
		people.erase(0, people.find(',') + 1);
		people.erase(people.find(','));
		nopeople = stoi(people);


		string day = res.substr(res.find(email) + strlen(email.c_str()));
		day.erase(0, day.find(',') + 1);
		day.erase(0, day.find(',') + 1);
		day.erase(day.find(','));
		m_day = stoi(day);


		string time = res.substr(res.find(people) + strlen(people.c_str()));
		time.erase(0, time.find(',') + 1);
		time.erase(0, time.find(',') + 1);
		hour = stoi(time);
		
	}

	void Reservation::update(int day, int time) {
		m_day = day;
		hour = time;
	}

	void Reservation::display(ostream& os) const {
		os.width(11);
		os << reserveid << ':';
		os.width(21);
		os << name;
		os << "  ";
		os.setf(ios::left);
		os.width(21);
		os << '<' + email + '>';
		os.unsetf(ios::left);

		if (hour >= 6 && hour <= 9)
		{
			os << "   Breakfast on day " <<  m_day << " @ " << hour << ":00 for ";
		}
		else if (hour >= 11 && hour <= 15)
		{
			os << "   Lunch on day " << m_day << " @ " << hour << ":00 for ";
		}
		else if (hour >= 17 && hour <= 21)
		{
			os << "   Dinner on day " << m_day << " @ " << hour << ":00 for ";
		}
		else
		{
			os << "   Drinks on day " << m_day << " @ " << hour << ":00 for ";
		}
		if (nopeople == 1)
		{
			os << nopeople << " person.";
		}
		else
		{
			os << nopeople << " people.";
		}
		os << endl;

	}

	ostream& operator<<(ostream& os, const Reservation& reserve) {
		os << "Reservation";
		reserve.display(os);
		return os;
	}

}