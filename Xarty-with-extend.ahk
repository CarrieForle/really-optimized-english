#Requires AutoHotkey >= 2
A_MaxHotkeysPerInterval := 150
A_HotkeyInterval := 1000
SetMouseDelay 1
SetDefaultMouseSpeed 2
SetKeyDelay -1
SendMode "Event"
ProcessSetPriority "A"
FileEncoding "UTF-8" ; https://www.autohotkey.com/docs/v2/lib/File.htm#Encoding

; extendKey := "CapsLock"
; extendLayer1Key := "Shift"
; extendLayer2Key := "Ctrl"

activatedExtendLayer1 := activatedExtendLayer2 := activatedExtendLayer3 := false
maximumComposeKeyLength := 20,
modifierHotKey := ""

if FileExist("xarty_config.ini") == ""
{
	FileAppend "
	(
	[xarty-global]

	; Upon the Compose sequence complete typing, 
	; the window for you to press Compose key
	; for the ranslation to begin. (in millisecond)
	
	; This property should be a positive integer, 
	; otherwise invalid.
	intervalAllowedForComposeValidation = 4800 

	; When you press and release a modifer key, 
	; the window for you to press extend key that
	; will still activate a extend layer. (in millisecond)
	
	; This property should be a positive integer, 
	; otherwise invalid.
	intervalAllowedForExtendLayerActivation = 250
	)", "xarty_config.ini", "UTF-16"
}

if FileExist("compose.txt") == ""
{
	FileAppend "
	(
	; This file is used to create compose key pairs
	; For details, specification, and guide of modification, refer to https://github.com/CarrieForle/xarty/wiki/Xarty-with-AHK#composetxt
	
	=btw=By the way
	=name=CarrieForle
	=lol=(ﾟ∀。)
	)", "compose.txt"
}

try
{
	intervalAllowedForComposeValidation := Integer(IniRead("xarty_config.ini", "xarty-global", "intervalAllowedForComposeValidation")),
	intervalAllowedForExtendLayerActivation := Integer(IniRead("xarty_config.ini", "xarty-global", "intervalAllowedForExtendLayerActivation"))
	
	if intervalAllowedForComposeValidation <= 0 || intervalAllowedForExtendLayerActivation <= 0
		throw ValueError("")
}
catch Error as e
{
	MsgBox e.Message . "Invalid properties found in xarty_config.ini.`nThe program will be terminated."
	ExitApp
}

timeSinceLastKey := -intervalAllowedForComposeValidation - 1,
timeSinceExtendPrestart := -intervalAllowedForExtendLayerActivation - 1,
wordList := Array(),
wordList.Length := wordList.Capacity := maximumComposeKeyLength

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
	else if StrLen(keypair[2]) > maximumComposeKeyLength
	{
		if "No" == MsgBox(A_LoopReadLine " is too long for a key (> 10).`n`nClick `"Yes`" to cuntinue and ignore this keypair.`nClick `"No`" to terminate the script.", "Error in compose.txt", 4)
			ExitApp
	}
	else
	{
		wordList[maximumComposeKeyLength - StrLen(keypair[2]) + 1].Set(keypair[2], keypair[3])
	}
}

VarSetStrCapacity &keypair, 0

if GetKeyState("CapsLock", "T")
	SetCapsLockState "AlwaysOn"
else
	SetCapsLockState "AlwaysOff"

#InputLevel 1

#HotIf modifierHotKey == "~Shift up" && A_TickCount - timeSinceExtendPrestart <= intervalAllowedForExtendLayerActivation
CapsLock::
{
	global
	activatedExtendLayer1 := false,
	activatedExtendLayer2 := true,
	activatedExtendLayer3 := false,
	KeyWait("CapsLock")
}

#HotIf modifierHotKey == "~Ctrl up" && A_TickCount - timeSinceExtendPrestart <= intervalAllowedForExtendLayerActivation
CapsLock::
{
	global
	activatedExtendLayer1 := false,
	activatedExtendLayer2 := false,
	activatedExtendLayer3 := true,
	KeyWait("CapsLock")
}

#HotIf !GetKeyState("CapsLock", "P")
~Ctrl up::
~Shift up::
{
	global
	timeSinceExtendPrestart := A_TickCount,
	modifierHotKey := ThisHotKey
}

#HotIf
CapsLock & Shift::
+CapsLock::
{
	global
	activatedExtendLayer1 := false,
	activatedExtendLayer2 := true,
	activatedExtendLayer3 := false,
	KeyWait("CapsLock")
}

CapsLock & Ctrl::
^CapsLock::
{
	global
	activatedExtendLayer1 := false,
	activatedExtendLayer2 := false,
	activatedExtendLayer3 := true,
	KeyWait("CapsLock")
}

