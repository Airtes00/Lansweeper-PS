# Lansweeper-PS
Wrapper functions for dbatools to query user and asset information directly from the Lansweeper databases for automation purposes without knowing SQL.
https://github.com/sqlcollaborative/dbatools

# A Note
This module is the result of much learning by myself, a student. As such, expect the modules to grow and mature over time after their initial release. I am excited to see if the open-source community latches onto this idea, and where other people might take it. On the flip side of this coin it is a work in progress and is subject to bugs/changes. For example, while the Get-LSComputerObject functions just fine, the object properties are returned in a not-so-neat order. This does not affect functionality, but could be more visually appealing.

# Requirements
This tool has several dependencies/pre-requisites that need to be met in order to be used succesfully. These are:

-dbatools module installed. The primary function of this module is to use dbatools Invoke-DbaQuery to pull information from a SQL database. Because it relies on literally only this function, and the dbatools module is available under the MIT license, I hope to incorporate this function directly into the Lansweeper-PS package in order to save time space. More on that below.

-Currently, the module only works with Lansweeper installs that are built on top of a true SQL database. CompactSQL databases are not supported but are a future goal. 

-The account running the module has to have read access to Lansweeper's SQL database. This can be accomplished on the SQL server with SQL credentials, or using windows credentials (if mixed authentication is supported on your SQL server). Every cmdlet in this module does accept -Credentials, and dbatools supports connecting via SQL credentials or Windows Authentication. 

# To do
-Add support for CompactSQL databases

-Integrate DbaQuery function into this module in order to remove dbatools as a dependency

-Add more functions as the community dictates. Currently the main functions deal with computer assets and user accounts. Support can be added for AWS, Azure, Linux devices, Mac devices, and Networking devices with minimal effort.

-Add support for wildcards when using parameters to search for assets in the LS database. Powershell and SQL handle wildcards differently, and currently adding support for them would be lengthy with my current skillset.

-Beautify code
