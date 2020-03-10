Deploy HeliarPlasterTemplateDeployment {
	By PSGalleryModule {
		FromSource 'HeliarPlasterTemplates'
		To PSGallery
		WithOptions @{
			ApiKey = $ENV:PSGalleryApiKey
		}
	}
}