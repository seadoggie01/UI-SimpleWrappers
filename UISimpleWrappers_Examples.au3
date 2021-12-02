#include <UISimpleWrappers.au3>

;~ Window: Untitled - Notepad
;~     Edit: Text Editor
;~         ScrollBar: Vertical
;~             Button: Line up
;~             Button: Line down
;~     StatusBar: msctls_statusbar32
;~         Text
;~         Text:    Windows (CRLF)
;~         Text:    Ln 1, Col 1
;~         Text: 100%
;~     TitleBar
;~         MenuBar: System
;~             MenuItem: System
;~         Button: Minimize
;~         Button: Maximize
;~         Button: Close
;~     MenuBar: Application
;~         MenuItem: File
;~         MenuItem: Edit
;~         MenuItem: Format
;~         MenuItem: View
;~         MenuItem: Help


Notepad_Example()

Func Notepad_Example()

	; Open Notepad
	Run("notepad")
	If @error Then Exit ConsoleWrite("Failed to run Notepad" & @CRLF)

	; Wait for NotePad to open
	WinWait("Untitled - Notepad")

	; Create the UI Automation object
	Local $oUI = _UIW_Create()
	If @error Then Exit ConsoleWrite("_UIW_Create - Error: " & @error & " Extended: " & @extended & " Unable to open UI Automation object" & @CRLF)

	; Create the top level UI automation parent -- the desktop
	Local $oDesktop = _UIW_RootObject($oUI)
	If @error Then Exit ConsoleWrite("_UIW_RootObject - Error: " & @error & " Extended: " & @extended & " Unable to create the desktop object" & @CRLF)

	; Find the notepad window (Mostly, windows will be children of the desktop)
	;	Note the format here, it's similar to AutoIt's format, just without the leading and trailing brackets
	;	This will automatically convert this into a Name property condition (is that the right term? Someone correct me here!)
	Local $oNotepadWin = _UIW_FindFirst($oDesktop, "NAME:Untitled - Notepad")
	If @error Then Exit ConsoleWrite("_UIW_FindFirst - Error: " & @error & " Extended: " & @extended & " Notepad wasn't found" & @CRLF)

	#CS
	; You can use the longer version as well, which creates the property condition, then finds the object. I like the shortened version
	; 	which handles the simpler property conditions in string form. See the UDF for all supported parsing options.
	;	Capitalization of the property conditions aren't required, but make it easier to read, imho.

	; First, create the property condition that will match the window. In this case, using the name (AutoIt calls it TITLE) is enough.
	Local $pNameCondition = _UIW_NamePropertyCondition($oUI, "Untitled - Notepad")
	If @error Then Exit ConsoleWrite("_UIW_NamePropertyCondition - Error: " & @error & " Extended: " & @extended & " Can't create Name Property condition" & @CRLF)

	; Now find the first object that matches our condition
	Local $oNotepadWin = _UIW_FindFirst($oDesktop, $pNameCondition)
	If @error Then Exit ConsoleWrite("_UIW_NamePropertyCondition - Error: " & @error & " Extended: " & @extended & " Notepad wasn't found" & @CRLF)
	#CE

	; Now, we'll find the Edit associated with Notepad
	;	Note that here we use Name and Class to find the edit.
	;	You can add as many conditions as you need, separate them by semi-colons
	;	All conditions you add in string form are combined in AND conditions
	;	The equivalent long version (without error handling) is as follows:
	;		_UIW_CreateAndCondition($oUI,
	;			_UIW_NamePropertyCondition($oUI, "TextEditor"),
	;			_UIW_ClassPropertyCondition($oUI, "Edit"))
	Local $oEdit = _UIW_FindFirst($oNotepadWin, "NAME:Text Editor;CLASS:Edit")
	If @error Then Exit ConsoleWrite("_UIW_FindFirst - Error: " & @error & " Extended: " & @extended & " Edit wasn't found" & @CRLF)

	; Set the value of the Edit
	_UIW_SetValue($oEdit, "Hello, world!")
	If @error Then Exit ConsoleWrite("_UIW_SetValue - Error: " & @error & " Extended: " & @extended & " Unable to set value of Edit" & @CRLF)

	ConsoleWrite("_UIW_GetValue - Value: " & _UIW_GetValue($oEdit) & @CRLF)

EndFunc
