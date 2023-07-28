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
#include "Restaurant.h"
#include "Reservation.h"

using namespace std;
using namespace sdds;

namespace sdds {

	Restaurant::Restaurant() :reserve{}, m_cnt{} { }

	Restaurant::Restaurant(Restaurant& copy) :reserve{}, m_cnt{} {
		*this = copy;
	}

	Restaurant::Restaurant(Restaurant&& move) :reserve{}, m_cnt{} {
		*this = std::move(move);
	}

	Restaurant::Restaurant(const Reservation* reservations[], size_t cnt){
		m_cnt = cnt;
		reserve = new Reservation * [m_cnt];
		for (size_t i = 0; i < m_cnt; i++)
		{
			reserve[i] = new Reservation;
			*reserve[i] = *reservations[i];
		}
	}

	Restaurant::~Restaurant(){
		for (size_t i = 0; i < m_cnt; i++)
		{
			delete reserve[i];
		}
		delete[] reserve;
	}

	Restaurant& Restaurant::operator=(const Restaurant& copy){
		if (this != &copy)
		{
			for (size_t i = 0; i < m_cnt; i++)
			{
				delete reserve[i];
			}
			delete[] reserve;
			m_cnt = copy.m_cnt;
			reserve = new Reservation * [m_cnt];
			for (size_t i = 0; i < m_cnt; i++)
			{
				reserve[i] = new Reservation;
				*reserve[i] = *copy.reserve[i];
			}
		}
		return *this;
	}

	Restaurant& Restaurant::operator=(Restaurant&& move){
		if (this != &move)
		{
			for (size_t i = 0; i < m_cnt; i++)
			{
				delete reserve[i];
			}
			m_cnt = move.m_cnt;
			move.m_cnt = 0;
			reserve = move.reserve;
			move.reserve = nullptr;
		}
		return *this;
	}

	size_t Restaurant::size() const{
		return m_cnt;
	}

	void Restaurant::display(ostream& os) const {
		for (size_t i = 0; i < m_cnt; i++)
		{
			os << *reserve[i];
		}
	}

	ostream& operator<<(ostream& os, const Restaurant& reserve) {
		static int CALL_CNT = 1;
		if (reserve.size() == 0)
		{
			os << "--------------------------" << endl;
			os << "Fancy Restaurant (" << CALL_CNT << ")" << endl;
			os << "--------------------------" << endl;
			os << "This restaurant is empty!" << endl;
			os << "--------------------------" << endl;
		}
		else
		{
			os << "--------------------------" << endl;
			os << "Fancy Restaurant (" << CALL_CNT << ")" << endl;
			os << "--------------------------" << endl;
			reserve.display(os);
			os << "--------------------------" << endl;
		}
		CALL_CNT++;
		return os;
	}

}