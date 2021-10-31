function DeleteElasticMonitorTests_T0001 {
	
    $removed = Remove-AzElasticMonitor -ResourceGroupName $resource_group_name  -Name $test_resource_name
	
	Start-Sleep -s 15
	
	$new_resource = ""
	
	try{
		$new_resource = Get-AzElasticMonitor -ResourceGroupName $resource_group_name -Name $test_resource_name -ErrorAction SilentlyContinue
	}
	catch{  
    
	}
	if ($null -eq $new_resource) {
		Write-Host $MyInvocation.MyCommand + "Passed"
        return $true   
	}
	else {
		Write-Host $MyInvocation.MyCommand + "Failed"
        return $false;
	}

}