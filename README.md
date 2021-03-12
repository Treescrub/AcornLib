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

All module names are converted to lowercase when loaded, any accesses of modules by a non-lowercase name will fail.

# API

# Installation

To install, download the [scripts](https://github.com/Treescrub/AcornLib/archive/master.zip) and unzip them into the **scripts/vscripts** folder in your addon or game installation.
