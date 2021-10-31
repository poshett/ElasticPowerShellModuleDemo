
function LogShippingTest_T0001 {
	$test_resource_name = "clitesting-portal-02"
    $rule = New-AzElasticTagRule -MonitorName $test_resource_name -ResourceGroupName $resource_group_name  -LogRuleSendSubscriptionLog
    $tag_rule = Get-AzElasticTagRule -MonitorName $test_resource_name -ResourceGroupName $resource_group_name

    if ($tag_rule.Name -eq "default") {
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Failed"
        return $false
    }
}

# Test case needs resources with tag "breakingchanges" and value "testing0909"
function LogShippingTest_T0002 {
	$test_resource_name = "clitesting-portal-02"
    $filter_rule1 = New-AzElasticFilteringTagObject -Action Include -Name "breakingchanges" -Value "testing0909"
    $filter_rule2 = New-AzElasticFilteringTagObject -Action Exclude -Name exTag -Value exTag
    $rule = New-AzElasticTagRule -MonitorName $test_resource_name -ResourceGroupName $resource_group_name -LogRuleSendActivityLog -LogRuleFilteringTag $filter_rule1, $filter_rule2
    
    Start-Sleep -s 300
    $monitored_res = Get-AzElasticMonitoredResource -Name $test_resource_name -ResourceGroupName $resource_group_name | Where-Object {$_.SendingLog -eq "True"}

    if ($monitored_res.Count -gt 0) {
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Failed"
        return $false
    }

}

# Test case needs resources with tag "breakingchanges" and value "testing0909"
function LogShippingTest_T0003 {
	
    $filter_rule1 = New-AzElasticFilteringTagObject -Action Include -Name "breakingchanges" -Value "testing0909"
    $rule = New-AzElasticTagRule -MonitorName $test_resource_name -ResourceGroupName $resource_group_name -LogRuleSendSubscriptionLog -LogRuleSendActivityLog -LogRuleFilteringTag $filter_rule1
    
    Start-Sleep -s 300
    $monitored_res = Get-AzElasticMonitoredResource -Name $test_resource_name -ResourceGroupName $resource_group_name | Where-Object {$_.SendingLog -eq "True"}

    if ($monitored_res.Count -gt 0) {
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Failed"
        return $false
    }

}


# Test case needs the Marketplace Subscription to be suspended
function LogShippingTest_T0004 {
	
	$suspended_resource_name = "clitesting-suspended-001"
	$suspended_resource_group_name = "clitesting"
    $filter_rule1 = New-AzElasticFilteringTagObject -Action Include -Name "breakingchanges" -Value "testing0909"
    $rule = New-AzElasticTagRule -MonitorName $suspended_resource_name -ResourceGroupName $suspended_resource_group_name -LogRuleSendActivityLog -LogRuleFilteringTag $filter_rule1
    
    Start-Sleep -s 300
    $tag_rule = Get-AzElasticTagRule -MonitorName $suspended_resource_name -ResourceGroupName $suspended_resource_group_name

    if ($tag_rule.LogRuleSendActivityLog -eq $false) {
        Write-Host $MyInvocation.MyCommand "- Passed"
        return $true
    }
    else {
        Write-Host $MyInvocation.MyCommand "- Failed"
        return $false
    }
}
