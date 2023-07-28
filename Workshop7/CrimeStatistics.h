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
#ifndef SDDS_CRIMESTATISTICS_H
#define SDDS_CRIMESTATISTICS_H
#include <iostream>
#include <string>
#include <vector>
#include <list>

namespace sdds
{
	
	struct Crime {
		std::string m_province;
		std::string m_district;
		std::string m_crimes;
		size_t m_cases;
		size_t m_year;
		size_t m_resolved;
	};

	class CrimeStatistics {
		std::vector<Crime> m_crime;
	public:
		CrimeStatistics(const std::string& file);
		void display(std::ostream& out) const;
		void sort(const std::string& field);
		void cleanList();
		bool inCollection(const std::string& crime) const;
		std::list<Crime> getListForProvince(const std::string& prov) const;
	};

	std::ostream& operator<<(std::ostream& out, const Crime& theCrime);

}

#endif