/*
*****************************************************************************
						OOP244-Workshop-2, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 18 September, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#ifndef SDDS_TIMER_H__
#define SDDS_TIMER_H__
#include <chrono>

namespace sdds {

	class Timer
	{

		std::chrono::steady_clock::time_point tstart, tstop;
		std::chrono::steady_clock::duration time;
	public:
		void start();
		long int stop();

	};

}
#endif