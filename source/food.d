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

				writefln("Food has dropped at %s, %s", foodSupplyLocation.x, foodSupplyLocation.y);
		}

    void foodSwap(int foodTaken)
    {
        foodSize -= foodTaken;
        writefln("Food at supply point %s is now %s", index, foodSize);
    }
}
