module simulator;

import std.random;
import std.stdio;
import std.math;

import dagon;
import location;
import ant;

auto rnd = Random();


class TestScene: Scene
{
    OBJAsset aOBJAnt;
    OBJAsset aOBJFood;

    IQMAsset iqmAnt;
    NewAnt eAnt;

    Entity ants;

//    Entity eMrfixit;
    Actor actor;

    this(SceneManager smngr)
    {
        super(smngr);
    }

    override void onAssetsRequest()
    {
        assetManager.mountDirectory("data/assets");
        iqmAnt = addIQMAsset("data/assets/mrfixit.iqm");
        aOBJFood = addOBJAsset("data/assets/crate.obj");
    }

    override void onAllocate()
    {
        super.onAllocate();

        view = New!Freeview(eventManager, assetManager);

        mainSun = createLightSun(Quaternionf.identity, environment.sunColor, environment.sunEnergy);
        mainSun.shadow = true;
        environment.setDayTime(9, 00, 00);

        auto matNoFood = createMaterial();
        matNoFood.diffuse = Color4f(1.0, 0.2, 0.2, 1.0);

        auto matFood = createMaterial();
        matFood.diffuse = Color4f(0.1, 0.1, 0.1, 1.0);

        // Common materials
        auto matFoodSource = createMaterial();
        matFoodSource.roughness = 0.9f;
        matFoodSource.metallic = 0.0f;
        matFoodSource.culling = false;
        matFoodSource.diffuse = Color4f(1.0, 0.2, 0.2, 1.0);

        // Common materials
        auto matGround = createMaterial();
        matGround.roughness = 0.9f;
        matGround.metallic = 0.0f;
        matGround.culling = false;
        matGround.diffuse = Color4f(1.0, 0.2, 1.2, 1.0);

        ants = createEntity3D();

        // why doesn't more than 1 figure show up?
        foreach(i; 0..5)
        {
            spawnAnt();
        }

        auto ePlaneA = createEntity3D();
        ePlaneA.drawable = New!ShapePlane(15, 20, 1, assetManager);
        ePlaneA.material = matGround;

// https://github.com/gecko0307/dagon/blob/289c483b91bf8b2b03c6ffc7bf66a2a1538abd69/src/dagon/graphics/shapes.d#L92
//        ePlaneA.drawable = New!ShapeQuad(assetManager); //Plane(150, 200, 1, assetManager);

        auto x = uniform(-7.5, 7.5, rnd);
        auto y = uniform(-10.0, 10.0, rnd);

        auto foodSource = createEntity3D();
        foodSource.drawable = aOBJFood.mesh;
        foodSource.material = matFoodSource;
        foodSource.position = Vector3f(x, 1, y);

//        auto ePlane = createEntity3D();
//        ePlane.drawable = New!ShapePlane(100000, 100000, 1, assetManager);
    }

    // TODO: Enemies will shoot and collide the ship also.
    void spawnAnt(){
        float myRndXPos = uniform(-7.5, 7.5, rnd);
        float myRndYPos = uniform(-10.0, 10.0, rnd);

        auto ant = createEntity3D(ants);
        ant.drawable = aOBJFood.mesh;
      //  ant.material = matNoFood;
        // ant.position = Vector3f(myRndXPos, 0.0f, myRndYPos);
        ant.rotation = rotationQuaternion(Axis.y, degtorad(180.0f));
        ant.scaling = Vector3f(0.5, 0.5, 0.5);

        ant.updateTransformation(0.0);

        auto antCtrl = New!NewAnt(ant);
        ant.controller = antCtrl;
        antCtrl.setHome(Vector3f(myRndXPos, 0.5f, myRndYPos));

    }

    void spawnFood()
    {
        
    }


    override void onStart()
    {
        super.onStart();
    }

    bool isCollision(Entity a, Entity b)
    {
      auto dx = a.position.x - b.position.x;
      auto dz = a.position.z - b.position.z;

      auto distance = sqrt(dx * dx + dz * dz);

      if(distance < 1)
          return true;
      else
          return false;
    }

}
