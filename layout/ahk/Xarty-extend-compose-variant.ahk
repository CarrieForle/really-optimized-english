#Requires AutoHotkey >= 2
A_MaxHotkeysPerInterval := 150
A_HotkeyInterval := 1000
SetMouseDelay 1
SetDefaultMouseSpeed 2
SetKeyDelay -1
ProcessSetPriority "A"
FileEncoding "UTF-8" ; https://www.autohotkey.com/docs/v2/lib/File.htm#Encoding

; extendKey := "CapsLock"
; extendLayer1Key := "Shift"
; extendLayer2Key := "Ctrl"
intervalAllowedForComposeValidation := 5000,
intervalAllowedForExtendLayerActivation := 150,
timeSinceExtendPrestart := -intervalAllowedForExtendLayerActivation - 1,
modifierHotKey := ""
globalSendMode := "Input"


if FileExist("compose.txt") == ""
{
	FileAppend "
	(
	; This file is used to create compose key pairs
	; For details and specification, refer to https://github.com/CarrieForle/xarty/wiki/Xarty-with-AHK#composetxt
	
	=btw=By the way
	=name=CarrieForle
	=lol=(ﾟ∀。)
	)", "compose.txt"
}

wordList := Array()
wordList.Length := wordList.Capacity := 10

loop wordList.Length
	wordList[A_Index] := Map()

Loop Read "compose.txt"
{
	if A_LoopReadLine == ""
		continue
	delimiterChar := SubStr(A_LoopReadLine, 1, 1)
	if delimiterChar == ";" ||
	delimiterChar == "`n" ||
	delimiterChar == A_Tab ||
	delimiterChar == A_Space
		continue
	keypair := StrSplit(A_LoopReadLine, delimiterChar,, 3)
	if keypair.Length < 3 || keypair[2] == "" ||keypair[3] == ""
	{
		if "No" == MsgBox(A_LoopReadLine " is not a valid compose keypair.`n`nClick `"Yes`" to cuntinue and ignore this keypair.`nClick `"No`" to terminate the script.", "Error in compose.txt", 4)
			ExitApp
	}
	else if StrLen(keypair[2]) > 10
	{
		if "No" == MsgBox(A_LoopReadLine " is too long for a key (> 10).`n`nClick `"Yes`" to cuntinue and ignore this keypair.`nClick `"No`" to terminate the script.", "Error in compose.txt", 4)
			ExitApp
	}
	else
	{
		wordList[11 - StrLen(keypair[2])].Set(keypair[2], keypair[3])
	}
}

VarSetStrCapacity &keypair, 0

if GetKeyState("CapsLock", "T")
	SetCapsLockState "AlwaysOn"
else
	SetCapsLockState "AlwaysOff"

#InputLevel 1
#HotIf GetKeyState("CapsLock", "P")
Shift & Ctrl::
Ctrl & Shift::
{
	SendEvent "{vk3c Up}{vk3d Up}{vk3e Down}"
	KeyWait "CapsLock"
}

#HotIf modifierHotKey == "Shift up" && A_TickCount - timeSinceExtendPrestart <= intervalAllowedForExtendLayerActivation
CapsLock::
{
	SendEvent "{vk3c Up}{vk3d Down}{vk3e Up}"
	KeyWait "CapsLock"
}

#HotIf modifierHotKey == "Ctrl up" && A_TickCount - timeSinceExtendPrestart <= intervalAllowedForExtendLayerActivation
CapsLock::
{
	SendEvent "{vk3c Up}{vk3d Down}{vk3e Up}"
	KeyWait "CapsLock"
}

#HotIf !GetKeyState("CapsLock", "P")
Ctrl up::
Shift up::
{
	global
	timeSinceExtendPrestart := A_TickCount,
	modifierHotKey := ThisHotKey
}

#HotIf
CapsLock & Shift::
+CapsLock::
{
	SendEvent "{vk3c Down}{vk3d Up}{vk3e Up}"
	KeyWait "CapsLock"
}

CapsLock & Ctrl::
^CapsLock::
{
	SendEvent "{vk3c Up}{vk3d Down}{vk3e Up}"
	KeyWait "CapsLock"
}

^+CapsLock::
~*CapsLock up::
{
	SendEvent "{vk3c Up}{vk3d Up}{vk3e Up}"
}

