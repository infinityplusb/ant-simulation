module ant;

import std.stdio;
import point;

class ant{
		point home ;
		int id ;

		this(in point _home, in int _id)
		{
				home = _home;
				id = _id;
				writefln("Created an ant at %s,%s. Number: %s", home.x, home.y, id);
		}
}
