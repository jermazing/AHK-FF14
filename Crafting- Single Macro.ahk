#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance Force
#InstallMouseHook
CoordMode, Tooltip, Screen
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
;Made by Jeremy Quintos 


;POS and color of the Synthesize button
SynthesizePOS := []

;POS and color of the crafting macro icon
CraftMacroPOS := []

;Number of errors allowed
Error_Timeout := 3

;Number of errors in current loop
Error_Counter := 0

;Start time of current Craft
Start_Time := 0

;How long the current craft has been crafting for (A_TickCount - Start_Time)
Craft_Timer := 0

;How long until the script assumes there was an error
Craft_Timeout := 60000

;Number of loops ditermined by user input
Loop_Count := 0

;Current loop iteration
Loop_Counter := 0


Startup:
	InputBox, UserInput, Number of Crafts, How many times should it craft?, ,240, 130
	if ErrorLevel
		ExitApp
	else if UserInput is not integer
	{
		MsgBox, Input can only be a whole number
		GoTo, Startup
	}
	else if (UserInput <= 0)
	{
		MsgBox, why are you like this
		MsgBox, i WaNnA cRaFt NeGaTiVe TiMeS
		GoTo, Startup
	}
	else
	{	
		Loop_Count := UserInput
	}

Tooltip, Getting Synthesize POS and color, 0, 0, 
sleep 100
MsgBox, 4097, , Hover over Synthesize button and press ENTER, 30
IfMsgBox Cancel
	ExitApp
IfMsgBox Timeout
	ExitApp

sleep 50
BlockInput, MouseMove
if WinExist("FINAL FANTASY XIV")
	WinActivate ; Use the window found by WinExist.
sleep 1000
MouseGetPos, xpos, ypos
PixelGetColor, mClr, %xpos%, %ypos%, RGB
mClr := "0x" . SubStr(mClr, 3)
SynthesizePOS := [xpos,ypos,mClr]
sleep 100
BlockInput, MouseMoveOff
sleep 100

Tooltip, Getting macro mouse POS, 0, 0, 
sleep 100
MsgBox, 4097, , Hover over crafting macro icon and press ENTER, 30
IfMsgBox Cancel
	ExitApp
IfMsgBox Timeout
	ExitApp

sleep 100
BlockInput, MouseMove
sleep 100
MouseGetPos, xpos, ypos
PixelGetColor, mClr, %xpos%, %ypos%, RGB
mClr := "0x" . SubStr(mClr, 3)
CraftMacroPOS := [xpos,ypos]
sleep 100
BlockInput, MouseMoveOff
sleep 100


