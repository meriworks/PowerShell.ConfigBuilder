param([string] $solutionDir, [string] $projectDir, [string] $targetPath)
#trap {Write-Host -foreground red "Error occurred in AfterBuild.ps1: " $_.Exception.Message; exit 1; continue}
#Add powershell statements that should be executed after the build
. (Join-Path $projectDir "_msbuild/Meriworks.PowerShell.Sign/Functions.ps1")

Write-Host "Signing scripts"
SignScriptsInFolder (join-path $projectDir "nuspec/tools")
