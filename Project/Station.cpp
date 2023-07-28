// Name: Travis Liu
// Seneca Student ID: 156740201
// Seneca email: tliu84@myseneca.ca
// Date of completion: 24 October, 2022
//
// I confirm that I am the only author of this file
//   and the content was created entirely by me.
#include <iostream>
#include <string>
#include "Station.h"
#include "Utilities.h"

using namespace std;

namespace sdds {
	
	size_t Station::m_widthField = 0;
	int Station::id_generator = 0;
	Station::Station() :m_id{}, m_name{}, m_des{}, m_serialNumber{}, m_items{} {}

	Station::Station(const std::string str) {
		Utilities util;
		size_t pos = 0;
		bool more = true;
		m_id = ++id_generator;
		m_name = util.extractToken(str, pos, more);
		m_serialNumber = stoi(util.extractToken(str, pos, more));
		m_items = stoi(util.extractToken(str, pos, more));
		m_widthField = m_widthField > util.getFieldWidth() ? m_widthField : util.getFieldWidth();
		m_des = util.extractToken(str, pos, more);
	}

	const std::string& Station::getItemName() const {
		return m_name;
	}

	size_t Station::getNextSerialNumber() {
		return m_serialNumber++;
	}

	size_t Station::getQuantity() const {
		return m_items;
	}

	void Station::updateQuantity() {
		if (m_items > 0)
			m_items--;
	}

	void Station::display(std::ostream& os, bool full) const {
		if (full)
		{
			cout.setf(ios::right);
			cout.fill('0');
			cout.width(3);
			cout << m_id << " | ";
			cout.unsetf(ios::right);
			cout.setf(ios::left);
			cout.fill(' ');
			cout.width(m_widthField);
			cout << m_name << "  | ";
			cout.unsetf(ios::left);
			cout.fill('0');
			cout.width(6);
			cout << m_serialNumber << " | ";
			cout.fill(' ');
			cout.width(4);
			cout << m_items << " | ";
			cout << m_des;
		}
		else
		{
			cout.setf(ios::right);
			cout.fill('0');
			cout.width(3);
			cout << m_id << " | ";
			cout.unsetf(ios::right);
			cout.setf(ios::left);
			cout.fill(' ');
			cout.width(m_widthField);
			cout << m_name << "  | ";
			cout.unsetf(ios::left);
			cout.fill('0');
			cout.width(6);
			cout << m_serialNumber << " | ";
		}
		cout << endl;
	}

}