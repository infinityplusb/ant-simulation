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

//        text.position.y = eventManager.windowHeight - 10;

//        uint n = sprintf(textBuffer.ptr, "FPS: %u", eventManager.fps);
//        string s = cast(string)textBuffer[0..n];
//        infoText.setText(s);

//        gui = New!NuklearGUI(eventManager, assetManager);
//        font = gui.addFont(aFontDroidSans, 20);
//        auto eNuklear = createEntity2D();
//        eNuklear.drawable = gui;

//        scoreText = New!TextLine(aFontDroidSans20.font, "0", assetManager);
//        scoreText.color = Color4f(0.5f, 0.5f, 0.0f, 0.8f);
//        auto eText = createEntity2D();
//        eText.drawable = scoreText;
//        eText.position = Vector3f(16.0f, 30.0f, 0.0f);

        auto ePlaneA = createEntity3D();
        ePlaneA.drawable = New!ShapePlane(15, 20, 1, assetManager);
        ePlaneA.material = matGround;

//        helpText = New!TextLine(aFontDroidSans14.font, helpTextGeneral, assetManager);
//        helpText.color = Color4f(1.0, 0.2, 0.6, 1.0);

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
//        findFoodCheck();
    }

}
