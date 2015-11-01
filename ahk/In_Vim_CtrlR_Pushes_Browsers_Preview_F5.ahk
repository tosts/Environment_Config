#SingleInstance force

#IfWinActive ahk_class Vim
^r::
  WinActivate localhost:9000
  Send, {F5}
  WinActivate ahk_class Vim
Return
#IfWinActive
