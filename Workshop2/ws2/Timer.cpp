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
#include <iostream>
#include "Timer.h"
#include <chrono>

using namespace std;

namespace sdds {

	void Timer::start() {
		tstart = chrono::steady_clock::now();
	}

	long int Timer::stop() {
		tstop = chrono::steady_clock::now();
		time = std::chrono::duration_cast<std::chrono::nanoseconds>(tstop - tstart);
		return time.count();
	}

}