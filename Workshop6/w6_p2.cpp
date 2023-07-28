/*
*****************************************************************************
						OOP244-Workshop-6, part-2
Full Name  : Travis Liu
e-mail     : tliu84@myseneca.ca
Student ID#: 156740201
Date       : 4 November, 2022
Section    : ZAA

I have done all the coding by myself and only copied the code that my
professor provided to complete my workshops and assignments.
*****************************************************************************
*/
#include <iostream>
#include <list>
#include <iomanip>
#include <fstream>
#include "Autoshop.h"
#include "Autoshop.h"
#include "Utilities.h"
#include "Utilities.h"
#include "Luxuryvan.h"



void loadData(const char* filename, sdds::Autoshop& as)
{
	std::ifstream file(filename);
	if (!file)
	{
		std::cerr << "ERROR: Cannot open file [" << filename << "].\n";
		return;
	}
	while (file)
	{
		// TODO: This code can throw errors to signal that something 
		//         went wrong while extracting data. Write code to catch
		//         and handle the following errors:
		//       - the record is not recognized: the first non-empty character
		//           on the line is not 'c', 'C', 'r', 'R', 'v', 'V', 'l', or 'L'
		//       - one of the fields in the record contains invalid data.
		try
		{
			sdds::Vehicle* aVehicle = sdds::createInstance(file);
			if (aVehicle)
				as += aVehicle;
		}
		catch (std::invalid_argument& err)
		{
			file.ignore(1000, '\n');
			std::cout << "Invalid record!" << std::endl;
		}
		catch (std::runtime_error& err)
		{
			std::cout << err.what() << std::endl;
		}
		catch (const std::string& err)
		{
			std::cout << err << std::endl;
			file.ignore(1000, '\n');
		}
	}
}

int cout{};

//ws dataCleanCar.txt, dataMessyCar.txt, dataCleanVan.txt, dataMessyVan.txt
int main(int argc, char** argv)
{
	std::cout << "Command Line:\n";
	std::cout << "--------------------------\n";
	for (int i = 0; i < argc; i++)
		std::cout << std::setw(3) << i + 1 << ": " << argv[i] << '\n';
	std::cout << "--------------------------\n\n";

	sdds::Autoshop as, av;
	loadData(argv[1], as);
	std::cout << "--------------------------------\n";
	std::cout << "|  Car in the autoshop!        |\n";
	std::cout << "--------------------------------\n";
	as.display(std::cout);
	std::cout << "--------------------------------\n";

	loadData(argv[2], as);
	std::cout << "--------------------------------\n";
	std::cout << "|  Car in the autoshop!        |\n";
	std::cout << "--------------------------------\n";
	as.display(std::cout);
	std::cout << "--------------------------------\n";

	loadData(argv[3], av);
	std::cout << "------------------------------------------------------------\n";
	std::cout << "|  Van in the autoshop!                                    |\n";
	std::cout << "------------------------------------------------------------\n";
	av.display(std::cout);
	std::cout << "------------------------------------------------------------\n";

	loadData(argv[4], av);
	std::cout << "------------------------------------------------------------\n";
	std::cout << "|  Van in the autoshop!                                    |\n";
	std::cout << "------------------------------------------------------------\n";
	av.display(std::cout);
	std::cout << "------------------------------------------------------------\n";

	std::cout << std::endl;
	std::list<const sdds::Vehicle*> vehicles;
	{
		// TODO: Create a lambda expression that receives as parameter `const sdds::Vehicle*`
		//         and returns true if the vehicle has a top speed >300km/h
		auto fastVehicles = [](const sdds::Vehicle* vec) { return vec->topSpeed() > 300; };
			as.select(fastVehicles, vehicles);
		std::cout << "--------------------------------\n";
		std::cout << "|       Fast Vehicles          |\n";
		std::cout << "--------------------------------\n";
		for (auto it = vehicles.begin(); it != vehicles.end(); ++it)
		{
			(*it)->display(std::cout);
			std::cout << std::endl;
		}
		std::cout << "--------------------------------\n";
	}

	vehicles.clear();
	std::cout << std::endl;
	{
		// TODO: Create a lambda expression that receives as parameter `const sdds::Vehicle*`
		//         and returns true if the vehicle is broken and needs repairs.
		auto brokenVehicles = [](const sdds::Vehicle* vec) { return vec->condition()[0] == 'b'; };
			as.select(brokenVehicles, vehicles);
		std::cout << "--------------------------------\n";
		std::cout << "| Cars in need of repair       |\n";
		std::cout << "--------------------------------\n";
		for (const auto vehicle : vehicles)
		{
			vehicle->display(std::cout);
			std::cout << std::endl;
		}
		std::cout << "--------------------------------\n";
	}

	vehicles.clear();
	std::cout << std::endl;
	{
		// TODO: Create a lambda expression that receives as parameter `const sdds::Vehicle*`
		//         and returns true if the vehicle is broken and needs repairs.
		auto brokenVehicles = [](const sdds::Vehicle* vec) { return vec->condition()[0] == 'b'; };
			av.select(brokenVehicles, vehicles);
		std::cout << "------------------------------------------------------------\n";
		std::cout << "|  Vans in need of repair                                  |\n";
		std::cout << "------------------------------------------------------------\n";
		for (const auto vehicle : vehicles)
		{
			vehicle->display(std::cout);
			std::cout << std::endl;
		}
		std::cout << "------------------------------------------------------------\n";
	}

	std::cout << std::endl;

	std::cout << std::endl;

	return cout;
}