^+CapsLock::
~CapsLock::
{
	global
	activatedExtendLayer1 := true,
	activatedExtendLayer2 := false,
	activatedExtendLayer3 := false,
	KeyWait("CapsLock")
}

~CapsLock up::
{
	global
	activatedExtendLayer1 := false,
	activatedExtendLayer2 := true,
	activatedExtendLayer3 := false
}

#SuspendExempt
#Hotif A_IsSuspended
CapsLock::CapsLock ; for CapsLock to be toggleabde while suspending
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

HoldKey(key) {
	SendInput "{Blind}{" key " DownR}"
	KeyWait key, "L"
}

HoldKeyNormal(key) {
	SendInput "{Blind}{" key " Down}"
	KeyWait key, "L"
}

#HotIf activatedExtendLayer1
Esc::CapsLock
F1::HoldKey "Media_Play_Pause"
F1 up::Send "{blind}{Media_Play_Pause Up}"
F2::HoldKey "Media_Prev"
F2 up::Send "{blind}{Media_Prev Up}"
F3::HoldKey "Media_Next"
F3 up::Send "{blind}{Media_Next Up}"
F4::HoldKey "Media_Stop"
F4 up::Send "{blind}{Media_Stop Up}"
F5::HoldKey "Volume_Mute"
F5 up::Send "{blind}{Volume_Mute Up}"
F6::Volume_Down
F7::Volume_Up
F8::HoldKey "Launch_Media"
F8 up::Send "{blind}{Launch_Media Up}"

sc029::SendEvent "{Click 16 96 0}"
sc002::F1
sc003::F2
sc004::F3
sc005::F4
sc006::F5
sc007::F6
sc008::F7
sc009::F8
sc00a::F9
sc00b::F10
sc00c::F11
sc00d::F12

sc010::Esc
sc011::WheelUp
sc012::Browser_Back
sc013::Browser_Forward
sc014::SendInput "{Click 0 -20 0 Rel}"
sc015::PgUp
sc016::Home
sc017::Up
sc018::End
sc019::Del
sc01a::WheelLeft
sc01b::WheelRight

sc01e::HoldKeyNormal "Alt"
sc01e up::Send "{Blind}{Alt Up}"
sc01f::WheelDown
sc020::HoldKeyNormal "Shift"
sc020 up::Send "{Blind}{Shift up}"
sc021::HoldKeyNormal "Ctrl"
sc021 up::Send "{Blind}{Ctrl up}"
sc022::SendInput "{Click 0 20 0 Rel}"
sc023::PgDn
sc024::Left
sc025::Down
sc026::Right
sc027::BackSpace
sc028::HoldKey "AppsKey"
sc028 up::Send "{blind}{AppsKey Up}"

sc02c::^z
sc02d::^x
sc02e::^c
sc02f::^v
sc030::Ins

sc031::LButton
sc032::MButton
sc033::RButton
sc034::SendInput "{Click -42 0 0 Rel}"
sc035::SendInput "{Click 42 0 0 Rel}"

Enter::^BackSpace
Space::Enter

#HotIf activatedExtendLayer2
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

#HotIf activatedExtendLayer3
sc029::
sc002::
sc003::
sc004::
sc005::
sc006::
sc007::
sc008::
sc009::
sc00a::
sc00b::
sc00c::
sc00d::return
sc010::[
sc011::]
sc012::~
sc013::
sc014::
sc015::return
sc016::'
;'
sc017::"
;"
sc018::\
sc019::
sc01a::
sc01b::
sc02b::return
sc01e::(
sc01f::)
sc020::`
sc021::
sc022::
sc023::return
sc024::`{
sc025::}
sc026::%
sc027::!
sc028::return
sc02c::&
sc02d::|
sc02e::*
sc02f::
sc030::
sc031::return
sc032::+
sc033::-
sc034::=
sc035::return

#HotIf
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

ih := InputHook("V L" . maximumComposeKeyLength, "{Left}{Up}{Right}{Down}{Home}{PgUp}{End}{PgDn}"),
oldBuffer := ""

sc15d::
{	
	if A_PriorHotKey !== ThisHotKey
		onKeyDown(ih, 0x5d, 0x15d)
	KeyWait "sc15d"
}

~Backspace::
~+Backspace::
{
	global oldBuffer
	if ih.Input == "" && oldBuffer != ""
		oldBuffer := SubStr(oldBuffer, 1, StrLen(oldBuffer) - 1)
}
~!Backspace::
~*^Backspace::
{
	if A_PriorHotKey != "~!Backspace" && A_PriorHotKey != "~*^Backspace"
	{
		ih.Stop(),
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
		ih.Stop(),
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
					ih.Stop(),
					SendInput("{Backspace " StrLen(key) "}" val),
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
ih.OnChar := onChar,
ih.Start()