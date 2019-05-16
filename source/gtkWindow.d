module gtkWindow;

import std.stdio;

import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Button;
import gdk.Event;
import gtk.GLArea;
import gdk.GLContext;

class AntSimWindow : MainWindow
{
    string title = "Ant Sim";
    string bye   = "Good Bye";
    string message = "Window close button clicked.";
		string otherMessage = "Button clicked instead.";


    this(string title)
    {
        super(title);
        addOnDestroy(delegate void(Widget w) {quitApp(message); });

        setDefaultSize(1280, 400);

        Button button = new Button("End");
    		button.addOnClicked(delegate void(Button b) {quitApp(otherMessage); });

        GLArea area = new GLArea();

        //ResizeButton resizeButton = new ResizeButton();
        //add(resizeButton);

    		add(area);
    		add(button);

        showAll();

    }

    void quitApp(string message)
    {
    		writeln("Bye ", message);
    		Main.quit();
    }
}

class ResizeButton : Button                                                     // *** NEW ***
{
	this(MainWindow window)
	{
		super("Resize Window");
		addOnClicked(delegate void(Button b) { resizeMe(window); });

	} // this()


	void resizeMe(MainWindow window)
	{
		int x, y;

		window.getSize(x, y);
		writeln("x = ", x, "y = ", y);

		// GTK deals in minimum sizes, not absolute sizes, therefore we can set
		// a minimum size for a window, but not a maximum. Also, we can't set
		// a new size smaller than the current size.
		if(x < 640)
		{
			window.setSizeRequest(640, 480);
		}
		else if(x > 641)
		{
			// The effect here is to set a minimum size and it can't be made smaller
			// after this condition becomes true.
			writeln("Minimum size is now set. You can shrink it, but not below the minimum size.");
			window.setSizeRequest(-1, -1);
		}
	}
} // class ResizeButton
