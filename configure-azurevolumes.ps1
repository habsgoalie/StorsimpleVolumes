<#	
	.NOTES
	===========================================================================
	 Created with: 	Visual Studio Code 0.10.6
	 Created on:   	1/8/2016 1:39 PM
	 Created by:   	 Kevin Olson
	 Organization: 	 Cimpress NV
	 Filename:     	configure-azurevolumes.ps1
	===========================================================================
	.DESCRIPTION
		A script to connect to azure Storsimple volume and configure it.
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True)]
	[string]$ServerName,
    
    [Parameter(Mandatory = $True)]
	[string]$VolumeName,
    
    [Parameter(Mandatory = $True)]
    [System.Int64]$Size,

    [Parameter(Mandatory = $True)]
    [String]$RegistrationKey,

    [Parameter(Mandatory = $True)]
    [String]$DeviceName,

    [Parameter(Mandatory = $True)]
    [String]$VolumeContainerName,

    [Parameter(Mandatory = $True)]
    [String]$SubscriptionName,

    [Parameter(Mandatory = $True)]
    [String]$StorsimpleInstance,

    [switch]$AddVolume
    
)

Import-Module Azure
Add-AzureAccount
$azuresubscription = Get-AzureSubscription -Current
$IQInitiatorname = "iqn.1991-05.com.microsoft:"+$ServerName

if ($azuresubscription.SubsciptionName -ne $SubscriptionName) {
    Select-AzureSubscription -SubscriptionName $SubscriptionName
}

$storsimplecontext = Get-AzureStorSimpleResourceContext

if ($storsimplecontext -ne $StorsimpleInstance){
    Select-AzureStorSimpleResource -ResourceName $StorsimpleInstance -RegistrationKey $RegistrationKey
} 

if ($AddVolume) {
    Get-AzureStorSimpleDeviceVolumeContainer -DeviceName $DeviceName -VolumeContainerName $VolumeContainerName | 
    New-AzureStorSimpleDeviceVolume -DeviceName $DeviceName -VolumeName $VolumeName -Size $Size -AccessControlRecords @() `
    -VolumeAppType PrimaryVolume -Online $True -EnableDefaultBackup $True -EnableMonitoring $True -WaitForComplete
}

$storsimpleacr = Get-AzureStorSimpleAccessControlRecord -ACRName $ServerName
$storsimpledevicevolume = Get-AzureStorSimpleDeviceVolume -Name $VolumeName -Devicename $DeviceName

if (!$storsimpleacr){
    New-AzureStorSimpleAccessControlRecord -ACRName $ServerName -IQNInitiatorName $IQInitiatorName
} 
$newacr = Get-AzureStorSimpleAccessControlRecord -ACRName $ServerName
if($storsimpledevicevolume.acrlist -notcontains $newacr){
    $existingacr = $storsimpledevicevolume.AcrList
    $acrlist = @()
    $acrlist += $existingacr
    $acrlist += $newacr
    Set-AzureStorSimpleDeviceVolume -DeviceName $DeviceName -VolumeName $VolumeName -AccessControlRecords $acrlist
}