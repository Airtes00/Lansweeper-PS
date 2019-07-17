# Lansweeper-PS
Wrapper functions for dbatools to query user and asset information directly from the Lansweeper databases for automation purposes...without knowing SQL.
https://github.com/sqlcollaborative/dbatools

# Install
Lansweeper-PS is published on the PSGallery (current version 1.27.6) and can be installed with Install-Module Lansweeper-PS
https://www.powershellgallery.com/packages/Lansweeper-PS/
```Powershell
Install-Module Lansweeper-PS
```

# Usage
**Note: An explanation of the different tables queried is at the bottom of this readme.**
#### SQLInstance is a mandatory parameter for each cmdlet. This specifies the SQL server where your Lansweeper database is stored, and can be found in Lansweeper > Configuration > Database Tables

![DB](https://github.com/marcus-dean/Lansweeper-PS/blob/master/Examples/database.PNG "Database Location")

## Example 1

We can pass the **Get-LSAsset** cmdlet a computer name to learn everything about it from the Assets table.

*Even though we got the user's credentials and passed them to the cmdlet, this is not mandatory. It is shown here for demonstration purposes.*

We can also see the results of our query are now properties of our variable that we are free to reference whenever we want.
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

# Tables Queried
| Function               | Table  Queried     | 
| -----------------------|:------------------:| 
| Get-LSAsset            | tblAssets          | 
| Get-LSAssetCustom      | tblAssetCustom     | 
| Get-LSADComputer       | tblADComputers     |
| Get-LSUser             | tblUsers           |
| Get-LSADComputer       | tblADComputers     |
| Get-LSLinuxSystem      | tblLinuxSystem     |
| Get-LSDisks            | tblDiskDrives      |
| Get-LSLinuxVolumes     | tblLinuxVolumes    |
| Get-LSComputerObject   | tblAssets, tblAssetCustom, tblCPLogonInfo, tblNetwork, tblNetworkAdapter, tblDiskDrives, tblProxy     |


# A Note
This module is the result of much learning by myself, a student. As such, expect the modules to grow and mature over time after their initial release. I am excited to see if the open-source community latches onto this idea, and where other people might take it. On the flip side of this coin it is a work in progress and is subject to bugs/changes. For example, while the Get-LSComputerObject functions just fine, the object properties are returned in a not-so-neat order. This does not affect functionality, but could be more visually appealing.

# Requirements
This tool has a few dependencies/pre-requisites that need to be met in order to be used succesfully. These are:

-Currently, the module only works with Lansweeper installs that are built on top of a true SQL database. CompactSQL databases are not supported but are a future goal. 

-The account running the module has to have read access to Lansweeper's SQL database. This can be accomplished on the SQL server with SQL credentials, or using windows credentials (if mixed authentication is supported on your SQL server). Every cmdlet in this module does accept -Credentials, and dbatools supports connecting via SQL credentials or Windows Authentication. 

# To do
-Add support for CompactSQL databases

-Integrate DbaQuery function into this module in order to remove dbatools as a dependency

-Add more functions as the community dictates. Currently the main functions deal with computer assets and user accounts. Support can be added for AWS, Azure, Linux devices, Mac devices, and Networking devices with minimal effort.

-Add support for wildcards when using parameters to search for assets in the LS database. Powershell and SQL handle wildcards differently, and currently adding support for them would be lengthy with my current skillset.

-Beautify code
