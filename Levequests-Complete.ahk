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

;Global sleep time for menu navigation
MenuSleep := 700

;Yellow spot on the repeatable card icon
;Align the small corner between levequest windows with the bottom right of the target HP bar
LeveSearchPOS := [1910,287,0xEFE352] ;Yellow spot on the repeatable card icon

;Total Quests Completed
QuestCounter := 0 

;Counter for searching through leve quests
LeveSearch := 1 

;Total Items submitted on each individual levequest. Resets after each quest completed.
TurnInCounter := 0 

;Total items submitted for all quests
ItemsSubmitted := 0 

;Total quests to be completed
Loop_Count := 0

;Get the number of completed rows
RowCounter := (ItemsSubmitted//5) 

;Get the remaining number of items submitted after dividing by 5
Mod_Counter := Mod(ItemsSubmitted,5) 



;Tooltip template for searching for the levequests
;Tooltip_Search = `nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nLeve Search attempt: %LeveSearch%

;Tooltip template for turning items in
;Tooltip_TurnIn = `nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%




Startup:
Tooltip, Startup, 0, 0
MsgBox, 4097, ,Please confirm the following:`nItems are filled correctly in Inventory`nCurrent class is BSM`nWindow will timeout in 30 seconds, 30
IfMsgBox Cancel
	ExitApp
IfMsgBox Timeout
	ExitApp

InputBox, UserInput, Number of Crafts, How many levequests should be completed?, , 300, 130
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

GetNPCPositions:
Tooltip, Getting Eirikur mouse POS, 0, 04
Sleep 200
MsgBox, 4097, , Hover over Eirikur and press ENTER
IfMsgBox Cancel
	ExitApp
IfMsgBox Timeout
	ExitApp
MouseGetPos, expos, eypos
EirikurPOS := [expos,eypos]

Tooltip, Getting Eirikur mouse POS, 0, 0
Sleep 200
MsgBox, 4097, , Hover over Moyce and press ENTER, 30
IfMsgBox Cancel
	ExitApp
IfMsgBox Timeout
	ExitApp
MouseGetPos, mxpos, mypos
MoycePOS := [mxpos,mypos]

;MsgBox % "Eirikur: X:" expos ", Y:" eypos ". Eirikur: X:" EirikurPOS[1] ", Y:" EirikurPOS[2] "."
;MsgBox % "Moyce: X:" mxpos ", Y:" mypos ". Moyce: X:" MoycePOS[1] ", Y:" MoycePOS[2] "."

Sleep 2000
BlockInput, MouseMove
Sleep 200

PrimaryLoop:
Loop, %Loop_Count%
{
	OpenLeveMenu:
	Tooltip, Clicking on Eirikur`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nLeve Search attempt: %LeveSearch%, 0, 0
	sleep 2000
	BlockInput, MouseMove
	Sleep 200
	MouseMove, EirikurPOS[1], EirikurPOS[2],
	Sleep 2000
	MouseClick, Left, EirikurPOS[1], EirikurPOS[2], 1, 0, D 
	sleep 200
	MouseClick, Left, EirikurPOS[1], EirikurPOS[2], 1, 0, U
	sleep MenuSleep
	Tooltip, Opening LeveQuest window`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nLeve Search attempt: %LeveSearch%, 0, 0
	sleep MenuSleep
	Send {Numpad0} ;Initial greeting
	sleep MenuSleep
	Send {Numpad0} ;Close greeting
	sleep MenuSleep
	Send {Numpad2} ;Down to highlight Tradecraft Leves
	sleep MenuSleep

	AcceptQuest:
	While LeveSearch <= 3
	{	
		
		Tooltip, Searching for Levequest`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nLeve Search attempt: %LeveSearch%, 0, 0
		Sleep 200
		Send {Numpad0} ;Select Tradecraft Leves
		sleep MenuSleep
		PixelSearch, OutputX, OutputY, LeveSearchPOS[1]-4, LeveSearchPOS[2]-4, LeveSearchPOS[1]+4, LeveSearchPOS[2]+4, LeveSearchPOS[3], 3, Fast RGB
		If (OutputX != "") ;If it found the levelquest
		{
			Tooltip, LeveQuest Found. Accepting`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nLeve Search attempt: %LeveSearch%, 0, 0
			Sleep 200
			LeveSearch := 1 ;Reset search counter
			Sleep 200
			Send {Numpad0} ;Select highlighted quest
			sleep MenuSleep
			Send {Numpad0} ;Accept quest
			sleep MenuSleep
			Send {Esc} ;Close quest window
			sleep MenuSleep
			Send {Esc} ;Close initial window
			sleep MenuSleep
			Break ;exit loop
		}
		else ;If it didnt find the levequest after 3 attempts
		{
			LeveSearch++
			Send {Numpad2} ;Down to select the next levequest
			sleep MenuSleep
		}
	}
	If LeveSearch > 3 ;If unable to find the levelquest, end script
	{
		Tooltip, Faile to find levequest`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nLeve Search attempt: %LeveSearch%, 0, 0
		Sleep 200
		BlockInput, MouseMoveOff
		Sleep 200
		MsgBox Unable to find Levequest. Ending script.
		ExitApp
	}

	TurnIn: ;select Moyce to turn in levequest items
	Tooltip, Selecting Moyce`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items submitted: %TurnInCounter%, 0, 0
	Sleep 200
	MouseMove, MoycePOS[1], MoycePOS[2], 
	Sleep 2000
	MouseClick, Left, MoycePOS[1], MoycePOS[2], 1, 0, D 
	sleep 200
	MouseClick, Left, MoycePOS[1], MoycePOS[2], 1, 0, U
	sleep MenuSleep
	Send {Numpad0} ;Initial greeting
	sleep MenuSleep
	Send {Numpad0} ;Close greeting
	sleep MenuSleep
	Loop, 3
	{	
		RowCounter := (ItemsSubmitted//5) ;Get the number of completed rows
		Mod_Counter := Mod(ItemsSubmitted,5) ;Get the floating point of items submitted / 5
		
		Tooltip, Selecting Moyce`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items submitted: %TurnInCounter%, 0, 0
		Sleep 200
		Send {Numpad0} ;Select item in Item Request window and activate inventory
		sleep MenuSleep
		If ItemsSubmitted = 0 ;If this is the first item turn in, reset cursor position
		{
			Tooltip, First Submission. Resetting Cursor`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
			Sleep 200
			Send {Numpad4 down} ;Hold to keep moving cursor left to reset position to start of inventory
			Sleep 9000
			Send {Numpad4 up}
			sleep MenuSleep
			;~ Send {Numpad4}
			;~ sleep MenuSleep
		}
		Else if ((Mod_Counter = 0) and (RowCounter > 0)) ;If the end of row in a quadrant
		{
			If (RowCounter = 7) or (RowCounter = 21) ;if the end of the 1st or 3rd quadrant, reset cursor to start of 2nd or 4th quadrant
			{
				Tooltip, Next Quadrant`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
				;~ Msgbox Next Quadrant!!`nRowCounter: %RowCounter%
				Sleep 500
				Send {numpad6} ;move cursor right
				Sleep 200
				Send {numpad8} ;move cursor up
				Sleep 200
				Send {numpad8}
				Sleep 200
				Send {numpad8}
				Sleep 200
				Send {numpad8}
				Sleep 200
				Send {numpad8}
				Sleep 200
				Send {numpad8}
				Sleep 200
			}
			Else if (RowCounter = 14) ; if the end of the 2nd quadrant, reset cursor to start of 2nd or 4th quadrant
			{
				Tooltip, Next Quadrant`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
				Sleep 500
				Send {numpad6} ;move cursor right
				Sleep 200			
			}
			Else ;if just the end of a row but not the end of a quadrant, reset cursor to start of next row in same quadrant
			{
				Tooltip, Next Row`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
				Sleep 500
				Send {numpad2} ;move cursor down
				Sleep 200
				Send {numpad4} ;move cursor left
				Sleep 200
				Send {numpad4}
				Sleep 200
				Send {numpad4}
				Sleep 200
				Send {numpad4}
				Sleep 200
			}
		}
		else ;If mid-row
		{
			Tooltip, Next Item`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
			Sleep 200
			Send {numpad6}
			Sleep 200
		}
		Tooltip, Turning in item`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
		Sleep 500
		Send {Numpad0} ;Select item to hand over
		sleep MenuSleep
		Send {Numpad0} ;Select Hand Over
		sleep MenuSleep
		Send {Numpad0} ;Select Yes High Quality
		sleep MenuSleep
		Send {Numpad0} ;Close NPC dialog
		sleep MenuSleep
		Send {Numpad0} ;Close HQ Reward notification
		sleep MenuSleep
		Send {Numpad0} ;Complete
		sleep MenuSleep
		TurnInCounter++ 
		ItemsSubmitted++
		Tooltip, Item Submitted`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
		Sleep 200
		If TurnInCounter < 3 ;if there are more to turn in
		{
			Tooltip, Turning in item`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
			Sleep 500
			Send {Numpad0} ;Close Additional turn-in Dialog Window
			sleep MenuSleep
			Send {Numpad0} ;Yes to additional turn-ins
			sleep MenuSleep
		}
		Tooltip, Quest Complete. Resetting`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
		Sleep 200
	}
	QuestCounter++
	TurnInCounter := 0 ; Reset Turn In Counter
	sleep MenuSleep
	
}
BlockInput, MouseMoveOff
Tooltip, Quest Complete. Resetting`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCompleted Rows: %RowCounter%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
MsgBox %QuestCounter% Quests completed.`n%ItemsSubmitted% Items Sumbitted
	
GuiClose:
ExitApp	
	
;ctrl+space to abort script
^space:: 
Send {Numpad4}
BlockInput, MouseMoveOff
ExitApp



