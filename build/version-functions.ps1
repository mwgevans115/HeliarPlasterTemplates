function EnsureGitVersion {

	try {

		Write-Debug "Checking for Gitversion install..."
		$ver = Exec { return gitversion -version }
		Write-Debug "Gitversion $ver installed"

	} catch {

		Write-Debug "Gitversion not installed, installing..."

		if ($IsLinux) {

			Exec {
				Write-Host 'Downloading GitVersion...'
				wget 'https://github.com/GitTools/GitVersion/releases/download/5.1.3/gitversion-linux-5.1.3.tar.gz'
				Write-Host 'Unzipping GitVersion...'
				unzip 'gitversion-linux-5.1.3.tar.gz' GitVersion
				Write-Host 'Creating symlink...'
				cd GitVersion
				ln -S "$pwd/gitversion" /usr/local/bin/gitversionß
			}

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