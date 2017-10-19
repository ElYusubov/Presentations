
#*** Get AzureRM module and login
Get-Module AzureRM
Login-AzureRmAccount

#*** List all availiable subscriptions under account
Get-AzureRmSubscription

#*** Get and Select Azure Subscription by ID
Get-AzureRmSubscription –SubscriptionId $id | Select-AzureRmSubscription -SubscriptionId $id

#*** List AzureRM resources
#Get-AzureRmResource | Format-Table Name,ResourceType,ResourceGroupName,Location -AutoSize

 
#***Changing the Windows PowerShell script execution policy
Set-ExecutionPolicy RemoteSigned

#*** Add and Remove resource group and all resources 
New-AzureRmResourceGroup -Name 'testresourcegroup' -Location 'eastus'
#Remove-AzureRmResourceGroup -Name 'testresourcegroup'

#*** Load Azure Module and Login
Get-Module AzureRM
Login-AzureRmAccount

#*** Identify your current context but not to trigger authentication
Get-AzureRmContext 

#*** List AzureRM resources
Get-AzureRmResource | Format-Table Name,ResourceType,ResourceGroupName,Location -AutoSize

#*** Query AzureRM resources
Get-AzureRmResource | Where-Object ResourceGroupName -eq "your_resource" | Select-Object Name,Location,ResourceType

#*** Convert selection output to JSON representation
Get-AzureRmResource | Select-Object ResourceGroupName,ResourceId,Name,Location | ConvertTo-Json

#***Uses Get-AzureRmResourceGroup cmdlet to get the resource group ContosoRG01, & then passes it to Remove-AzureRmResourceGroup by using the pipeline operator.
Get-AzureRmResourceGroup -Name "ContosoRG01" | Remove-AzureRmResourceGroup -Verbose -Force
