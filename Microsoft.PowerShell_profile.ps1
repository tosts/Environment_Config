Import-Module PSReadLine
Import-Module PSake
Set-PSReadlineKeyHandler -Key Ctrl+P -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Ctrl+N -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Ctrl+B -Function BackwardChar
Set-PSReadlineKeyHandler -Key Ctrl+F -Function ForwardChar

Set-PSReadlineKeyHandler -Key Ctrl+D -Function DeleteChar
Set-PSReadlineKeyHandler -Key Ctrl+A -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+E -Function EndOfLine
Set-PSReadlineKeyHandler -Key Ctrl+K -Function ForwardDeleteLine
Set-PSReadlineKeyHandler -Key Ctrl+W -Function BackwardKillWord

Set-PSReadlineKeyHandler -Key Alt+F -Function ForwardWord
Set-PSReadlineKeyHandler -Key Alt+B -Function BackwardWord
Set-PSReadlineKeyHandler -Key Alt+D -Function KillWord
Set-PSReadlineKeyHandler -Key Alt+Backspace -Function BackwardKillWord

Set-Alias psake Invoke-PSake
Remove-Item alias:\ps
Set-Alias ps Invoke-PSake
Set-Alias make gmake.exe
Set-Alias groovy groovy.bat
Set-Alias groovysh groovysh.bat
Set-Alias gsh groovysh.bat
Set-Alias gradle gradle.bat
Set-Alias which Get-Command
Set-Alias mvn mvn.bat
Set-Alias android android.bat
Set-Alias ll Get-ChildItem
Set-Alias js node.exe
Set-Alias gti git
Set-Alias g git
Set-Alias jshint jshint.cmd
Set-Alias jsxhint jshint.cmd
Set-Alias coffee coffee.cmd
Set-Alias cake cake.cmd


$OrigBgColor = $host.ui.rawui.BackgroundColor
$OrigFgColor = $host.ui.rawui.ForegroundColor
function Reset-Colors {
    $host.ui.rawui.BackgroundColor = $OrigBgColor
    $host.ui.rawui.ForegroundColor = $OrigFgColor
}
Function npm {
    npm.cmd $args
    Reset-Colors
}
Function node {
    node.exe $args
    Reset-Colors
}
Function gr {
    grunt $args
    Reset-Colors
}
Function c {
    cake.cmd $args
    Reset-Colors
}
Function cs {
    cd C:\Users\Tris\C2Development\TMXServer\
}
Function ck {
    cd C:\Users\Tris\Work\KnowledgeBase\
}
Function cdh {
  cd $HOME
}

function Expand-ZipFile
{
    param ($File, $Destination)
    $shell = new-object -com shell.application
    $zip = $shell.Namespace($File)
    foreach($item in $zip.items())
    {
        $shell.Namespace($Destination).copyhere($item)
    }
}
