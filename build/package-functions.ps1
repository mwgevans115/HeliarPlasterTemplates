<#
.SYNOPSIS
	Installs Nuget if it is not installed and registers a source if present in $BuildContext i.e., nugetSource.
#>
function EnsureNuGet {

	try {

		Write-Debug "Checking for NuGet install..."
		$help = Exec { return nuget help }
		$ver = $help.Split([Environment]::NewLine) | Select-Object -First 1
		Write-Debug "$ver installed"

	} catch {

		Write-Debug "NuGet not installed, installing..."

		if ($IsLinux) {

			try {
				Exec { sudo apt install nuget }
			} catch {
				Write-Host $LASTEXITCODE
				Write-Host ($_ -notcontains 'WARNING') #ß{ throw $_ }
			}

		} elseif ($IsMacOS) {

			Exec { brew install nuget }

		} elseif ($IsWindows) {

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