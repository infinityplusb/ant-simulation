module food;

import std.stdio;
import std.conv;

import point;
import ant_simulation;

class Food {
		int foodSize = 1_000_000;
		point foodSupplyLocation;
		int index;

		this(in int _x, in int _y)
		{
				foodSupplyLocation.x = _x;
				foodSupplyLocation.y = _y;
				foodRegister[to!int(foodRegister.length+1)] = foodSupplyLocation ;

				writefln("Food has dropped at %s, %s", foodSupplyLocation.x, foodSupplyLocation.y);
		}
}
