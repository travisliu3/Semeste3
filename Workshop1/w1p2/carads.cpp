/*
*****************************************************************************
						OOP244-Workshop-1, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 11 September, 2022
Section    : ZCC

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include<string>
#include<cstring>
#include"carads.h"

using namespace std;

double g_taxrate{};
double g_discount{};

namespace sdds {

	void listArgs(int argc, char** argv) {
		cout << "Command Line:" << endl;
		cout << "--------------------------" << endl;
		for (int i = 0; i < argc; i++)
		{
			cout << "  " << i + 1 << ": " << argv[i] << endl;
		}
		cout << "--------------------------\n" << endl;
	}

	Cars::Cars() {
		brand = nullptr;
		model = nullptr;
	}

	Cars::~Cars() {
		delete[] brand;
		delete[] model;
	}

	void Cars::operator=(const Cars& car) {
		brand = new char[char_traits<char>::length(car.brand) + 1];
		strcpy(brand, car.brand);
		model = new char[char_traits<char>::length(car.model) + 1];
		strcpy(model, car.model);
		year = car.year;
		price = car.price;
		status = car.status;
		discount = car.discount;
		dis = car.dis;
	}

	void Cars::read(std::istream& is) {
		if (is.good())
		{
			delete[] brand;
			delete[] model;
			string bb{}, mm{};
			is.get(status);
			is.ignore(1000, ',');
			getline(is, bb, ',');
			brand = new char[char_traits<char>::length(bb.c_str()) + 1];
			strcpy(brand, bb.c_str());
			getline(is, mm, ',');
			model = new char[char_traits<char>::length(mm.c_str()) + 1];
			strcpy(model, mm.c_str());
			is >> year;
			is.ignore();
			is >> price;
			is.ignore();
			is >> discount;
			is.clear();
			is.ignore(1000, '\n');
			if (discount == 'Y')
			{
				dis = true;
			}
			else
			{
				dis = false;
			}
		}
	}

	void Cars::display(bool reset) const{
		static int counter = 1;
		if (reset)
		{
			counter = 1;
		}
		cout.setf(ios::fixed);
		cout.width(2);
		cout.setf(ios::left);
		cout << counter << ". ";
		cout.unsetf(ios::left);
		cout.unsetf(ios::fixed);
		cout.setf(ios::fixed);
		cout.width(10);
		cout.setf(ios::left);
		cout << brand << "| ";
		cout.unsetf(ios::left);
		cout.unsetf(ios::fixed);
		cout.setf(ios::fixed);
		cout.width(15);
		cout.setf(ios::left);
		cout << model << "| ";
		cout.unsetf(ios::left);
		cout.unsetf(ios::fixed);
		cout.setf(ios::fixed);
		cout.width(5);
		cout.setf(ios::left);
		cout << year << "|";
		cout.unsetf(ios::left);
		cout.unsetf(ios::fixed);
		cout.setf(ios::fixed);
		cout.width(12);
		cout.setf(ios::right);
		cout.precision(2);
		cout << price + (price * g_taxrate) << "|";
		cout.unsetf(ios::right);
		cout.unsetf(ios::fixed);
		if (dis)
		{
			cout.setf(ios::fixed);
			cout.width(12);
			cout.setf(ios::right);
			cout.precision(2);
			cout << price + (price * g_taxrate) - ((price + (price * g_taxrate)) * g_discount) << endl;
			cout.unsetf(ios::right);
			cout.unsetf(ios::fixed);
		}
		else
		{
			cout << endl;
		}
		counter++;
	}

	char Cars::getStatus() {
		return status;
	}

	Cars::operator bool() const{
		return (status == 'N');
	}

	istream& operator>>(std::istream& is, Cars& car) {
		car.read(is);
		return is;
	}

	void operator>>(const Cars& car1, Cars& car2) {
		car2 = car1;
	}

}