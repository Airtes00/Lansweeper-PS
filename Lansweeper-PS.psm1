<#Invoke-DbaQuery function is created by the dbatools team and is provided under the MIT license.

        Author: Friedrich Weinmann (@FredWeinmann)

        Website: https://dbatools.io
        Copyright: (c) 2018 by dbatools, licensed under MIT
        License: MIT https://opensource.org/licenses/MIT

        Link: https://dbatools.io/Invoke-DbaQuery
#>
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
            }
       }
}

function Get-LSComputerObject
{
<#
.Description
Queries the tables listed below to generate an object that completely represents a computer on the network.
-SQLInstance parameter is used to specify the SQL server where the database exists.

lansweeperdb.dbo.tblAssetCustom, lansweeperdb.dbo.tblScanHistory, lansweeperdb.dbo.tblComputerSystem, lansweeperdb.dbo.tblCPlogoninfo, lansweeperdb.dbo.tblNetwork,
 lansweeperdb.dbo.tblNetworkAdapter, and lansweeperdb.dbo.tblProxy.
#>
    [CmdletBinding()]

    #This function requires that the input be an AssetName in order to locate the computer across multiple tables. 
    #AssetID is used as a universal identifier across tables, even those that do not track AssetName.
    param
        (
        [parameter(Mandatory=$true) ]$AssetName,
        [parameter(Mandatory=$true) ]$SQLInstance,
        [parameter(Mandatory=$false)]$Credentials
        )
        
        #The Assets table is loaded first in order to locate the AssetID for the given AssetName to effectively locate the asset across tables.
        $AssetsTable_Properties = Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblAssets WHERE AssetName = @Variable" -SqlParameters @{Variable = $AssetName} -SQLCredential $Credentials -SqlInstance $SQLInstance}

        #AssetID is assigned for use in the rest of the queries.
        $AssetID = $AssetsTable_Properties.AssetID
        
        #Tables are queried by AssetID to locate all relevant properties of the asset.
        $AssetCustomTable_Properties = Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblAssetCustom WHERE AssetID = @Variable" -SqlParameters @{Variable = $AssetID} -SQLCredential $Credentials -SqlInstance $SQLInstance}
        $ScanHistoryTable_Properties = Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblScanHistory WHERE AssetID = @Variable" -SqlParameters @{Variable = $AssetID} -SQLCredential $Credentials -SqlInstance $SQLInstance}
        $ComputerSystemTable_Properties = Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblComputerSystem WHERE AssetID = @Variable" -SqlParameters @{Variable = $AssetID} -SQLCredential $Credentials -SqlInstance $SQLInstance}
        $CPLogonInfoTable_Properties = Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblCPlogoninfo WHERE AssetID = @Variable" -SqlParameters @{Variable = $AssetID} -SQLCredential $Credentials -SqlInstance $SQLInstance}
        $NetworkTable_Properties = Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblNetwork WHERE AssetID = @Variable" -SqlParameters @{Variable = $AssetID} -SQLCredential $Credentials -SqlInstance $SQLInstance}
        $NetworkAdapterTable_Properties = Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblNetworkAdapter WHERE AssetID = @Variable" -SqlParameters @{Variable = $AssetID} -SQLCredential $Credentials -SqlInstance $SQLInstance}
        $ProxyTable_Properties = Invoke-Command -ScriptBlock {Invoke-DbaQuery -Query "SELECT * FROM lansweeperdb.dbo.tblProxy WHERE AssetID = @Variable" -SqlParameters @{Variable = $AssetID} -SQLCredential $Credentials -SqlInstance $SQLInstance}
        
        $WholeComputerObject = $AssetsTable_Properties
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "PurchaseDate" -Value ($AssetCustomTable_Properties).PurchaseDate
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "WarrantyDate" -Value ($AssetCustomTable_Properties).WarrantyDate
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "LastPatched" -Value ($AssetCustomTable_Properties).LastPatched
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "LastFullBackup" -Value ($AssetCustomTable_Properties).LastFullBackup
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "LastFullImage" -Value ($AssetCustomTable_Properties).LastFullImage
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "Location" -Value ($AssetCustomTable_Properties).Location
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "Model" -Value ($AssetCustomTable_Properties).Model
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "SerialNumber" -Value ($AssetCustomTable_Properties).SerialNumber
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "DNSName" -Value ($AssetCustomTable_Properties).DNSName

        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "ScanTime" -Value ($ScanHistoryTable_Properties).ScanTime

        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "CurrentTimeZone" -Value ($ComputerSystemTable_Properties).CurrentTimeZone
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "DayLightInEffect" -Value ($ComputerSystemTable_Properties).DaylightInEffect
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "NumberOfLogicalProcessors" -Value ($ComputerSystemTable_Properties).NumberOfLogicalProcessors
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "NumberOfProcessors" -Value ($ComputerSystemTable_Properties).NumberOfProcessors
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "PartOfDomain" -Value ($ComputerSystemTable_Properties).PartOfDomain
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "PowerOnPasswordStatus" -Value ($ComputerSystemTable_Properties).PowerOnPasswordStatus
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "Roles" -Value ($ComputerSystemTable_Properties).Roles
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "SystemType" -Value ($ComputerSystemTable_Properties).SystemType
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "TermalState" -Value ($ComputerSystemTable_Properties).ThermalState
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "TotalPhysicalMemory" -Value ($ComputerSystemTable_Properties).TotalPhysicalMemory

        #The below properties (Last logon time, userdomain, and user) are represented as arrays in the SQL database. 
        #The first value in the array is the most recent addition and is assigned as the property.
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "LastLogonTime" -Value ($CPLogonInfoTable_Properties).logontime[0]
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "LastUserLogonDomain" -Value ($CPLogonInfoTable_Properties).Domain[0]
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "LastLogon" -Value ($CPLogonInfoTable_Properties).Username[0]

        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "DefaultIPGateway" -Value ($NetworkTable_Properties).DefaultIPGateway
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "NetworkConfigDescription" -Value ($NetworkTable_Properties).Description
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "DHCPEnabled" -Value ($NetworkTable_Properties).DHCPEnabled
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "DHCPServer" -Value ($NetworkTable_Properties).DHCPServer
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "DNSDomain" -Value ($NetworkTable_Properties).DNSDomain
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "IPSubnet" -Value ($NetworkTable_Properties).IPSubnet

        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "NICManufacturer" -Value ($NetworkAdapterTable_Properties).Manufacturer
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "NICName" -Value ($NetworkAdapterTable_Properties).Name #But his nickname is Steve

        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "ProxyServer" -Value ($ProxyTable_Properties).ProxyServer
        $WholeComputerObject | Add-Member -MemberType NoteProperty -Name "ProxyPortNumber" -Value ($ProxyTable_Properties).ProxyPortNumber

        #The compiled object is returned with all relevant properties.
        $WholeComputerObject
      
}

Export-ModuleMember -Function "Get-*"
