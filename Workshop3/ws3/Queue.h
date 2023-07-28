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
#ifndef SDDS_QUEUE_H__
#define SDDS_QUEUE_H__
#include <iostream>
#include "Dictionary.h"

namespace sdds {

	template <typename T, unsigned int CAPACITY> // template header
	class Queue
	{
		static T obj[CAPACITY];
		static unsigned int Size;
	public:
		virtual ~Queue() {};
		virtual bool push(const T& item);
		T pop();
		unsigned int size() const;
		void display(std::ostream& os = std::cout) const;
		T operator[](size_t i)const;
	};

	template <typename T, unsigned int CAPACITY>
	T Queue<T, CAPACITY>::obj[CAPACITY]{};

	template <>
	sdds::Dictionary Queue<sdds::Dictionary, 100>::obj[100]{};

	template <>
	unsigned int Queue<sdds::Dictionary, 100>::Size{};

	template <typename T, unsigned int CAPACITY>
	unsigned int Queue<T, CAPACITY>::Size{};

	template <typename T, unsigned int CAPACITY>
	bool Queue<T, CAPACITY>::push(const T& item) {
		if (CAPACITY > size())
		{
			obj[Size] = item;
			Size++;
			return true;
		}
		return false;
	}

	template <typename T, unsigned int CAPACITY>
	T Queue<T, CAPACITY>::pop() {
		T temp;
		temp = obj[0];
		for (unsigned int i = 0; i < size(); i++)
		{
			obj[i] = obj[i + 1];
		}
		Size--;
		return temp;
	}

	template <typename T, unsigned int CAPACITY>
	unsigned int Queue<T, CAPACITY>::size() const {
		return Size;
	}

	template <typename T, unsigned int CAPACITY>
	void Queue<T, CAPACITY>::display(std::ostream& os) const {
		std::cout << "----------------------" << std::endl;
		std::cout << "| Dictionary Content |" << std::endl;
		std::cout << "----------------------" << std::endl;
		for (size_t i = 0; i < size(); i++)
		{
			os << obj[i] << std::endl;
		}
		std::cout << "----------------------" << std::endl;
	}

	template <typename T>
	std::ostream& operator<<(std::ostream& os, T& que) {
		os << que;
		return os;
	}

	template <typename T, unsigned int CAPACITY>
	T Queue<T, CAPACITY>::operator[](size_t i) const {
		T dummy{};
		if (i < size())
		{
			return obj[i];
		}
		return dummy;
	}

	template <>
	sdds::Dictionary Queue<sdds::Dictionary, 100>::operator[](size_t i) const {
		sdds::Dictionary dummy("Empty Term", "Empty Substitute");
		if (i < size())
		{
			return obj[i];
		}
		return dummy;
	}

}
#endif