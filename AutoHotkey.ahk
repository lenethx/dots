;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;C+Space window on top
^SPACE:: Winset, Alwaysontop, , A

;C+Esc window transparent
^+Space::
  WinGet, TransLevel, Transparent, A
  If (TransLevel = OFF) {
    WinSet, Transparent, 180, A
  } Else {
    WinSet, Transparent, OFF, A
  }

^Capslock:: 
    If GetKeyState("CapsLock","T") {
    SetCapsLockState Off
  } Else {
    SetCapsLockState On
  }

;Capslock escape or control
*Capslock::
    Send {Blind}{LControl down}
    return

*Capslock up::
    Send {Blind}{LControl up}
    ; Tooltip, %A_PRIORKEY%
    ; SetTimer, RemoveTooltip, 1000
    if A_PRIORKEY = CapsLock
    {
        	Send {Esc}
    }
    return




RemoveTooltip(){
    SetTimer, RemoveTooltip, Off
    Tooltip
    return
}

ToggleCaps(){
    ; this is needed because by default, AHK turns CapsLock off before doing Send
    SetStoreCapsLockMode, Off
    Send {CapsLock}
    SetStoreCapsLockMode, On
    return
}
LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

; ^!r::Reload


;loop
;{
;	loop,500
;	{
;		Sleep, 770 ; ms
;		ControlClick,,Minecraft 1.12.2,,R,,NA,,
;	}
;;;;;;	ControlClick,,Minecraft 1.12.2,,WU,,NA,,
;}
;!x::ExitApp