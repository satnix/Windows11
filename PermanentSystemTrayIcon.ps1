#############################################################################################
## SCRIPT For PermanentSystemTrayIcon		 					                           ##
## Description:  Script looks for powershell scripted System Tray applications in registry ##
##               HKEY_CURRENT_USER\Control Panel\NotifyIconSettings and makes              ##
##               it permanent in System Tray without the need of clicking up button        ##
## Author: Satyam Krishna                                                                  ##
## Date: 10.20.2023                  		                                               ##
#############################################################################################

$LogFile = "C:\Windows\CCM\Logs\Install_PermanentSystemTrayIcon.log"
$SourceFolder = $PSScriptRoot
$SCCMLogFolder = "C:\Windows\CCM\Logs"
$StartDateTime = Get-Date


# LOGGING: Delete any existing logfile if it exists
If (Test-Path $LogFile){Remove-Item $LogFile -Force -ErrorAction SilentlyContinue -Confirm:$false}

Function Write-Log{
	param (
    [Parameter(Mandatory = $true)]
    [string]$Message
    )

    $TimeGenerated = $(Get-Date -UFormat "%D %T")
    $Line = "$TimeGenerated : $Message"
    Add-Content -Value $Line -Path $LogFile -Encoding Ascii
}


Function Search-RegistryKey {
    Param (
        [string]$Path
    )

    $results = @()

    $subkeys = Get-ChildItem -Path $Path | Where-Object { $_.PSPath -ne 'Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER\Control Panel\NotifyIconSettings' }

    foreach ($subkey in $subkeys) {
        $subkeyPath = $subkey.PSPath

        if (Test-Path $subkeyPath) {
            $key = Get-Item -LiteralPath $subkeyPath

            if ($key.GetValue("ExecutablePath")) {
                $executablePath = $key.GetValue("ExecutablePath")

                if ($executablePath -like "*powershell.exe") {
                    $results += [PSCustomObject]@{
                        "RegistryKey" = $subkeyPath
                        "ExecutablePath" = $executablePath
                    }

                    # Create the "IsPromoted" DWORD value with data "1"
                    Set-ItemProperty -Path $subkeyPath -Name "IsPromoted" -Value 1 -Type DWord
                }
            }

            $subResults = Search-RegistryKey -Path $subkeyPath
            if ($subResults.Count -gt 0) {
                $results += $subResults
            }
        }
    }

    return $results
}

# Example usage:
$results = Search-RegistryKey -Path 'HKCU:\Control Panel\NotifyIconSettings'

# Display the results
if ($results.Count -eq 0) {
    Write-Log "No matching results found."
} else {
    foreach ($result in $results) {
        Write-Log "Registry Key: $($result.RegistryKey)"
        Write-Log "ExecutablePath: $($result.ExecutablePath)"
        Write-Log ""
    }
}
