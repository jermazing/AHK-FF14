#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance Force
#InstallMouseHook
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
;Made by Jeremy Quintos 


;POS and color of the Synthesize button
;Align bottom-right of crafting log with bottom-right of c3
SynthesizePOS := [1500,1136,0xA5824A]

SynthesizePOS_Hover := [1500,1136,0xB5925A]

;POS and color of the crafting macro icon
;Should be in c-
CraftMacroPOS1 := [1455,1311,0x0E3510]

;POS and color of the crafting macro icon
;Should be in c=
CraftMacroPOS2 := [1507,1311,0x1B7F6F]

TestPOS := [1189,1135,0xDECBAD]

;Number of errors allowed
Error_Timeout := 3

;Number of errors in current loop
Error_Counter := 0

;Start time of current Craft
Start_Time := 0

;How long the current craft has been crafting for (A_TickCount - Start_Time)
Craft_Timer := 0

;Runtime of the first crafting macro
Macro_1_Time := 38000

;How long until the script assumes there was an error
Craft_Timeout := 40000

;Number of loops ditermined by user input
Loop_Count := 0

;Current loop iteration
Loop_Counter := 0


Startup:
	InputBox, UserInput, Number of Crafts, How many times should it craft., , 300, 130
	if ErrorLevel
		ExitApp
	else if UserInput is not integer 
	{
		MsgBox, Input can only be a whole number
		GoTo, Startup
	}
	else
	{	
		Loop_Count := UserInput
	}
	


CraftLoop:
loop, %Loop_Count%
{
	Loop_Counter := Loop_Counter +1
	Tooltip, Checking for synthesize button`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
	loop
	{ ;Loop to check for the synthesize button
		Tooltip, Looking for synthesize button`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
		If (Error_Counter >= Error_Timeout) ;If it failed 3 times, provide error message and stop script
		{
			MsgBox Unable to Locate Synthesize button.
			ExitApp
		}
		PixelSearch, OutputX, OutputY, SynthesizePOS[1]-4, SynthesizePOS[2]-4, SynthesizePOS[1]+4, SynthesizePOS[2]+4, SynthesizePOS[3], 25, Fast RGB ;Looks for synthesize button in a 9x9 square centered on SynthesizePOS
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
		PixelSearch, OutputX, OutputY, SynthesizePOS[1]-4, SynthesizePOS[2]-4, SynthesizePOS[1]+4, SynthesizePOS[2]+4, SynthesizePOS[3], 25, Fast RGB ;Check for the synthesize button again to make sure it closed.
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

	Tooltip, Clicking crafting macro icon 1`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
	sleep 100
	BlockInput, MouseMove
	sleep 100
	MouseClick, Left, CraftMacroPOS1[1], CraftMacroPOS1[2], 1, 0, D ;Click on the Macro Icon 1
	sleep 100
	MouseClick, Left, CraftMacroPOS1[1], CraftMacroPOS1[2], 1, 0, U
	sleep 100
	BlockInput, MouseMoveOff
	Start_Time := A_TickCount
	sleep 100		
	Loop
	{
		Macro_1_Timer := Start_Time + Macro_1_Time - A_TickCount
		Tooltip, Waiting for first macro completion`nLoop: %Loop_Counter%`nErrors: %Error_Counter%`nMacro Time Remaining: %Macro_1_Timer%, 0, 0
		If (Macro_1_Timer <= 0)
		{
			Break
		}
		sleep 100
	}
	
	Tooltip, Clicking crafting macro icon 2`nLoop: %Loop_Counter% of %Loop_Count%`nErrors: %Error_Counter%, 0, 0
	sleep 100
	BlockInput, MouseMove
	sleep 100
	MouseClick, Left, CraftMacroPOS2[1], CraftMacroPOS2[2], 1, 0, D ;Click on the Macro Icon 2
	sleep 100
	MouseClick, Left, CraftMacroPOS2[1], CraftMacroPOS2[2], 1, 0, U
	sleep 100
	BlockInput, MouseMoveOff
	Start_Time := A_TickCount
	sleep 500
	loop 
	{ ;Loop to check for the synthesize button to see if the craft is complete
		Craft_Timer := A_TickCount - Start_Time
		Tooltip, Checking for craft completion`nLoop: %Loop_Counter%`nErrors: %Error_Counter%`nCraft Timer: %Craft_Timer%, 0, 0
		If (Craft Timer >= Craft_Timeout) ;If total craft time exceeds the buffer window, then display error message
		{
			MsgBox, 4, , Crafting time exceeded %Craft_Timeout%. try again?, 30
			IfMsgBox, Yes
				Break
			else
				ExitApp
		}
		PixelSearch, OutputX, OutputY, SynthesizePOS[1]-4, SynthesizePOS[2]-4, SynthesizePOS[1]+4, SynthesizePOS[2]+4, SynthesizePOS[3], 1, Fast RGB ;Looks for synthesize button in a 9x9 square centered on SynthesizePOS
		If (OutputX != "") ;If it found the synthesize button, exit current loop and continue
		{
		Break
		}
		sleep 100
	}
	
	
}
MsgBox %Loop_counter% items crafted
	
GuiClose:
ExitApp	
	
;ctrl+space to abort script
^space:: ExitApp