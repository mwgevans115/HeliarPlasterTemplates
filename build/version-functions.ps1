function EnsureGitVersion {

	try {

		Write-Debug "Checking for Gitversion install..."
		$ver = Exec { return gitversion -version }
		Write-Debug "Gitversion $ver installed"

	} catch {

		Write-Debug "Gitversion not installed, installing..."

		if ($IsLinux) {

			Exec { sudo apt-get install gitversion }

		} elseif ($IsMacOS) {

			Exec { brew install gitversion }

		} elseif ($IsWindows) {

			Exec { choco install gitversion.portable -y }

		}
	}
}

function GetVersionInfo {

	EnsureGitVersion
	$ver = Exec { return gitversion } | ConvertFrom-Json -AsHashtable
	return $ver

}