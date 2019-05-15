module location;

import std.stdio;
import std.random;

import ant;
import point;

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
				writefln("Bottom corner of this location is: %d, %d", bottom_left.x, bottom_left.y);
				foreach(int ant; 1.._numberOfAnts)
						makeAnt();
		}

		ant makeAnt()
		{
			auto x = uniform(bottom_left.x, bottom_left.x+width, rnd);
			auto y = uniform(bottom_left.y, bottom_left.y+height, rnd);
			point spawn = {x, y};
// debug			writeln(spawn);
			countOfAnts++;
			ant a = new ant(spawn, countOfAnts);

			return a;
		}
}
