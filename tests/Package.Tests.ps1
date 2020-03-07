param(
	[Parameter(Mandatory = $true)]
	[hashtable]$BuildContext
)

$sut = Join-Path -Path $BuildContext.distributionPath -ChildPath "HeliarPlasterTemplates.psd1"

Describe 'Module Package Tests' {
	It 'Once the module is built, has a valid module manifest file' {
		Test-ModuleManifest -Path $sut
	}
}