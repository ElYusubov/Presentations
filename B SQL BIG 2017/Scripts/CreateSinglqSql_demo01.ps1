# *** Create a single Azure SQL database using PowerShell

# Login to the account
Add-AzureRmAccount

# The data center and resource name for your resources
$resourcegroupname = "mySqlDemo"
$location = "eastus"
# The logical server name: Use a random value or replace with your own value (do not capitalize)
$servername = "demo-server-$(Get-Random)"
# Set an admin login and password for your database
# The login information for the server
$adminlogin = "ServerAdmin"
$password = "ChangeYourAdminPassword1"
# The ip address range that you want to allow to access your server - change as appropriate
$startip = "173.69.0.0"
$endip = "173.69.255.255"
# The database name
$databasename = "demoSql"

# Create a resource group
New-AzureRmResourceGroup -Name $resourcegroupname -Location $location

# Create a logical server
New-AzureRmSqlServer -ResourceGroupName $resourcegroupname `
    -ServerName $servername `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))
	

# Configure a server firewall rule
New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname `
    -ServerName $servername `
    -FirewallRuleName "AllowSome" -StartIpAddress $startip -EndIpAddress $endip
	

# Create a database in the server with sample data
New-AzureRmSqlDatabase  -ResourceGroupName $resourcegroupname `
    -ServerName $servername `
    -DatabaseName $databasename `
    -SampleName "AdventureWorksLT" `
    -RequestedServiceObjectiveName "S0"
	
# Remove resource 
#Remove-AzureRmResourceGroup -ResourceGroupName mySqlDemoResourceGroup