import std.stdio, std.algorithm, std.traits, std.random;
import std.conv;

import dagon;

import ant;
import point;
import location;
import food;
import simulator;

//ant[int] antRegister;
Food[int] foodRegister;

class MyApplication: SceneApplication
{
    this(string[] args)
    {
        super(1280, 720, false, "Ant Simulation", args);

        TestScene test = New!TestScene(sceneManager);
        sceneManager.addScene(test, "TestScene");
        sceneManager.goToScene("TestScene");
    }
}

void initialize()
{
	location A = new location(0, 0, 150, 200, 2);
	// writeln(antRegister.length);
//	location B = new location(200, 0, 100, 100, 100);
	// writeln(antRegister.length);
}

void iterate()
{
	//writeln(antRegister.length);
	//doAntThings();
}

void doAntThings()
{
//	foreach(ant; antRegister)
//		ant.antAction();
}

void main(string[] args)
{
//		initialize();
		int iterations = 0;
//		Food F = new Food(44, 65);
//		foodRegister[to!int(foodRegister.length+1)] = F ;

		MyApplication app = New!MyApplication(args);
    app.run();
    Delete(app);

//		while(true)
//		{
//				iterate();
//				if(iterations > 20)
//						break;

//				iterations ++ ;
//		}
		writefln("Ran for %s iterations", iterations);
}
