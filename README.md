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
