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

Set-PSReadlineKeyHandler -Key Alt+F -Function ForwardWord
Set-PSReadlineKeyHandler -Key Alt+B -Function BackwardWord
Set-PSReadlineKeyHandler -Key Alt+D -Function KillWord
Set-PSReadlineKeyHandler -Key Alt+Backspace -Function BackwardKillWord

Set-Alias psake Invoke-PSake
Remove-Item alias:\ps
Set-Alias ps Invoke-PSake
Set-Alias make gmake.exe
Set-Alias groovy groovy.bat
Set-Alias gsh groovysh.bat
Set-Alias which Get-Command
Set-Alias mvn mvn.bat
Set-Alias android android.bat
Set-Alias ll Get-ChildItem
Set-Alias js node.exe
Set-Alias node node.exe
Set-Alias gti git
Set-Alias jshint jshint.cmd
Set-Alias jsxhint jshint.cmd


$OrigBgColor = $host.ui.rawui.BackgroundColor
$OrigFgColor = $host.ui.rawui.ForegroundColor
function Reset-Colors {
    $host.ui.rawui.BackgroundColor = $OrigBgColor
    $host.ui.rawui.ForegroundColor = $OrigFgColor
}
Function mocha {
    mocha.cmd $args
    Reset-Colors
}
Function npm {
    npm.cmd $args
    Reset-Colors
}