CapsLock::
{
	SendEvent "{vk3c Up}{vk3d Up}{vk3e Down}"
	s := SubStr(ih.Input, -5)
	Loop Parse s
	{
		SendInput "{" A_LoopField " up}"
	}
	KeyWait "CapsLock"
}

#SuspendExempt
#Hotif A_IsSuspended
CapsLock::CapsLock ; for CapsLock to be toggleable while suspending
#HotIf
RAlt & LAlt::
LAlt & RAlt::Suspend -1
^+sc006::
{
	SendEvent "{vk3c Up}{vk3d Up}{vk3e Up}"
	Reload
}
^+sc029::ExitApp
#SuspendExempt false
#InputLevel 0
#HotIf

HoldKey(key) {
	SendInput "{Blind}{" key " DownR}"
	KeyWait key, "L"
}

HoldKeyNormal(key) {
	SendInput "{Blind}{" key " Down}"
	KeyWait key, "L"
}

SSend(key) {
	SendMode globalSendMode
	Send "{Blind}{" key " DownR}"
}

vk3c & sc002::!
vk3c & sc003::@
vk3c & sc004::#
vk3c & sc005::$
vk3c & sc006::%
vk3c & sc007::^
vk3c & sc008::Numpad7
vk3c & sc009::Numpad8
vk3c & sc00a::Numpad9
vk3c & sc00b::NumpadMult
vk3c & sc00c::NumpadSub
vk3c & sc00d::=
vk3c & sc010::Home
vk3c & sc011::Up
vk3c & sc012::End
vk3c & sc013::Del
vk3c & sc014::Esc
vk3c & sc015::PgUp
vk3c & sc016::Numpad4
vk3c & sc017::Numpad5
vk3c & sc018::Numpad6
vk3c & sc019::NumpadAdd
vk3c & sc01a::(
vk3c & sc01b::)
vk3c & sc02b::,
vk3c & sc01e::Left
vk3c & sc01f::Down
vk3c & sc020::Right
vk3c & sc021::Backspace
vk3c & sc022::NumLock
vk3c & sc023::PgDn
vk3c & sc024::Numpad1
vk3c & sc025::Numpad2
vk3c & sc026::Numpad3
vk3c & sc027::NumpadEnter
vk3c & sc028::'
;'
vk3c & sc02c::^z
vk3c & sc02d::^x
vk3c & sc02e::^c
vk3c & sc02f::^v
vk3c & sc030::LButton
vk3c & sc031:::
vk3c & sc032::Numpad0
vk3c & sc033::Numpad0
vk3c & sc034::NumpadDot
vk3c & sc035::NumpadDiv

vk3d & sc029::
vk3d & sc002::
vk3d & sc003::
vk3d & sc004::
vk3d & sc005::
vk3d & sc006::
vk3d & sc007::
vk3d & sc008::
vk3d & sc009::
vk3d & sc00a::
vk3d & sc00b::
vk3d & sc00c::
vk3d & sc00d::return
vk3d & sc010::[
vk3d & sc011::]
vk3d & sc012::~
vk3d & sc013::
vk3d & sc014::
vk3d & sc015::return
vk3d & sc016::'
;'
vk3d & sc017::"
;"
vk3d & sc018::\
vk3d & sc019::
vk3d & sc01a::
vk3d & sc01b::
vk3d & sc02b::return
vk3d & sc01e::(
vk3d & sc01f::)
vk3d & sc020::`
vk3d & sc021::
vk3d & sc022::
vk3d & sc023::return
vk3d & sc024::`{
vk3d & sc025::}
vk3d & sc026::%
vk3d & sc027::!
vk3d & sc028::return
vk3d & sc02c::&
vk3d & sc02d::|
vk3d & sc02e::*
vk3d & sc02f::
vk3d & sc030::
vk3d & sc031::return
vk3d & sc032::+
vk3d & sc033::-
vk3d & sc034::=
vk3d & sc035::return

vk3e & Esc::CapsLock
vk3e & F1::HoldKey "Media_Play_Pause"
vk3e & F1 up::Send "{blind}{Media_Play_Pause Up}"
vk3e & F2::HoldKey "Media_Prev"
vk3e & F2 up::Send "{blind}{Media_Prev Up}"
vk3e & F3::HoldKey "Media_Next"
vk3e & F3 up::Send "{blind}{Media_Next Up}"
vk3e & F4::HoldKey "Media_Stop"
vk3e & F4 up::Send "{blind}{Media_Stop Up}"
vk3e & F5::HoldKey "Volume_Mute"
vk3e & F5 up::Send "{blind}{Volume_Mute Up}"
vk3e & F6::Volume_Down
vk3e & F7::Volume_Up
vk3e & F8::HoldKey "Launch_Media"
vk3e & F8 up::Send "{blind}{Launch_Media Up}"

