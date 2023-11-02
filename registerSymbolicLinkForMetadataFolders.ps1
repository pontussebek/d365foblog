<#
   This script will create a symbolic link for each model folder in the Metadata folder in the AOSService\PackagesLocalDirectory which allows Visual studio to 
   find the model files and the AOS to access the binaries when the model has been built. 
#>
# Check if the script is running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch the script with elevated permissions
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`"" -Verb RunAs
    Exit
}

if (Test-Path -Path K:\AosService\PackagesLocalDirectory)
{
   $AOSMetadataPath = "K:\AosService\PackagesLocalDirectory"
}
elseif (Test-Path -Path C:\AosService\PackagesLocalDirectory)
{
   $AOSMetadataPath = "C:\AosService\PackagesLocalDirectory"
}
elseif (Test-Path -Path E:\AosService\PackagesLocalDirectory)
{
   $AOSMetadataPath = "E:\AosService\PackagesLocalDirectory"
}
elseif (Test-Path -Path J:\AosService\PackagesLocalDirectory)
{
   $AOSMetadataPath = "J:\AosService\PackagesLocalDirectory"
}
else
{
  throw "Cannot find the AOSService folder in any known location"
}

$RepoPath = Split-Path $MyInvocation.MyCommand.Path
$RepoMetadataPath = $RepoPath + "\Metadata"
$RepoModelFolders = Get-ChildItem $RepoMetadataPath -Directory
foreach ($ModelFolder in $RepoModelFolders)
{
	$Target = "$RepoMetadataPath\$ModelFolder"
	New-Item -ItemType SymbolicLink -Path "$AOSMetadataPath" -Name "$ModelFolder" -Value "$Target"
}
