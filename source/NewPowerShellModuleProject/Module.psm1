# Implement your module commands in this script.

# Invoke any startup scripts
if (Test-Path -Path "$PSScriptRoot\Startup" -ErrorAction Ignore)
{
    Get-ChildItem "$PSScriptRoot\Startup" -ErrorAction Stop | ForEach-Object {
        . $_.FullName
    }
}

# Import modules and any other setup or steps here