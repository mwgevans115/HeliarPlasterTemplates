# Defines all of the psake tasks used to build, test, and publish this project

Include "build-functions.ps1"
Include "package-functions.ps1"
Include "version-functions.ps1"

Properties {
	$BuildContext = @{
		distributionPath = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "dist")
		rootPath = (Split-Path -Parent $PSScriptRoot)
		sourcePath = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "source")
		testPath = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "tests")
		versionInfo = $null
		nugetSource = $null
	}
}

Task default -depends Test

Task Clean -description "Deletes all build artifacts and the distribution (dist) folder" {

	Remove-Item $BuildContext.distributionPath -Recurse -Force -ErrorAction SilentlyContinue

}

Task Build -depends Clean, Init -description "Creates ready to distribute modules with all required files" {

	$BuildContext.versionInfo = GetVersionInfo

	New-Item $BuildContext.distributionPath -ItemType Directory

	Build-Module -BuildContext $BuildContext
	PackModule -BuildContext $BuildContext

}

Task Init -description "Initializes the build chain by installing dependencies" {

	$psd = Get-Module PSDepend -listAvailable
	if ($null -eq $psd) {
	  Install-Module PSDepend -AcceptLicense -Force
	}
	Import-Module PSDepend

	Invoke-PSDepend $PSScriptRoot -Force

}

Task Test -depends Init, Build -description "Executes all unit tests" {

	Invoke-Pester -Script @{ Path = $BuildContext.testPath; Parameters = @{ BuildContext = $BuildContext } }  -OutputFile (Join-Path -Path $BuildContext.rootPath -ChildPath 'Test-Results.xml') -OutputFormat NUnitXml

}

Task Publish -depends Init -description "Publishes the HeliarStandardsAzure module and all submodules to Azure Artifacts" {

	Assert (Test-Path -Path (Join-Path -Path $BuildContext.DistributionPath -ChildPath "*") -Include "*.nupkg") -failureMessage "Module not built. Please build before publishing or use the BuildAndPublish task."
	PublishModule -BuildContext $BuildContext

}

Task BuildAndPublish -depends Build, Test, Publish