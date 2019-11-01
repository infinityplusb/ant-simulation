import std.stdio, std.algorithm, std.traits, std.random;
import std.conv;
import std.math;

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
    private double elapsedTime = 0.0;
    this(string[] args)
    {
        super(1280, 720, false, "Ant Simulation", args);

        TestScene test = New!TestScene(sceneManager);
        sceneManager.addScene(test, "TestScene");

        sceneManager.goToScene("TestScene");
    }

    /* 
    override void run()
    {
        Time t;
        while(eventManager.running)
        {
            eventManager.update();
            processEvents();

            t.delta = eventManager.deltaTime;
            t.elapsed = elapsedTime;
            elapsedTime += t.elapsed;

            if(t == std.math.floor(t))
              onUpdate(t);
        }
    }
    */

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
		MyApplication app = New!MyApplication(args);
    app.run();
    Delete(app);
}
