[![Build Status](https://dev.azure.com/heliar/Heliar%20Plaster%20Templates/_apis/build/status/rlvandaveer.HeliarPlasterTemplates?branchName=master)](https://dev.azure.com/heliar/Heliar%20Plaster%20Templates/_build/latest?definitionId=7&branchName=master)

# Heliar Plaster Templates
This repo contains [Plaster](https://github.com/PowerShell/Plaster) templates for quickly creating PowerShell projects and items.

## Getting Started

### Prerequisites

In order to use this project you need the following:

* [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)

The following steps will clone the repo, install all dependencies and execute a build and all unit tests.

1. `git clone git@github.com:rlvandaveer/HeliarPlasterTemplates.git`
1. `cd Heliar-Plaster-Templates`
1. `Install-Module -Name psake`
1. `Invoke-psake ./build/tasks.ps1 -taskList Test`

### Getting the source code

* `git clone git@github.com:rlvandaveer/HeliarPlasterTemplates.git`

### Running the tests

* `Invoke-psake ./build/tasks.ps1 -taskList Test`

### Publishing

* `Invoke-psake ./build/tasks.ps1 -taskList Publish`

For more see the [build readme](./docs/building-and-publishing.md)

## Dependencies

This project depends on the following modules/applications to manage dependencies, build, test, version, and publish, and will install them if they are not present when executed:

* [BuildHelpers](https://github.com/RamblingCookieMonster/BuildHelpers)
* [GitVersion](https://gitversion.readthedocs.io/en/latest/)
* [Nuget](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools)
* [Pester](https://github.com/pester/Pester)
* [Psake](https://github.com/psake/psake)
* [PSDepend](https://github.com/RamblingCookieMonster/PSDepend)
* [PSDeploy](https://github.com/RamblingCookieMonster/PSDeploy)

## Structure
- /build - contains the code for destributing the templates contained in the project
- /cicd - contains continuous integration-continuous delivery code
- /docs - contains documentation for using and maintaining the Heliar Plaster Templates project
- /dist - created automatically when a build is executed. Contains everything needed to distribute the PowerShell module.
- /source - contains the source code for each template
- /tests - contains unit tests for the Heliar Plaster Templates PowerShell module

## Templates
1. [**NewPowerShellModuleProject**](./source/NewPowerShellModuleProject/readme.md) - this template will create a project with configuration options for building, publishing, testing, and versioning a PowerShell module.

## Installing and Using the Templates

```PowerShell
Install-Module -Name HeliarPlasterTemplates
```

Once the module has been installed, you should be able to see all of the installed templates by using the following command:

```PowerShell
Get-PlasterTemplates -IncludeInstalledModules
```

Which will give output similar to:
```
Title        : AddPSScriptAnalyzerSettings
Author       : Plaster project
Version      : 1.0.0
Description  : Add a PowerShell Script Analyzer settings file to the root of your workspace.
Tags         : {PSScriptAnalyzer, settings}
TemplatePath : /Users/robb/.local/share/powershell/Modules/Plaster/1.1.3/Templates/AddPSScriptAnalyzerSettings

Title        : New PowerShell Manifest Module
Author       : Plaster
Version      : 1.1.0
Description  : Creates files for a simple, non-shared PowerShell script module.
Tags         : {Module, ScriptModule, ModuleManifest}
TemplatePath : /Users/robb/.local/share/powershell/Modules/Plaster/1.1.3/Templates/NewPowerShellScriptModule

Title        : New PowerShell Module Project
Author       : R. L. Vandaveer
Version      : 1.0.0
Description  : Creates the structure for a new PowerShell module project
Tags         : {PowerShell, module, project}
TemplatePath : /Users/robb/.local/share/powershell/Modules/HeliarPlasterTemplates/1.0.0/NewPowerShellModuleProject
```

The templates can be used by `Invoke-Plaster -Template {full path to template} -DesitinationPath {path to destination}`. The following snippet can be helpful to find the full path to the template: `(Get-PlasterTemplate -IncludeInstalledModules | Where-Object Title -eq '{title of the template}').TemplatePath`. *Note that the {} in the preceeding examples denote code that should be replaced and would be excluded from your final code.*

## Built With

* [Azure Pipelines](https://azure.microsoft.com/en-us/services/devops/pipelines/)
* [BuildHelpers](https://github.com/RamblingCookieMonster/BuildHelpers)
* [GitVersion](https://gitversion.readthedocs.io/en/latest/)
* [Nuget](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools)
* [Pester](https://github.com/pester/Pester)
* [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
* [Psake](https://github.com/psake/psake)
* [PSDepend](https://github.com/RamblingCookieMonster/PSDepend)
* [PSDeploy](https://github.com/RamblingCookieMonster/PSDeploy)

## Contributing

* TBD

## Versioning

* This project uses [GitVersion](https://gitversion.readthedocs.io/en/latest/) to automatically version the PowerShell module and Nuget package generated. As long as the user is using [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow), no other steps should be necessary.

## Authors

* **Robb Vandaveer** - *Creator* - [Robb Vandaveer](https://aex.dev.azure.com/me?mkt=en-US&campaign=o~msft~vsts~usercard)

## License

* [MIT](https://raw.githubusercontent.com/rlvandaveer/HeliarPlasterTemplates/master/LICENSE)

## Acknowledgments

