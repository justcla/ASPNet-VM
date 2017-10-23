Install-WindowsFeature -name Web-Server -IncludeManagementTools

Install-WindowsFeature -Name Web-Mgmt-Service
Set-ItemProperty -Path  HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement  -Value 1
Set-Service -name WMSVC  -StartupType Automatic
net start wmsvc

$tempFile = [System.IO.Path]::GetTempFileName() |
    Rename-Item -NewName { $_ -replace 'tmp$', 'exe' } -PassThru
Invoke-WebRequest -Uri http://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi -OutFile $tempFile

$logFile = [System.IO.Path]::GetTempFileName()

$proc = (Start-Process $tempFile -PassThru "/quiet /install /log $logFile")
$proc | Wait-Process
Get-Content $logFile
