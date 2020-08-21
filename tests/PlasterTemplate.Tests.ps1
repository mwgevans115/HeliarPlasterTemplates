param(
	[Parameter(Mandatory = $true)]
	[hashtable]$BuildContext
)

Describe 'Plaster Template Tests' {

	$templateDirs = Get-ChildItem -Path $BuildContext.ModuleDistributionPath -Directory
	foreach ($templateDir in $templateDirs) {

		Context "The $($templateDir.Name) Plaster template" {

			$sut = Get-PlasterTemplate -Path $templateDir

			It 'Is a valid plaster template' {
				$sut | Should -Not -BeNullOrEmpty
			}

			It 'Has the correct version number' {
				$sut.Version | Should -BeExactly $BuildContext.VersionInfo.MajorMinorPatch
			}

		}

		Context "Invoke-Plaster -Path $($templateDir.Name) with basic params" {

			$plasterParams = @{
				Author = "Testy McTester"
				AuthorEmail = "test@mctester.test"
				BuildAutomation = 'None'
				CreateRepo = 'False'
				DependencyFramework = 'None'
				Description = 'Test'
				DestinationPath = (Join-Path -Path 'TestDrive:' -ChildPath $templateDir.Name)
				Editor = 'None'
				FunctionFolders = 'Public', 'Private', 'Classes'
				GitVersion = 'False'
				LicenseUri = 'https://test.mctester.test/license'
				Name = 'TestProject'
				ProjectUri = 'https://test.mctester.test'
				TemplatePath = $templateDir.FullName
				TestFramework = 'None'
				Version = '1.0.0'
			}

			Invoke-Plaster @plasterParams -Force

			It 'Creates destination' {
				$plasterParams.DestinationPath | Should -Exist
			}

			It 'Creates module file' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'source' -ChildPath "$($plasterParams.Name).psm1") | Should -Exist
			}

			It 'Creates basic module manifest file' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'source' -ChildPath "$($plasterParams.Name).psd1") | Should -Exist
			}

			It 'Creates source directory' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath 'source' | Should -Exist
			}

			It 'Creates Private directory' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'source' -ChildPath 'Private') | Should -Exist
			}

			It 'Creates Public directory' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'source' -ChildPath 'Public') | Should -Exist
			}

			It 'Creates Classes directory' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'source' -ChildPath 'Classes') | Should -Exist
			}

			It 'Creates finishing script file' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath 'Invoke-CompleteModuleSetup.ps1' | Should -Exist
			}
		}

		Context "Invoke-Plaster -Path $($templateDir.Name) with complex params" {

			$plasterParams = @{
				Author = "Testy McTester"
				AuthorEmail = "test@mctester.test"
				BuildAutomation = 'psake'
				CreateRepo = 'True'
				DependencyFramework = 'PSDepend'
				Description = 'Test'
				DestinationPath = (Join-Path -Path 'TestDrive:' -ChildPath $templateDir.Name)
				Editor = 'VSCode'
				FunctionFolders = 'Public' , 'Private'
				GitVersion = 'True'
				LicenseUri = 'https://test.mctester.test/license'
				Name = 'TestProject'
				ProjectUri = 'https://test.mctester.test'
				TemplatePath = $templateDir.FullName
				TestFramework = 'Pester'
				Version = '1.0.0'
			}

			Invoke-Plaster @plasterParams -Force

			It 'Creates destination' {
				$plasterParams.DestinationPath | Should -Exist
			}

			It 'Creates module file' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'source' -ChildPath "$($plasterParams.Name).psm1") | Should -Exist
			}

			It 'Creates module definition data file' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'source' -ChildPath "$($plasterParams.Name).definition.psd1") | Should -Exist
			}

			It 'Creates build directory' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath 'build' | Should -Exist
			}

			It 'Creates psake file' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'build' -ChildPath "tasks.ps1") | Should -Exist
			}

			It 'psake file is valid PowerShell' {
				$here = Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'build' -ChildPath "tasks.ps1")
				$sut = Get-Content -Path $here -ErrorAction Stop
				$errors = $null
				$null = [System.Management.Automation.PSParser]::Tokenize($sut, [ref]$errors)
				$errors.Count | Should -Be 0
			}

			It 'Creates psake dependency file' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'build' -ChildPath "tasks.depend.psd1") | Should -Exist
			}

			It 'psake dependency file is valid PowerShell' {
				$here = Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'build' -ChildPath "tasks.depend.psd1")
				$sut = Get-Content -Path $here -ErrorAction Stop
				$errors = $null
				$null = [System.Management.Automation.PSParser]::Tokenize($sut, [ref]$errors)
				$errors.Count | Should -Be 0
			}

			It 'Creates build functions' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'build' -ChildPath 'build-functions.ps1') | Should -Exist
			}

			It 'Build functions are valid PowerShell' {
				$here = Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'build' -ChildPath 'build-functions.ps1')
				$sut = Get-Content -Path $here -ErrorAction Stop
				$errors = $null
				$null = [System.Management.Automation.PSParser]::Tokenize($sut, [ref]$errors)
				$errors.Count | Should -Be 0
			}

			It 'Creates version functions' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'build' -ChildPath 'version-functions.ps1') | Should -Exist
			}

			It 'Version functions are valid PowerShell' {
				$here = Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'build' -ChildPath 'version-functions.ps1')
				$sut = Get-Content -Path $here -ErrorAction Stop
				$errors = $null
				$null = [System.Management.Automation.PSParser]::Tokenize($sut, [ref]$errors)
				$errors.Count | Should -Be 0
			}

			It 'Creates GitVersion configuration' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath 'GitVersion.yml' | Should -Exist
			}

			It 'Creates tests' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'tests' -ChildPath "$($plasterParams.Name).Tests.ps1") | Should -Exist
			}

			It 'Creates VSCode directory' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath '.vscode' | Should -Exist
			}

			It 'Creates source directory' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath 'source' | Should -Exist
			}

			It 'Creates Private directory' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'source' -ChildPath 'Private') | Should -Exist
			}

			It 'Creates Public directory' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath (Join-Path -Path 'source' -ChildPath 'Public') | Should -Exist
			}

			It 'Creates finishing script file' {
				Join-Path -Path $plasterParams.DestinationPath -ChildPath 'Invoke-CompleteModuleSetup.ps1' | Should -Exist
			}

			It 'Finishing script creates git repo' {
				$sut = Join-Path -Path $plasterParams.DestinationPath -ChildPath 'Invoke-CompleteModuleSetup.ps1'
				$sut | Should -FileContentMatch 'git init'
			}
		}
	}
}