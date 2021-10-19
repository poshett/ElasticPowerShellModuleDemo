. $PSScriptRoot\variables.ps1

function GetGUID($maxSize = 10)
{
    $g = [guid]::NewGuid()
    $v = [string]$g
    $v = $v.Replace("-", "")
    return $v.substring(0, $maxSize)
}

function CreateElasticMonitor()
{
	Write-Host "Starting to create new Elastic resource"
    $unique_id = GetGUID 10
    $test_resource_name = $test_resource_name_prefix+$unique_id
    Write-Host "Resource Name : "$test_resource_name
    return New-AzElasticMonitor -ResourceGroupName $resource_group_name -Name $test_resource_name -Location $location -Sku "ess-monthly-consumption_Monthly" -UserInfoEmailAddress $user_email

}

function GetElasticMonitorDetails($rg, $res)
{
	return Get-AzElasticMonitor -ResourceGroupName $rg -Name $res -ErrorAction SilentlyContinue
}

function GetElasticDeploymentInfo($rg, $res)
{
	return Get-AzElasticDeploymentInfo -ResourceGroupName $rg -Name $res
}

function AddElasticRTagRuleResourceLogs($rg, $res, $tag)
{
	Write-Host "Started to add tag rule"
    New-AzElasticTagRule -ResourceGroupName $rg -MonitorName $res  -LogRuleSendActivityLog -LogRuleFilteringTag $tag
    return Get-AzElasticTagRule -ResourceGroupName $rg -MonitorName $res
}

function AddElasticSubscriptionActivityLogs($rg, $res)
{
	Write-Host "Started to add rule for subscription activity logs"
	New-AzElasticTagRule -ResourceGroupName $rg -MonitorName $res -LogRuleSendSubscriptionLog
	return Get-AzElasticTagRule -ResourceGroupName $rg -MonitorName $res
}

function AddElasticAgentVmExtension($rg, $res)
{
	Write-Host "Starting to add Virtual Machine Extension"
    Update-AzElasticVMCollection -ResourceGroupName $rg -Name $res -OperationName Add -VMResourceId $test_vm_resourceid
    return Get-AzElasticVMHost -ResourceGroupName $rg -Name $res
}

function DeleteElasticMonitor($rg, $res)
{
	Write-Host "Starting to delete Elastic resource"
	Remove-AzElasticMonitor -ResourceGroupName $rg  -Name $res
}

function CheckContinuance($i)
{
	if($i -eq "manual")
	{
		$message = "Press any key to continue....."
		if ($psISE)
		{
			Add-Type -AssemblyName System.Windows.Forms
			[System.Windows.Forms.MessageBox]::Show("$message")
		}
		else
		{
			Write-Host "$message" -ForegroundColor Yellow
			$x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		}
	}
	return
}
		
	