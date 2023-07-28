/*
*****************************************************************************
						OOP244-Workshop-5, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 10 October, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#ifndef SDDS_COLLECTION_H__
#define SDDS_COLLECTION_H__
#include <iostream>
#include <string>
#include <stdexcept>

namespace sdds {

	template<typename T>
	class Collection {
		
		std::string m_name;
		T* m_items;
		size_t m_size;
		void (*observe)(const Collection<T>& coll, const T& itm);
	public:
		Collection(const std::string& name);
		~Collection();
		const std::string& name() const;
		size_t size() const;
		void setObserver(void (*observer)(const Collection<T>& collect, const T& item));
		Collection<T>& operator+=(const T& item);
		T& operator[](size_t idx) const;
		T* operator[](const std::string& title) const;

	};

	template<typename T>
	Collection<T>::Collection(const std::string& name) :m_name{}, m_items{}, m_size{}, observe{} {
		m_name = name;
	}

	template<typename T>
	Collection<T>::~Collection() {
		delete[] m_items;
	}

	template<typename T>
	const std::string& Collection<T>::name() const {
		return m_name;
	}

	template<typename T>
	size_t Collection<T>::size() const {
		return m_size;
	}

	template<typename T>
	void Collection<T>::setObserver(void (*observer)(const Collection<T>& collect, const T& item)) {
		observe = observer;
	}
	
	template<typename T>
	Collection<T>& Collection<T>::operator+=(const T& item) {
		for (size_t i = 0; i < m_size; i++)
		{
			if (m_items[i].title() == item.title()) {
				return *this;
			}
		}
		T* newitem = new T[m_size + 1];
		for (size_t i = 0; i < m_size; i++)
		{
			newitem[i] = m_items[i];
		}
		newitem[m_size] = item;
		delete[] m_items;
		m_items = newitem;
		m_size++;
		if (observe != nullptr)
		{
			observe(*this, item);
		}
		return *this;
	}

	template<typename T>
	T& Collection<T>::operator[](size_t idx) const {
		if (m_size <= idx)
		{
			throw std::out_of_range("Bad index [" + std::to_string(idx) + "]. Collection has [" + std::to_string(m_size) + "] items.");
		}
		return m_items[idx];
	}

	template<typename T>
	T* Collection<T>::operator[](const std::string& title) const {
		for (size_t i = 0; i < m_size; i++)
		{
			if (title == m_items[i].title()) {
				return m_items + i;
			}
		}
		return nullptr;
	}

	template <typename T>
	std::ostream& operator<<(std::ostream& os, Collection<T>& collect) {
		for (size_t i = 0; i < collect.size(); i++)
		{
			os << collect[i];
		}
		return os;
	}

}
#endif