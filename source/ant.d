module ant;

import std.stdio;
import std.random;
import point;

import ant_simulation;
// extern (D) ant[int] antRegister;
auto rnd = Random(63);

class ant{
		point home ;
		int id ;
		bool hasFoundFood = false;
		point currentLocation ;
		int foodSupply = 0 ;
		int foodLocation = 0 ;

		this(in point _home, in int _id)
		{
				home = _home;
				id = _id;
debug(1)	writefln("Created an ant at %s,%s. Number: %s", home.x, home.y, id);
				currentLocation = home;
		}

		void antAction()
		{
			if(foodSupply == 0)
			{
debug(2)				writeln("I'm hungry");
				lookForFood();
			}

		}

		void lookForFood()
		{
 				if(isFoodAtCurrentLocation())
				{
						takeFood();
						hasFoundFood = true;
				}
				else if (hasFoundFood)
				{
						writeln("Going to my known supply");
				}
				else
				{
						int move_direction = uniform(1, 5, rnd);
						switch (move_direction)
						{
								case 1:
										currentLocation.x++ ; break;
								case 2:
										currentLocation.y++ ; break;
								case 3:
										currentLocation.x-- ; break;
								case 4:
										currentLocation.y-- ; break;
								default:
									throw new Exception("Not sure what to do. Staying still.");
						}

				}
		}

		bool isFoodAtCurrentLocation()
		{
				bool isFood = false;
				foreach(i; foodRegister.keys)
						if(foodRegister[i] == currentLocation)
						{
								foodLocation = i ;
								isFood = true;
						}
				return isFood;
		}

		void takeFood()
		{
				writeln("Taking food");
		}
}
