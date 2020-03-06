<#
.SYNOPSIS
	Installs Nuget if it is not installed and registers a source if present in $BuildContext i.e., nugetSource.
#>
function EnsureNuGet {

	try {

		Write-Host "Checking for NuGet install..."
		$help = Exec { return nuget help }
		$ver = $help.Split([Environment]::NewLine) | Select-Object -First 1
		Write-Host "$ver installed"

	} catch {

		Write-Host "NuGet not installed, installing..."

		if ($IsLinux) {

			Write-Host 'Executing apt-get install on Linux...'
			Exec { sudo apt-get install nuget }

		} elseif ($IsMacOS) {

			Write-Host 'Executing brew install on MacOS...'
			Exec { brew install nuget }

		} elseif ($IsWindows) {

			Write-Host 'Executing choco install on Windows...'
			Exec { choco install nuget.commandline -y }

		}
	}

	$sources = Exec { return nuget sources }

	if (($null -ne $BuildContext.nugetSource) -and !($sources -match "\d\.\s*$BuildContext.nugetSource.name")) {

		nuget sources Add -Name $BuildContext.nugetSource.name  -Source $BuildContext.nugetSource.source

	}
}

function PackModule ([hashtable] [ValidateNotNull()] $BuildContext) {

	EnsureNuGet
	$specPath = Get-ChildItem -Path (Join-Path -Path $BuildContext.distributionPath -ChildPath "*") -Include "*.nuspec"
	nuget pack $specPath.FullName -OutputDirectory $BuildContext.distributionPath

	$packagePath = Get-ChildItem -Path (Join-Path -Path $BuildContext.distributionPath -ChildPath '*') -Include "*.nupkg"

	# Detect if we are running in an Azure Pipeline and write out the path to the NuGet package file
	if ($null -ne $env:Agent_Id) {
		Write-Output("##vso[task.setvariable variable=azure.pipelines.packagepath]$($packagePath.FullName)")
	}

}

function PublishModule ([hashtable] [ValidateNotNull()] $BuildContext) {

	EnsureNuGet
	$pkgPath = Get-ChildItem -Path (Join-Path -Path $BuildContext.distributionPath -ChildPath "*") -Include "*.nupkg"
	nuget push $pkgPath -Source $BuildContext.nugetSource.name -ApiKey 'AzureDevOpsServices'

}