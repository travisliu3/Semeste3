/*
*****************************************************************************
						OOP244-Workshop-7, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 11 November, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#include <iostream>
#include <fstream>
#include <algorithm>
#include <numeric>
#include <iomanip>
#include "CrimeStatistics.h"

using namespace std;

namespace sdds {

	CrimeStatistics::CrimeStatistics(const std::string& file) :m_crime{} {
		ifstream in(file);
		if (!in)
		{
			throw "";
		}
		string tempstring{};
		getline(in, tempstring);
		while (in)
		{
			Crime temp{};
			temp.m_province = tempstring.substr(0, 25);
			while (temp.m_province[temp.m_province.length() - 1] == ' ')
			{
				temp.m_province.erase(temp.m_province.length() - 1, 1);
			}
			temp.m_district = tempstring.substr(25, 25);
			while (temp.m_district[temp.m_district.length() - 1] == ' ')
			{
				temp.m_district.erase(temp.m_district.length() - 1, 1);
			}
			temp.m_crimes = tempstring.substr(50, 25);
			while (temp.m_crimes[temp.m_crimes.length() - 1] == ' ')
			{
				temp.m_crimes.erase(temp.m_crimes.length() - 1, 1);
			}
			temp.m_year = stoi(tempstring.substr(75, 5));
			temp.m_cases = stoi(tempstring.substr(80, 5));
			temp.m_resolved = stoi(tempstring.substr(85, 5));

			m_crime.push_back(temp);
			getline(in, tempstring);
		}
	}

	void CrimeStatistics::display(std::ostream& out) const {
		for_each(m_crime.begin(), m_crime.end(), [&out](const Crime prntcrime) {
			out << prntcrime << endl;
			});
		out << std::setw(89) << std::setfill('-') << '\n' << std::setfill(' ');
		auto crimes = std::accumulate(m_crime.begin(), m_crime.end(), (int)0, [](int crime1, const Crime crime2) {
			return crime1 + crime2.m_cases;
			});
		auto cases = std::accumulate(m_crime.begin(), m_crime.end(), (int)0, [](int crime1, const Crime crime2) {
			return crime1 + crime2.m_resolved;
			});
		out << "| " << std::setw(79) << "Total Crimes:  " << crimes << " |" << '\n' << std::setfill(' ');
		out << "| " << std::setw(79) << "Total Resolved Cases:  " << cases << " |" << '\n' << std::setfill(' ');
	}

	void CrimeStatistics::sort(const std::string& field) {
			std::sort(m_crime.begin(), m_crime.end(), [field](const Crime crime1, const Crime crime2) {
			if (field == "Province")
			{
				return crime1.m_province < crime2.m_province;
			}
			else if (field == "Crime")
			{
				return crime1.m_crimes < crime2.m_crimes;
			}
			else if (field == "Cases")
			{
				return crime1.m_cases < crime2.m_cases;
			}
			else
			{
				return crime1.m_resolved < crime2.m_resolved;
			}
			});
	}

	void CrimeStatistics::cleanList() {
		
		std::transform(m_crime.begin(), m_crime.end(), m_crime.begin(), [](Crime copy) {
			if (copy.m_crimes == "[None]")
			{
				copy.m_crimes = "";
			}
			return copy; });
	}

	bool CrimeStatistics::inCollection(const std::string& crime) const {
		bool flag{};
		flag = any_of(m_crime.begin(), m_crime.end(), [crime](const Crime crim) {
			return crim.m_crimes== crime;
			});
		return flag;
	}

	std::list<Crime> CrimeStatistics::getListForProvince(const std::string& prov) const {
		auto size = count_if(m_crime.begin(), m_crime.end(), [prov](const Crime copy) {
			return copy.m_province == prov;
			});
		list<Crime> crimelist(size);
		std::copy_if(m_crime.begin(), m_crime.end(), crimelist.begin(), [prov](const Crime copy) {
			return copy.m_province == prov;
			});
		return crimelist;
	}

	std::ostream& operator<<(std::ostream& out, const Crime& theCrime) {
		out << "| " << left << setw(21) << theCrime.m_province << " | " << setw(15) << theCrime.m_district << " | " << setw(20) << theCrime.m_crimes;
		out << " | " << right << setw(6) << theCrime.m_year << " | " << setw(4) << theCrime.m_cases << " | " << setw(3) << theCrime.m_resolved << " |";
		return out;
	}

}