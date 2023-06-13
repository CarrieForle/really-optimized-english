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
intervalAllowedForComposeValidation := 2000,
timeSinceLastKey := -intervalAllowedForComposeValidation - 1,
intervalAllowedForExtendLayerActivation := 150,
timeSinceExtendPrestart := -intervalAllowedForExtendLayerActivation - 1,
isEnteringExtendLayer1 := false,
isEnteringExtendLayer2 := false

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

#SuspendExempt
#Hotif A_IsSuspended
CapsLock::CapsLock ; for CapsLock to be toggleabde while suspending
#HotIf
RAlt & LAlt::
LAlt & RAlt::Suspend -1
^+5::Reload
^+`::ExitApp
#SuspendExempt false

if GetKeyState("CapsLock", "T")
	SetCapsLockState "AlwaysOn"
else
	SetCapsLockState "AlwaysOff"

#HotIf GetKeyState("CapsLock")
Shift & Ctrl::
Ctrl & Shift::
{
	global
	isEnteringExtendLayer1 := false,
	isEnteringExtendLayer2 := false
}

#HotIf !GetKeyState("Ctrl")
CapsLock & Shift::
+CapsLock::
{
	global
	isEnteringExtendLayer1 := true,
	isEnteringExtendLayer2 := false
}

#HotIf (A_PriorKey == "LShift" || A_PriorKey == "RShift") && A_TickCount - timeSinceExtendPrestart <= intervalAllowedForExtendLayerActivation
CapsLock::
{
	global
	isEnteringExtendLayer1 := true,
	isEnteringExtendLayer2 := false
}

#HotIf !GetKeyState("Shift")
CapsLock & Ctrl::
^CapsLock::
{
	global
	isEnteringExtendLayer1 := false,
	isEnteringExtendLayer2 := true
}

#HotIf (A_PriorKey == "LControl" || A_PriorKey == "RControl") && A_TickCount - timeSinceExtendPrestart <= intervalAllowedForExtendLayerActivation
CapsLock::
{
	global
	isEnteringExtendLayer1 := false,
	isEnteringExtendLayer2 := true
}

#HotIf
^+CapsLock::
~*CapsLock up::
{
	global
	isEnteringExtendLayer1 := false,
	isEnteringExtendLayer2 := false
}

Ctrl::
Shift::global timeSinceExtendPrestart := A_TickCount

sc029::`
sc002::1
sc003::2
sc004::3
sc005::4
sc006::5
sc007::6
sc008::7
sc009::8
sc00a::9
sc00b::0
sc00c::-
sc00d::=
sc010::v
sc011::h
sc012::s
sc013::g
sc014::b
sc015::j
sc016::m
sc017::o
sc018::u
sc019::;
sc01a::[
sc01b::]
sc02b::\
sc01e::x
sc01f::a
sc020::r
sc021::t
sc022::y
sc023::k
sc024::n
sc025::e
sc026::i
sc027::w
sc028::'
;'
sc02c::z
sc02d::f
sc02e::l
sc02f::d
sc030::q
sc031::c
sc032::p
sc033::,
sc034::.
sc035::/

HoldKey(key) {
	if !GetKeyState(key)
		Send "{Blind}{" key " DownR}"
}

#HotIf !isEnteringExtendLayer1 && !isEnteringExtendLayer2

CapsLock & Esc::CapsLock
CapsLock & F1::HoldKey "Media_Play_Pause"
CapsLock & F1 up::Send "{blind}{Media_Play_Pause Up}"
CapsLock & F2::HoldKey "Media_Prev"
CapsLock & F2 up::Send "{blind}{Media_Prev Up}"
CapsLock & F3::HoldKey "Media_Next"
CapsLock & F3 up::Send "{blind}{Media_Next Up}"
CapsLock & F4::HoldKey "Media_Stop"
CapsLock & F4 up::Send "{blind}{Media_Stop Up}"
CapsLock & F5::HoldKey "Volume_Mute"
CapsLock & F5 up::Send "{blind}{Volume_Mute Up}"
CapsLock & F6::Volume_Down
CapsLock & F7::Volume_Up
CapsLock & F8::HoldKey "Launch_Media"
CapsLock & F8 up::Send "{blind}{Launch_Media Up}"

CapsLock & sc029::SendEvent "{Click 16 96 0}"
CapsLock & sc002::F1
CapsLock & sc003::F2
CapsLock & sc004::F3
CapsLock & sc005::F4
CapsLock & sc006::F5
CapsLock & sc007::F6
CapsLock & sc008::F7
CapsLock & sc009::F8
CapsLock & sc00a::F9
CapsLock & sc00b::F10
CapsLock & sc00c::F11
CapsLock & sc00d::F12

