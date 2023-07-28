/*
*****************************************************************************
						OOP244-Workshop-3, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 27 September, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#ifndef SDDS_UNIQUEQUEUE_H__
#define SDDS_UNIQUEQUEUE_H__
#include <iostream>
#include <cmath>
#include "Queue.h"

namespace sdds {

	template <typename T>
	class UniqueQueue : public Queue<T, 100> {
	public:
		bool push(const T& item);
	};

	template <typename T>
	bool UniqueQueue<T>::push(const T& item) {
		for (size_t i = 0; i < Queue<T, 100>::size(); i++)
		{
			if (Queue<T, 100u>::operator[](i) == item)
				return false;
		}
		return Queue<T, 100u>::push(item);
	}

	template <> // denotes specialization
	bool UniqueQueue<double>::push(const double& item)
	{
		for (size_t i = 0; i < size(); i++)
		{
			double temp = fabs(Queue<double, 100>::operator[](i) - item);
			if (temp <= 0.005)
				return false;
		}
		return Queue<double, 100>::push(item);
	}

	template <typename T>
	std::ostream& operator<<(std::ostream& os, T que) {
		os << que;
		return os;
	}

}
#endif