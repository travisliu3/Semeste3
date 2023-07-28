// Name: Travis Liu
// Seneca Student ID: 156740201
// Seneca email: tliu84@myseneca.ca
// Date of completion: 24 October, 2022
//
// I confirm that I am the only author of this file
//   and the content was created entirely by me.
#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>
#include "LineManager.h"

using namespace std;

namespace sdds {

	LineManager::LineManager(const std::string& file, const std::vector<Workstation*>& stations) :m_activeLine{}, m_cntCustomerOrder{}, m_firstStation{} {

		ifstream in(file);
		string str{};
		while (!in.eof())
		{
			getline(in, str);
			string current{};
			string next{};
			auto found = str.find('|');
			if (found != std::string::npos)
			{
				current = str.substr(0, found);
				next = str.substr(found + 1);
			}
			else
			{
				current = str.substr(0);
			}
			auto activework = find_if(stations.begin(), stations.end(), [&current](Workstation* station) {
				return station->getItemName() == current;
				});
			m_activeLine.push_back(*activework);
			auto nextpresent = any_of(stations.begin(), stations.end(), [&next](Workstation* station) {
				return (station->getItemName() == next);
				});
			if (nextpresent)
			{
				auto nextstation = find_if(stations.begin(), stations.end(), [&next](Workstation* station) {
					return station->getItemName() == next;
					});
				m_activeLine.back()->setNextStation(*nextstation);
			}
		}
		for_each(m_activeLine.begin(), m_activeLine.end(), [&](Workstation* station) {
			auto avilable = any_of(m_activeLine.begin(), m_activeLine.end(), [&station](Workstation* avi) {
				return (station == avi->getNextStation());
				});
			if (!avilable)
			{
				m_firstStation = station;
			}
			});
		m_cntCustomerOrder = g_pending.size();

	}

	void LineManager::reorderStations() {

		vector<Workstation*> copy{};
		copy.push_back(m_firstStation);
		Workstation* nextptr = m_firstStation->getNextStation();
		if (nextptr != nullptr)
		{
			for (size_t i = 0; i < m_activeLine.size() - 1; i++)
			{
				copy.push_back(nextptr);
				nextptr = nextptr->getNextStation();
			}
		}
		m_activeLine = copy;

	}
	
	bool LineManager::run(std::ostream& os) {
		static int iteration{};
		os << "Line Manager Iteration: " << ++iteration << endl;
		if (!g_pending.empty())
		{
			*m_firstStation += move(g_pending.front());
			g_pending.pop_front();
		}
		for_each(m_activeLine.begin(), m_activeLine.end(), [&](Workstation* line) {
			line->fill(os);
			});
		for (auto it = m_activeLine.begin(); it != m_activeLine.end(); it++)
		{
			(*it)->attemptToMoveOrder();
		}
		return g_completed.size() + g_incomplete.size() == m_cntCustomerOrder;
	}

	void LineManager::display(std::ostream& os) const {
		for_each(m_activeLine.begin(), m_activeLine.end(), [&](const Workstation* line) {line->display(os); });
	}

}