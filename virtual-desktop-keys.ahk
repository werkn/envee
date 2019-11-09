;--------------------------------------------------------------
; _    _ _____  ______ _______ _     _ _______                
;  \  /    |   |_____/    |    |     | |_____| |              
;   \/   __|__ |    \_    |    |_____| |     | |_____         
;                                                             
;      ______  _______ _______ _     _ _______  _____   _____ 
;      |     \ |______ |______ |____/     |    |     | |_____]
;      |_____/ |______ ______| |    \_    |    |_____| |      
;                                                             
;           _     _ _______ __   __ _______                   
;           |____/  |______   \_/   |______                   
;           |    \_ |______    |    ______|                   
;                                                             
;--------------------------------------------------------------
;@author Ryan Radford wekrn.github.io
;--------------------------------------------------------------
;This program allows automated switching between virtual desktops on Windows 10
;something that should be trivial with Powershell/C# etc... but without a 
;API there is no nice way to achieve that
;
;With the introduction virtual desktops automating switching desktops via any
;scripting efforts is a nightmare.  Literally.  This app is used to
;move between and create new virtual desktops

;grab command line args
arg := a_args[1]

;SetKeyDelay is important here, if we hit the Ctrl+Win+{Direction} 
;combination to quickly it will not move to the next available virtual
;desktop
SetKeyDelay, 100 

; Send window left
WindowLeft() 
{
	sendevent {LWin down}{Left down}{LWin up}{Left up}
	sendevent {Esc}
}

; Send window right
WindowRight() 
{
	sendevent {LWin down}{Right down}{LWin up}{Right up}
	sendevent {Esc}
}
	
; Send window down
WindowDown() 
{
	sendevent {LWin down}{Down down}{LWin up}{Down up}
	sendevent {Esc}
}

; Send window up / maximize
WindowUp() 
{
	sendevent {LWin down}{Up down}{LWin up}{Up up}
	sendevent {Esc}
}

SetWindowLeft()
{
	WindowUp()
	WindowLeft()
}

SetWindowRight() 
{
	WindowUp()
	WindowRight()
}

SetWindowTopLeft() 
{
	SetWindowLeft()
	WindowLeft()
	WindowUp()
}

SetWindowBottomLeft()
{
	SetWindowLeft()
	WindowLeft()
	WindowDown()
}

SetWindowTopRight()
{
	SetWindowRight()
	WindowRight()
	WindowUp()
}

SetWindowBottomRight()
{
	SetWindowRight()
	WindowRight()
	WindowDown()
}

; Send next virtual desktop keybinding
NextDesktop() 
{
	sendevent {LWin down}{LCtrl down}{Right down}{LWin up}{LCtrl up}{Right up}
}

; Send prev virtual desktop keybinding
PrevDesktop() 
{
	sendevent {LWin down}{LCtrl down}{Left down}{LWin up}{LCtrl up}{Left up}
}

; Send new virtual desktop
NewDesktop() 
{
	sendevent {LWin down}{LCtrl down}{d down}{LWin up}{LCtrl up}{d up}
}
; Destroy current virtual desktop
KillDesktop()
{
	sendevent {LWin down}{LCtrl down}{F4 down}{LWin up}{LCtrl up}{F4 up}
}

; big messy arguments checking
if (arg = "--settopleft") 
{
	SetWindowTopLeft()
}
else if (arg = "--setbottomleft")
{
	SetWindowBottomLeft()
}
else if (arg = "--setleft")
{
	SetWindowLeft()
}
else if (arg = "--settopright") 
{
	SetWindowTopRight()
}
else if (arg = "--setbottomright")
{
	SetWindowBottomRight()
}
else if (arg = "--setright")
{
	SetWindowRight()
}
else if (arg = "--sendup")
{
	WindowUp()
}
else if (arg = "--senddown")
{
	WindowDown()
}
else if (arg = "--sendright")
{
	WindowRight()
}
else if (arg = "--sendleft")
{
	WindowLeft()
}
else if (arg = "--right")
{
	NextDesktop()
}
else if (arg = "--right")
{
	NextDesktop()
}
else if (arg = "--left")
{
	PrevDesktop()
} 
else if (arg = "--new")
{
	NewDesktop()
} 
else if (arg = "--kill")
{
	KillDesktop()
} else {
	MsgBox 0,virtual-desktop-keys,Usage: virtual-desktop-keys.exe [--right / --left / --new / --kill] 
}

