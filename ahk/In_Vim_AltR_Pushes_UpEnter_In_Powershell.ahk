#SingleInstance force
SetTitleMatchMode 2

#IfWinActive ahk_class Vim
!r::
  WinActivate Windows PowerShell
  Send, {Up} {Enter}
  WinActivate ahk_class Vim
Return
#IfWinActive
