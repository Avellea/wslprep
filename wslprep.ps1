$config = @'
[wsl2]
guiApplications=true
networkingMode=mirrored
debugConsole=false
'@

function Show-Menu([string]$Title) {
    clear
    Write-Host "==============================[$Title]=============================="
    Write-Host “1: Install Ubuntu with WSL 2”
    Write-Host “2: Configure networking for full LAN”
    Write-Host “Q: Press ‘Q’ to quit.”
}

do {
    Show-Menu("WSL2 AutoPrepper")
    $input = Read-Host "Please make a selection"
    
    switch($input) {
        '1' {
            clear
            dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
            dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
            Invoke-WebRequest "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile ".\wsl2.msi"
            Write-Host "Please run through the WSL2 setup. It will appear on your screen soon."
            .\wsl2.msi
            pause
            Write-Host "A terminal window will appear asking you to make a new user account for your WSL installation. Please follow it."
            pause
            wsl --install -d Ubuntu
            wsl --set-default-version Ubuntu 2
        }
        '2' {
            clear
            Write-Host "WSL2 Config located at: C:\Users\$Env:UserName\.wslconfig"
            Write-Host ""
            echo $config
            echo $config > C:\Users\$Env:UserName\.wslconfig
            wsl --shutdown
            Set-NetFirewallHyperVVMSetting -Name ‘{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}’ -DefaultInboundAction Allow
            Write-Host ""
            Write-Host "Done!"
            pause 
        }
    }

} until ($input -eq 'q')
