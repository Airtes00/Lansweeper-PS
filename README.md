# Lansweeper-PS
Provides functionality to load asset information in Powershell from the Lansweeper database.

SQL queries are accomplished using dbatools to interact with the SQL server. (Specifically Invoke-dbaquery)
https://github.com/sqlcollaborative/dbatools

[Check out my LinkedIn!](https://www.linkedin.com/in/marcus-dean/)

# Install + Update
Lansweeper-PS is published on the PSGallery (current version 1.30) and can be installed with **Install-Module Lansweeper-PS**
https://www.powershellgallery.com/packages/Lansweeper-PS/

Module will be updated periodically for features and improvements. 

```Powershell
Install-Module Lansweeper-PS
```

# Index

[Usage](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#usage)

**Examples**

[Get-LSAsset](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#example-1)

[Get-LSComputerObject](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#example-2)

[Get-LSAssetCustom + Get-LSComputerObject](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#example-3)

[Get-LSDisks + Get-LSLinuxVolumes](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#example-4)

**Automation**

[Adding Serials or Other Attributes to Active Directory](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#add-computer-serial-numbers-or-any-attributes-to-active-directory)

[Remotely Enable BDE](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#remotely-enable-bitlocker)

[Perform a Disk Cleanup](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#perform-a-disk-cleanup-at-90-disk-usage)

[Schedule a Restart Based on Uptime](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#schedule-a-restart-at-30-days-uptime)

[Disable Local Guest/Admin Accounts](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#disable-local-guest-or-administrator-accounts)

[Parameters](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#Function-Parameters)

[Tables Queried](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#tables-queried)

[Notes](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#A-Note)

[Requirements](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#Requirements)

[To Do](https://github.com/marcus-dean/Lansweeper-PS/blob/master/README.md#to-do)

# Usage
**Note: An explanation of the different tables queried is at the bottom of this readme.**
#### SQLInstance is a mandatory parameter for each cmdlet. This specifies the SQL server where your Lansweeper database is stored, and can be found in Lansweeper > Configuration > Database Tables

![DB](https://github.com/marcus-dean/Lansweeper-PS/blob/master/Examples/database.PNG "Database Location")

## Example 1

We can pass the **Get-LSAsset** cmdlet a computer name to learn everything about it from the Assets table.

*Even though we got the user's credentials and passed them to the cmdlet, this is not mandatory. It is shown here for demonstration purposes.*

```Powershell
$Creds = Get-Credential
$var = Get-LSAsset -AssetName "Class-SVR1" -SQLInstance "SVR3-SQL" -Credentials $Creds
```
![Example1](https://github.com/marcus-dean/Lansweeper-PS/blob/master/Examples/Get-LSAsset.PNG "Results of Get-LSAsset")

## Example 2

For a more complete look at our asset we use the **Get-LSComputerObject**. This cmdlet queries different tables that hold more pieces of information about a computer. This will take an AssetName or an AssetID as input.

```Powershell
Get-LSComputerObject -AssetName "Marcus-Laptop" -SQLInstance "SVR3-SQL"
```
![Example2](https://github.com/marcus-dean/Lansweeper-PS/blob/master/Examples/Get-LSComputerObject.PNG "Results of Get-LSCoputerObject")

## Example 3

But let's say that we only have a computer's serial number, and we want to know the FQDN. Let's use **Get-LSAssetCustom** to match an AssetID to the serial number, and then look up that AssetID in **Get-LSComputerObject**.

```Powershell
$MyID = (Get-LSAssetCustom -SerialNumber "C17QC073FVH3" -SQLInstance "SVR3-SQL").AssetID
Get-LSComputerObject -AssetID $MyID -SQLInstance "SVR3-SQL" | Select FQDN
```
![Example3](https://github.com/marcus-dean/Lansweeper-PS/blob/master/Examples/Get%20Computer%20Serial.PNG "Turning our computer serial into a FQDN")

## Example 4

We can also see the physical disks attached to a Windows system. **Get-LSDisks** queries the DiskDrives table to return information about all physical disks attached to an asset. This also needs an AssetID to run, which we will get in the same manner as above. 

*The **Get-LSLinuxVolumes** cmdlet works the same way, but for Linux assets by querying the LinuxVolumes table.*

```Powershell
$Server = "SVR3-SQL"
$MyID = (Get-LSAsset -AssetName "Class-SVR1" -SQLInstance $Server).AssetID
Get-LSDisks -AssetID $MyID -SQLInstance $Server 
```
![Example4](https://github.com/marcus-dean/Lansweeper-PS/blob/master/Examples/Get-LSDisks.PNG "Results of Get-LSDisks")

# Automation Examples

## Add Computer Serial Numbers (or any attributes) to Active Directory

Another useful place to keep computers' serials is in Active Directory. With the proper permissions to AD, we can add the serial to each object's serialNumber atrribute. 
To update attributes all you need is the attribute name and a value to assign it. The below example will add the machine's serial and MAC to its AD object, but this can be expanded on as long as you know the attribute you are trying to edit. [Set-ADComputer](https://docs.microsoft.com/en-us/powershell/module/addsadministration/set-adcomputer?view=win10-ps) accepts a hashtable to modify objects, in the form of @{attributeName=value}. [List of all AD attributes.](https://docs.microsoft.com/en-us/windows/win32/adschema/attributes-all)

```Powershell
$Assetlist = Get-Content .\computers.txt
$SQLServer = "YourSQLServer"
foreach ($Computer in $Assetlist){
    $AssetQuery = Get-LSComputerObject -AssetName $computer -SQLInstance $SQLServer
    $LSSerialNumber = $AssetQuery.DeviceSerial
    $LSMac = $AssetQuery.MAC
    Set-ADComputer -Identity $Computer -Add @{serialNumber=$LSSerialNumber, macAddress=$LSMac}
}
```
*Note: Because object properties with multiple values are stored as an array (such as multiple MACs on a server with multiple NICs), and the **Set-ADComputer** cmdlet accepts a hashtable as input, properties with multiple values **will** translate into attributes with multiple values.* [More about hashtables.](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-6)
![ADProperties](https://github.com/marcus-dean/Lansweeper-PS/blob/master/Examples/AD%20Properties%20Serial.PNG)

## Remotely Enable Bitlocker

Below is an example script to check Bitlocker on the C: drive of our assets. The unencrypted assets are exported to a file to be troubleshot or to have Bitlocker enabled remotely. 

```Powershell
# To get the list of our unsecure assets 
$list = Get-Content .\computers.csv
$SQLServer = "YourSQLServer"
foreach ($asset in $list){
    $Object = Get-LSComputerObject -AssetName $asset -SQLInstance $SQLServer
    if ($object.OSDriveEncryptionStatus -NotLike $True){$Object.FQDN | Out-File -Append "NoBDE.csv"}
 }
 
 # To remotely enable BDE
 $ToBeEncrypted = Get-Content .\NoBDE.csv
 foreach ($computer in $ToBeEncrypted){
    manage-bde -on C: -cn $computer -rp
    Restart-Computer -ComputerName $computer
 }
 ```
After this, a GPO or the manage-bde tool can be used to save the new recovery keys to Active Directory.

https://www.top-password.com/blog/tag/manually-backup-bitlocker-recovery-key-to-ad/

## Perform A Disk Cleanup At >90% Disk Usage

This scriptblock will import a list of computers and display the percentage of their fixed drives (drive type 3) that is in use.

```Powershell
$Assetlist = Get-Content .\computers.txt
$SQLServer = "YourSQLServer"
foreach ($asset in $Assetlist)
{
    $diskList = Get-LSDisks -AssetName $asset -SQLInstance $SQLServer
    foreach ($disk in $diskList)
        {
            if ($disk.DriveType -eq 3 -and ($disk.Freespace / $disk.Size) -gt 0.90){
                $usage = (($disk.Freespace / $disk.Size) * 100)
                $usage = [math]::Round($usage,2)
                Write-Host $asset $disk.Caption is at $usage% capacity
                Invoke-Command -ComputerName $asset -ScriptBlock{cleanmgr.exe /verylowdisk}
            }
        }
}
```

*Note: WinRM would have to be enabled on the device. A scheduled task can also be created with schtasks.exe as demonstrated below.*

## Schedule A Restart at >30 Days Uptime

**Get-LSAsset** provides an asset's uptime, and we use schtasks.exe to schedule a restart at 9:00pm. WinRM does not have to be enabled for this.

```Powershell
$Assetlist = Get-Content .\computers.txt
$SQLServer = "YourSQLServer"
foreach ($Computer in $Assetlist){
    $AssetUpTime = ((Get-LSAsset -AssetName $Computer -SQLInstance $SQLServer).UpTime) / 86400
    if ($AssetUpTime -gt 30){
        Write-Host $computer uptime is at $AssetUpTime days
        schtasks /Create /S $Computer /TN "Scheduled Restart" /TR "powershell.exe Restart-Computer" /SC once /ST 21:00
    }
}
```

## Disable Local Guest or Administrator Accounts

Using **Get-LSUser** to look at the local users on a machine (or list of machines), we can make sure we've disabled any Guest accounts on our Windows systems, built in admin accounts, or all local admin accounts. 

*Note: The property BuildInAdmin is not a typo.*

```Powershell
$Assetlist = Get-Content .\computers.txt
$SQLServer = "YourSQLServer"
foreach ($computer in $Assetlist)
{
    $userList = Get-LSUser -AssetName $computer -SQLInstance $SQLServer
    foreach ($account in $userList)
        {
            #For the if statement below, we can change from looking for admin accounts to Guest 
            #accounts by changing $account.BuildInAdmin -eq $True to $account.Name -eq "Guest".
            if ($account.BuildInAdmin -eq $True -and account.Disabled -eq $False{
                Write-Host "Administrator account is currently enabled on $computer. Disabling..."
                Invoke-Command -ComputerName $computer -ScriptBlock{Disable-LocalUser -Name "Administrator"} -Confirm
            }
        }
}
```

# Function Parameters

*Function parameters are based on the columns/data held in the specific table that they query. Most, but not all, of the columns have been made into parameters. Each function will accept 1 parameter besides Credentials and SQLInstance, this is purposeful to prevent returning many results as the result of a vague parameter. Functions can still return multiple results if the parameter entered (like Domain) would match with multiple assets.*

**Get-LSAsset**: AssetID, AssetName, Credentials, IPAddress, LastChanged, Lastseen, LastTried, LastTriggered, LastActiveScan, LastScheduled, LastSaved, MAC, Memory, OSCode, Processor, SQLInstance, Scanserver, SP, Username, Userdomain 

**Get-LSAssetCustom**: AssetID, BranchOffice, Contact, CustID, DNSName, Department DeviceVersion, FirmwareVersion, HardwareVersion, HTTPServer, HTTPSServer, SNMPOID, SMTPHeader, FTPHeader, LastChanged, Location, LastPatched, LastFullBackup, LastFullImage, Manufacturer, Model, Serialnumber, SQLInstance, SystemSKU, Warrantydate, Custom1-20

**Get-LSADComputer**: AdcomputerID, AssetID, Comment, Company, Description, Location, OU, Lastchanged, LastScheduled, LastSaved, MAC, Memory, OSCode, Processor, SQLInstance, Scanserver, SP, Username, Userdomain 

**Get-LSUser**: AssetID, Accounttype, BuiltInAdmin, Disabled, Description, Fullname, Lockout, Name, PasswordChangeable, PasswordExpires, PasswordRequired, SID, Status, UserID, LastChanged, SQLInstance, Credentials

**Get-LSLinuxSystem**: AssetID, Manufacturer, ProductName, Serial, UUID, NetworkNodtHostName, KernelName, KernelRelease, KernelVersion, MachineHardwareName, HardwarePlatform, OperatingSystem, OSRelease, SystemSku, SQLInstance, Credentials 

**Get-LSDisks**: AssetID, DriveType, Filesystem, VolumeName, VolumeSerialNumber, SQLInstance, Credentials 

**Get-LSLinuxVolumes**: AssetID, Type, SQLInstance, Credentials

**Get-LSWindowsSoftware**: AssetID, AssetName, SQLInstance, Credentials

**Get-LSMacSoftware**: AssetID, AssetName, SQLInstance, Credentials

**Get-LSComputerObject**: AssetID, AssetName, SQLInstance, Credentials 


# Tables Queried
#### More information about tables and their content can be found in Lansweeper's database documentation
| Function               | Table  Queried     | 
| -----------------------|:------------------:| 
| Get-LSAsset            | tblAssets          | 
| Get-LSAssetCustom      | tblAssetCustom     | 
| Get-LSADComputer       | tblADComputers     |
| Get-LSUser             | tblUsers           |
| Get-LSLinuxSystem      | tblLinuxSystem     |
| Get-LSDisks            | tblDiskDrives      |
| Get-LSLinuxVolumes     | tblLinuxVolumes    |
| Get-LSWindowsSoftware  | tblAssets, tblAssetCustom, tblSoftware, tblSoftwareUni, tsysOS |
| Get-LSMacSoftware      | tblAssets, tblAssetCustom, tlbMacApplications, tblSoftwareUni, tblMacOsInfo |
| Get-LSComputerObject   | tblAssets, tblAssetCustom, tblCPLogonInfo, tblNetwork, tblNetworkAdapter, tblEncryptableDisk, tblProxy     |


# A Note
This module is the result of much learning by myself, a student. As such, expect the modules to grow and mature over time after their initial release. I am excited to see if the open-source community latches onto this idea, and where other people might take it. On the flip side of this coin it is a work in progress and is subject to bugs/changes. For example, while the Get-LSComputerObject functions just fine, the object properties are returned in a not-so-neat order. This does not affect functionality, but could be more visually appealing.

# Requirements
This tool has a few dependencies/pre-requisites that need to be met in order to be used succesfully. These are:

-Currently, the module only works with Lansweeper installs that are built on top of a true SQL database. CompactSQL databases are not supported but are a future goal. 

-The account running the module has to have read access to Lansweeper's SQL database. This can be accomplished on the SQL server with SQL credentials, or using windows credentials (if mixed authentication is supported on your SQL server). Every cmdlet in this module does accept -Credentials, and dbatools supports connecting via SQL credentials or Windows Authentication. 

# To do
-Add support for CompactSQL databases

-~~Integrate DbaQuery function into this module in order to remove dbatools as a dependency~~

---While this module's only dependency is invoke-dbaquery, that command depends on quite a few things within the dbatools module including the SMO libraries for working with SQL. 

-Add more functions to handle a wider variety of assets, including cloud infrastructure and mobile devices.

-Beautify code
