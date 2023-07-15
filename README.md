# Waltz
 A GUI library for OpenComputers and ComputerCraft, two computer-related mods for Minecraft. Has a similar interface to Java's Swing toolkit. 

Implemented functionality:

1. GUI remains responsive under most conditions, certainly more often than competing GUI libraries. It does this by separating the main loop of the program from the GUI thread. Thus, GUI updates may happen while the main loop is running, and the main loop may be interrupted by a GUI event such as a click.
2. Supports both OpenComputers and ComputerCraft (with small necessary differences).
3. Buttons, clickable, with setable actions.
4. Labels, with setable text.
5. Icons, a way to draw ASCII icons on screen. This Icon represents a reactor in a reactor and turbine control program: ![ReactorControlIcon](/assets/images/icon.png "Reactor") The Icons may change colours to indicate the status of the reactors, or whatever you wish to monitor with your program, for instance blue for shutdown, green for active, orange for active with issues, and red for critical. Uses Labels to draw the icons.
6. Panels, much like a jPanel, or a "Window Lite", if you will. Allows you to organise your other components into one single panel, which when moved will move its daughter components with it so everything remains organised. 
7. Progress bars, standard type.
8. Progress bars, vertical type.
9. A shim Window class for OpenComputers compatibility.
10. Themes.

Planned functionality:

1. FlowLayouts, similar to Swing's FlowLayouts. Lays out components in a sequential order. 
2. Ability to scroll Windows and Panels.
3. CheckBoxes and RadioButtons.
4. Lists and Tables.
5. Better themes.
6. TextBoxes.
7. Sliders.