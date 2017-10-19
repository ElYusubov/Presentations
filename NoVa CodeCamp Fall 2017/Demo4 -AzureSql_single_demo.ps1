# *** Create a single Azure SQL database using PowerShell

# Login to the account
Get-Module AzureRM
Login-AzureRmAccount

#Get-AzureRmLocation
#Get-AzureRmLocation | Format-Table Location,DisplayName

$location="eastus"
$resourcegroupname = "rg-sql-$(Get-Random)"

# The logical server name: Use a random value or replace with your own value (do not capitalize)
$servername = "demo-server-$(Get-Random)"
$databasename = "demoSql"

# Set an admin login and password for your database
# The login information for the server
$adminlogin = "ServerAdmin"
$password = "NewAdminPassword123"

# Set ip address range that you want to allow to access your server
$startip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip
$endip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip

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
	
# Query all resources
Get-AzureRmResource | Format-Table Name,ResourceType,ResourceGroupName,Location -AutoSize

#Get-AzureRmResource -ResourceType "Microsoft.Storage/storageAccounts" -ResourceGroupName "rg-storage"

# Remove resource 
# Remove-AzureRmResourceGroup -ResourceGroupName $resourcegroupname 