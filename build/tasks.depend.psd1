@{
	PSDependOptions      = @{
		Target     = 'CurrentUser'
		Parameters = @{
			Repository         = 'PSGallery'
			SkipPublisherCheck = $true
		}
	}
	BuildHelpers = 'latest'
	Pester = 'latest'
	Plaster = 'latest'
}