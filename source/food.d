module food;

import std.stdio;
import std.conv;

import dagon;

import point;
import ant_simulation;

class NewFood : EntityController
{
PhysicsWorld world;
RigidBody rbody;

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

        entity.transformation =
            translationMatrix(entity.position) *
            entity.rotation.toMatrix4x4 *
            scaleMatrix(entity.scaling);

        entity.invTransformation = entity.transformation.inverse;
//				writefln("Food is at: %s", entity.position);
//				writeln(dt);
    }
}


class Food {
		int foodSize = 1_000_000;
		point foodSupplyLocation;
		int index;

		this(in int _x, in int _y)
		{
				foodSupplyLocation.x = _x;
				foodSupplyLocation.y = _y;

//				writefln("Food has dropped at %s, %s", foodSupplyLocation.x, foodSupplyLocation.y);
		}

    void foodSwap(int foodTaken)
    {
        foodSize -= foodTaken;
//        writefln("Food at supply point %s is now %s", index, foodSize);
    }
}
