@{
	GUID              = '5982adbd-d701-4696-a23c-a1b2b0867c70'
	Author            = 'Robb L. Vandaveer'
	CompanyName       = 'Heliar Systems, LLC.'
	Copyright         = 'Copyright 2019 Robb L. Vandaveer. All rights reserved.'
	Description       = 'Provides Plaster templates for the quick creation of PowerShell items and projects'
	FileList          = @('HeliarPlasterTemplates.psm1', 'HeliarPlasterTemplates.psd1')
	ModuleList        = @()
	NestedModules     = @()
	FunctionsToExport = @()
	CmdletsToExport   = @()
	VariablesToExport = @()
	AliasesToExport   = @()
	PrivateData = @{
		PSData = @{
			LicenseUri = 'https://raw.githubusercontent.com/rlvandaveer/HeliarPlasterTemplates/master/LICENSE'
			ProjectUri = 'https://github.com/rlvandaveer/HeliarPlasterTemplates'
			Tags	   = @('powershell', 'plaster', 'templating', 'codegeneration', 'scaffold')
			Extensions = @(
				@{
					Module = 'Plaster'
					MinimumVersion = '1.1.3'
					Details = @{
						TemplatePaths = @('NewPowerShellModuleProject')
					}
				}
			)
		}
	}
}