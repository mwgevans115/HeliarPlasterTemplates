param(
	[Parameter(Mandatory = $true)]
	[hashtable]$BuildContext
)
$manifest = Join-Path -Path $BuildContext.distributionPath -ChildPath "HeliarPlasterTemplates.psd1"

Describe 'Testing Module Manifest' {

	It 'The module has a valid module manifest file' {
		Test-ModuleManifest -Path $manifest
	}

	Context 'The module manifest' {

		$sut = Import-PowerShellDataFile -Path $manifest
		$definition = Import-PowerShellDataFile -Path (Join-Path -Path $BuildContext.sourcePath -ChildPath 'HeliarPlasterTemplates.definition.psd1')

		It 'Has a valid version number' {
			$sut.ModuleVersion | Should -Match '\d+\.\d+.\d+'
		}

		It 'Has the correct GUID' {
			$sut.GUID | Should -BeExactly $definition.GUID
		}

		It 'Has the correct author' {
			$sut.Author | Should -BeExactly $definition.Author
		}

		It 'Has the correct company name' {
			$sut.CompanyName | Should -BeExactly $definition.CompanyName
		}

		It 'Has the correct copyright' {
			$sut.Copyright | Should -BeExactly $definition.Copyright
		}

		It 'Has the correct description' {
			$sut.Description | Should -BeExactly $definition.Description
		}

		It 'Has the correct file list' {
			$sut.FileList | Should -HaveCount 2
		}

		It 'Has private data' {
			$sut.PrivateData | Should -Not -BeNullOrEmpty
		}
	}
}