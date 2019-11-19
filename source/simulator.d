module simulator;

import std.random;
import std.stdio;
import std.math;
import std.parallelism;
import std.conv;

import dagon;
import location;
import ant;
import food;

auto rnd = Random();

BVHTree!Triangle meshesToBVH(Mesh[] meshes)
{
    DynamicArray!Triangle tris;

    foreach(mesh; meshes)
    foreach(tri; mesh)
    {
        Triangle tri2 = tri;
        tri2.v[0] = tri.v[0];
        tri2.v[1] = tri.v[1];
        tri2.v[2] = tri.v[2];
        tri2.normal = tri.normal;
        tri2.barycenter = (tri2.v[0] + tri2.v[1] + tri2.v[2]) / 3;
        tris.append(tri2);
    }

    assert(tris.length);
    BVHTree!Triangle bvh = New!(BVHTree!Triangle)(tris, 4);
    tris.free();
    return bvh;
}

void collectEntityTrisRecursive(Entity e, ref DynamicArray!Triangle tris)
{
    if (e.solid && e.drawable)
    {
        e.update(0.0);
        Matrix4x4f normalMatrix = e.invAbsoluteTransformation.transposed;

        Mesh mesh = cast(Mesh)e.drawable;
        if (mesh is null)
        {
            Terrain t = cast(Terrain)e.drawable;
            if (t)
            {
                mesh = t.collisionMesh;
            }
        }

        if (mesh)
        {
            foreach(tri; mesh)
            {
                Vector3f v1 = tri.v[0];
                Vector3f v2 = tri.v[1];
                Vector3f v3 = tri.v[2];
                Vector3f n = tri.normal;

                v1 = v1 * e.absoluteTransformation;
                v2 = v2 * e.absoluteTransformation;
                v3 = v3 * e.absoluteTransformation;
                n = n * normalMatrix;

                Triangle tri2 = tri;
                tri2.v[0] = v1;
                tri2.v[1] = v2;
                tri2.v[2] = v3;
                tri2.normal = n;
                tri2.barycenter = (tri2.v[0] + tri2.v[1] + tri2.v[2]) / 3;
                tris.append(tri2);
            }
        }
    }

    foreach(c; e.children)
        collectEntityTrisRecursive(c, tris);
}

BVHTree!Triangle entitiesToBVH(Entity[] entities)
{
    DynamicArray!Triangle tris;

    foreach(e; entities)
        collectEntityTrisRecursive(e, tris);

    if (tris.length)
    {
        BVHTree!Triangle bvh = New!(BVHTree!Triangle)(tris, 4);
        tris.free();
        return bvh;
    }
    else
        return null;
}



class TestScene: Scene
{
    OBJAsset aOBJAnt;
    OBJAsset aOBJFood;

    OBJAsset oOBJBarrier;

    IQMAsset iqmAnt;
    NewAnt eAnt;

    Entity ants;
    Entity foods;
    Entity barriers;

    NewAnt[ulong] allAnts;
    NewFood[ulong] allFoods;

//    Entity eMrfixit;
    Actor actor;

    Material antWithFoodMaterial;
    Material antWithNoFoodMaterial;
    Material foodSourceMaterial;
    Material foodSourceBrown;
    Material foodSourceGreen;
    Material barrierBlack;

    BVHTree!Triangle bvh;
    bool haveBVH = false;

    PhysicsWorld world;
    RigidBody bAnts;
    RigidBody bFoods;
    RigidBody bBarriers;
    RigidBody bGround;

    NuklearGUI gui;

    FontAsset aFontDroidSans14;

    string helpTextGeneral = "Press RMB to add a random food Source";

    TextLine helpText;

    int iteration = 0;


    this(SceneManager smngr)
    {
        super(smngr);
    }

    override void onAssetsRequest()
    {
        assetManager.mountDirectory("data/assets");
        iqmAnt = addIQMAsset("data/assets/mrfixit.iqm");
        aOBJFood = addOBJAsset("data/assets/crate.obj");
        aFontDroidSans14 = addFontAsset("data/font/DroidSans.ttf", 14);
    }

