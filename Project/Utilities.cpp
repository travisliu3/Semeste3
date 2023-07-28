// Name: Travis Liu
// Seneca Student ID: 156740201
// Seneca email: tliu84@myseneca.ca
// Date of completion: 24 October, 2022
//
// I confirm that I am the only author of this file
//   and the content was created entirely by me.
#include <iostream>
#include <string>
#include "Utilities.h"

using namespace std;

namespace sdds {

	char Utilities::m_delimiter{};
	Utilities::Utilities() :m_widthField{1} {}

	void Utilities::setFieldWidth(size_t newWidth) {
		m_widthField = newWidth;
	}

	size_t Utilities::getFieldWidth() const {
		return m_widthField;
	}

	std::string Utilities::extractToken(const std::string& str, size_t& next_pos, bool& more) {
		if (m_delimiter == str[next_pos])
		{
			more = false;
			throw "";
		}
		string local_str = str.substr(next_pos, str.find(m_delimiter, next_pos) - next_pos);
		while (local_str[0] == ' ')
		{
			local_str.erase(0, 1);
		}
		while (local_str[local_str.length() - 1] == ' ')
		{
			local_str.erase(local_str.length() - 1, 1);
		}
		next_pos = str.find(m_delimiter, next_pos) + 1;
		m_widthField = m_widthField > local_str.length() ? m_widthField : local_str.length();
		if (!next_pos)
		{
			more = false;
		}
		return local_str;
	}

	void Utilities::setDelimiter(char newDelimiter) {
		m_delimiter = newDelimiter;
	}

	char Utilities::getDelimiter() {
		return m_delimiter;
	}

}