@{
	GUID              = '<%=$PLASTER_Guid1%>'
	Author            = '<%=$PLASTER_PARAM_Author%>'
	CompanyName       = ''
	Copyright         = 'Copyright <%=$PLASTER_PARAM_Year%> <%=$PLASTER_PARAM_Author%>. All rights reserved.'
	Description       = '<%=$PLASTER_PARAM_Description%>'
	FileList          = @('<%=$PLASTER_PARAM_Name%>.ps1', '<%=$PLASTER_PARAM_Name%>.psd1')
	ModuleList        = @()
	NestedModules     = @()
	FunctionsToExport = @()
	CmdletsToExport   = @()
	VariablesToExport = @()
	AliasesToExport   = @()
	PrivateData = @{
		PSData = @{
			LicenseUri = '<%=$PLASTER_PARAM_LicenseUri%>'
			ProjectUri = '<%=$PLASTER_PARAM_ProjectUri%>'
			Tags	   = @()
			Extensions = @()
		}
	}
}