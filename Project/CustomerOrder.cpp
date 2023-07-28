// Name: Travis Liu
// Seneca Student ID: 156740201
// Seneca email: tliu84@myseneca.ca
// Date of completion: 24 October, 2022
//
// I confirm that I am the only author of this file
//   and the content was created entirely by me.
#include <iostream>
#include <string>
#include "CustomerOrder.h"
#include "Utilities.h"

using namespace std;

namespace sdds {

	size_t CustomerOrder::m_widthField = 0;
	CustomerOrder::CustomerOrder() :m_name{}, m_product{}, m_cntItem{}, m_lstItem{} {}

	CustomerOrder::CustomerOrder(const std::string& str) :m_name{}, m_product{}, m_cntItem{}, m_lstItem{} {
		Utilities util;
		size_t pos = 0;
		bool more = true;
		m_name = util.extractToken(str, pos, more);
		m_product = util.extractToken(str, pos, more);
		size_t newpos = pos;
		while (more)
		{
			auto token = util.extractToken(str, pos, more);
			m_cntItem++;
		}
		more = true;
		m_lstItem = new Item * [m_cntItem];
		for (int i = 0; more; i++)
		{
			m_lstItem[i] = new Item(util.extractToken(str, newpos, more));
		}
		m_widthField = m_widthField > util.getFieldWidth() ? m_widthField : util.getFieldWidth();
	}

	CustomerOrder::CustomerOrder(const CustomerOrder& copy) {
		throw "";
	}

	CustomerOrder::CustomerOrder(CustomerOrder&& move) noexcept :m_name{}, m_product{}, m_cntItem{}, m_lstItem{} {
		*this = std::move(move);
	}

	CustomerOrder& CustomerOrder::operator=(CustomerOrder&& move) noexcept {
		if (this != &move)
		{
			for (size_t i = 0; i < m_cntItem; i++) {
				delete m_lstItem[i];
			}
			delete[] m_lstItem;
			m_name = move.m_name;
			move.m_name = {};
			m_product = move.m_product;
			move.m_product = {};
			m_cntItem = move.m_cntItem;
			move.m_cntItem = {};
			m_lstItem = move.m_lstItem;
			move.m_lstItem = nullptr;
		}
		return *this;
	}

	CustomerOrder::~CustomerOrder() {
		for (size_t i = 0; i < m_cntItem; i++)
		{
			delete m_lstItem[i];
		}
		delete[] m_lstItem;
	}

	bool CustomerOrder::isOrderFilled() const {
		for (size_t i = 0; i < m_cntItem; i++)
		{
			if (m_lstItem[i]->m_isFilled == false) {
				return m_lstItem[i]->m_isFilled;
			}
		}
		return true;
	}

	bool CustomerOrder::isItemFilled(const std::string& itemName) const {
		for (size_t i = 0; i < m_cntItem; i++)
		{
			if (m_lstItem[i]->m_itemName == itemName) {
				if (m_lstItem[i]->m_isFilled == false) {
					return m_lstItem[i]->m_isFilled;
				}
			}
		}
		return true;
	}

	void CustomerOrder::fillItem(Station& station, std::ostream& os) {
		for (size_t i = 0; i < m_cntItem; i++)
		{
			if (station.getItemName() == m_lstItem[i]->m_itemName && !m_lstItem[i]->m_isFilled) {
				if (station.getQuantity())
				{
					station.updateQuantity();
					m_lstItem[i]->m_serialNumber = station.getNextSerialNumber();
					m_lstItem[i]->m_isFilled = true;
					os << "    Filled " << m_name << ", " << m_product << " [" << m_lstItem[i]->m_itemName << "]" << endl;
					break;
				}
				else
				{
					os << "    Unable to fill " << m_name << ", " << m_product << " [" << m_lstItem[i]->m_itemName << "]" << endl;
				}
			}
		}
	}

	void CustomerOrder::display(std::ostream& os) const {
		os << m_name << " - " << m_product << std::endl;
		for (size_t i = 0; i < m_cntItem; i++)
		{
			os << "[";
			os.setf(ios::right);
			os.fill('0');
			os.width(6);
			os << m_lstItem[i]->m_serialNumber << "] ";
			os.unsetf(ios::right);
			os.fill(' ');
			os.width(m_widthField);
			os.setf(ios::left);
			os << m_lstItem[i]->m_itemName << "   - ";
			if (m_lstItem[i]->m_isFilled)
			{
				os << "FILLED" << endl;
			}
			else
			{
				os << "TO BE FILLED" << endl;
			}
		}
	}

}