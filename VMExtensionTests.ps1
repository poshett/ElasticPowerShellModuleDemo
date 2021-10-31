function VMExtensionTest_T0001 {
   
    $a = Update-AzElasticVMCollection -ResourceGroupName $resource_group_name -Name $test_resource_name -OperationName Add -VMResourceId $test_vm_resourceid
    
    $vm_res = Get-AzElasticVMHost -Name $test_resource_name -ResourceGroupName $resource_group_name
    if($vm_res.Count -eq 1){
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true;
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Failed"
        return $false;
    }
}

function VMExtensionTest_T0002 {
    
    $a = Update-AzElasticVMCollection -ResourceGroupName $resource_group_name -Name $test_resource_name -OperationName Delete -VMResourceId $test_vm_resourceid
    
    $vm_res = Get-AzElasticVMHost -Name $test_resource_name -ResourceGroupName $resource_group_name
    if($vm_res.Count -eq 0){
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true;
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Failed"
		return $false;
    }
}

# Test case needs the Marketplace Subscription to be suspended
function VMExtensionTest_T0003 {
    
	$suspended_resource_name = "clitesting-suspended-001"
	$suspended_resource_group_name = "clitesting"
    $a = Update-AzElasticVMCollection -ResourceGroupName $suspended_resource_group_name -Name $suspended_resource_name -OperationName Add -VMResourceId $test_vm_resourceid
    
    $vm_res = Get-AzElasticVMHost -Name $suspended_resource_name -ResourceGroupName $suspended_resource_group_name
    if($vm_res.Count -eq 0){
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true;
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Failed"
		return $false;
    }
}