param([string] $solutionDir, [string] $projectDir, [string] $targetPath)
#trap {Write-Host -foreground red "Error occurred in AfterBuild.ps1: " $_.Exception.Message; exit 1; continue}

Write-Host "Signing scripts"
SignScriptsInFolder (join-path $projectDir "nuspec/tools")
