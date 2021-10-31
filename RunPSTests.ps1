## Testing Elastic Powershell module commandlets
## Refer to https://docs.microsoft.com/en-us/powershell/module/az.elastic/?view=azps-6.5.0 for more details

. $PSScriptRoot\helperFunctions.ps1
. $PSScriptRoot\CreateElasticMonitorTests.ps1
. $PSScriptRoot\LogShippingTests.ps1
. $PSScriptRoot\VMExtensionTests.ps1
. $PSScriptRoot\DeleteElasticMonitorTests.ps1

# update these details to your data
$tenant_id = "4bbb79f7-5724-4c9e-95f3-de075f6ec090"
$test_resource_name = "poshett-ps-testing-" + (GetGUID 10)
$resource_group_name = "clitesting"
# Change email id to the one from which you are logged in
$user_email = "poshettMPTesting@mpliftrelastic20210901outlo.onmicrosoft.com"
$location = "westus2"
$test_vm_resourceid = "/subscriptions/5a611eed-e33a-44e8-92b1-3f6bf835905e/resourceGroups/CLITESTING/providers/Microsoft.Compute/virtualMachines/poshett-cli-testing-vm-02"

$total_test=13;
$failed =0;
$passed =0;

Write-Host "Login to AzAccount"
Connect-AzAccount -TenantId $tenant_id
Write-Host "Login Successful"
Write-Host $test_resource_name

Write-Host "Starting Test cases"

# $res = CreateElasticMonitorTest_T0001
if (CreateElasticMonitorTest_T0001) {$passed++} else {$failed++}

# $res = CreateElasticMonitorTest_T0002
if (CreateElasticMonitorTest_T0002) {$passed++} else {$failed++}

# $res = CreateElasticMonitorTest_T0003
if (CreateElasticMonitorTest_T0003) {$passed++} else {$failed++}

# $res = CreateElasticMonitorTest_T0004
if (CreateElasticMonitorTest_T0004) {$passed++} else {$failed++}

# $res = CreateElasticMonitorTest_T0005 - Testing Suspended Accounts
#if (CreateElasticMonitorTest_T0005) {$passed++} else {$failed++}

# Test Subsciption Activity Logs
#if (LogShippingTest_T0001) {$passed++} else {$failed++}

# Test Resource logs
#if (LogShippingTest_T0002) {$passed++} else {$failed++}

# Test both Subsciption Activity and Resource Logs
#if (LogShippingTest_T0003) {$passed++} else {$failed++}

# Test Tag Rules for Suspended Accounts
#if (LogShippingTest_T0004) {$passed++} else {$failed++}

# Test VM Extension Installing
#if (VMExtensionTest_T0001) {$passed++} else {$failed++}

# Test VM Extension Uninstalling
#if (VMExtensionTest_T0002) {$passed++} else {$failed++}

# Test installing VM Extension on a Suspended resource
#if (VMExtensionTest_T0003) {$passed++} else {$failed++}

# Test Elastic monitor resource deletion
if (DeleteElasticMonitorTests_T0001) {$passed++} else {$failed++}

Write-Host "Tests completed"
Write-Host "total_test = "$total_test
Write-Host "total_test passed = "$passed
Write-Host  "total_test failed = "$failed
