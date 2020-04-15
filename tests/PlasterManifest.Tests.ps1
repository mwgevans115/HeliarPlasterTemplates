param(
	[Parameter(Mandatory = $true)]
	[hashtable]$BuildContext
)

Describe 'Plaster Manifest Tests' {

	$manifests = Get-ChildItem -Path $BuildContext.DistributionPath -Filter 'PlasterManifest.xml' -Recurse

	Context 'The raw XML' {

		foreach ($manifest in $manifests) {

			$testCases += @{ Path = $manifest.FullName }

		}

		It "For the Plaster manifest at -Path '<Path>' should be valid" -TestCases $testCases {
			param ( $Path )
			{ [xml](Get-Content -Path $Path) } | Should -Not -Throw
		}

	}

	Context 'The Manifest' {

		foreach ($manifest in $manifests) {

			$manifestXml = [xml](Get-Content -Path $manifest)
			$testCases += @{ Title = ($manifestXml.GetElementsByTagName('title') | Select-Object -First 1 | ForEach-Object { $_.InnerText }); Manifest = $manifest; ManifestXml = $manifestXml }

		}

		It "For -Title '<Title>' is a valid manifest file" -TestCases $testCases {
			param ( $Title, $Manifest, $ManifestXml )
			Test-PlasterManifest -Path $Manifest
		}

		It "For -Title '<Title>' has a valid version number format" -TestCases $testCases {
			param ( $Title, $Manifest, $ManifestXml )
			$ManifestXml.GetElementsByTagName('version') | Select-Object -First 1 -Property InnerText | Should -Match '\d+\.\d+.\d+'
		}

		It "For -Title '<Title>' has a valid version number" -TestCases $testCases {
			param ( $Title, $Manifest, $ManifestXml )
			$hasOneNonZero = $false
			($ManifestXml.GetElementsByTagName('version') | Select-Object -First 1).InnerText -split '\.' | ForEach-Object { if ( $_ -ge 1 ) { $hasOneNonZero = $true } }
			$hasOneNonZero | Should -BeTrue
		}

	}
}