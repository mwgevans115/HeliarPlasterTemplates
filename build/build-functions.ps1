function Build-Module ([ValidateNotNull()] [hashtable] $BuildContext) {

	$publicFuncs = Get-ChildItem -Path (Join-Path -Path $BuildContext.SourcePath -ChildPath "Public/*") -Include @("*.ps1", "*.psm1") -ErrorAction Ignore
	$privateFuncs = Get-ChildItem -Path (Join-Path -Path $BuildContext.SourcePath -ChildPath "Private/*") -Include @("*.ps1", "*.psm1") -ErrorAction Ignore
	$templates = Get-ChildItem -Path (Join-Path -Path $BuildContext.SourcePath -ChildPath "*") -Directory

	Get-ChildItem -Path (Join-Path -Path $BuildContext.SourcePath -ChildPath "*") -Include @("*.ps1", "*.psm1") -Exclude "*.definition.psd1" | Copy-Item -Destination $BuildContext.DistributionPath

	Get-ChildItem -Path (Join-Path -Path $BuildContext.SourcePath -ChildPath "*") -Include @("*.md") | Copy-Item -Destination $BuildContext.DistributionPath

	$templates | Copy-Item -Recurse -Destination $BuildContext.DistributionPath

	Build-ModuleDefinition $BuildContext $publicFuncs $privateFuncs

	$nuspec = Get-ChildItem -Path (Join-Path -Path $BuildContext.SourcePath -ChildPath "*") -Include "*.nuspec" | Copy-Item -Destination $BuildContext.DistributionPath -PassThru | Get-Item

	(Get-Content -Path $nuspec.FullName -Raw).Replace("{version-replace-me}", $BuildContext.versionInfo.NuGetVersionV2) | Set-Content -Path $nuspec.FullName

}

function Build-ModuleDefinition ([ValidateNotNull()] [hashtable] $BuildContext, [System.IO.FileInfo[]] $PublicFuncs, [System.IO.FileInfo[]] $PrivateFuncs) {

	$defPath = Get-ChildItem -Path (Join-Path -Path $BuildContext.SourcePath -ChildPath "*") -Include "*.definition.psd1"

	$definition = Import-PowerShellDataFile -Path (Join-Path -Path $BuildContext.SourcePath -ChildPath $defPath.Name)

	$name = $defPath.Name.Split('.')[0]
	$path = (Join-Path -Path $BuildContext.DistributionPath -ChildPath "$name.psd1")

	$definition.Add("Path", $path)
	$definition.Add("ModuleVersion", $BuildContext.versionInfo.MajorMinorPatch)

	if ($null -ne $PublicFuncs) {
		$definition.FileList += [string[]]$PublicFuncs.Name
		$definition.FunctionsToExport += $PublicFuncs.BaseName
	}
	if ($null -ne $PrivateFuncs) {
		$definition.FileList += [string[]]$PrivateFuncs.Name
	}
	if (($null -ne $PublicFuncs) -or ($null -ne $PrivateFuncs)) {
		$definition.NestedModules += Get-NestedModules $PublicFuncs $PrivateFuncs
	}

	New-ModuleManifest @definition

	# Update PrivateData as New-ModuleManifest butchers it: https://github.com/PowerShell/PowerShell/issues/5922, https://github.com/PowerShell/PowerShellGet/issues/294#issuecomment-401151546
	if ($null -ne $definition.PrivateData) {
		Update-Metadata -Path $path -PropertyName PrivateData -Value $definition.PrivateData
	}
}

function Get-NestedModules ([System.IO.FileInfo[]] $PublicFuncs, [System.IO.FileInfo[]] $PrivateFuncs) {

	[string[]]$BaseNames = $null
	if ($null -ne $PrivateFuncs) {
		$BaseNames += $PrivateFuncs.Name
	}

	if ($null -ne $PublicFuncs) {
		$BaseNames += $PublicFuncs.Name
	}

	return $BaseNames
}