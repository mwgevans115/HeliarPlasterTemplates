# NewPowerShellModuleProject Plaster Template

This Plaster template allows you to quickly scaffold a PowerShell module project packed full of useful features. This template will:

1. Create the project folder structure and infastructure
1. Create and populate a PowerShell module manifest
1. Create and populate a root PowerShell module
1. Optionally:
	1. Intialize a Git repo
	1. Install support for a code editor
	1. Add support for using GitVersion for module versioning
	1. Add support for publishing the module using Nuget
	1. Add support for a build automation tool
	1. Add support for a dependency framework
	1. Add support for a unit testing framework


## Getting Started

1. Install the template
```PowerShell
Install-Module -HeliarPlasterTemplates -Repository PSGallery
```
2. Create a new module project
```PowerShell
Invoke-Plaster -Template (Get-PlasterTemplate -IncludeInstalledModules | Where-Object Title -eq 'New PowerShell Module Project').TemplatePath -Destination ~/Code/new-powershell-project
```

Instead of filling out all of the prompts manually, you have the option of supplying an object to the script at execution time:
```PowerShell
$templateParams = @{
	templatePath = '.',
	destinationPath = '~/Code/new-module-project',
	name = 'NewModuleProject',
	description = 'This is a new PowerShell module project',
	version = '0.1.0',
	author = 'Robb Vandaveer',
...
}

Invoke-Plaster $templateParams -Force
```
3. Execute the completion script
```PowerShell
cd new-module-project #or whatever your project is called
./Invoke-CompleteModuleSetup.ps1
```