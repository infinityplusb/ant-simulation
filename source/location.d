module location;

import std.stdio;
import std.random;
import std.conv;

import ant;
import point;
/* need to remove this going forward */
import ant_simulation;

// extern (D) ant[int] antRegister;

auto rnd = Random(42);

class location{
		point bottom_left ;
		int width ;
		int height ;
		int countOfAnts = 0;

		this(in int _x, in int _y, in int i_width, in int i_height, in int _numberOfAnts)
		{
				bottom_left.x = _x;
				bottom_left.y = _y;
				width = i_width;
				height = i_height;
debug(1)				writefln("Bottom corner of this location is: %f, %f", bottom_left.x, bottom_left.y);
				foreach(int ant; 1.._numberOfAnts)
				{}
						//makeAnt();
		}
/*
		ant makeAnt()
		{
			auto x = uniform(bottom_left.x, bottom_left.x+width, rnd);
			auto y = uniform(bottom_left.y, bottom_left.y+height, rnd);
			point spawn = {x, y};
debug(1)	writeln(spawn);
			countOfAnts++;
			ant a = new ant(spawn, countOfAnts);
debug(1)	 writeln(antRegister.length);
			antRegister[to!int(antRegister.length + 1)] = a;

			return a;
		}
*/
}
