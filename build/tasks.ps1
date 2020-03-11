# Defines all of the psake tasks used to build, test, and publish this project

Include "build-functions.ps1"
Include "version-functions.ps1"

New-Variable -Name MODULE_NAME -Value 'HeliarPlasterTemplates' -Option Constant
New-Variable -Name ROOT_PATH -Value (Split-Path -Parent $PSScriptRoot) -Option Constant
New-Variable -Name BUILD_PATH -Value (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath 'build') -Option Constant
New-Variable -Name DISTRIBUTION_PATH -Value (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath 'dist') -Option Constant
New-Variable -Name MODULE_DISTRIBUTION_PATH -Value (Join-Path -Path $DISTRIBUTION_PATH -ChildPath $MODULE_NAME) -Option Constant
New-Variable -Name SOURCE_PATH -Value (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath 'source') -Option Constant
New-Variable -Name TESTS_PATH -Value (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath 'tests') -Option Constant

Properties {
	$BuildContext = @{
		BuildPath = $BUILD_PATH
		DistributionPath = $DISTRIBUTION_PATH
		ModuleDistributionPath = $MODULE_DISTRIBUTION_PATH
		ModuleName = $MODULE_NAME
		PsRepository = @{ Source = 'PSGallery'; Url = 'https://www.powershellgallery.com/api/v2' }
		RootPath = $ROOT_PATH
		SourcePath = $SOURCE_PATH
		TestPath = $TESTS_PATH
		VersionInfo = $null
	}
}

Task Build -depends Clean, Init -description 'Creates a ready to distribute module with all required files' {

	[hashtable]$ver = [hashtable](GetVersionInfo)
	$BuildContext.VersionInfo = $ver
	Write-Host '$ver Type: ' + $ver.GetType()
	Write-Host '$BuildContext.VersionInfo Type: ' + $BuildContext.VersionInfo.GetType()
	if ($ENV:BHBuildSystem -eq 'Azure Pipelines') {
		Write-VersionInfoToAzureDevOps -Version $BuildContext.VersionInfo
	}

	New-Item $BuildContext.DistributionPath -ItemType Directory

	Build-Module -BuildContext $BuildContext

}

Task Build-And-Publish -depends Clean, Init, Build, Test -description ''

Task Check-And-Build -depends Build -description 'Conditionally executes a build if no build output is found' -precondition { return Test-BuildRequired -Path $BuildContext.moduleDistributionPath }

Task Clean -description 'Deletes all build artifacts and the distribution folder' {

	Remove-Item $BuildContext.DistributionPath -Recurse -Force -ErrorAction SilentlyContinue

}

Task default -depends Test

Task Init -description 'Initializes the build chain by installing dependencies' {

	$psd = Get-Module PSDepend -listAvailable
	if ($null -eq $psd) {
	  Install-Module PSDepend -AcceptLicense -Force
	}
	Import-Module PSDepend

	Invoke-PSDepend $PSScriptRoot -Force

	Set-BuildEnvironment -Force
}

Task Publish -depends Init -description "Publishes the module and all submodules to the $($BuildContext.PsRepository.Name)" {

	Assert (Test-Path -Path (Join-Path -Path $BuildContext.DistributionPath -ChildPath "*") -Include "*.psd1") -failureMessage "Module not built. Please build before publishing or use the Build-And-Publish task."
	Publish-Module -Path $BuildContext.ModuleDistributionPath -Repository $BuildContext.PsRepository.Name -NuGetApiKey $ENV:PSGalleryApiKey

}

Task Test -depends Init, Check-And-Build -description 'Executes all unit tests' {

	Invoke-Pester -Script @{ Path = $BuildContext.TestPath; Parameters = @{ BuildContext = $BuildContext } }  -OutputFile (Join-Path -Path $BuildContext.RootPath -ChildPath 'Test-Results.xml') -OutputFormat NUnitXml

}