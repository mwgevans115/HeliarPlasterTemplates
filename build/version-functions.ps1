function EnsureGitVersion {

	try {

		Write-Debug "Checking for Gitversion install..."
		$ver = Exec { return gitversion -version }
		Write-Debug "Gitversion $ver installed"

	} catch {

		Write-Debug "Gitversion not installed, installing..."

		$platform = $PSVersionTable.Platform
		if ($platform -eq 'Unix') {

			Exec { brew install gitversion }

		} elseif ($platform -like 'Win*') {

			Exec { choco install gitversion.portable -y }

		}
	}
}

function GetVersionInfo {

	EnsureGitVersion
	$ver = Exec { return gitversion } | ConvertFrom-Json -AsHashtable
	return $ver

}