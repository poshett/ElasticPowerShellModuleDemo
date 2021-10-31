function CreateElasticMonitorTest_T0001 {
    
    $resource = New-AzElasticMonitor -ResourceGroupName $resource_group_name -Name $test_resource_name -Location $location -Sku "ess-monthly-consumption_Monthly" -UserInfoEmailAddress $user_email
    
    $new_main_resource = Get-AzElasticMonitor -ResourceGroupName $resource_group_name -Name $test_resource_name

    if ($new_main_resource.Name -eq $test_resource_name) {
        Write-Host $MyInvocation.MyCommand "- Passed"  
        return $true
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Failed"
        return $false;
    }
}

function CreateElasticMonitorTest_T0002 {
    
    $resource = New-AzElasticMonitor -ResourceGroupName -Name "PSTest-NoRG" -Location $location -Sku "ess-monthly-consumption_Monthly" -UserInfoEmailAddress $user_email -ErrorAction SilentlyContinue
    
    $new_main_resource = Get-AzElasticMonitor -ResourceGroupName $resource_group_name -Name "PSTest-NoRG"

    if ($new_main_resource.Name -eq "PSTest-NoRG") {
        Write-Host $MyInvocation.MyCommand "- Failed"
        return $false
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true;
    }
}

function CreateElasticMonitorTest_T0003 {
    
    $resource = New-AzElasticMonitor -ResourceGroupName $resource_group_name -Name "PSTest-!!InvalidMonitorName" -Location $location -Sku "ess-monthly-consumption_Monthly" -UserInfoEmailAddress $user_email
    
    $new_main_resource = Get-AzElasticMonitor -ResourceGroupName $resource_group_name -Name "PSTest-!!InvalidMonitorName"

    if ($new_main_resource.Name -eq "PSTest-!!InvalidMonitorName") {
        Write-Host $MyInvocation.MyCommand "- Failed"
        return $false
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true;
    }
}

function CreateElasticMonitorTest_T0004 {
    
    $resource = New-AzElasticMonitor -ResourceGroupName $resource_group_name -Name "PSTest-!!InvalidMonitorNamexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -Location $location -Sku "ess-monthly-consumption_Monthly" -UserInfoEmailAddress $user_email
    
    $new_main_resource = Get-AzElasticMonitor -ResourceGroupName $resource_group_name -Name "PSTest-!!InvalidMonitorNamexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

    if ($new_main_resource.Name -eq "PSTest-!!InvalidMonitorNamexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") {
        Write-Host $MyInvocation.MyCommand "- Failed"
        return $false
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true;
    }
}

# Test case needs the Marketplace Subscription to be suspended
function CreateElasticMonitorTest_T0005 {
    
	$suspended_resource_name = "clitesting-suspended-0001"
	$suspended_resource_group_name = "clitesting"
	
	$resource = New-AzElasticMonitor -ResourceGroupName $resource_group_name -Name $suspended_resource_name -Location $location -Sku "ess-monthly-consumption_Monthly" -UserInfoEmailAddress $user_email -ErrorAction SilentlyContinue

    $new_main_resource = Get-AzElasticMonitor -ResourceGroupName $resource_group_name -Name $suspended_resource_name -ErrorAction SilentlyContinue
	
    if ($new_main_resource.Status -eq "Healthy") {
        Write-Host $MyInvocation.MyCommand "- Failed"  
        return $false
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true;
    }
}