    override void onAllocate()
    {
        world = New!PhysicsWorld(assetManager);
        auto b = world.addDynamicBody(Vector3f(0, 0, 0), 0.0f);

        super.onAllocate();

        view = New!Freeview(eventManager, assetManager);

        mainSun = createLightSun(Quaternionf.identity, environment.sunColor, environment.sunEnergy);
        mainSun.shadow = true;
        environment.setDayTime(9, 00, 00);

        antWithFoodMaterial = createMaterial();
        antWithFoodMaterial.diffuse = Color4f(0.0,1.0,0.0,1.0);

        antWithNoFoodMaterial = createMaterial();
        antWithNoFoodMaterial.diffuse = Color4f(1.0,0.0,0.0,1.0);

        foodSourceBrown = createMaterial();
        foodSourceBrown.diffuse = Color4f(0.1, 0.1, 0.1, 1.0);

        foodSourceGreen = createMaterial();
        foodSourceGreen.diffuse = Color4f(0.0,1.0,0.0,1.0);

        barrierBlack = createMaterial();
        barrierBlack.diffuse = Color4f(1.0, 1.0, 1.0, 1.0);

        // Common materials
        auto matGround = createMaterial();
        matGround.roughness = 0.9f;
        matGround.metallic = 0.0f;
        matGround.culling = false;
        matGround.diffuse = Color4f(1.0, 0.2, 0.6, 1.0);

        ants = createEntity3D();

        // HUD text
        helpText = New!TextLine(aFontDroidSans14.font, helpTextGeneral, assetManager);
        helpText.color = Color4f(1.0, 0.2, 0.6, 1.0);

        auto eText = createEntity2D();
        eText.drawable = helpText;
        eText.position = Vector3f(16.0f, 30.0f, 0.0f);

        Vector3f[] testPolygon;
//        testPolygon ~= Vector3f(4.79751, 4.7647, 1);
//        testPolygon ~= Vector3f(4.79659, 4.76467, 1);
//        testPolygon ~= Vector3f(4.79640, 4.76472, 1);
//        testPolygon ~= Vector3f(4.79736, 4.76575, 1);
        testPolygon ~= Vector3f(40.79751, 10, 4.7647);
        testPolygon ~= Vector3f(40.79659, 10, -4.76467);
//        testPolygon ~= Vector3f(4.79640, -4.76472, 1);
        testPolygon ~= Vector3f(40.79736, 10, 4.76575);


        auto ePlaneA = createEntity3D();
        ePlaneA.drawable = New!ShapePlane(15, 20, 1, assetManager);
        ePlaneA.material = matGround;

//        auto eTestPlaneB = createEntity3D();
//        eTestPlaneB.drawable = New!ShapePolygon(testPolygon, assetManager);
//        eTestPlaneB.material = barrierBlack;


// https://github.com/gecko0307/dagon/blob/289c483b91bf8b2b03c6ffc7bf66a2a1538abd69/src/dagon/graphics/shapes.d#L92
//        ePlaneA.drawable = New!ShapeQuad(assetManager); //Plane(150, 200, 1, assetManager);


        // BVH for castle model to handle collisions
        bvh = entitiesToBVH(_entities3D.data);
        haveBVH = true;
        if (bvh)
            world.bvhRoot = bvh.root;


        // why doesn't more than 1 figure show up?
        foreach(i; 0..10)
        {
            spawnAnt(i, b, world);
        }

        foods = createEntity3D();

        foreach(i; 0..1)
        {
            spawnFood(i, b, world);
        }

        barriers = createEntity3D();

  //      foreach(i; 0..5)
//        {
//            spawnBarrier(b, world);
//        }
//        auto ePlane = createEntity3D();
//        ePlane.drawable = New!ShapePlane(100000, 100000, 1, assetManager);
    }

