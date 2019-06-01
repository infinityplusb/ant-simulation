module ant;

import std.stdio;
import std.random;
import std.conv;
import std.math : sin, PI;

import dlib.math.matrix;
import dlib.math.transformation;


import dagon;

import ant_simulation;
import point;
// extern (D) ant[int] antRegister;
auto rnd = Random(63);

class NewAnt: EntityController
{

		bool hasFoundFood = false;
		int foodSupply = 0 ;
		int foodLocation = 0 ;
		Vector3f home ;
		int id;
		float speed = 0.2f;

    this(Entity e){
        super(e);
				entity.material.diffuse = Color4f(1.0,1.0,0.0,1.0);
    }

    override void update(double dt)
		{
				antAction();

        entity.transformation =
            translationMatrix(entity.position) *
            entity.rotation.toMatrix4x4 *
            scaleMatrix(entity.scaling);

        entity.invTransformation = entity.transformation.inverse;

    }

		void setHome(in Vector3f location)
		{
				entity.position = location;
				home = location ;
		}

		void antAction()
		{
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
		}

		bool isFoodAtCurrentLocation()
		{
				bool isFood = false;
				foreach(i; foodRegister.keys)
						if(foodRegister[i].foodSupplyLocation.x == entity.position.x
							&& foodRegister[i].foodSupplyLocation.y == entity.position.z)
						{
								foodLocation = i ;
								isFood = true;
						}
				return isFood;
		}

		void takeFood()
		{
				writeln("Taking food");
				foreach(i; foodRegister.keys)
				if(foodRegister[i].foodSupplyLocation.x == entity.position.x
					&& foodRegister[i].foodSupplyLocation.y == entity.position.z)
						{
								foodLocation = i ;
								foodRegister[i].foodSwap(100);
						}

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
}