CapsLock & sc010::Esc
CapsLock & sc011::WheelUp
CapsLock & sc012::Browser_Back
CapsLock & sc013::Browser_Forward
CapsLock & sc014::MouseMove 0, -20,, "R"
CapsLock & sc015::PgUp
CapsLock & sc016::Home
CapsLock & sc017::Up
CapsLock & sc018::End
CapsLock & sc019::Del
CapsLock & sc01a::WheelLeft
CapsLock & sc01b::WheelRight

CapsLock & sc01e::Alt
CapsLock & sc01f::WheelDown
CapsLock & sc020::Shift
CapsLock & sc021::Ctrl
CapsLock & sc022::MouseMove 0, 20,, "R"
CapsLock & sc023::PgDn
CapsLock & sc024::Left
CapsLock & sc025::Down
CapsLock & sc026::Right
CapsLock & sc027::BackSpace
CapsLock & sc028::HoldKey "AppsKey"
CapsLock & sc028 up::Send "{blind}{AppsKey Up}"

CapsLock & sc02c::^z
CapsLock & sc02d::^x
CapsLock & sc02e::^c
CapsLock & sc02f::^v
CapsLock & sc030::Ins

CapsLock & sc031::LButton
CapsLock & sc032::MButton
CapsLock & sc033::RButton
CapsLock & sc034::MouseMove -42, 0,, "R"
CapsLock & sc035::MouseMove 42, 0,, "R"

CapsLock & Enter::^BackSpace
CapsLock & Space::Enter

#HotIf isEnteringExtendLayer1
sc002::!
sc003::@
sc004::#
sc005::$
sc006::%
sc007::^
sc008::Numpad7
sc009::Numpad8
sc00a::Numpad9
sc00b::NumpadMult
sc00c::NumpadSub
sc00d::=
sc010::Home
sc011::Up
sc012::End
sc013::Del
sc014::Esc
sc015::PgUp
sc016::Numpad4
sc017::Numpad5
sc018::Numpad6
sc019::NumpadAdd
sc01a::(
sc01b::)
sc02b::,
sc01e::Left
sc01f::Down
sc020::Right
sc021::Backspace
sc022::NumLock
sc023::PgDn
sc024::Numpad1
sc025::Numpad2
sc026::Numpad3
sc027::NumpadEnter
sc028::'
;'
sc02c::^z
sc02d::^x
sc02e::^c
sc02f::^v
sc030::LButton
sc031:::
sc032::Numpad0
sc033::Numpad0
sc034::NumpadDot
sc035::NumpadDiv

#HotIf isEnteringExtendLayer2
sc029::return
sc002::return
sc003::return
sc004::return
sc005::return
sc006::return
sc007::return
sc008::return
sc009::return
sc00a::return
sc00b::return
sc00c::return
sc00d::return
sc010::[
sc011::]
sc012::~
sc013::return
sc014::return
sc015::return
sc016::'
;'
sc017::"
;"
sc018::\
sc019::return
sc01a::return
sc01b::return
sc02b::return
sc01e::(
sc01f::)
sc020::`
sc021::return
sc022::return
sc023::return
sc024::`{
sc025::}
sc026::%
sc027::!
sc028::return
sc02c::&
sc02d::|
sc02e::*
sc02f::return
sc030::return
sc031::return
sc032::+
sc033::-
sc034::=
sc035::return

#HotIf
oldBuffer := ""
ih := InputHook("V L10", "{Left}{Right}{Home}{End}")

*RWin::
{	
	if A_PriorHotKey !== ThisHotKey
		onKeyDown(ih, 0x5c, 0x15c)
}

~Backspace::
~+Backspace::
{
	global oldBuffer
	if ih.Input == "" && oldBuffer != ""
		oldBuffer := SubStr(oldBuffer, 1, StrLen(oldBuffer) - 1)
}
~!Backspace::
~^Backspace::
{
	if A_PriorHotKey != "~!Backspace" && A_PriorHotKey != "~^Backspace"
	{
		ih.Stop()
		ih.Start()
	}
}

onChar(ih, ch)
{
	global timeSinceLastKey := A_TickCount
}

onKeyDown(ih, vk, sc)
{
	global timeSinceLastKey
	
	if A_TickCount - timeSinceLastKey > intervalAllowedForComposeValidation
	{
		ih.Stop()
		ih.Start()
	}
	
	else if A_TickCount - timeSinceLastKey <= intervalAllowedForComposeValidation
	{
		inpBuffer := oldBuffer . ih.Input
		for words in wordList
		{
			for key, val in words
			{
				if key == SubStr(inpBuffer, -StrLen(key))
				{
					ih.Stop()
					Send "{Backspace " StrLen(key) "}"
					SendText val
					ih.Start()
					return
				}
			}
		}
	}
}

onEnd(ih)
{
	global oldBuffer
	if ih.EndReason == "Max"
	{
		oldBuffer := ih.Input
		ih.Start()
	}
	else
	{
		oldBuffer := ""
	}
}

ih.OnKeyDown := onKeyDown,
ih.OnEnd := onEnd,
ih.OnChar := onChar
ih.Start()
