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
#ifndef SDDS_TENNISLOG_H__
#define SDDS_TENNISLOG_H__
#include <iostream>
#include <string>

namespace sdds {

	struct TennisMatch {

		std::string tournamentid{};
		std::string tournamentname{};
		int matchid{};
		std::string winner{};
		std::string loser{};

		operator bool() const;

	};

	std::ostream& operator<<(std::ostream& os, const TennisMatch& match);

	class TennisLog {

		TennisMatch* matches;
		int totalmatches;
	public:
		void setempty();
		TennisLog();
		TennisLog(char* filename);
		TennisLog(const TennisLog& copy);
		TennisLog(TennisLog&& move);
		~TennisLog();
		TennisLog& operator=(const TennisLog& copy);
		TennisLog& operator=(TennisLog&& move);
		void addMatch(TennisMatch& match);
		TennisLog findMatches(const char* name) const;
		TennisMatch operator[](size_t i) const;
		operator size_t();

	};

}
#endif