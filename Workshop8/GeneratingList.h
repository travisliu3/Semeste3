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
#ifndef SDDS_GENERATINGLIST_H
#define SDDS_GENERATINGLIST_H

#include <iostream>
#include <iomanip>
#include <vector>
#include <string>
#include <memory>
#include <utility>
#include <fstream>

namespace sdds {
	template<typename T>
	class GeneratingList {

		std::vector<T> list;
	public:

		GeneratingList() {}
		GeneratingList(const char* f) {
			std::ifstream file(f);
			if (!file)
				throw std::string("*** Failed to open file ") + std::string(f) + std::string(" ***");

			while (file) {
				T t;
				if (t.load(file))
					list.push_back(T(t));
			}
		}

		size_t size() const { return list.size(); }
		const T& operator[](size_t i) const { return list[i]; }

		//TODO: Implement the Luhn Algorithm to check the 
		//      valadity of SIN No's
		bool checkSIN(const std::string sin) const{
			int sum{};
			for (size_t i = 0; i < sin.length(); i++)
			{
				std::string temp{};
				temp += sin[i];
				int check = std::stoi(temp);
				if (i % 2 != 0)
				{
					check *= 2;
					if (check > 9)
					{
						check -= 9;
					}
				}
				sum += check;
			}
			if (sum % 10 == 0)
			{
				return true;
			}
			return false;
		}

		//TODO: Overload the += operator with a smart pointer
		// as a second operand.
		void operator+=(std::unique_ptr<T>& item) {
			list.push_back(*item);
		}

		//TODO: Overload the += operator with a raw pointer
		// as a second operand.
		void operator+=(T* item) {
			list.push_back(*item);
		}

		void print(std::ostream& os) const {
			os << std::fixed << std::setprecision(2);
			for (auto& e : list)
				e.print(os);
		}
	};

	template<typename T>
	std::ostream& operator<<(std::ostream& os, const GeneratingList<T>& rd) {
		rd.print(os);
		return os;
	}
}
#endif // !SDDS_GENERATINGLIST_H