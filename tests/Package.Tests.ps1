$testFileDir = Get-Item (Split-Path -Parent $MyInvocation.MyCommand.Path)
$sutDirFrag = Join-Path -Path (Get-Item (Split-Path -Path $testFileDir -Parent)) -ChildPath "dist"
$sut = Join-Path -Path $sutDirFrag -ChildPath "HeliarPlasterTemplates.psd1"

Describe 'Module Package Tests' {
	It 'Once the module is built, has a valid module manifest file' {
		Test-ModuleManifest -Path $sut
	}
}