param(
	[Parameter(Mandatory = $true)]
	[hashtable]$BuildContext
)

Describe 'Testing Module Nuget Package' {

	$sut = Get-ChildItem -Path $BuildContext.distributionPath -Filter "HeliarPlasterTemplates.*.nupkg"

	It 'Has a single Nuget Package' {
		$sut | Should -HaveCount 1
	}
}