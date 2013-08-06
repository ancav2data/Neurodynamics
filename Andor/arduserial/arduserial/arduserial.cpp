// arduserial.cpp : main project file.

#include "stdafx.h"
#include <stdio.h>
#include <stdlib.h>
#include <string> 
#include <iostream> 

using namespace System;
using namespace System::IO::Ports;
using namespace System;


int main(array<System::String ^> ^args)
{
	String^ answer;
	String^ result;
/*	String^ portName;
	int baudRate=9600;
	Console::WriteLine("Type in a port name and hit ENTER");
	portName=Console::ReadLine();*/

	SerialPort^ arduino;
	arduino = gcnew SerialPort();
	arduino->PortName = "COM12";
    arduino->BaudRate = 9600;
    arduino->DataBits = 8;
    arduino->Parity = Parity::None;
    arduino->StopBits = StopBits::One;
    arduino->ReadTimeout = 500;
    arduino->WriteTimeout = 500;

	arduino->Open();

		//Console::Clear(); // clear the command line
		// get answer
		answer = "D500f";
		arduino->WriteLine(answer);
		result = arduino->ReadLine();
        Console::Write(result);
	    std::cout << std::endl;

		answer = "I100f";
		arduino->WriteLine(answer);
		result = arduino->ReadLine();
        Console::Write(result);
	    std::cout << std::endl;

		answer = "P5f";
		arduino->WriteLine(answer);
		result = arduino->ReadLine();
        Console::Write(result);
	    std::cout << std::endl;

		answer = "O2500f";
		arduino->WriteLine(answer);
		result = arduino->ReadLine();
        Console::Write(result);
	    std::cout << std::endl;

		answer = "V500f";
		arduino->WriteLine(answer);
		result = arduino->ReadLine();
        Console::Write(result);
	    std::cout << std::endl;
		
		getchar();

		for(int i=0;i<10;i++) {
		answer = "S500f";
		arduino->WriteLine(answer);
		getchar();
		}
		// clear the screen

	arduino->Close();
    return 0;
}