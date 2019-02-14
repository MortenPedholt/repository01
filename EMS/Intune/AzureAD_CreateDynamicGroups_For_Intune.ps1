﻿<###
DESCRIPTION
Author: Morten Pedholt
Created: November 2018
Edited: January 2019
Edited by: Morten Pedholt
ScriptVersion: 1.0.1

Updated in version 1.0.1
Will now check if AzureAD or AzureADPreview module is installed, if not then it will install the module.


###>

#Check if AzureAD or AzureADPreview module is installed, if not it will install and import the module.
$checkmodule = Get-Module -ListAvailable | Where-Object { $_.Name -like "*AzureAD*" } | Select Name
if($checkmodule) {
Write-Host "AzureAD or AzureADPreview is already installed"
$selectmodule = $checkmodule[0] -replace "@{Name=", "" -replace "}", ""
Import-Module $selectmodule
}
Else{
Write-Host "No Module found to connect to AzureAD, installing AzureADPreview module"
Install-Module AzureADPreview
Import-Module AzureAdPreview
}


#Connect to AzureAD
$azureadcred = Get-Credential
Connect-AzureAD -Credential $azureadcred


$newgroups = @( "All Windows 10 1507 – MDM", `
                "All Windows 10 1511 – MDM", `
                "All Windows 10 1607 – MDM", `
                "All Windows 10 1703 – MDM", `
                "All Windows 10 1709 – MDM", `
                "All Windows 10 1803 – MDM", `
                "All Windows 10 1809 – MDM", `
                "All Windows Devices – MDM", `
                "All Android Devices – MDM", `
                "All iOS Devices – MDM", `
                "All macOS Devices – MDM", `
                "All Windows Enrolled Devices – MDM",`
                "Update ring - SAC-T",`
                "Update ring - SAC",`
                "Update ring - Insider")

#Check if group already exist, if any group exist it will end and error.
$azureadgroups = Get-AzureADMSGroup | Where-Object { $newgroups -contains $_.DisplayName}
if ($azureadgroups) { foreach ($group in $azureadgroups) {
Write-Host "$($group.Displayname) already exist!" -ForegroundColor Red} 
write-host "script stopped because one or more groups was already created" -ForegroundColor Red;break} 
else {
Write-Host "No groups were found start creating groups." -ForegroundColor Green}


#Create Dynamic groups for specific Windows Versions
New-AzureADMSGroup -DisplayName "All Windows 10 1507 – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Windows 10 1507 – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSVersion -contains ""10.0.10240"")" -MembershipRuleProcessingState On
New-AzureADMSGroup -DisplayName "All Windows 10 1511 – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Windows 10 1511 – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSVersion -contains ""10.0.10586"")" -MembershipRuleProcessingState On
New-AzureADMSGroup -DisplayName "All Windows 10 1607 – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Windows 10 1607 – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSVersion -contains ""10.0.14393"")" -MembershipRuleProcessingState On
New-AzureADMSGroup -DisplayName "All Windows 10 1703 – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Windows 10 1703 – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSVersion -contains ""10.0.15063"")" -MembershipRuleProcessingState On
New-AzureADMSGroup -DisplayName "All Windows 10 1709 – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Windows 10 1709 – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSVersion -contains ""10.0.16299"")" -MembershipRuleProcessingState On
New-AzureADMSGroup -DisplayName "All Windows 10 1803 – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Windows 10 1803 – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSVersion -contains ""10.0.17134"")" -MembershipRuleProcessingState On
New-AzureADMSGroup -DisplayName "All Windows 10 1809 – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Windows 10 1809 – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSVersion -contains ""10.0.17763"")" -MembershipRuleProcessingState On


#Create Dynamic groups for specific OSType Versions
New-AzureADMSGroup -DisplayName "All Windows Devices – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Windows Devices – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSType -contains ""Windows"")" -MembershipRuleProcessingState On
New-AzureADMSGroup -DisplayName "All Android Devices – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Android Devices – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSType -contains ""Android"")" -MembershipRuleProcessingState On
New-AzureADMSGroup -DisplayName "All iOS Devices – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All iOS Devices – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.managementType -eq ""MDM"") -and ((device.deviceOSType -eq ""iPad"") -or (device.deviceOSType -eq ""iPhone""))" -MembershipRuleProcessingState On
New-AzureADMSGroup -DisplayName "All macOS Devices – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All macOS Devices – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.deviceOSType -contains ""macOS"")" -MembershipRuleProcessingState On


#Create Dynamic groups for all MDM enrolled Windows devices
New-AzureADMSGroup -DisplayName "All Enrolled Windows Devices – MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "All Windows Enrolled Devices – MDM" -GroupTypes DynamicMembership -MembershipRule "(device.managementType -eq ""MDM"") -and (device.deviceOSType -contains ""Windows"")" -MembershipRuleProcessingState On


#Create test groups for MDM enrollment
New-AzureADGroup -DisplayName "Test User - MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "ITR Test User - MDM" 
New-AzureADGroup -DisplayName "Test Device - MDM" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "ITR Test Device - MDM" 


#Create Windows update ring groups
New-AzureADGroup -DisplayName "Update ring - SAC-T" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "Update ring - SAC-T" 
New-AzureADGroup -DisplayName "Update ring - Insider" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "Update ring - Insider" 
New-AzureADMSGroup -DisplayName "Update ring - SAC" -MailEnabled $false -MailNickname "NotSet" -SecurityEnabled $True -Description "Update ring - SAC" -GroupTypes DynamicMembership -MembershipRule "(device.managementType -eq ""MDM"") -and (device.deviceOSType -contains ""Windows"")" -MembershipRuleProcessingState On