# AcornLib
A lightweight modular Squirrel library for Left 4 Dead 2 VScripts.

# Usage

To load the library in the current scope use:

```Squirrel
IncludeScript("AcornLib")
```

To load the library in a new table use:

```Squirrel
AcornLib <- {}
IncludeScript("AcornLib", AcornLib)
```

## Module loading

```Squirrel
AcornLib.LoadModule("logger")
```

## Module unloading

```Squirrel
AcornLib.UnloadModule("logger")
```


# API

[The wiki](https://github.com/Treescrub/AcornLib/wiki) has detailed documentation about the main AcornLib script and modules.

# Installation

To install, download the latest release and unzip the scripts into the **scripts/vscripts** folder in your addon or game installation.

Or if you want the most recent version of the scripts, download the [source files](https://github.com/Treescrub/AcornLib/archive/master.zip) and place the scripts in the *AcornLib* folder into the **scripts/vscripts** folder.

You may want to place the files in a *AcornLib* folder to organize them, just make sure the modules and the main script are in the same folder.
