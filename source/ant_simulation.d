import std.stdio, std.algorithm, std.traits, std.random;
import std.conv;

import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Button;
import gdk.Event;
import gtk.GLArea;
import gdk.GLContext;

import ant;
import point;
import location;
import food;
import gtkWindow;

ant[int] antRegister;
point[int] foodRegister;

void initialize()
{
	location A = new location(0, 0, 150, 200, 20);
	// writeln(antRegister.length);
	location B = new location(200, 0, 100, 100, 100);
	// writeln(antRegister.length);
}

void iterate()
{
	//writeln(antRegister.length);
	doAntThings();
}

void doAntThings()
{
	foreach(ant; antRegister)
		ant.antAction();
}

void main(string[] args)
{
		initialize();
		int iterations = 0;
		Food F = new Food(10, 50);

		Main.init(args);
		AntSimWindow myAntSim = new AntSimWindow("Ant Simulator");
		Main.run();

		while(true)
		{
				iterate();

				//writeln(antRegister[1].currentLocation);
				if(iterations > 1000)
						break;

				iterations ++ ;
		}
		writefln("Ran for %s iterations", iterations);
}
