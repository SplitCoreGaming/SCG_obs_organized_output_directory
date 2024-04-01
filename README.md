# Organized Output Directory
With "Organized Output Directory" you can create order in your output directory.
The script automatically creates subdirectories for each game in the output directory.
To do this, it searches for Window Capture or Game Capture sources in the current scene.
The last active and hooked source is then used to determine the name of the subdirectory from the window title or the process name.

❗This script only works with OBS v30.0.0 and newer versions.

![Screenshot](assets/screenshot.png)

# Known Issues / Planned Features
- Some kind of rule/wildcard/match system would be useful.<p>
Some games/apps like Minecraft are a little tricky. The window title contains the current game version like `Minecraft 1.20.4` and the process name is something like `javaw.exe`. With a rule/wildcard/match system, we could change the name and remove the version from the window title, for example.

- Currently only Windows is supported. I would like to get the script running on Linux and MacOS as well.

DONE! - M̵a̵y̵b̵e̵ ̵a̵d̵d̵ ̵a̵n̵ ̵o̵p̵t̵i̵o̵n̵ ̵t̵o̵ ̵e̵x̵c̵l̵u̵d̵e̵ ̵s̵o̵m̵e̵ ̵c̵h̵a̵r̵a̵c̵t̵e̵r̵s̵ ̵o̵r̵ ̵o̵n̵l̵y̵ ̵a̵l̵l̵o̵w̵ ̵a̵ ̵c̵e̵r̵t̵a̵i̵n̵ ̵c̵h̵a̵r̵a̵c̵t̵e̵r̵ ̵s̵e̵t̵<̵p̵>̵
̵S̵o̵m̵e̵ ̵g̵a̵m̵e̵s̵ ̵l̵i̵k̵e̵ ̵B̵a̵t̵t̵l̵e̵f̵i̵e̵l̵d̵ ̵2̵0̵4̵2̵ ̵h̵a̵v̵e̵ ̵a̵ ̵w̵i̵n̵d̵o̵w̵ ̵t̵i̵t̵l̵e̵ ̵l̵i̵k̵e̵ ̵`̵B̵a̵t̵t̵l̵e̵f̵i̵e̵l̵d̵™̵ ̵2̵0̵4̵2̵`̵.̵ ̵E̵v̵e̵n̵ ̵i̵f̵ ̵i̵t̵ ̵i̵s̵ ̵t̵e̵c̵h̵n̵i̵c̵a̵l̵l̵y̵ ̵p̵o̵s̵s̵i̵b̵l̵e̵ ̵t̵o̵ ̵u̵s̵e̵ ̵c̵h̵a̵r̵a̵c̵t̵e̵r̵s̵ ̵s̵u̵c̵h̵ ̵a̵s̵ ̵`̵™̵`̵ ̵i̵n̵ ̵t̵h̵e̵ ̵f̵i̵l̵e̵ ̵n̵a̵m̵e̵,̵ ̵i̵t̵ ̵i̵s̵ ̵o̵f̵t̵e̵n̵ ̵n̵o̵t̵ ̵r̵e̵c̵o̵m̵m̵e̵n̵d̵e̵d̵,̵ ̵a̵s̵ ̵i̵t̵ ̵c̵a̵n̵ ̵h̵a̵p̵p̵e̵n̵ ̵t̵h̵a̵t̵ ̵s̵o̵m̵e̵ ̵s̵o̵f̵t̵w̵a̵r̵e̵,̵ ̵e̵s̵p̵e̵c̵i̵a̵l̵y̵ ̵o̵l̵d̵e̵r̵ ̵o̵n̵e̵s̵,̵ ̵m̵a̵y̵ ̵o̵n̵l̵y̵ ̵e̵x̵p̵e̵c̵t̵ ̵A̵S̵C̵I̵I̵ ̵c̵h̵a̵r̵a̵c̵t̵e̵r̵s̵.̵ ̵T̵h̵e̵ ̵s̵a̵m̵e̵ ̵a̵p̵p̵l̵i̵e̵s̵ ̵t̵o̵ ̵w̵h̵i̵t̵e̵s̵p̵a̵c̵e̵s̵.̵
