Import-Module PSReadLine
Set-PSReadlineKeyHandler -Key Ctrl+P -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Ctrl+N -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Ctrl+B -Function BackwardChar
Set-PSReadlineKeyHandler -Key Ctrl+F -Function ForwardChar

Set-PSReadlineKeyHandler -Key Ctrl+D -Function DeleteChar
Set-PSReadlineKeyHandler -Key Ctrl+A -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+K -Function ForwardDeleteLine

Set-PSReadlineKeyHandler -Key Alt+F -Function ForwardWord
Set-PSReadlineKeyHandler -Key Alt+B -Function BackwardWord

Set-Alias make gmake.exe
Set-Alias groovy groovy.bat
Set-Alias gsh groovysh.bat
Set-Alias which Get-Command
Set-Alias mvn mvn.bat
Set-Alias android android.bat
Set-Alias ll Get-ChildItem
