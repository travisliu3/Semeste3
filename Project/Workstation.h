// Name: Travis Liu
// Seneca Student ID: 156740201
// Seneca email: tliu84@myseneca.ca
// Date of completion: 24 October, 2022
//
// I confirm that I am the only author of this file
//   and the content was created entirely by me.
#ifndef SDDS_WORKSTATION_H__
#define SDDS_WORKSTATION_H__
#include <string>
#include <deque>
#include "CustomerOrder.h"
#include "Station.h"

namespace sdds {

	extern std::deque<CustomerOrder> g_pending;  // holds the orders to be placed onto the assembly line at the first station.
	extern std::deque<CustomerOrder> g_completed;
	extern std::deque<CustomerOrder> g_incomplete;

	class Workstation : public Station {

		std::deque<CustomerOrder> m_orders;
		Workstation* m_pNextStation;
	public:
		Workstation(std::string& str);
		Workstation(const Workstation& copy) = delete;
		Workstation(Workstation&& move) = delete;
		Workstation& operator=(Workstation&& move) = delete;
		Workstation& operator=(const Workstation&& move) = delete;
		void fill(std::ostream& os);
		bool attemptToMoveOrder();
		void setNextStation(Workstation* station);
		Workstation* getNextStation() const;
		void display(std::ostream& os) const;
		Workstation& operator+=(CustomerOrder&& newOrder);

	};

}
#endif