vk3e & sc029::SendEvent "{Click 16 96 0}"
vk3e & sc002::F1
vk3e & sc003::F2
vk3e & sc004::F3
vk3e & sc005::F4
vk3e & sc006::F5
vk3e & sc007::F6
vk3e & sc008::F7
vk3e & sc009::F8
vk3e & sc00a::F9
vk3e & sc00b::F10
vk3e & sc00c::F11
vk3e & sc00d::F12

vk3e & sc010::Esc
vk3e & sc011::WheelUp
vk3e & sc012::Browser_Back
vk3e & sc013::Browser_Forward
vk3e & sc014::SendInput "{Click 0 -20 0 Rel}"
vk3e & sc015::PgUp
vk3e & sc016::Home
vk3e & sc017::Up
vk3e & sc018::End
vk3e & sc019::Del
vk3e & sc01a::WheelLeft
vk3e & sc01b::WheelRight

vk3e & sc01e::Alt
vk3e & sc01f::WheelDown
vk3e & sc020::Shift
vk3e & sc021::Ctrl
vk3e & sc022::SendInput "{Click 0 20 0 Rel}"
vk3e & sc023::PgDn
vk3e & sc024::Left
vk3e & sc025::Down
vk3e & sc026::Right
vk3e & sc027::BackSpace
vk3e & sc028::HoldKey "AppsKey"
vk3e & sc028 up::Send "{blind}{AppsKey Up}"

vk3e & sc02c::^z
vk3e & sc02d::^x
vk3e & sc02e::^c
vk3e & sc02f::^v
vk3e & sc030::Ins

vk3e & sc031::LButton
vk3e & sc032::MButton
vk3e & sc033::RButton
vk3e & sc034::SendInput "{Click -42 0 0 Rel}"
vk3e & sc035::SendInput "{Click 42 0 0 Rel}"

vk3e & Enter::^BackSpace
vk3e & Space::Enter

