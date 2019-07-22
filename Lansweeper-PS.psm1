if (Get-Module -ListAvailable -Name dbatools) {
    import-module dbatools
} 
else {
    write-host "The module dbatools is not installed, but it is required to function. Please follow the prompts to install dbatools."
    install-module dbatools
    import-module dbatools
}

function EncryptableVolumeStatus($AssetObject, $AssetID)
{
    $MyHash = [ordered]@{}
    $DiskArray = Invoke-Command {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblEncryptableVolume WHERE AssetID = @Variable" -SqlParameters @{Variable = $AssetID} -SqlInstance "SVR3-SQL"}

    foreach($Disk in $DiskArray)
    {
        $MyHash[$Disk.DriveLetter] = $Disk.ProtectionStatus
    }

    if ($MyHash["C:"] -eq 0) {$AssetObject | Add-Member -MemberType NoteProperty -Name "OSDriveEncryptionStatus" -Value $false -Force}
    elseif ($MyHash["C:"] -eq 1) {$AssetObject | Add-Member -MemberType NoteProperty -Name "OSDriveEncryptionStatus" -Value $true -Force}
    else {$AssetObject | Add-Member -MemberType NoteProperty -Name "OSDriveEncryptionStatus" -Value "Unknown"}

    $AssetObject | Add-Member -MemberType NoteProperty -Name "EncryptableDisks" -Value $MyHash -Force
}

function Get-LSAsset
{
<#
.Description
Get-Asset queries lansweeperdb.dbo.tblAssets for asset(s) matching the passed parameters. Object is returned with parameters for each column in SQL database.
-SQLInstance parameter is used to specify the SQL server where the database exists.
#>

    #Parameters are defined to search for matching objects.
    [CmdletBinding()]
    param
        (
        [parameter(Mandatory=$false)]$AssetID,
        [parameter(Mandatory=$false)]$AssetName,
        [parameter(Mandatory=$false)]$Credentials,
        [parameter(Mandatory=$false)]$IPAddress,
        [parameter(Mandatory=$false)]$LastChanged,
        [parameter(Mandatory=$false)]$Lastseen,
        [parameter(Mandatory=$false)]$LastTried,
        [parameter(Mandatory=$false)]$LastTriggered,
        [parameter(Mandatory=$false)]$LastActiveScan,
        [parameter(Mandatory=$false)]$LastScheduled,
        [parameter(Mandatory=$false)]$LastSaved,
        [parameter(Mandatory=$false)]$MAC,
        [parameter(Mandatory=$false)]$Memory,
        [parameter(Mandatory=$false)]$OSCode,
        [parameter(Mandatory=$false)]$Processor,
        [parameter(Mandatory=$true)] $SQLInstance,
        [parameter(Mandatory=$false)]$Scanserver,
        [parameter(Mandatory=$false)]$SP,
        [parameter(Mandatory=$false)]$Username,
        [parameter(Mandatory=$false)]$Userdomain    
        )

        #Build a query based on assigned parameters that are not SQLInstance or Credentials.
        foreach ($Parameter in $PSBoundParameters.keys) 
       {
            if ($Parameter -NotLike "SQLInstance" -And $Parameter -NotLike "Credentials")
            {
             $ComputerObject = $PSBoundParameters.item($Parameter)
             Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblAssets WHERE $Parameter = @Variable" -SqlParameters @{Variable = $ComputerObject} -SQLCredential $Credentials -SqlInstance $SQLInstance}
             break #Allows only one parameter to be run without creating literally dozens of parameter sets
            }
       }
}

function Get-LSAssetCustom
{
<#
.Description
Get-AssetCustom queries lansweeperdb.dbo.tblAssetCustom for asset(s) matching the passed parameters. Object is returned with parameters for each column in SQL database.
-SQLInstance parameter is used to specify the SQL server where the database exists.
#>
    [CmdletBinding()]
    param
        (
        [parameter(Mandatory=$false)]$AssetID,
        [parameter(Mandatory=$false)]$BranchOffice,
        [parameter(Mandatory=$false)]$Contact,
        [parameter(Mandatory=$false)]$CustID,
        [parameter(Mandatory=$false)]$DNSName,
        [parameter(Mandatory=$false)]$Department,
        [parameter(Mandatory=$false)]$DeviceVersion,
        [parameter(Mandatory=$false)]$FirmwareVersion,
        [parameter(Mandatory=$false)]$HardwareVersion,
        [parameter(Mandatory=$false)]$HTTPServer,
        [parameter(Mandatory=$false)]$HTTPSServer,
        [parameter(Mandatory=$false)]$SNMPOID,
        [parameter(Mandatory=$false)]$SMTPHeader,
        [parameter(Mandatory=$false)]$FTPHeader,
        [parameter(Mandatory=$false)]$LastChanged,
        [parameter(Mandatory=$false)]$Location,
        [parameter(Mandatory=$false)]$LastPatched,
        [parameter(Mandatory=$false)]$LastFullBackup,
        [parameter(Mandatory=$false)]$LastFullImage,
        [parameter(Mandatory=$false)]$Manufacturer,
        [parameter(Mandatory=$false)]$Model,
        [parameter(Mandatory=$false)]$Serialnumber,
        [parameter(Mandatory=$true) ]$SQLInstance,
        [parameter(Mandatory=$false)]$SystemSKU,
        [parameter(Mandatory=$false)]$Warrantydate,
        [parameter(Mandatory=$false)]$Custom1,
        [parameter(Mandatory=$false)]$Custom2,
        [parameter(Mandatory=$false)]$Custom3,
        [parameter(Mandatory=$false)]$Custom4,
        [parameter(Mandatory=$false)]$Custom5,
        [parameter(Mandatory=$false)]$Custom6,
        [parameter(Mandatory=$false)]$Custom7,
        [parameter(Mandatory=$false)]$Custom8,
        [parameter(Mandatory=$false)]$Custom9,
        [parameter(Mandatory=$false)]$Custom10,
        [parameter(Mandatory=$false)]$Custom11,
        [parameter(Mandatory=$false)]$Custom12,
        [parameter(Mandatory=$false)]$Custom13,
        [parameter(Mandatory=$false)]$Custom14,
        [parameter(Mandatory=$false)]$Custom15,
        [parameter(Mandatory=$false)]$Custom16,
        [parameter(Mandatory=$false)]$Custom17,
        [parameter(Mandatory=$false)]$Custom18,
        [parameter(Mandatory=$false)]$Custom19,
        [parameter(Mandatory=$false)]$Custom20

        )

         foreach ($Parameter in $PSBoundParameters.keys) 
       {
            if ($Parameter -NotLike "SQLInstance" -And $Parameter -NotLike "Credentials")
            {
             $ComputerObject = $PSBoundParameters.item($Parameter)
             Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblAssetCustom WHERE $Parameter = @Variable" -SqlParameters @{Variable = $ComputerObject} -SQLCredential $Credentials -SqlInstance $SQLInstance}
             break
            }
       }

}

function Get-LSADComputer
{
<#
.Description
Get-LSADComputer queries lansweeperdb.dbo.tblADComputer for asset(s) matching the passed parameters. Object is returned with parameters for each column in SQL database.
-SQLInstance parameter is used to specify the SQL server where the database exists.
#>
    [CmdletBinding()]
    param
        (
        [parameter(Mandatory=$false)]$AdcomputerID,
        [parameter(Mandatory=$false)]$AssetID,
        [parameter(Mandatory=$false)]$Comment,
        [parameter(Mandatory=$false)]$Company,
        [parameter(Mandatory=$false)]$Description,
        [parameter(Mandatory=$false)]$Location,
        [parameter(Mandatory=$false)]$OU,
        [parameter(Mandatory=$false)]$Lastchanged,
        [parameter(Mandatory=$false)]$LastScheduled,
        [parameter(Mandatory=$false)]$LastSaved,
        [parameter(Mandatory=$false)]$MAC,
        [parameter(Mandatory=$false)]$Memory,
        [parameter(Mandatory=$false)]$OSCode,
        [parameter(Mandatory=$false)]$Processor,
        [parameter(Mandatory=$true)] $SQLInstance,
        [parameter(Mandatory=$false)]$Scanserver,
        [parameter(Mandatory=$false)]$SP,
        [parameter(Mandatory=$false)]$Username,
        [parameter(Mandatory=$false)]$Userdomain    
        )

        foreach ($Parameter in $PSBoundParameters.keys) 
       {
            if ($Parameter -NotLike "SQLInstance" -And $Parameter -NotLike "Credentials")
            {
             $ComputerObject = $PSBoundParameters.item($Parameter)
             Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblADComputers WHERE $Parameter = @Variable" -SqlParameters @{Variable = $ComputerObject} -SQLCredential $Credentials -SqlInstance $SQLInstance}
             break
            }
       }
}

function Get-LSUser
{
<#
.Description
Get-LSUser queries lansweeperdb.dbo.tblUsers for asset(s) matching the passed parameters. Object is returned with parameters for each column in SQL database.
-SQLInstance parameter is used to specify the SQL server where the database exists.
#>

    [CmdletBinding()]
    param
        (
        [parameter(Mandatory=$false)]$AssetID,
        [parameter(Mandatory=$false)]$Accounttype,
        [parameter(Mandatory=$false)]$BuiltInAdmin,
        [parameter(Mandatory=$false)]$Disabled,
        [parameter(Mandatory=$false)]$Description,
        [parameter(Mandatory=$false)]$Fullname,
        [parameter(Mandatory=$false)]$Lockout,
        [parameter(Mandatory=$false)]$Name,
        [parameter(Mandatory=$false)]$PasswordChangeable,
        [parameter(Mandatory=$false)]$PasswordExpires,
        [parameter(Mandatory=$false)]$PasswordRequired,
        [parameter(Mandatory=$false)]$SID,
        [parameter(Mandatory=$false)]$Status,
        [parameter(Mandatory=$false)]$UserID,
        [parameter(Mandatory=$false)]$LastChanged,
        [parameter(Mandatory=$true) ]$SQLInstance,
        [parameter(Mandatory=$false)]$Credentials
        )

        foreach ($Parameter in $PSBoundParameters.keys) 
       {
            if ($Parameter -NotLike "SQLInstance" -And $Parameter -NotLike "Credentials")
            {
             $ComputerObject = $PSBoundParameters.item($Parameter)
             Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblUsers WHERE $Parameter = @Variable" -SqlParameters @{Variable = $ComputerObject} -SQLCredential $Credentials -SqlInstance $SQLInstance}
             break
            }
       }
}

function Get-LSComputerObject
{

    [CmdletBinding()]

    #This function requires that the input be an AssetName in order to locate the computer across multiple tables. 
    #AssetID is used as a universal identifier across tables, even those that do not track AssetName.
    param
        (
        [parameter(Mandatory=$false) ]$AssetID,
        [parameter(Mandatory=$false) ]$AssetName,
        [parameter(Mandatory=$true) ]$SQLInstance,
        [parameter(Mandatory=$false)]$Credentials
        )

        #Creates the empty hashtable where we will later store the status of encryptable volumes on our search result
        $MyHash = [ordered]@{}

        foreach ($Parameter in $PSBoundParameters.keys) 
       {
            if ($Parameter -NotLike "SQLInstance" -And $Parameter -NotLike "Credentials" -And $Parameter -Like "AssetName")
            {
                $AssetsTable = Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblAssets WHERE AssetName = @Variable" -SqlParameters @{Variable = $AssetName} -SQLCredential $Credentials -SqlInstance $SQLInstance}

                #MyAssetID is assigned for use in the rest of the queries.
                $MyAssetID = $AssetsTable.AssetID
                $WholeComputerObject = Invoke-Command -ScriptBlock {Invoke-DbaQuery -File $PSScriptRoot\LSComputerObjectQuery.txt -SqlParameters @{AssetID = $MyAssetID} -SQLCredential $Credentials -SqlInstance $SQLInstance}

                #Using our new AssetID to query the EncryptableVolumes table and add the results to the DiskTable hashtable
                EncryptableVolumeStatus $WholeComputerObject $MyAssetID
                $WholeComputerObject
                break
            }

            elseif ($Parameter -NotLike "SQLInstance" -And $Parameter -NotLike "Credentials" -And $Parameter -Like "AssetID")
            {
            $WholeComputerObject = Invoke-Command -ScriptBlock {Invoke-DbaQuery -File $PSScriptRoot\LSComputerObjectQuery.txt -SqlParameters @{AssetID = $AssetID} -SQLCredential $Credentials -SqlInstance $SQLInstance}
            EncryptableVolumeStatus $WholeComputerObject $WholeComputerObject.AssetID
            $WholeComputerObject
            break
            }
       }

      
}

function Get-LSLinuxSystem
{
        [CmdletBinding()]
    param
        (
        [parameter(Mandatory=$false)]$AssetID,
        [parameter(Mandatory=$false)]$Manufacturer,
        [parameter(Mandatory=$false)]$ProductName,
        [parameter(Mandatory=$false)]$Serial,
        [parameter(Mandatory=$false)]$UUID,
        [parameter(Mandatory=$false)]$NetworkNodtHostName,
        [parameter(Mandatory=$false)]$KernelName,
        [parameter(Mandatory=$false)]$KernelRelease,
        [parameter(Mandatory=$false)]$KernelVersion,
        [parameter(Mandatory=$false)]$MachineHardwareName,
        [parameter(Mandatory=$false)]$HardwarePlatform,
        [parameter(Mandatory=$false)]$OperatingSystem,
        [parameter(Mandatory=$false)]$OSRelease,
        [parameter(Mandatory=$false)]$SystemSku,
        [parameter(Mandatory=$true) ]$SQLInstance,
        [parameter(Mandatory=$false)]$Credentials
        )

        foreach ($Parameter in $PSBoundParameters.keys) 
       {
            if ($Parameter -NotLike "SQLInstance" -And $Parameter -NotLike "Credentials")
            {
             $ComputerObject = $PSBoundParameters.item($Parameter)
             Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblLinuxSystem WHERE $Parameter = @Variable" -SqlParameters @{Variable = $ComputerObject} -SQLCredential $Credentials -SqlInstance $SQLInstance}
             break
            }
       }
}

function Get-LSDisks
{
        [CmdletBinding()]
    param
        (
        [parameter(Mandatory=$false)]$AssetID,
        [parameter(Mandatory=$false)]$DriveType,
        [parameter(Mandatory=$false)]$Filesystem,
        [parameter(Mandatory=$false)]$VolumeName,
        [parameter(Mandatory=$false)]$VolumeSerialNumber,
        [parameter(Mandatory=$true) ]$SQLInstance,
        [parameter(Mandatory=$false)]$Credentials

        )

        foreach ($Parameter in $PSBoundParameters.keys) 
       {
            if ($Parameter -NotLike "SQLInstance" -And $Parameter -NotLike "Credentials")
            {
             $ComputerObject = $PSBoundParameters.item($Parameter)
             Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblDiskDrives WHERE $Parameter = @Variable" -SqlParameters @{Variable = $ComputerObject} -SQLCredential $Credentials -SqlInstance $SQLInstance}
             break
            }
       }
}

function Get-LSLinuxVolumes
{
        [CmdletBinding()]
    param
        (
        [parameter(Mandatory=$false)]$AssetID,
        [parameter(Mandatory=$false)]$Type,
        [parameter(Mandatory=$true) ]$SQLInstance,
        [parameter(Mandatory=$false)]$Credentials

        )

        foreach ($Parameter in $PSBoundParameters.keys) 
       {
            if ($Parameter -NotLike "SQLInstance" -And $Parameter -NotLike "Credentials")
            {
             $ComputerObject = $PSBoundParameters.item($Parameter)
             Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblLinuxVolumes WHERE $Parameter = @Variable" -SqlParameters @{Variable = $ComputerObject} -SQLCredential $Credentials -SqlInstance $SQLInstance}
             break
            }
       }
}

Export-ModuleMember -Function "Get-*"