CraftLoop:
loop, %Loop_Count%
{
	Loop_Counter := Loop_Counter +1
	Tooltip, Checking for synthesize button`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
	loop
	{ ;Loop to check for the synthesize button
		Tooltip, Looking for synthesize button`nLoop: %Loop_Counter%`nErrors: %Error_Counter%, 0, 0
		MouseMove, SynthesizePOS[1], SynthesizePOS[2]
		Sleep 1000
		If (Error_Counter >= Error_Timeout) ;If it failed 3 times, provide error message and stop script
		{
			MsgBox Unable to Locate Synthesize button.
			ExitApp
		}
		;~ PixelSearch, OutputX, OutputY, SynthesizePOS[1]-4, SynthesizePOS[2]-4, SynthesizePOS[1]+4, SynthesizePOS[2]+4, SynthesizePOS[3], 25, Fast RGB ;Looks for synthesize button in a 9x9 square centered on SynthesizePOS
		PixelSearch, OutputX, OutputY, SynthesizePOS[1]-1, SynthesizePOS[2]-1, SynthesizePOS[1]+1, SynthesizePOS[2]+1, SynthesizePOS[3], 1, Fast RGB ;Looks for synthesize button on the specific pixel
		If (OutputX != "") ;If it found the synthesize button, exit current loop and continue
		{
			Error_Counter = 0 ;Reset Error Count
			Break
		}
		Error_Counter := Error_Counter + 1
		sleep 200
	}
	Tooltip, Clicking synthesize button`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
	sleep 100
	BlockInput, MouseMove
	sleep 100
	MouseClick, Left, SynthesizePOS[1], SynthesizePOS[2], 1, 0, D ;Click on the synthesize button. Crafting log window should close and crafting progress progress window should open
	sleep 100
	MouseClick, Left, SynthesizePOS[1], SynthesizePOS[2], 1, 0, U
	sleep 100
	BlockInput, MouseMoveOff
	sleep 2000		
	Loop
	{ ;Loop to check if the crafting window is still up.
		Tooltip, Confirming Crafting Log is closed`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
		If (Error_Counter >= Error_Timeout) ;If it failed 3 times, provide error message and stop script
		{
			MsgBox Unable to start crafting.
			ExitApp
		}
		PixelSearch, OutputX, OutputY, SynthesizePOS[1]-4, SynthesizePOS[2]-4, SynthesizePOS[1]+4, SynthesizePOS[2]+4, SynthesizePOS[3], 0, Fast RGB ;Check for the synthesize button again to make sure it closed.
		If (Outputx = "") ;If it can't find the synthesize button,
		{
			Error_Counter = 0 ;Reset Error Count
			Break
		}
		Error_Counter := Error_Counter + 1
		Tooltip, Clicking synthesize button`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
		sleep 100
		BlockInput, MouseMove
		sleep 100
		MouseClick, Left, SynthesizePOS[1], SynthesizePOS[2], 1, 0, D ;Click on the synthesize button. Crafting log window should close and crafting progress progress window should open
		sleep 100
		MouseClick, Left, SynthesizePOS[1], SynthesizePOS[2], 1, 0, U
		sleep 100
		BlockInput, MouseMoveOff
		sleep 2000
	}
	;~ loop
	;~ { ;Loop to check for the crafting macro icon
		;~ Tooltip, Checking for crafting macro icon`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
		;~ If (Error_Counter >= Error_Timeout) ;If it failed 3 times, provide error message and stop script
		;~ {
			;~ MsgBox Unable to locate crafting macro icon.
			;~ ExitApp
		;~ }
		;~ PixelSearch, OutputX, OutputY, CraftMacroPOS[1]-4, CraftMacroPOS[2]-4, CraftMacroPOS[1]+4, CraftMacroPOS[2]+4, CraftMacroPOS[3], 25, Fast RGB ;Looks for crafting macro icon in a 9x9 square centered on CraftMacroPOS
		;~ If (OutputX != "") ;If it found the crafting macro icon, exit current loop and continue
		;~ {
			;~ Error_Counter = 0 ;Reset Error Count
			;~ Break
		;~ }
		;~ Error_Counter := Error_Counter + 1
		;~ sleep 200
	;~ }
	Tooltip, Clicking crafting macro icon`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
	sleep 100
	BlockInput, MouseMove
	sleep 100
	MouseClick, Left, CraftMacroPOS[1], CraftMacroPOS[2], 1, 0, D ;Click on the Macro Icon window
	sleep 100
	MouseClick, Left, CraftMacroPOS[1], CraftMacroPOS[2], 1, 0, U
	sleep 100
	BlockInput, MouseMoveOff
	Start_Time := A_TickCount
	sleep 500		
	loop 
	{ ;Loop to check for the synthesize button to see if the craft is complete
		Craft_Timer := A_TickCount - Start_Time
		Tooltip, Checking for craft completion`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%`nCraft Timer: %Craft_Timer%, 0, 0
		sleep 50
		If (Craft_Timer >= Craft_Timeout) ;If total craft time exceeds the buffer window, then display error message
		{
			MsgBox, 4, , Crafting time exceeded %Craft_Timeout%. try again?
			IfMsgBox, Yes
				Break
			else
				ExitApp
		}
		MouseMove, SynthesizePOS[1], SynthesizePOS[2]
		PixelSearch, OutputX, OutputY, SynthesizePOS[1]-4, SynthesizePOS[2]-4, SynthesizePOS[1]+4, SynthesizePOS[2]+4, SynthesizePOS[3], 1, Fast RGB ;Looks for synthesize button in a 9x9 square centered on SynthesizePOS
		If (OutputX != "") ;If it found the synthesize button, exit current loop and continue
		{
		Break
		}
		sleep 50
	}
	
	
}
MsgBox %Loop_counter% items crafted
	
GuiClose:
ExitApp	
	
;ctrl+space to abort script
^space:: ExitApp