; sc029::`
; sc002::1
; sc003::2
; sc004::3
; sc005::4
; sc006::5
; sc007::6
; sc008::7
; sc009::8
; sc00a::9
; sc00b::0
; sc00c::-
; sc00d::=
; sc010::v
; sc011::h
; sc012::s
; sc013::g
; sc014::b
; sc015::j
; sc016::m
; sc017::o
; sc018::u
; sc019::;
; sc01a::[
; sc01b::]
; sc02b::\
; sc01e::x
; sc01f::a
; sc020::r
; sc021::t
; sc022::y
; sc023::k
; sc024::n
; sc025::e
; sc026::i
; sc027::w
; sc028::'

; sc02c::z
; sc02d::f
; sc02e::l
; sc02f::d
; sc030::q
; sc031::c
; sc032::p
; sc033::,
; sc034::.
; sc035::/

*sc029::
{
	SSend "``"
}
*sc029 up::Send "{`` up}"
*sc002::
{
	SSend "1"
}
*sc002 up::Send "{1 up}"
*sc003::
{
	SSend "2"
}
*sc003 up::Send "{2 up}"
*sc004::
{
	SSend "3"
}
*sc004 up::Send "{3 up}"
*sc005::
{
	SSend "4"
}
*sc005 up::Send "{4 up}"
*sc006::
{
	SSend "5"
}
*sc006 up::Send "{5 up}"
*sc007::
{
	SSend "6"
}
*sc007 up::Send "{6 up}"
*sc008::
{
	SSend "7"
}
*sc008 up::Send "{7 up}"
*sc009::
{
	SSend "8"
}
*sc009 up::Send "{8 up}"
*sc00a::
{
	SSend "9"
}
*sc00a up::Send "{9 up}"
*sc00b::
{
	SSend "0"
}
*sc00b up::Send "{0 up}"
*sc00c::
{
	SSend "-"
}
*sc00c up::Send "{- up}"
*sc00d::
{
	SSend "="
}
*sc00d up::Send "{= up}"
*sc010::
{
	SSend "v"
}
*sc010 up::Send "{v up}"
*sc011::
{
	SSend "h"
}
*sc011 up::Send "{h up}"
*sc012::
{
	SSend "s"
}
*sc012 up::Send "{s up}"
*sc013::
{
	SSend "g"
}
*sc013 up::Send "{g up}"
*sc014::
{
	SSend "b"
}
*sc014 up::Send "{b up}"
*sc015::
{
	SSend "j"
}
*sc015 up::Send "{j up}"
*sc016::
{
	SSend "m"
}
*sc016 up::Send "{m up}"
*sc017::
{
	SSend "o"
}
*sc017 up::Send "{o up}"
*sc018::
{
	SSend "u"
}
*sc018 up::Send "{u up}"
*sc019::
{
	SSend ";"
}
*sc019 up::Send "{; up}"
*sc01a::
{
	SSend "["
}
*sc01a up::Send "{[ up}"
*sc01b::
{
	SSend "]"
}
*sc01b up::Send "{] up}"
*sc02b::
{
	SSend "\"
}
*sc02b up::Send "{\ up}"
*sc01e::
{
	SSend "x"
}
*sc01e up::Send "{x up}"
*sc01f::
{
	SSend "a"
}
*sc01f up::Send "{a up}"
*sc020::
{
	SSend "r"
}
*sc020 up::Send "{r up}"
*sc021::
{
	SSend "t"
}
*sc021 up::Send "{t up}"
*sc022::
{
	SSend "y"
}
*sc022 up::Send "{y up}"
*sc023::
{
	SSend "k"
}
*sc023 up::Send "{k up}"
*sc024::
{
	SSend "n"
}
*sc024 up::Send "{n up}"
*sc025::
{
	SSend "e"
}
*sc025 up::Send "{e up}"
*sc026::
{
	SSend "i"
}
*sc026 up::Send "{i up}"
*sc027::
{
	SSend "w"
}
*sc027 up::Send "{w up}"
*sc028::
{
	SSend "'"
}
*sc028 up::Send "{' up}"
;'
*sc02c::
{
	SSend "z"
}
*sc02c up::Send "{z up}"
*sc02d::
{
	SSend "f"
}
*sc02d up::Send "{f up}"
*sc02e::
{
	SSend "l"
}
*sc02e up::Send "{l up}"
*sc02f::
{
	SSend "d"
}
*sc02f up::Send "{d up}"
*sc030::
{
	SSend "q"
}
*sc030 up::Send "{q up}"
*sc031::
{
	SSend "c"
}
*sc031 up::Send "{c up}"
*sc032::
{
	SSend "p"
}
*sc032 up::Send "{p up}"
*sc033::
{
	SSend ","
}
*sc033 up::Send "{, up}"
*sc034::
{
	SSend "."
}
*sc034 up::Send "{. up}"
*sc035::
{
	SSend "/"
}
*sc035 up::Send "{/ up}"


ih := InputHook("V L13", "{Left}{Up}{Right}{Down}{Home}{End}{PgUp}{PgDn}")

*RWin::
{
	if ih.InProgress
	{
		onKeyDown(ih, 0x5c, 0x15c)
	}
	else
	{
		ih.Start()
		global globalSendMode := "Event"
	}
}

~Backspace::
~+Backspace::
{
	static backspaceCounter := 0
	if ih.Input == ""
	{
		if backspaceCounter > 3
		{
			ih.Stop()
			backspaceCounter := 0
		}
		else
		{
			backspaceCounter++
		}
	}			
}
~!Backspace::
~*^Backspace::
{
	ih.Stop()
}

onChar(ih, ch)
{
	static helper := () => ih.Stop()
	SetTimer helper, intervalAllowedForComposeValidation
}

onKeyDown(ih, vk, sc)
{
	globalSendMode := "Input"
	if StrLen(ih.Input) <= 10
	{
		for words in wordList
		{
			for key, val in words
			{
				if key == SubStr(ih.Input, -StrLen(key))
				{
					ih.Stop()
					SendInput "{Backspace " StrLen(key) "}"
					SendText val
					if vk != 0x5c
						SendInput Format("`{vk{:x}}", vk)
					return
				}
			}
		}
	}
	ih.Stop()
	if vk != 0x5c
		SendInput Format("`{vk{:x}}", vk)
}

ih.OnChar := onChar
ih.OnKeyDown := onKeyDown
ih.KeyOpt("{Enter} ", "ISN")
; ih.OnEnd := (ih) => MsgBox("InputHook end `n" ih.Input "endofline")