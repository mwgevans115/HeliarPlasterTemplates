# Defines all of the psake tasks used to build, test, and publish this project

Include "build-functions.ps1"
Include "package-functions.ps1"
Include "version-functions.ps1"

Properties {
	$BuildContext = @{
		buildPath = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "build")
		distributionPath = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "dist")
		rootPath = (Split-Path -Parent $PSScriptRoot)
		sourcePath = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "source")
		testPath = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "tests")
		versionInfo = $null
		nugetSource = $null
	}
}

Task Build -depends Clean, Init -description 'Creates a ready to distribute module with all required files' {

	$BuildContext.versionInfo = GetVersionInfo

	New-Item $BuildContext.distributionPath -ItemType Directory

	Build-Module -BuildContext $BuildContext
	PackModule -BuildContext $BuildContext

}

Task Check-And-Build -depends Build -description 'Conditionally executes a build if no build output is found' -precondition { return Test-BuildRequired -Path $BuildContext.distributionPath }

Task Clean -description 'Deletes all build artifacts and the distribution folder' {

	Remove-Item $BuildContext.distributionPath -Recurse -Force -ErrorAction SilentlyContinue

}

Task default -depends Test

Task Init -description 'Initializes the build chain by installing dependencies' {

	$psd = Get-Module PSDepend -listAvailable
	if ($null -eq $psd) {
	  Install-Module PSDepend -AcceptLicense -Force
	}
	Import-Module PSDepend

	Invoke-PSDepend $PSScriptRoot -Force

}

Task Publish -depends Init, Check-And-Build, Test -description 'Publishes the module and all submodules to the PSGallery' {

	Invoke-PSDeploy -Path $BuildContext.buildPath -DeploymentRoot $BuildContext.distributionPath

}

Task Test -depends Init, Check-And-Build -description 'Executes all unit tests' {

	Invoke-Pester -Script @{ Path = $BuildContext.testPath; Parameters = @{ BuildContext = $BuildContext } }  -OutputFile (Join-Path -Path $BuildContext.rootPath -ChildPath 'Test-Results.xml') -OutputFormat NUnitXml

}