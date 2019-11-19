module warehouse;

import dagon;

class StoreScene: Scene
{
    Actor actor;

    Material barrierBlack;

    IQMAsset iqmAnt;

    PhysicsWorld world;
    RigidBody bGround;

    NuklearGUI gui;

    FontAsset aFontDroidSans14;

    string helpTextGeneral = "Press RMB to add a random food Source";

    TextLine helpText;

    this(SceneManager smngr)
    {
        super(smngr);
    }

    override void onAssetsRequest()
    {
        aFontDroidSans14 = addFontAsset("data/font/DroidSans.ttf", 14);
//        assetManager.mountDirectory("data/assets");
//        thing = addIQMAsset("data/assets/mrfixit.iqm");
    }

    override void onAllocate()
    {
        super.onAllocate();

        world = New!PhysicsWorld(assetManager);
        auto b = world.addDynamicBody(Vector3f(0, 0, 0), 0.0f);

        view = New!Freeview(eventManager, assetManager);

        mainSun = createLightSun(Quaternionf.identity, environment.sunColor, environment.sunEnergy);
        mainSun.shadow = true;
        environment.setDayTime(9, 00, 00);

        barrierBlack = createMaterial();
        barrierBlack.diffuse = Color4f(1.0, 1.0, 1.0, 1.0);

        // Common materials
        auto matGround = createMaterial();
        matGround.roughness = 0.9f;
        matGround.metallic = 0.0f;
        matGround.culling = false;
        matGround.diffuse = Color4f(1.0, 0.2, 0.6, 1.0);

        auto ePlaneA = createEntity3D();
        ePlaneA.drawable = New!ShapePlane(15, 20, 1, assetManager);
        ePlaneA.material = matGround;

        helpText = New!TextLine(aFontDroidSans14.font, helpTextGeneral, assetManager);
        helpText.color = Color4f(1.0, 0.2, 0.6, 1.0);

        auto eText = createEntity2D();
        eText.drawable = helpText;
        eText.position = Vector3f(16.0f, 30.0f, 0.0f);

    }


    override void onStart()
    {
        super.onStart();
    }

    override void onUpdate(double dt)
    {
        super.onUpdate(dt);
    }

}
