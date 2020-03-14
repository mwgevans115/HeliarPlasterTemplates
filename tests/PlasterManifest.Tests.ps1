param(
	[Parameter(Mandatory = $true)]
	[hashtable]$BuildContext
)

$manifests = Get-ChildItem -Path $BuildContext.DistributionPath -Filter 'PlasterManifest.xml' -Recurse
$testCases = @()

foreach ($manifest in $manifests) {

	$manifestXml = [xml](Get-Content -Path $manifest)
	$testCases += @{ Title = ($manifestXml.GetElementsByTagName('title') | Select-Object -First 1 | ForEach-Object { $_.InnerText }); Manifest = $manifest; ManifestXml = $manifestXml }

}

Describe 'Testing Plaster Manifests' {

	It "The Plaster manifest -Title '<Title>' is a valid manifest file" -TestCases $testCases {
		param ( $Title, $Manifest, $ManifestXml )
		Test-PlasterManifest -Path $Manifest
	}

	It "The Plaster manifest -Title '<Title>' has a valid version number format" -TestCases $testCases {
		param ( $Title, $Manifest, $ManifestXml )
		$ManifestXml.GetElementsByTagName('version') | Select-Object -First 1 -Property InnerText | Should -Match '\d+\.\d+.\d+'
	}

	It "The Plaster manifest -Title '<Title>' has a valid version number" -TestCases $testCases {
		param ( $Title, $Manifest, $ManifestXml )
		$hasOneNonZero = $false
		($ManifestXml.GetElementsByTagName('version') | Select-Object -First 1).InnerText -split '\.' | ForEach-Object { if ( $_ -ge 1 ) { $hasOneNonZero = $true } }
		$hasOneNonZero | Should -BeTrue
	}

}