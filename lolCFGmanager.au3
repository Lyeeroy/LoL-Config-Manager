#RequireAdmin

;==== LOL CFG MANAGER BY LYEE ====

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\Downloads\png.png.ico
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <File.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <_ConfigIO.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=c:\users\marrowgar\documents\autoit\lolcfg\koda\cfgkoda.kxf
$ssRead = IniRead(@ScriptDir & "myini.ini", "PATH", "LoLPath", "")
$Form1_1 = GUICreate("lolCFGmanager", 420, 170, 798, 266)
$Tab1 = GUICtrlCreateTab(0, 0, 433, 177)
;========================================================== SAVE
$TabSheet1 = GUICtrlCreateTabItem("Save")
$Input1 = GUICtrlCreateInput($ssRead, 28, 76, 249, 21)
$btnp = GUICtrlCreateButton("+", 284, 74, 19, 25)
$btnbrowse = GUICtrlCreateButton("Browse", 308, 74, 59, 25)
$Label1 = GUICtrlCreateLabel("SELECT LOL CFG PATH", 12, 50, 124, 17)
$exit = GUICtrlCreateButton("Exit", 260, 114, 51, 25)
$scfg = GUICtrlCreateButton("Saved CFGs", 180, 114, 75, 25)
;========================================================== REPLACE
$TabSheet2 = GUICtrlCreateTabItem("Replace")
$Combo = GUICtrlCreateCombo("", 28, 76, 249, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$replace = GUICtrlCreateButton("Replace", 308, 74, 59, 25)
$btnm = GUICtrlCreateButton("-", 284, 74, 19, 25)
$scfg02 = GUICtrlCreateButton("Saved CFGs", 180, 114, 75, 25)
$exit02 = GUICtrlCreateButton("Exit", 260, 114, 51, 25)
$Label2 = GUICtrlCreateLabel("SELECT CONFIG", 12, 50, 88, 17)
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW)

_ref()

Func _ref()
	$lolpath = GUICtrlRead($Input1)
	$path = ($lolpath & '\Config')
	$FileList = _FileListToArray($path & "\Saved CFGs", "*")
	$cData = ""
	For $i = 1 To UBound($FileList) - 1
		$cData &= "|" & $FileList[$i]
	Next
	GUICtrlSetData($Combo, $cData)
EndFunc   ;==>_ref


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $exit
			Exit
		Case $exit02
			Exit
		Case $btnbrowse
			$sPath = FileSelectFolder("Open a file", @DesktopDir, "All file (*.*)")
			If Not $sPath = "" Then
				GUICtrlSetData($Input1, $sPath)
				IniWrite(@ScriptDir & "myini.ini", "PATH", "LoLPath", $sPath)
			EndIf
		Case $btnp
			$lolpath = GUICtrlRead($Input1)
			$path = ($lolpath & '\Config')
			If Not FileExists($path & "\PersistedSettings.json") Then
				MsgBox(0, @ScriptName, 'Make sure you got correct path' & @CRLF & @CRLF & 'PATH & \League of Legends')
			Else
				$cfgname = InputBox(@ScriptName, 'Save CFG as:', "", "", 230, 140)
				If @error = 1 Then
					ConsoleWrite('Input box EX')
				ElseIf $cfgname = '' Then
					MsgBox(0, @ScriptName, "Name your config first!")
				ElseIf FileExists($path & "\Saved CFGs\" & $cfgname) Then
					MsgBox(0, @ScriptName, $cfgname & " CFG already exists")
				Else
					If Not FileExists($path & "\Saved CFGs") Then
						DirCreate($path & "\Saved CFGs")
					EndIf
					DirCreate($path & "\Saved CFGs\" & $cfgname)
					FileCopy($path & "\PersistedSettings.json", $path & "\Saved CFGs\" & $cfgname)
					FileCopy($path & "\input.ini", $path & "\Saved CFGs\" & $cfgname)
				EndIf
			EndIf
			_ref()
		Case $btnm
			$combocfg = GUICtrlRead($Combo)
			$lolpath = GUICtrlRead($Input1)
			If $combocfg = "" Then
				$mb = MsgBox(0, @ScriptName, 'Choose config!')
			Else
				$mb = MsgBox(4, @ScriptName, 'Are you sure you want to delete "' & $combocfg & '" config?')
				If $mb = $IDYES Then
					$path = ($lolpath & '\Config')
					DirRemove($path & "\Saved CFGs\" & $combocfg, 1)
					_ref()
				EndIf
			EndIf

		Case $replace
			$combocfg = GUICtrlRead($Combo)
			$lolpath = GUICtrlRead($Input1)
			$path = ($lolpath & '\Config')

			If $combocfg = "" Then
				$mb = MsgBox(0, @ScriptName, 'Choose config!')
			Else
				$mb = MsgBox(4, @ScriptName, 'Are you sure you want to replace "' & $combocfg & '" with current config?')
				If $mb = $IDYES Then
					;==== DELETE current cfg ====
					FileDelete($path & "\PersistedSettings.json")
					FileDelete($path & "\input.ini")
					;==== REPLACE WITH SAVED ====
					FileCopy($path & "\Saved CFGs\" & $combocfg & '\PersistedSettings.json', $path)
					FileCopy($path & "\Saved CFGs\" & $combocfg & '\input.ini', $path)
					;==== DONE ====
					MsgBox(0, @ScriptName, 'Config sucesfully replaced')
				EndIf
			EndIf
		Case $scfg
			$lolpath = GUICtrlRead($Input1)
			$path = ($lolpath & '\Config')
			ShellExecute($path & "\Saved CFGs")
		Case $scfg02
			$lolpath = GUICtrlRead($Input1)
			$path = ($lolpath & '\Config')
			ShellExecute($path & "\Saved CFGs")
	EndSwitch
WEnd

