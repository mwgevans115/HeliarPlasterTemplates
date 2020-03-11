# Defines all of the psake tasks used to build, test, and publish this project

Include build-functions.ps1
if ($PLASTER_PARAM_GitVersion -eq $true) {
"Include version-functions.ps1"
}
%>

New-Variable -Name MODULE_NAME -Value '<%=$PLASTER_PARAM_Name%>' -Option Constant
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

	<%
	if ($PLASTER_PARAM_GitVersion -eq $true) {
		$BuildContext.VersionInfo = GetVersionInfo
	}
	%>

	New-Item $BuildContext.DistributionPath -ItemType Directory

	Build-Module -BuildContext $BuildContext

}

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

}

ask Publish -depends Init, Check-And-Build, Test -description "Publishes the module and all submodules to the $BuildContext.PsRepository.Name" {

	Publish-Module -Path $BuildContext.ModuleDistributionPath -Repository $BuildContext.PsRepository.Name -NuGetApiKey $ENV:PSGalleryApiKey

}

<%
if ($PLASTER_PARAM_TestFramework -ne 'None') {
@"
Task Test -depends Init, Build -description 'Executes all unit tests' {

"@
}
if ($PLASTER_PARAM_TestFramework -eq 'Pester') {
@"
	Invoke-Pester -Script $BuildContext.testPath -OutputFile "$($BuildContext.rootPath)\Test-Results.xml" -OutputFormat NUnitXml
"@
}
if ($PLASTER_PARAM_TestFramework -ne 'None') {
@"

}
"@
}
%>