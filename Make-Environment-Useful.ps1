$install_mingw = $false;

# For user _and_ admin

(New-Object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression
Install-Module PSReadline

if (Test-Path 'Microsoft.PowerShell_profile.ps1') {
    Write-Host "Updating PowerShell profile."
    Copy-Item 'Microsoft.PowerShell_profile.ps1' "$env:HOMEDRIVE$env:HOMEPATH\Documents\WindowsPowerShell"
}

# Elevate & Restart
#
# Source: http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/09/23/a-self-elevating-powershell-script.aspx

$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=New-Object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($myWindowsPrincipal.IsInRole($adminRole)) {
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   Clear-Host
} else {
   $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);
   exit
}

if ($install_mingw) {
    Write-Host "Fetching for installation: mingw installer"
    Write-Host "Hint: Suggested path C:\MinGW64"
        Invoke-Webrequest http://win-builds.org/1.5-rc3/win-builds-1.5-rc3.exe -OutFile mingw_installer.exe
        $rc = (Start-Process "mingw_installer.exe" -Wait).ExitCode
        Remove-Item mingw_installer.exe
    Write-Host "Finished with exit code '$rc'"

    if (Test-Path 'C:\MinGW64\bin') {
        Write-Host "Adding to system PATH: 'C:\MinGW64\bin'"
        [Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\MinGW64\bin", [EnvironmentVariableTarget]::Machine)
    }
}

Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
