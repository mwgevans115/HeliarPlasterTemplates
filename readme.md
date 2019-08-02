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
1. `Install-Module -Name PSDepend`
1. `Invoke-PSDepend ./build`
1. `Invoke-psake ./build/tasks.ps1 -taskList Test`

## Dependencies

This project dependends on all of the following to manage dependencies, build, test, version, and publish, and will install them if they are not present when executed:

* [BuildHelpers](https://github.com/RamblingCookieMonster/BuildHelpers)
* [GitVersion](https://gitversion.readthedocs.io/en/latest/)
* [Nuget](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools)
* [PSDepend](https://github.com/RamblingCookieMonster/PSDepend)
* [Pester](https://github.com/pester/Pester)
* [Psake](https://github.com/psake/psake)

## Structure
- /build - contains the code for destributing the templates contained in the project
- /cicd - contains continuous integration-continuous delivery code
- /docs - contains documentation for using and maintaining the Heliar Plaster Templates project
- /dist - created automatically when a build is executed. Contains everything needed to distribute the PowerShell module.
- /source - contains the source code for each template
- /tests - contains unit tests for the Heliar Plaster Templates PowerShell module

## Templates
1. NewPowerShellModuleProject - creates a project with configuration options for building, publishing, testing, and versioning a PowerShell module.

### Getting the source code

* `git clone git@github.com:rlvandaveer/HeliarPlasterTemplates.git`

## Running the tests

* `Invoke-psake ./build/tasks.ps1 -taskList Test`

## Publishing

* `Invoke-psake ./build/tasks.ps1 -taskList Publish`

## Built With

* [BuildHelpers](https://github.com/RamblingCookieMonster/BuildHelpers)
* [GitVersion](https://gitversion.readthedocs.io/en/latest/)
* [Nuget](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools)
* [PSDepend](https://github.com/RamblingCookieMonster/PSDepend)
* [Pester](https://github.com/pester/Pester)
* [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
* [Psake](https://github.com/psake/psake)
* [Azure Pipelines](https://azure.microsoft.com/en-us/services/devops/pipelines/)

## Contributing

* TBD

## Versioning

* This project uses [GitVersion](https://gitversion.readthedocs.io/en/latest/) to automatically version the PowerShell module and Nuget package generated. As long as the user is using [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow), no other steps should be necessary.

## Authors

* **Robb Vandaveer** - *Creator* - [Robb Vandaveer](https://aex.dev.azure.com/me?mkt=en-US&campaign=o~msft~vsts~usercard)

## License

* [MIT](https://raw.githubusercontent.com/rlvandaveer/HeliarPlasterTemplates/master/LICENSE)

## Acknowledgments

