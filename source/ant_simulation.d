import std.stdio, std.algorithm, std.traits, std.random;
import std.conv;
import std.math;

import dagon;

import ant;
import point;
import location;
import food;
import simulator;
import warehouse;

//ant[int] antRegister;
Food[int] foodRegister;

class MyApplication: SceneApplication
{
    private double elapsedTime = 0.0;
    this(string[] args)
    {
        super(1280, 720, false, "Ant Simulation", args);

        TestScene test = New!TestScene(sceneManager);
        StoreScene store = New!StoreScene(sceneManager);
//        MenuScene home = New!MenuScene(sceneManager);

        sceneManager.addScene(store, "Warehouse");
        sceneManager.addScene(test, "TestScene");

        sceneManager.goToScene("TestScene");
//        sceneManager.goToScene("Warehouse");
    }
}

void main(string[] args)
{
    debug enableMemoryProfiler(true);

		MyApplication app = New!MyApplication(args);
    app.run();
    Delete(app);

    debug printMemoryLeaks();

}