    // TODO: Enemies will shoot and collide the ship also.
    void spawnAnt(int i, RigidBody b, ref PhysicsWorld w){
        float myRndXPos = uniform(-10.0, 10.0, rnd);
        float myRndYPos = uniform(-10.0, 10.0, rnd);

        auto ant = createEntity3D(ants);

        ant.drawable = aOBJFood.mesh;
        ant.material = antWithNoFoodMaterial;
        // ant.position = Vector3f(myRndXPos, 0.0f, myRndYPos);
        ant.rotation = rotationQuaternion(Axis.y, degtorad(180.0f));
        ant.scaling = Vector3f(0.25, 0.25, 0.25);
//        b.scaling = Vector3f(0.25, 0.25, 0.25);

        ant.updateTransformation(0.0);

        auto antCtrl = New!NewAnt(ant, b, w);
        allAnts[i] = antCtrl;
        ant.controller = antCtrl;

        antCtrl.setHome(Vector3f(myRndXPos, 0.25f, myRndYPos));
    }

    void spawnFood(int i, RigidBody b, ref PhysicsWorld w) //b) //)
    {
        float x = uniform(-10.0, 10.0, rnd);
        float y = uniform(-10.0, 10.0, rnd);

        int food_type = uniform(1, 3, rnd);

        auto foodSource = createEntity3D(foods);
        switch (to!int(std.math.remainder(food_type,2)))
        {
            case 0:
                foodSource.material = foodSourceBrown;
                break;
            case 1:
                foodSource.material = foodSourceGreen;
                break;
            default:
                throw new Exception("Don't know what colour to be.");
        }

        foodSource.drawable = aOBJFood.mesh;
        foodSource.position = Vector3f(x, 1, y);

        auto foodSpot = New!NewFood(foodSource, b, w);
        foodSource.controller = foodSpot;
        allFoods[i] = foodSpot;
    }

    void spawnBarrier(RigidBody b, ref PhysicsWorld w) //int i)
    {
        float x = uniform(-10.0, 10.0, rnd);
        float y = uniform(-10.0, 10.0, rnd);

        auto barrierSource = createEntity3D(barriers);
        barrierSource.material = barrierBlack;

        barrierSource.drawable = aOBJFood.mesh;
        barrierSource.position = Vector3f(x, 0.25, y);
        barrierSource.scaling = Vector3f(4.0, 0.25, 0.25);
//        b.scaling = Vector3f(4.0, 0.25, 0.25);

        auto barrierSpot = New!NewFood(barrierSource, b, w);
        barrierSource.controller = barrierSpot;
//        allFoods[i] = foodSpot;
    }



    override void onStart()
    {
        super.onStart();
    }

    override void onUpdate(double dt)
    {
        super.onUpdate(dt);
        writeln(iteration);
        findFoodCheck();
        writeln(allAnts.length);
        writeln(allFoods.length);
        iteration ++;


//        writeln(allAnts[0].foodSupply);

// HELP        ants.children[1].controller.setHome(Vector3f(0.0f, 0.0f, 0.0f));

    }

    void findFoodCheck()
    {
        foreach(i; 0..allAnts.length)
        {
            foreach(j ; 0..allFoods.length)
            {

//                writefln("%s: %s", i, j);

  //              isCollision(allAnts[i].entity, allFoods[j].entity);

/*                if(isCollision(allAnts[i].entity, allFoods[j].entity))
                {
                    allAnts[i].entity.material = allFoods[j].entity.material;
                    // antController.setHome(Vector3f(0.0f, 0.0f, 0.0f));
                    allAnts[i].takeFood(allFoods[j].entity.position);
                    allAnts[i].hasFoundFood = true;
                    writeln("Found new food");

                }

                */
            }
        }
    }

    bool isCollision(Entity a, Entity b)
    {
      auto dx = a.position.x - b.position.x;
      auto dz = a.position.z - b.position.z;

      auto distance = sqrt(dx * dx + dz * dz);
      // writeln(distance);
      if(distance < 3)
          return true;
      else
          return false;
    }

    override void onMouseButtonDown(int button)
    {
        // Create a FoodSource
        if (button == MB_RIGHT)
        {
            auto b = world.addDynamicBody(Vector3f(0, 0, 0), 0.0f);

            int i = to!int(allFoods.length);
            spawnFood(i, b, world);

        }
    }

}
