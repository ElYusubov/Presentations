# Source taken from https://docs.microsoft.com/en-us/powershell/azure/get-started-azureps?view=azurermps-4.2.0
# Modified with an addition of automationAccount & automationCredential creation

# Login to the account
Get-Module AzureRM
Login-AzureRmAccount

# Variables for common values
$subscriptionId = "your_guid_subscripyion_id"
$resourceGroup = "rg-vm-$(Get-Random)"
$location = "your_region"
$vmName = "demoNoVaVM"
$user = "student"
$automationAccount = "novaAutoAccount"
$automationCredential = "novaAutoCredential"
$pw = ConvertTo-SecureString "Passw0rd12#$" -AsPlainText -Force

Register-AzureRmResourceProvider -ProviderNamespace Microsoft.Network
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.Automation

New-AzureRmResourceGroup -Name $resourceGroup -Location $location

# Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name mySubnet1 -AddressPrefix 192.168.1.0/24

# Create a virtual network
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
  -Name MYvNET1 -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

# Create a public IP address and specify a DNS name
$publicIp = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
  -Name "mypublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4
$publicIp | Select-Object Name,IpAddress

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleRDP  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
  -Name myNetworkSecurityGroup1 -SecurityRules $nsgRuleRDP

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzureRmNetworkInterface -Name myNic1 -ResourceGroupName $resourceGroup -Location $location `
  -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id -NetworkSecurityGroupId $nsg.Id

Get-AzureRmSubscription –SubscriptionId $subscriptionId | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionId $subscriptionId

# Create user object with prompt
# $cred = Get-Credential -Message "Enter a username and password for the virtual machine."
# $pw = ConvertTo-SecureString "ResulumXamarin@3" -AsPlainText -Force

$cred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $user, $pw

New-AzureRmAutomationAccount -ResourceGroupName $resourceGroup -Name $automationAccount -Location "eastus2" -Plan Free 
New-AzureRmAutomationCredential -ResourceGroupName $resourceGroup -AutomationAccountName $automationAccount -Name $automationCredential -Value $cred 


# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize Standard_DS2_V2 |
  Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred |
  Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest |
  Add-AzureRmVMNetworkInterface -Id $nic.Id

# Create a virtual machine
New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig

# Remove resource group
Get-AzureRmResourceGroup -Name $resourceGroup | Remove-AzureRmResourceGroup -Verbose -Force