#*** List all availiable subscriptions under account
#Get-Module AzureRM
#Login-AzureRmAccount

# Get-AzureRmLocation
Get-AzureRmLocation | Format-Table Location,DisplayName

$location="eastus"  # Set the closest region
$rg = "rg-$(Get-Random)"
$subscriptionName = "your_subscription_name"
# Alternatively uoi may use $subscriptionId
$storageAccountName = "storage$(Get-Random)"

#***Changing the Windows PowerShell script execution policy
Set-ExecutionPolicy RemoteSigned

#*** Identify your current context but not to trigger authentication
# Get-AzureRmContext 

#*** Get and Select Azure Subscription by Name
Get-AzureRmSubscription -SubscriptionName $subscriptionName | Select-AzureRmSubscription -SubscriptionName $subscriptionName

#*** List AzureRM resources
Get-AzureRmResource | Format-Table Name,ResourceType,ResourceGroupName,Location -AutoSize 

#*** Add resource group and all resources 
New-AzureRmResourceGroup -Name $rg -Location $location
New-AzureRmStorageAccount -ResourceGroupName $rg -AccountName $storageAccountName -Location $location -SkuName "Standard_GRS"

#*** List AzureRM resources
Get-AzureRmResource | Format-Table Name,ResourceType,ResourceGroupName,Location -AutoSize

#*** Query AzureRM resources
Get-AzureRmResource | Where-Object ResourceGroupName -eq $rg | Select-Object Name,Location,ResourceType,ResourceGroupName

#*** Convert selection output to JSON representation
Get-AzureRmResource | Select-Object ResourceGroupName,ResourceId,Name,Location | ConvertTo-Json

#*** Get-AzureRmResourceGroup cmdlet to get the resource group name & passes it to Remove-AzureRmResourceGroup by using the pipeline operator.
Get-AzureRmResourceGroup -Name $rg | Remove-AzureRmResourceGroup -Verbose -Force
