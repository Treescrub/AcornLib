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

## AcornLib

### **Module loading**

```Squirrel
bool LoadModule(string moduleName)
```
LoadModule returns a boolean indicating if the loading succeeded.

The module name should match a module script that is in the same directory as the main AcornLib script.

The load will fail if the module is already loaded, or the script isn't a valid module script (see MODULE SCRIPT INFO when I write it), or the script encountered an error.

The OnLoad function in the module script will be called once fully loaded and all dependencies have been loaded.

All module names are converted to lowercase when loaded, any access of modules by a non-lowercase name will fail.

After a module has successfully loaded, you can access the module script table with:
```Squirrel
AcornLib.module_name
AcornLib[module_name]
```

```Squirrel
bool LoadModules(...)
```

The same as LoadModule, but takes any number of module names.

### **Module unloading**

```Squirrel
bool UnloadModule(string moduleName)
```

Unloads the provided module.

Returns true if the module was successfully unloaded, false if the module is not loaded.

Calls OnUnload in the module script just before the module is removed.

```Squirrel
bool UnloadModules(...)
```

The same as UnloadModule, but takes any number of module names.

# Installation

To install, download the [scripts](https://github.com/Treescrub/AcornLib/archive/master.zip) and unzip them into the **scripts/vscripts** folder in your addon or game installation.
