#This script file is not intended to be run and exists solely to pull code snippets from for the readme.md file
Import-Module Lansweeper-PS

#Pulls all information about a computer that is held in the Assets table based on the computer name
#-Credentials parameter is added in this case to demonstrate its use case, but is not mandatory if the current user has proper permissions
$Creds = Get-Credential
$var = Get-LSAsset -AssetName "Class-SVR1" -SQLInstance "SVR3-SQL" -Credentials $Creds

#Displays all information about local user accounts that have been pulled from assets and stored in Users table
$Creds = Get-Credential
Get-LSUser -Name "Marcus" -SQLInstance "SVR3-SQL" -Credentials $Creds

#Displays all information about physical disks in a Windows system from the DiskDrives table.

$Server = "SVR3-SQL"
$MyID = (Get-LSAsset -AssetName "Class-SVR1" -SQLInstance $Server).AssetID
Get-LSDisks -AssetID $MyID -SQLInstance $Server 

#Displays all information about physical disks in a Linux system from the DiskDrives table.
$Server = "SVR3-SQL"
$MyID = (Get-LSAsset -AssetName "Class-SVR1" -SQLInstance $Server).AssetID
Get-LSLinuxVolumes -AssetID $MyID -SQLInstance $Server

Get-LSComputerObject -AssetName "Class-SVR1" -SQLInstance "SVR3-SQL"