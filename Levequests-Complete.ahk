#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance Force
#InstallMouseHook
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
;Made by Jeremy Quintos 

;Global sleep time
MenuSleep := 500

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

;Tooltip template for searching for the levequests
;Tooltip_Search = `nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nLeve Search attempt: %LeveSearch%

;Tooltip template for turning items in
;Tooltip_TurnIn = `nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%




Startup:
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
Tooltip, Getting Eirikur mouse POS, 0, 0
sleep 100
MsgBox Hover over Eirikur and press ENTER
MouseGetPos, expos, eypos
EirikurPOS := [expos,eypos]

Tooltip, Getting Eirikur mouse POS, 0, 0
sleep 100
MsgBox Hover over Moyce and press ENTER
MouseGetPos, mxpos, mypos
MoycePOS := [mxpos,mypos]

;MsgBox % "Eirikur: X:" expos ", Y:" eypos ". Eirikur: X:" EirikurPOS[1] ", Y:" EirikurPOS[2] "."
;MsgBox % "Moyce: X:" mxpos ", Y:" mypos ". Moyce: X:" MoycePOS[1] ", Y:" MoycePOS[2] "."


PrimaryLoop:
Loop, %Loop_Count%
{
	OpenLeveMenu:
	Tooltip, Clicking on Eirikur`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nLeve Search attempt: %LeveSearch%, 0, 0
	sleep 100
	MouseClick, Left, EirikurPOS[1], EirikurPOS[2], 1, 0, D 
	sleep 100
	MouseClick, Left, EirikurPOS[1], EirikurPOS[2], 1, 0, U
	sleep MenuSleep
	Tooltip, Opening LeveQuest window`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nLeve Search attempt: %LeveSearch%, 0, 0
	sleep 100
	Send {Numpad0} ;Initial greeting
	sleep MenuSleep
	Send {Numpad0} ;Close greeting
	sleep MenuSleep
	Send {Numpad2} ;Down to highlight Tradecraft Leves
	sleep MenuSleep

	AcceptQuest:
	While LeveSearch <= 3
	{	
		
		Tooltip, Searching for Levequest`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nLeve Search attempt: %LeveSearch%, 0, 0
		sleep 100
		Send {Numpad0} ;Select Tradecraft Leves
		sleep MenuSleep
		PixelSearch, OutputX, OutputY, LeveSearchPOS[1]-4, LeveSearchPOS[2]-4, LeveSearchPOS[1]+4, LeveSearchPOS[2]+4, LeveSearchPOS[3], 3, Fast RGB
		If (OutputX != "") ;If it found the levelquest
		{
			Tooltip, LeveQuest Found. Accepting`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nLeve Search attempt: %LeveSearch%, 0, 0
			sleep 100
			LeveSearch := 1 ;Reset search counter
			sleep 100
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
		Tooltip, Faile to find levequest`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nLeve Search attempt: %LeveSearch%, 0, 0
		sleep 100
		MsgBox Unable to find Levequest. Ending script.
		ExitApp
	}

	TurnIn:
	Tooltip, Selecting Moyce`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
	sleep 100
	MouseClick, Left, MoycePOS[1], MoycePOS[2], 1, 0, D 
	sleep 100
	MouseClick, Left, MoycePOS[1], MoycePOS[2], 1, 0, U
	sleep MenuSleep
	Send {Numpad0} ;Initial greeting
	sleep MenuSleep
	Send {Numpad0} ;Close greeting
	sleep MenuSleep
	Loop, 3
	{	
		Tooltip, Selecting Moyce`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
		sleep 100
		Send {Numpad0} ;Select item in Item Request window and activate inventory
		sleep MenuSleep
		If ItemsSubmitted = 0 ;If this is the first item turn in
		{
			Tooltip, First Submission. Resetting Cursor`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
			sleep 100
			Send {Numpad4 down} ;Hold down
			sleep 10000
			Send {Numpad4 up}
			sleep MenuSleep
			Send {Numpad4}
			sleep MenuSleep
		}
		Tooltip, Turning in item`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
		sleep 100
		Send {Numpad6} ;Move cursor to next item
		sleep MenuSleep
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
		Tooltip, Item Submitted`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
		sleep 100
		If TurnInCounter < 3 ;if there are more to turn in
		{
			Tooltip, Turning in item`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
			sleep 100
			Send {Numpad0} ;Close Additional turn-in Dialog Window
			sleep MenuSleep
			Send {Numpad0} ;Yes to additional turn-ins
			sleep MenuSleep
		}
		Tooltip, Quest Complete. Resetting`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
		sleep 100
	}
	QuestCounter++
	TurnInCounter := 0 ; Reset Turn In Counter
	sleep MenuSleep
}
Tooltip, Quest Complete. Resetting`nQuests Complete: %QuestCounter% of %Loop_Count%`nTotal Items Submitted: %ItemsSubmitted%`nCurrent quest Items turned in: %TurnInCounter%, 0, 0
MsgBox %QuestCounter% Quests completed.`n%ItemsSubmitted% Items Sumbitted
	
GuiClose:
ExitApp	
	
;ctrl+space to abort script
^space:: ExitApp



