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
PhysicsWorld world;
RigidBody rbody;

public:
		public bool hasFoundFood= false ;
		int foodSupply = 0 ;
		Vector3f foodLocation = 0 ;
		Vector3f home ;
		int id;
		float speed = 0.2f;

    this(Entity e){
        super(e);
    }

		this(Entity e, RigidBody b, PhysicsWorld w)
		{
				super(e);

				world = w;

				rbody = b;
				b.position = e.position;
				b.orientation = e.rotation;

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
				if(foodSupply == 0)
				{
						writeln("Got no food");
						if(!hasFoundFood)
						{
								debug(2)				writeln("Looking for food");
								lookForFood();
						}
						else
						{
								writefln("Going to get food at: %s", foodSupply);
								getMoreFood();
								writeln(foodSupply);
						}
				}
				else
				{
						writefln("Food supply is: %s", foodSupply);
						if(entity.position == home)
						{
								writefln("At home with food");
//								writefln("Have I found food? %s", hasFoundFood);
//								writefln("I have %s", foodSupply);
//								writeln("what do I do now??");
								dropFood();
						}
						else
						{
								writefln("Returning home with food");
								goHome();
								writeln(foodSupply);
						}
				}
		}

		/**

		*/
		void lookForFood()
		{
//				writefln("Have I found food? %s", hasFoundFood);
//				writefln("I have %s", foodSupply);
	 //debug(1)
//	 			writeln("Looking for Food");
				levyFlight();
		}

		void takeFood(Vector3f actualFoodLocation)
		{
				foodLocation = actualFoodLocation;
				foodSupply += 100;
				hasFoundFood = true;
		}

		void goHome()
		{
//				writefln("Going Home to %s. Currently at %s ", entity.position, home);
				int numberOfXSteps = to!int(entity.position.x - home.x) ;
				int numberOfYSteps = to!int(entity.position.z - home.z) ;

				if(numberOfXSteps == 0 && numberOfYSteps == 0)
						entity.position = home;
				else if(numberOfXSteps == 0)
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
					// debug(1) writeln(entity.position);
		}

		void getMoreFood()
		{
//			writefln("Getting more food at %s. Currently at %s ", foodLocation, entity.position);
			int numberOfXSteps = to!int(entity.position.x - foodLocation.x) ;
			int numberOfYSteps = to!int(entity.position.z - foodLocation.z) ;


			if(numberOfXSteps == 0)
			{
				if(entity.position.z > foodLocation.z)
						entity.position.z -= speed ;
				else
						entity.position.z += speed ;
			}
			else if (numberOfYSteps == 0)
			{
				if(entity.position.x > foodLocation.x)
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
								if(entity.position.x > foodLocation.x)
										entity.position.x -= speed ;
								else
										entity.position.x += speed ;
								break;
						case 2:
								if(entity.position.z > foodLocation.z)
										entity.position.z -= speed ;
								else
										entity.position.z += speed ;
								break;
						default:
							throw new Exception("Not sure how to get to Food. Staying still.");
					}
				}
		}

		void dropFood()
		{
				debug(1) writeln("Dropping food");
				foodSupply = 0;
				debug(1) writeln(foodSupply);
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
				// debug(1) writeln(entity.position);
		}

		void levyFlight()
		{
				int move_direction = uniform(1, 5, rnd);
				int move_magnitude = uniform(1, 101, rnd);
				int move_size = 1;

				if(move_magnitude < 20)
					  move_size = uniform(1,26, rnd);

				switch (move_direction)
				{
						case 1:
								entity.position.x += move_size * speed * 0.25; break;
						case 2:
								entity.position.z += move_size * speed * 0.25 ; break;
						case 3:
								entity.position.x -= move_size * speed  * 0.25; break;
						case 4:
								entity.position.z -= move_size * speed  * 0.25; break;
						default:
							throw new Exception("Not sure what to do. Staying still.");
				}
//				debug(1) writeln(entity.position);
		}



}
