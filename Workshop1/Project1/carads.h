#ifndef SDDS_CARADS_H_
#define SDDS_CARADS_H_
#include <iostream>

extern double g_taxrate;
extern double g_discount;

namespace sdds {

	class Cars
	{
		char* brand{};
		char* model{};
		int year{};
		double price{};
		char status{};
		char discount{};
		bool dis{};
	public:
		Cars();
		~Cars();
		void operator=(Cars& car);
		void read(std::istream& is);
		void display(bool reset);
		char getStatus();

	};
	void listArgs(int argc, char** argv);
}
#endif