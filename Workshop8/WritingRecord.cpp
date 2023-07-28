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
#include "GeneratingList.h"
#include "EmpProfile.h"
#include "WritingRecord.h"

using namespace std;

namespace sdds {
	GeneratingList<EmployeeWage> writeRaw(const GeneratingList<Employee>& emp, const GeneratingList<Salary>& sal) {
		GeneratingList<EmployeeWage> activeEmp;

		// TODO: Add your code here to build a list of employees
		//         using raw pointers
		for (size_t i = 0; i < emp.size(); i++)
		{
			for (size_t j = 0; j < sal.size(); j++)
			{
				if (emp[i].id == sal[j].id)
				{
					EmployeeWage* wage = new EmployeeWage(emp[i].name, sal[j].salary);
					try
					{
						wage->rangeValidator();
					}
					catch (const std::string& err)
					{
						delete wage;
						throw err;
					}
					if (emp.checkSIN(emp[i].id))
					{
						activeEmp += wage;
						delete wage;
					}
					else
					{
						throw "";
					}
				}
			}
		}
		return activeEmp;
	}

	GeneratingList<EmployeeWage> writeSmart(const GeneratingList<Employee>& emp, const GeneratingList<Salary>& sal) {
		GeneratingList<EmployeeWage> activeEmp;
		// TODO: Add your code here to build a list of employees
		//         using smart pointers
		for (size_t i = 0; i < emp.size(); i++)
		{
			for (size_t j = 0; j < sal.size(); j++)
			{
				if (emp[i].id == sal[j].id)
				{
					std::unique_ptr<EmployeeWage> wage(new EmployeeWage(emp[i].name, sal[j].salary));
					wage->rangeValidator();
					if (emp.checkSIN(emp[i].id))
					{
						activeEmp += wage;
					}
				}
			}
		}

		return activeEmp;
	}

}