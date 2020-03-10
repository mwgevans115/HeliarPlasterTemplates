# Building and Publishing the Templates

This module is built using psake and tested using Pester.

## PSake Tasks

To execute any build task simply use the following where task list is one or more from the numbered list below:
```PowerShell
Invoke-psake -buildFile ./build/tasks.ps1 -taskList [task list]
```

1. **Build** - Creates a ready to distribute module with all required files
1. **Check-And-Build** - An *internal* task that conditionally executes a build if no build output is found
1. **Clean** - Deletes all build artifacts and the distribution (dist) folder
1. **Default** - Executes test
1. **Init** - Initializes the build chain by installing dependencies
1. **Test** - Executes all unit tests
1. **Publish** - Publishes the module and all submodules to the PSGallery

To output the latest info on all of the build tasks execute `Invoke-psake ./build/tasks.ps1 -detailedDocs`.