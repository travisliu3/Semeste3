// Name: Travis Liu
// Seneca Student ID: 156740201
// Seneca email: tliu84@myseneca.ca
// Date of completion: 24 October, 2022
//
// I confirm that I am the only author of this file
//   and the content was created entirely by me.
#include <iostream>
#include <string>
#include "Workstation.h"
#include "Utilities.h"

using namespace std;

namespace sdds {

	deque<CustomerOrder> g_pending{};
	deque<CustomerOrder> g_completed{};
	deque<CustomerOrder> g_incomplete{};
	Workstation::Workstation(std::string& str) : Station(str) {
		m_pNextStation = nullptr;
	}

	void Workstation::fill(std::ostream& os) {
		if (!m_orders.empty())
			m_orders.front().fillItem(*this, os);
	}

	bool Workstation::attemptToMoveOrder() {
		if (!m_orders.empty())
		{
			if (m_orders.front().isItemFilled(getItemName()) || !getQuantity())
			{
				if (m_pNextStation) {
					*m_pNextStation += move(m_orders.front());
				}
				else
				{
					if (m_orders.front().isOrderFilled())
					{
						g_completed.push_back(move(m_orders.front()));
					}
					else
					{
						g_incomplete.push_back(move(m_orders.front()));
					}
				}
				m_orders.pop_front();
				return true;
			}
		}
		return false;
	}

	void Workstation::setNextStation(Workstation* station) {
		m_pNextStation = station;
	}

	Workstation* Workstation::getNextStation() const {
		return m_pNextStation;
	}

	void Workstation::display(std::ostream& os) const {
		os << getItemName();
		if (m_pNextStation)
			os << " --> " << m_pNextStation->getItemName();
		else
			os << " --> " << "End of Line";
		os << endl;
	}

	Workstation& Workstation::operator+=(CustomerOrder&& newOrder) {
		m_orders.push_back(move(newOrder));
		return *this;
	}

}