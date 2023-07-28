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
#include "ConfirmationSender.h"
#include "Reservation.h"

using namespace std;
using namespace sdds;

namespace sdds {

	ConfirmationSender::ConfirmationSender() :m_pReserations{}, m_cnt{} { }

	ConfirmationSender::ConfirmationSender(ConfirmationSender& copy) :m_pReserations{}, m_cnt{} {
		*this = copy;
	}

	ConfirmationSender::ConfirmationSender(ConfirmationSender&& move) :m_pReserations{}, m_cnt{} {
		*this = std::move(move);
	}

	ConfirmationSender::~ConfirmationSender() {
		delete[] m_pReserations;
	}

	ConfirmationSender& ConfirmationSender::operator=(const ConfirmationSender& copy) {
		if (this != &copy)
		{
			for (size_t i = 0; i < m_cnt; i++)
			{
				delete m_pReserations[i];
			}
			m_cnt = copy.m_cnt;
			m_pReserations = new const Reservation * [m_cnt];
			for (size_t i = 0; i < m_cnt; i++)
			{
				m_pReserations[i] = copy.m_pReserations[i];
			}
		}
		return *this;
	}

	ConfirmationSender& ConfirmationSender::operator=(ConfirmationSender&& move) {
		if (this != &move)
		{
			for (size_t i = 0; i < m_cnt; i++)
			{
				delete m_pReserations[i];
			}
			m_cnt = move.m_cnt;
			move.m_cnt = 0;
			m_pReserations = move.m_pReserations;
			move.m_pReserations = nullptr;
		}
		return *this;
	}

	ConfirmationSender& ConfirmationSender::operator+=(const Reservation& res) {
		for (size_t i = 0; i < m_cnt; i++)
		{
			if (m_pReserations[i] == &res) {
				return *this;
			}
		}
		m_cnt++;
		const Reservation** temp = new const Reservation * [m_cnt];
		for (size_t i = 0; i < m_cnt - 1; i++)
		{
			temp[i] = m_pReserations[i];
		}
		temp[m_cnt - 1] = &res;
		delete[] m_pReserations;
		m_pReserations = temp;
		return *this;
	}

	ConfirmationSender& ConfirmationSender::operator-=(const Reservation& res) {
		for (size_t i = 0; i < m_cnt; i++)
		{
			if (m_pReserations[i] == &res) {
				m_pReserations[i] = nullptr;
				while (i < m_cnt - 1)
				{
					m_pReserations[i] = m_pReserations[i + 1];
					i++;
				}
				m_cnt--;
				const Reservation** temp = new const Reservation * [m_cnt];
				for (size_t i = 0; i < m_cnt; i++)
				{
					temp[i] = m_pReserations[i];
				}
				delete[] m_pReserations;
				m_pReserations = temp;
			}
		}
		return *this;
	}

	size_t ConfirmationSender::size() const {
		return m_cnt;
	}

	void ConfirmationSender::display(std::ostream& os) const {
		for (size_t i = 0; i < m_cnt; i++)
		{
			os << *m_pReserations[i];
		}
	}

	std::ostream& operator<<(std::ostream& os, const ConfirmationSender& confirm) {
		if (confirm.size() == 0)
		{
			os << "--------------------------" << endl;
			os << "Confirmations to Send" << endl;
			os << "--------------------------" << endl;
			os << "There are no confirmations to send!" << endl;
			os << "--------------------------" << endl;
		}
		else
		{
			os << "--------------------------" << endl;
			os << "Confirmations to Send" << endl;
			os << "--------------------------" << endl;
			confirm.display(os);
			os << "--------------------------" << endl;
		}
		return os;
	}

}