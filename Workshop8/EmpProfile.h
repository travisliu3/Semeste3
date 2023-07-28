/*
*****************************************************************************
						OOP244-Workshop-8, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 14 November, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#ifndef SDDS_EMPPROFILE_H
#define SDDS_EMPPROFILE_H

#include <iomanip>
#include <string>
#include <fstream>
#include <iostream>

namespace sdds {
	struct Employee {
		std::string id;
		std::string name;
		bool load(std::ifstream& f) {
			f >> id >> name;
			return f.good();
		}

		void print(std::ostream& os) const {
			os << std::setw(10) << id << std::setw(7) << name << std::endl;
		}
	};

	struct Salary {
		std::string id;
		double salary;
		bool load(std::ifstream& f) {
			f >> id >> salary;
			return f.good();
		}

		void print(std::ostream& os) const {
			os << std::setw(10) << id << std::setw(10) << salary << std::endl;
		}
	};


	struct EmployeeWage {
		std::string name{};
		double m_salary{};
		int m_counter{};
		static int recCount;
		static bool Trace;

		EmployeeWage() {
			m_counter = ++recCount;
			if (Trace)
			{
				std::cout << "Default Constructor [" << m_counter << "]" << std::endl;
			}
		}

		EmployeeWage(const std::string& str, double sal)
		{
			this->name = str;
			this->m_salary = sal;
			m_counter = ++recCount;
			if (Trace)
			{
				std::cout << "Ovdrloaded Constructor" << std::setw(6) << "[" << m_counter << "]" << std::endl;
			}
		}

		EmployeeWage(const EmployeeWage& copyEmpProf) {
			this->name = copyEmpProf.name;
			this->m_salary = copyEmpProf.m_salary;
			m_counter = ++recCount;
			if (Trace)
			{
				std::cout << "Copy Constructor " << std::setw(11) << "[" << m_counter << "] from [" << copyEmpProf.m_counter << "]" << std::endl;
			}
		}

		~EmployeeWage() {
			if (Trace)
			{
				std::cout << "Destructor " << std::setw(17) << "[" << m_counter << "]" << std::endl;
			}
		}

		//TODO: add a function here to check correct salary range
		void rangeValidator() const{
			std::string err{ "*** Employees salaray range is not valid" };
			if (m_salary > 99999)
			{
				throw err;
			}
			else if (m_salary < 0)
			{
				throw err;
			}
		}

		void print(std::ostream& os)const {
			os << std::setw(15) << name << std::setw(10) << m_salary << std::endl;
		}

	};
}
#endif // !SDDS_EMPPROFILE_H