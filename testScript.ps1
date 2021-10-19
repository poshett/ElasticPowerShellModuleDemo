## Testing Elastic Powershell module commandlets
## Refer to https://docs.microsoft.com/en-us/powershell/module/az.elastic/?view=azps-6.5.0 for more details

. $PSScriptRoot\helperFunctions.ps1
. $PSScriptRoot\variables.ps1

Write-Host "Testing Elastic Powershell module commandlets"
Write-Host "Refer to https://docs.microsoft.com/en-us/powershell/module/az.elastic/?view=azps-6.5.0 for more details"
Write-Host "`n"
Write-Host "Press 'm/M' for for controlled manual testing"
$input = Read-Host "Press any other key to continue automatically"

if ($input -eq "m" -or $input -eq "M")
{
    $input = "manual"
}

Write-Host "`n"
Write-Host "Login to AzAccount"
Connect-AzAccount -TenantId $tenant_id
Write-Host "Login Successful"

Write-Host "`n"
Write-Host "Creating new Elastic resource"
$create_new_resource = CreateElasticMonitor

Start-Sleep -s 20

Write-Host "Verifying newly created Elastic resource"
$new_resource = GetElasticDeploymentInfo $resource_group_name $create_new_resource.Name 

if($new_resource.Status -eq "Healthy") {
	Write-Host "Elastic resource is healthy, continuing with testing....."
}
else {
	Write-Host "Elastic resource is not healthy..... Exiting testing!"
    Exit
}

$new_resource = GetElasticMonitorDetails $resource_group_name $create_new_resource.Name

if ($new_resource.Name -eq $create_new_resource.Name) {
    Write-Host "Successfully verified the newly created Elastic resource"    
}
else {
    Write-Host "Failed to create Elastic resource..... Exiting testing!"
    Exit
}

CheckContinuance $input
Write-Host "`n"
Write-Host "Adding tags to the Elastic resource"
Update-AzElasticMonitor -ResourceGroupName $resource_group_name -Name $create_new_resource.Name -Tag @{$elastic_tag_name = $elastic_tag_value}

Write-Host "Adding subscription activity logs"
$rule = AddElasticSubscriptionActivityLogs $resource_group_name $create_new_resource.Name
if ($rule.Name -eq "default") {
    Write-Host "Successfully added rule for subscription activity logs"    
}
else {
    Write-Host "Failed to add rule..... Exiting testing!"
    Exit
}

CheckContinuance $input
Write-Host "`n"
Write-Host "Creating Filtering rule"
$filter_rule = New-AzElasticFilteringTagObject -Action Include -Name $tag_rule_name -Value $tag_rule_value

Write-Host "Adding tag rule"
$tag_rule = AddElasticRTagRuleResourceLogs $resource_group_name $create_new_resource.Name $filter_rule
if ($tag_rule.Name -eq "default") {
    Write-Host "Successfully added tag rule for resource logs"    
}
else {
    Write-Host "Failed to add tag rule..... Exiting testing!"
    Exit
}

Write-Host "Testing the resources monitored by the added tag rules"
Write-Host "Sleeping for 300 seconds for filtering tags to come to effect"

Start-Sleep -s 300

$monitored_res = Get-AzElasticMonitoredResource -ResourceGroupName $resource_group_name -Name $create_new_resource.Name  | Where-Object {$_.SendingLog -eq "True"}

if ($monitored_res.Count -gt 0) {
    Write-Host "Monitored resources count verified"    
}
else {
    Write-Host "Monitored resources count verification failed..... Exiting testing!"
    Exit
}

CheckContinuance $input
Write-Host "`n"
Write-Host "Testing Virtual Machine Extension"
$vm = AddElasticAgentVmExtension $resource_group_name $create_new_resource.Name
if ($vm.VMResourceId = $test_vm_resourceid) {
    Write-Host "Elastic agent VM extension has been successfully installed"
}
else {
    Write-Host "Failed to install Elastic agent VM Extension"
}

CheckContinuance $input
Write-Host "`n"
Write-Host "Deleting Elastic resource"
DeleteElasticMonitor $resource_group_name  $create_new_resource.Name

Write-Host "Sleeping for 15 seconds"
Start-Sleep -s 15

Write-Host "Getting Elastic resource details....."
try{
    $new_resource = GetElasticMonitorDetails $resource_group_name $create_new_resource.Name
}
catch{  
    
}
if ($null -eq $new_resource) {
    Write-Host "Successfully deleted Elastic resource"    
}
else {
    Write-Host "Failed to delete Elastic resource..... Exiting testing!"
    Exit
}

Write-Host "`n"
Write-Host "PS script Tests Completed!"