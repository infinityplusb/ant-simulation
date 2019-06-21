module ant;

import std.stdio;
import std.random;
import std.conv;
import std.math : sin, PI, sqrt;

import dlib.math.matrix;
import dlib.math.transformation;

import dagon;

import ant_simulation;
import point;

auto rnd = Random(63);

class NewAnt: EntityController
{
public:
		public bool hasFoundFood = false;
		int foodSupply = 0 ;
		int foodLocation = 0 ;
		Vector3f home ;
		int id;
		float speed = 0.2f;

    this(Entity e){
        super(e);
    }

    override void update(double dt)
		{
				antAction();

        entity.transformation =
            translationMatrix(entity.position) *
            entity.rotation.toMatrix4x4 *
            scaleMatrix(entity.scaling);

        entity.invTransformation = entity.transformation.inverse;
//				writeln(dt);
    }

		void setHome(in Vector3f location)
		{
				entity.position = location;
				home = location ;
		}

		void antAction()
		{
//				writeln(foodSupply);
//				writefln("home: %s", home);
//				writefln("current: %s", entity.position);

				if(foodSupply == 0 || entity.position == home)
				{
	debug(2)				writeln("I'm hungry");
						lookForFood();
				}
				else
				{
						goHome();
				}
		}

		void lookForFood()
		{
				writeln("Looking for Food");
 				if(isFoodAtCurrentLocation())
				{
						takeFood();
						hasFoundFood = true;
				}
				else if (hasFoundFood)
				{
						writeln("Returning to my known supply");
//						foodSupply = 0;
						hasFoundFood = false;
				}
				else
				{
//						randomWalk();
						levyFlight();
				}
		}

		bool isFoodAtCurrentLocation()
		{
				bool isFood = false;
				writeln("Checking for nearby food");
			//	writeln(foodRegister);
			//	writeln(foods);
				foreach(i; foodRegister.keys)
				{
						auto dx = foodRegister[i].foodSupplyLocation.x - entity.position.x;
						auto dz = foodRegister[i].foodSupplyLocation.y - entity.position.z;

						auto distance = sqrt(dx * dx + dz * dz);
			//			writeln(distance);
						if(distance < 100)
						{
								foodLocation = i ;
								isFood = true ;
						}
				}
					/*	if(foodRegister[i].foodSupplyLocation.x == round(entity.position.x
							&& foodRegister[i].foodSupplyLocation.y == entity.position.z)
						{
								foodLocation = i ;
								isFood = true;
						}
					*/
				return isFood;
		}
public:
		void takeFood()
		{
				writeln("Taking food");
				foodSupply += 100;
		}

		void goHome()
		{
				int numberOfXSteps = to!int(entity.position.x - home.x) ;
				int numberOfYSteps = to!int(entity.position.z - home.z) ;

				if(numberOfXSteps == 0)
				{
					if(entity.position.z > home.z)
							entity.position.z -= speed ;
					else
							entity.position.z += speed ;
				}
				else if (numberOfYSteps == 0)
				{
					if(entity.position.x > home.x)
							entity.position.x -= speed ;
					else
							entity.position.x += speed ;
				}
				else
				{
					int move_direction = uniform(1, 3, rnd);
					switch (move_direction)
					{
							case 1:
									if(entity.position.x > home.x)
											entity.position.x -= speed ;
									else
											entity.position.x += speed ;
									break;
							case 2:
									if(entity.position.z > home.z)
											entity.position.z -= speed ;
									else
											entity.position.z += speed ;
									break;
							default:
								throw new Exception("Not sure how to get home. Staying still.");
						}
					}
					debug(1) writeln(entity.position);
		}

		void randomWalk()
		{
				int move_direction = uniform(1, 5, rnd);
				switch (move_direction)
				{
						case 1:
								entity.position.x += speed ; break;
						case 2:
								entity.position.z += speed ; break;
						case 3:
								entity.position.x -= speed ; break;
						case 4:
								entity.position.z -= speed ; break;
						default:
							throw new Exception("Not sure what to do. Staying still.");
				}
				debug(1) writeln(entity.position);
		}

		void levyFlight()
		{
				int move_direction = uniform(1, 5, rnd);
				int move_magnitude = uniform(1, 101, rnd);
				int move_size = 1;

				if(move_magnitude < 2)
					move_size = uniform(1,26, rnd);

				switch (move_direction)
				{
						case 1:
								entity.position.x += move_size * speed ; break;
						case 2:
								entity.position.z += move_size * speed ; break;
						case 3:
								entity.position.x -= move_size * speed ; break;
						case 4:
								entity.position.z -= move_size * speed ; break;
						default:
							throw new Exception("Not sure what to do. Staying still.");
				}
				debug(1) writeln(entity.position);
		}



}
