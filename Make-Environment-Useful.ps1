$VerbosePreference = "Continue"

# For user _and_ admin

if (-Not (Get-Module PSReadLine)) {
    (New-Object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression
    Install-Module PSReadLine
}

if (-Not (Get-Module PSake)) {
    New-Item -type directory "$env:USERPROFILE\Documents\WindowsPowerShell\modules\PSake"
    (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/psake/psake/master/psake.psm1") | `
        New-Item -Type file "$env:USERPROFILE\Documents\WindowsPowerShell\modules\PSake\PSake.psm1"
}

if (Test-Path "$PSScriptRoot\Microsoft.PowerShell_profile.ps1") {
    Write-Verbose "Updating PowerShell profile."
    Copy-Item "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" "$env:USERPROFILE\Documents\WindowsPowerShell"
    Unblock-File "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
}

if (-Not ($env:PATH -Split ';' | `
        Select-String ([Regex]::Escape("$env:USERPROFILE\AppData\Roaming\npm"))
   )) {
    [Environment]::SetEnvironmentVariable("Path",         `
        "$env:Path;$env:USERPROFILE\AppData\Roaming\npm", `
        [EnvironmentVariableTarget]::User)
}
if (-Not ($env:PATH -Split ';' | `
        Select-String ([Regex]::Escape("$env:USERPROFILE\AppData\Local\Programs\Git\bin"))
   ) -And (Test-Path "$env:USERPROFILE\AppData\Local\Programs\Git\bin")) {
    [Environment]::SetEnvironmentVariable("Path",         `
        "$env:Path;$env:USERPROFILE\AppData\Local\Programs\Git\bin", `
        [EnvironmentVariableTarget]::User)
}

if (-Not $env:HOME) {
    Write-Verbose 'Ensuring existence of $env:HOME'
    [Environment]::SetEnvironmentVariable("HOME",`
        "$env:USERPROFILE",                      `
        [EnvironmentVariableTarget]::User)
}
if (-Not $env:TEMP) {
    Write-Verbose 'Ensuring existence of $env:TEMP'
    [Environment]::SetEnvironmentVariable("TEMP",`
        "$env:USERPROFILE\AppData\Local\Temp",   `
        [EnvironmentVariableTarget]::User)
}
if (-Not $env:TMP) {
    Write-Verbose 'Ensuring existence of $env:TMP'
    [Environment]::SetEnvironmentVariable("TMP",`
        "$env:USERPROFILE\AppData\Local\Temp",  `
        [EnvironmentVariableTarget]::User)
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

#
# Helpers
#

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

#
# Software install stuff (probably happening in the admin context first)
#

$expected_mingw_path = "C:\MinGW64"
$install_mingw = $false #-Not (Test-Path "$expected_mingw_path\bin\g++.exe")

$expected_node_path = "C:\Program Files\nodejs"
$install_node = $false #-Not (Test-Path "$expected_node_path\node.exe")

$expected_gradle_path = "C:\Gradle"
$install_gradle = $false #-Not (Test-Path "$expected_gradle_path\*\bin\gradle.bat")

if ($install_mingw) {
    Write-Verbose "Fetching for installation: mingw installer"
    Write-Verbose "Hint: Expected path '$expected_mingw_path'"
        Invoke-Webrequest 'http://win-builds.org/1.5.0/win-builds-1.5.0.exe' -OutFile mingw_installer.exe
        Start-Process 'mingw_installer.exe' -Wait
        Remove-Item 'mingw_installer.exe'

        if (Test-Path "$expected_mingw_path\bin") {
            Write-Verbose "Adding to system PATH: '$expected_mingw_path\bin'"
            [Environment]::SetEnvironmentVariable("Path", "$env:Path;$expected_mingw_path\bin",`
                [EnvironmentVariableTarget]::Machine)
        }
    Write-Verbose "Finished"
}

if ($install_node) {
    Write-Verbose "Fetching for installation: node installer"
        $node_latest_downloads = 'http://nodejs.org/dist/latest/x64/'
        $msi_file_name = ((Invoke-Webrequest $node_latest_downloads).Content `
                -Split ' *<.*?> *', 0, "RegexMatch" |                        `
                Select-String -Pattern '^node-.*.msi$'                       `
            ).Line
        Invoke-Webrequest $node_latest_downloads$msi_file_name -OutFile node_installer.msi
        Start-Process 'msiexec.exe' -ArgumentList '/i', 'node_installer.msi', '/passive' -Wait
        Remove-Item 'node_installer.msi'

        if (Test-Path "$expected_node_path\node.exe") {
            Write-Verbose "Adding to system PATH: '$expected_node_path'"
            [Environment]::SetEnvironmentVariable("Path", `
                "$env:Path;$expected_node_path",          `
                [EnvironmentVariableTarget]::Machine)
        }
    Write-Verbose "Finished"
}

if ($install_gradle) {
    Write-Verbose "Fetching for installation: gradle zip"
        $gradle_download = 'https://gradle.org/gradle-download/'
        $zip_url = ((Invoke-WebRequest $gradle_download).content | Select-String -Pattern 'https://.*?bin.zip').Matches.Value
        Invoke-Webrequest $zip_url -OutFile gradle.zip
        Unzip ".\gradle.zip" "C:\Gradle"
        Remove-Item 'gradle.zip'

        if (Test-Path "$expected_gradle_path\*\bin\gradle.bat") {
            Write-Verbose "Adding to system PATH: '$expected_gradle_path'"
            $subfolder = Get-ChildItem $expected_gradle_path
            [Environment]::SetEnvironmentVariable("Path",              `
                "$env:Path;$expected_gradle_path\$subfolder.name\bin", `
                [EnvironmentVariableTarget]::Machine)
        }
    Write-Verbose "Finished"
}

Write-Verbose "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
