# Configuring Storsimple volumes with PowerShell

This is a simple script which can be used to configure a volume in [Microsoft Azure Storsimple Service](https://www.microsoft.com/en-us/cloud-platform/azure-storsimple).
All the values required ot run this are parameterized and can be passed as you run the script. This script configures the following - 
* Add a volume
* Configure an ACR record for a specific server iSCSI initiator
* Set volume with default values for backup schedule and monitoring
* Configure volume size.

Without the **AddVolume** switch, you can supply the name of an existing volume and update values for size or ACR. 


## Prerequisites

* In order to run this you need the [Azure Powershell Service Management Cmdlets](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/).
* You will need information specific to your Azure subscription in order to connect to your StorSimple Service and pass the correct parameters.

## Parameters

**ServerName**

`[Parameter(Mandatory = $True)]
	[string]$ServerName`

* The hostname of the server you will be connecting to the volume from via iSCSI Inititor.

**VolumeName**  

`[Parameter(Mandatory = $True)]
	[string]$VolumeName`

* The name of the volume on the Storsimple device that you are creating or modifying.

**Size**

`[Parameter(Mandatory = $True)]
    [System.Int64]$Size`

* The size of the volume you are creating, or the new size if modifying an existing volume.

**RegistrationKey**

`[Parameter(Mandatory = $True)]
    [String]$RegistrationKey`

* The Registration key obtained from your Azure account for access to this device. See [this documentation](https://azure.microsoft.com/en-us/documentation/articles/storsimple-manage-service/#get-the-service-registration-key) for details if you aren't sure where to get it.

**DeviceName**

`[Parameter(Mandatory = $True)]
    [String]$DeviceName`

* Name of the Storsimple device.

**VolumeContainerName**

`[Parameter(Mandatory = $True)]
    [String]$VolumeContainerName`

* Name of the Volume COntainer which will be used to house the volume you are creating or modifying.

**SubscriptionName**

`[Parameter(Mandatory = $True)]
    [String]$SubscriptionName`

* Name of the Azure Subscription to be used.

**StorsimpleInstance**

`[Parameter(Mandatory = $True)]
    [String]$StorsimpleInstance`

* Name of the Storsimple service instance in Azure.

**AddVolume**

`[switch]$AddVolume`

* A switch you can use to specify whether you are adding a new volume or modifying an existing.

