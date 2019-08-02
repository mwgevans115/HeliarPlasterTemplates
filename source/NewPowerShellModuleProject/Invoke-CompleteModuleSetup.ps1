# This script can be executed to complete any remaining setup of your module project.

<%
if ($PLASTER_PARAM_CreateRepo -eq $true) {
"Write-Host 'Initializing git repo...'"
"git init"
"git config --local --add user.email $PLASTER_PARAM_AuthorEmail"
"Write-Host 'Repo initialized'"
"Write-Host 'Downloading Visual Studio gitignore from Github...'"
"Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore' -OutFile '.gitignore'"
"Write-Host 'Visual Studio .gitignore created'"
}
%>
Write-Host 'Removing completion script Invoke-CompletedModuleSetup.ps1...'

Remove-Item -Path Invoke-CompleteModuleSetup.ps1 -Force