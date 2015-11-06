#SingleInstance force

#m::WinMinimize, A

#x::
  WinGet, maximizedState, MinMax, A
  If maximizedState = 1
    WinRestore, A
  else
    WinMaximize, A
Return
