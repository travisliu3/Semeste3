#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include<cstring>
#include"carads.h"

using namespace std;

double g_taxrate{};
double g_discount{};

namespace sdds {

	void listArgs(int argc, char** argv) {
		cout << "Command Line :" << endl;
		cout << "--------------------------" << endl;
		for (int i = 0; i < argc; i++)
		{
			cout << "\t" << i + 1 << " : " << argv[i] << endl;
		}
		cout << "--------------------------\n" << endl;
	}

	Cars::Cars() {
		brand = new char[10];
		model = new char[15];
	}

	Cars::~Cars() {
		delete[] brand;
		delete[] model;
	}

	void Cars::operator=(Cars& car) {
		strcpy(brand, car.brand);
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
			is.get(status);
			is.ignore(1000, ',');
			is.getline(brand, 10, ',');
			is.getline(model, 15, ',');
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

	void Cars::display(bool reset) {
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

}