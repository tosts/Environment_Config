$expected_mingw_path = "C:\MinGW64"
$install_mingw = -Not (Test-Path "$expected_mingw_path\bin\g++.exe")

$expected_node_path = "C:\Program Files\nodejs"
$install_node = -Not (Test-Path "$expected_node_path\node.exe")

# For user _and_ admin

if (-Not (Get-Module PSReadLine)) {
    (New-Object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression
    Install-Module PSReadLine
}

if (Test-Path "$PSScriptRoot\Microsoft.PowerShell_profile.ps1") {
    Write-Host "Updating PowerShell profile."
    Copy-Item "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" "$env:USERPROFILE\Documents\WindowsPowerShell"
}

# Elevate & Restart
#
# Source: http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/09/23/a-self-elevating-powershell-script.aspx

$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=New-Object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($myWindowsPrincipal.IsInRole($adminRole)) {
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
} else {
   $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);
   exit
}

if ($install_mingw) {
    Write-Host "Fetching for installation: mingw installer"
    Write-Host "Hint: Expected path '$expected_mingw_path'"
        Invoke-Webrequest 'http://win-builds.org/1.5-rc3/win-builds-1.5-rc3.exe' -OutFile mingw_installer.exe
        Start-Process 'mingw_installer.exe' -Wait
        Remove-Item 'mingw_installer.exe'

        if (Test-Path "$expected_mingw_path\bin") {
            Write-Host "Adding to system PATH: '$expected_mingw_path\bin'"
            [Environment]::SetEnvironmentVariable("Path", "$env:Path;$expected_mingw_path\bin", [EnvironmentVariableTarget]::Machine)
        }
    Write-Host "Finished"
}

if ($install_node) {
    Write-Host "Fetching for installation: node installer"
        $node_latest_downloads = 'http://nodejs.org/dist/latest/x64/'
        $msi_file_name = ((Invoke-Webrequest $node_latest_downloads).Content `
                -split ' *<.*?> *', 0, "RegexMatch" |                        `
                Select-String -Pattern '^node-.*.msi$'                       `
            ).Line
        Invoke-Webrequest $node_latest_downloads$msi_file_name -OutFile node_installer.msi
        Start-Process 'msiexec.exe' -ArgumentList '/i', 'node_installer.msi', '/passive' -Wait
        Remove-Item 'node_installer.msi'

        if ((Test-Path "$expected_node_path\node.exe") -And (Test-Path "$expected_node_path\nodevars.bat")) {
            Start-Process "$expected_node_path\nodevars.bat" -Wait
            Write-Host "Adding to system PATH: '$expected_node_path'"
            [Environment]::SetEnvironmentVariable("Path", "$env:Path;$expected_node_path", [EnvironmentVariableTarget]::Machine)
        }
    Write-Host "Finished"
}

Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
