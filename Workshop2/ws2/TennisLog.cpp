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
#include <string>
#include <cstring>
#include <fstream>
#include "TennisLog.h"

using namespace std;

namespace sdds {

	TennisMatch::operator bool() const{
		return (tournamentid[0] != '\0' &&
			tournamentname[0] != '\0' &&
			matchid != 0 &&
			winner[0] != '\0' &&
			loser[0] != '\0');
	}

	ostream& operator<<(ostream& os, const TennisMatch& match) {
		if (match)
		{
			cout.fill('.');
			cout.width(23);
			cout << "Tourney ID : ";
			cout.setf(ios::left);
			cout.width(30);
			cout << match.tournamentid << endl;
			cout.unsetf(ios::left);

			cout.width(23);
			cout << "Match ID : ";
			cout.setf(ios::left);
			cout.width(30);
			cout << match.matchid << endl;
			cout.unsetf(ios::left);

			cout.width(23);
			cout << "Tourney : ";
			cout.setf(ios::left);
			cout.width(30);
			cout << match.tournamentname << endl;
			cout.unsetf(ios::left);

			cout.width(23);
			cout << "Winner : ";
			cout.setf(ios::left);
			cout.width(30);
			cout << match.winner << endl;
			cout.unsetf(ios::left);

			cout.width(23);
			cout << "Loser : ";
			cout.setf(ios::left);
			cout.width(30);
			cout << match.loser << endl;
			cout.unsetf(ios::left);
			cout.fill(' ');
		}
		else
			cout << "Empty Match";
		return os;
	}

	void TennisLog::setempty() {
		delete[] matches;
		matches = nullptr;
		totalmatches = 0;
	}

	TennisLog::TennisLog() : matches{}, totalmatches {} { }

	TennisLog::TennisLog(char* filename) {
		totalmatches = 0;
		std::ifstream in(filename);
		while (!in.eof()) {
			in.ignore(1000, '\n');
			totalmatches++;
		}
		totalmatches -= 2;
		matches = new TennisMatch[totalmatches];
		in.close();
		in.open(filename);
		in.ignore(1000, '\n');
		for (int i = 0; i < totalmatches; i++) {
			getline(in, matches[i].tournamentid, ',');
			getline(in, matches[i].tournamentname, ',');
			in >> matches[i].matchid;
			in.ignore();
			getline(in, matches[i].winner, ',');
			getline(in, matches[i].loser, '\n');
		}
		in.close();
	}

	TennisLog::TennisLog(const TennisLog& copy) {
		matches = nullptr;
		totalmatches = 0;
		*this = copy;
	}

	TennisLog::TennisLog(TennisLog&& move) {
		matches = nullptr;
		totalmatches = 0;
		*this = std::move(move);
	}

	TennisLog::~TennisLog() {
		delete[] matches;
	}

	TennisLog& TennisLog::operator=(const TennisLog& copy) {
		if (this != &copy)
		{
			delete[] matches;
			totalmatches = copy.totalmatches;
			matches = new TennisMatch[totalmatches];
			for (int i = 0; i < totalmatches; i++)
			{
				matches[i] = copy.matches[i];
			}
		}
		return *this;
	}

	TennisLog& TennisLog::operator=(TennisLog&& move) {
		if (this != &move)
		{
			delete[] matches;
			totalmatches = move.totalmatches;
			move.totalmatches = 0;
			matches = move.matches;
			move.matches = nullptr;
		}
		return *this;
	}

	void TennisLog::addMatch(TennisMatch& match) {
		TennisMatch* matchcopy = new TennisMatch[++totalmatches];
		for (int i = 0; i < totalmatches - 1; i++)
		{
			matchcopy[i] = matches[i];
		}
		matchcopy[totalmatches - 1] = match;
		delete[] matches;
		matches = matchcopy;
	}

	TennisLog TennisLog::findMatches(const char* name) const{
		TennisLog found;
		found.setempty();
		for (int i = 0; i < totalmatches; i++)
		{
			if (!strcmp(matches[i].winner.c_str(), name) || !strcmp(matches[i].loser.c_str(), name))
			{
				TennisMatch match{ matches[i].tournamentid, matches[i].tournamentname, matches[i].matchid, matches[i].winner, matches[i].loser};
				found.addMatch(match);
			}
		}
		return found;
	}

	TennisMatch TennisLog::operator[](size_t i) const{
		if (matches)
		{
			return matches[i];
		}
		TennisMatch emptymatch;
		return emptymatch;
	}

	TennisLog::operator size_t() {
		return size_t(this->totalmatches);
	}

}