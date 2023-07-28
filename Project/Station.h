// Name: Travis Liu
// Seneca Student ID: 156740201
// Seneca email: tliu84@myseneca.ca
// Date of completion: 24 October, 2022
//
// I confirm that I am the only author of this file
//   and the content was created entirely by me.
#ifndef SDDS_STATION_H__
#define SDDS_STATION_H__
#include <string>

namespace sdds {

	class Station {

		int m_id;
		std::string m_name;
		std::string m_des;
		size_t m_serialNumber;
		size_t m_items;
		static size_t m_widthField;
		static int id_generator;
	public:
		Station();
		Station(const std::string str);
		const std::string& getItemName() const;
		size_t getNextSerialNumber();
		size_t getQuantity() const;
		void updateQuantity();
		void display(std::ostream& os, bool full) const;

	};

}
#endif