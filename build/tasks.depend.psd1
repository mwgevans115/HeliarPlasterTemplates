@{
	PSDependOptions      = @{
		Target     = 'CurrentUser'
		Parameters = @{
			Repository         = 'PSGallery'
			SkipPublisherCheck = $true
		}
	}
	BuildHelpers = 'latest'
	Pester = '4.10.1'
	Plaster = 'latest'
}