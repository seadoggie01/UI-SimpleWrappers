#include <CUIAutomation2.au3>

; Currently supported property values for parsing: Bool, Type, Class, Name, ID, AccessKey
Global Const $__g_UISWrapperProperties[][] = [_
	["Name", "UISWrappers"], _
	["Version", "0.0.0.1"], _
	["Updated", "November 25, 2019"], _
	["Authors", "Seadoggie01"], _
	["Contributors", "LarsJ"] _
]

Global $__g_oUIAutomation

#Region ### Global Consts ###

Global Const $UIW_IAccessible[2] = [$sIID_IAccessible, $dtagIAccessible]
Global Const $UIW_IRawElementProviderSimple[2] = [$sIID_IRawElementProviderSimple, $dtagIRawElementProviderSimple]
Global Const $UIW_Automation[2] = [$sIID_IUIAutomation, $dtagIUIAutomation]
Global Const $UIW_AndCondition[2] = [$sIID_IUIAutomationAndCondition, $dtagIUIAutomationAndCondition]
Global Const $UIW_BoolCondition[2] = [$sIID_IUIAutomationBoolCondition, $dtagIUIAutomationBoolCondition]
Global Const $UIW_CacheRequest[2] = [$sIID_IUIAutomationCacheRequest, $dtagIUIAutomationCacheRequest]
Global Const $UIW_Condition[2] = [$sIID_IUIAutomationCondition, $dtagIUIAutomationCondition]
Global Const $UIW_DockPattern[3] = [$sIID_IUIAutomationDockPattern, $dtagIUIAutomationDockPattern, $UIA_DockPatternId]
Global Const $UIW_Element[2] = [$sIID_IUIAutomationElement, $dtagIUIAutomationElement]
Global Const $UIW_ElementArray[2] = [$sIID_IUIAutomationElementArray, $dtagIUIAutomationElementArray]
Global Const $UIW_EventHandler[2] = [$sIID_IUIAutomationEventHandler, $dtagIUIAutomationEventHandler]
Global Const $UIW_ExpandCollapsePattern[3] = [$sIID_IUIAutomationExpandCollapsePattern, $dtagIUIAutomationExpandCollapsePattern, $UIA_ExpandCollapsePatternId]
Global Const $UIW_FocusChangedEventHandler[2] = [$sIID_IUIAutomationFocusChangedEventHandler, $dtagIUIAutomationFocusChangedEventHandler]
Global Const $UIW_GridItemPattern[3] = [$sIID_IUIAutomationGridItemPattern, $dtagIUIAutomationGridItemPattern, $UIA_GridItemPatternId]
Global Const $UIW_GridPattern[3] = [$sIID_IUIAutomationGridPattern, $dtagIUIAutomationGridPattern, $UIA_GridPatternId]
Global Const $UIW_InvokePattern[3] = [$sIID_IUIAutomationInvokePattern, $dtagIUIAutomationInvokePattern, $UIA_InvokePatternId]
Global Const $UIW_ItemContainerPattern[3] = [$sIID_IUIAutomationItemContainerPattern, $dtagIUIAutomationItemContainerPattern, $UIA_ItemContainerPatternId]
Global Const $UIW_LegacyIAccessiblePattern[3] = [$sIID_IUIAutomationLegacyIAccessiblePattern, $dtagIUIAutomationLegacyIAccessiblePattern, $UIA_LegacyIAccessiblePatternId]
Global Const $UIW_MultipleViewPattern[3] = [$sIID_IUIAutomationMultipleViewPattern, $dtagIUIAutomationMultipleViewPattern, $UIA_MultipleViewPatternId]
Global Const $UIW_NotCondition[2] = [$sIID_IUIAutomationNotCondition, $dtagIUIAutomationNotCondition]
Global Const $UIW_OrCondition[2] = [$sIID_IUIAutomationOrCondition, $dtagIUIAutomationOrCondition]
Global Const $UIW_PropertyChangedEventHandler[2] = [$sIID_IUIAutomationPropertyChangedEventHandler, $dtagIUIAutomationPropertyChangedEventHandler]
Global Const $UIW_PropertyCondition[2] = [$sIID_IUIAutomationPropertyCondition, $dtagIUIAutomationPropertyCondition]
Global Const $UIW_ProxyFactory[2] = [$sIID_IUIAutomationProxyFactory, $dtagIUIAutomationProxyFactory]
Global Const $UIW_ProxyFactoryEntry[2] = [$sIID_IUIAutomationProxyFactoryEntry, $dtagIUIAutomationProxyFactoryEntry]
Global Const $UIW_ProxyFactoryMapping[2] = [$sIID_IUIAutomationProxyFactoryMapping, $dtagIUIAutomationProxyFactoryMapping]
Global Const $UIW_RangeValuePattern[3] = [$sIID_IUIAutomationRangeValuePattern, $dtagIUIAutomationRangeValuePattern, $UIA_RangeValuePatternId]
Global Const $UIW_ScrollItemPattern[3] = [$sIID_IUIAutomationScrollItemPattern, $dtagIUIAutomationScrollItemPattern, $UIA_ScrollItemPatternId]
Global Const $UIW_ScrollPattern[3] = [$sIID_IUIAutomationScrollPattern, $dtagIUIAutomationScrollPattern, $UIA_ScrollPatternId]
Global Const $UIW_SelectionItemPattern[3] = [$sIID_IUIAutomationSelectionItemPattern, $dtagIUIAutomationSelectionItemPattern, $UIA_SelectionItemPatternId]
Global Const $UIW_SelectionPattern[3] = [$sIID_IUIAutomationSelectionPattern, $dtagIUIAutomationSelectionPattern, $UIA_SelectionPatternId]
Global Const $UIW_StructureChangedEventHandler[2] = [$sIID_IUIAutomationStructureChangedEventHandler, $dtagIUIAutomationStructureChangedEventHandler]
Global Const $UIW_SynchronizedInputPattern[3] = [$sIID_IUIAutomationSynchronizedInputPattern, $dtagIUIAutomationSynchronizedInputPattern, $UIA_SynchronizedInputPatternId]
Global Const $UIW_TableItemPattern[3] = [$sIID_IUIAutomationTableItemPattern, $dtagIUIAutomationTableItemPattern, $UIA_TableItemPatternId]
Global Const $UIW_TablePattern[3] = [$sIID_IUIAutomationTablePattern, $dtagIUIAutomationTablePattern, $UIA_TablePatternId]
Global Const $UIW_TextPattern[3] = [$sIID_IUIAutomationTextPattern, $dtagIUIAutomationTextPattern, $UIA_TextPatternId]
Global Const $UIW_TextRange[2] = [$sIID_IUIAutomationTextRange, $dtagIUIAutomationTextRange]
Global Const $UIW_TextRangeArray[2] = [$sIID_IUIAutomationTextRangeArray, $dtagIUIAutomationTextRangeArray]
Global Const $UIW_TogglePattern[3] = [$sIID_IUIAutomationTogglePattern, $dtagIUIAutomationTogglePattern, $UIA_TogglePatternId]
Global Const $UIW_TransformPattern[3] = [$sIID_IUIAutomationTransformPattern, $dtagIUIAutomationTransformPattern, $UIA_TransformPatternId]
Global Const $UIW_TreeWalker[2] = [$sIID_IUIAutomationTreeWalker, $dtagIUIAutomationTreeWalker]
Global Const $UIW_ValuePattern[3] = [$sIID_IUIAutomationValuePattern, $dtagIUIAutomationValuePattern, $UIA_ValuePatternId]
Global Const $UIW_VirtualizedItemPattern[3] = [$sIID_IUIAutomationVirtualizedItemPattern, $dtagIUIAutomationVirtualizedItemPattern, $UIA_VirtualizedItemPatternId]
Global Const $UIW_WindowPattern[3] = [$sIID_IUIAutomationWindowPattern, $dtagIUIAutomationWindowPattern, $UIA_WindowPatternId]

#EndRegion ### Global Consts ###

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_Create
; Description ...: Gets a UIAutomation object
; Syntax ........: _UIW_Create()
; Parameters ....: None
; Return values .: Success - A UI Automation object
;                  Failure - False and sets @error to 1
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_Create()

	Local $oUIAutomation = ObjCreateInterface($sCLSID_CUIAutomation, $sIID_IUIAutomation, $dtagIUIAutomation)
	If Not IsObj($oUIAutomation) Then
		_UIW_ErrorStack("_UIW_Create", 1)
		Return SetError(1, 0, False)
	EndIf
	$__g_oUIAutomation = $oUIAutomation
	Return $oUIAutomation

EndFunc   ;==>_UIW_Create

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_RootObject
; Description ...: Gets the UI Automation desktop object
; Syntax ........: _UIW_RootObject($oUIAutomation)
; Parameters ....: $oUIAutomation       - an object.
; Return values .: Success - the desktop object
;                  Failure - False and sets @error:
;                  | 1 - $oUIAutomation isn't an object
;                  | 2 - Unable to create $oDesktop
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_RootObject($oUIAutomation)

	If Not __UIW_Param($oUIAutomation, "Object", "InterfaceDispatch") Then
		_UIW_ErrorStack(1, "_UIW_RootObject")
		Return SetError(1, 0, False)
	EndIf

	Local $pDesktop, $oDesktop

	; Get the root object, a pointer to the desktop
	$oUIAutomation.GetRootElement($pDesktop)
	$oDesktop = ObjCreateInterface($pDesktop, $sIID_IUIAutomationElement, $dtagIUIAutomationElement)
	If Not IsObj($oDesktop) Then
		_UIW_ErrorStack(2, "_UIW_RootObject")
		Return SetError(2, 0, False)
	EndIf
	Return $oDesktop

EndFunc   ;==>_UIW_RootObject

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_FindFirst
; Description ...: Finds the first child matching the condition
; Syntax ........: _UIW_FindFirst($oParent, $vCondition)
; Parameters ....: $oParent             - an object.
;                  $vCondition          - a condition pointer or a string to be parsed.
; Return values .: Success - the first object matching the condition
;                  Failure - False and sets @error:
;                  | 1 - $oParent isn't an object
;                  | 2 - Can't parse string condition
;                  | 3 - No children found matching
;                  | 4 - COM error. @extended = COM Error
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_FindFirst($oParent, $vCondition)

	If Not IsObj($oParent) Then
		_UIW_ErrorStack(1, "_UIW_FindFirst")
		Return SetError(1, 0, False)
	EndIf
	$vCondition = __UIW_ParseCondition($__g_oUIAutomation, $vCondition)
	If @error Then
		SetError(2, @extended)
		_UIW_ErrorStack(2, "_UIW_FindFirst")
		Return False
	EndIf

	Local $hErr = __UIW_ErrHnd()
	#forceref $hErr

	Local $pResult
	$oParent.FindFirst($TreeScope_Descendants, $vCondition, $pResult)
	If @error Then
		SetError(4, @error, False)
		_UIW_ErrorStack(4, "_UIW_FindFirst")
		Return False
	EndIf
	Local $oResult = ObjCreateInterface($pResult, $sIID_IUIAutomationElement, $dtagIUIAutomationElement)
	If Not IsObj($oResult) Then
		_UIW_ErrorStack(3, "_UIW_FindFirst")
		Return SetError(3, 0, False)
	EndIf
	Return $oResult

EndFunc   ;==>_UIW_FindFirst

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_FindAll
; Description ...: Finds all elements matching the condition
; Syntax ........: _UIW_FindAll($oParent, $vCondition)
; Parameters ....: $oParent             - an object.
;                  $vCondition          - a pointer value or a string to create a condtion with.
; Return values .: Success - an array of matching elements.
;                  Failue - False and sets @error:
;                  | 1 - $vCondtion isn't a pointer and couldn't be parsed
;                  | 2 - $oParent.FindAll returned no matches
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_FindAll($oParent, $vCondition)

	$vCondition = __UIW_ParseCondition($__g_oUIAutomation, $vCondition)
	If @error Then
		_UIW_ErrorStack(1, "_UIW_FindAll")
		Return SetError(1, 0, False)
	EndIf

	Local $pCollection
	$oParent.FindAll($TreeScope_Descendants, $vCondition, $pCollection)
	Local $oCollection = ObjCreateInterface($pCollection, $sIID_IUIAutomationElementArray, $dtagIUIAutomationElementArray)
	If Not IsObj($oCollection) Then
		_UIW_ErrorStack(2, "_UIW_FindAll")
		Return SetError(2, 0, False)
	EndIf
	Return $oCollection

EndFunc   ;==>_UIW_FindAll

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_GetCurrentPattern
; Description ...: Gets the pattern from an element
; Syntax ........: _UIW_GetCurrentPattern($oParent, $aPatternId)
; Parameters ....: $oParent             - an object.
;                  $aPatternId          - an array of unknowns.
; Return values .: Success - the pattern object
;                  Failure - False and sets @error:
;                  | 1 - $aPatternId isn't an array
;                  | 2 - $oParent isn't an object
;                  | 3 - $aPatternId is invalid for this $oParent
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_GetCurrentPattern($oParent, $aPatternId)

	Local $pValue, $oValue
	If Not IsArray($aPatternId) Then
		_UIW_ErrorStack(1, "_UIW_GetCurrentPattern")
		Return SetError(1, 2, False)
	EndIf
	If Not IsObj($oParent) Then
		_UIW_ErrorStack(2, "_UIW_GetCurrentPattern")
		Return SetError(2, 0, False)
	EndIf
	$oParent.GetCurrentPattern($aPatternId[2], $pValue)
	$oValue = ObjCreateInterface($pValue, $aPatternId[0], $aPatternId[1])
	If Not IsObj($oValue) Then
		_UIW_ErrorStack(3, "_UIW_GetCurrentPattern")
		Return SetError(3, 0, False)
	EndIf
	Return $oValue

EndFunc   ;==>_UIW_GetCurrentPattern

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_SetValue
; Description ...: Sets the value of a UIAElement
; Syntax ........: _UIW_SetValue($oElement, $sText)
; Parameters ....: $oElement            - an object.
;                  $sText               - a string value.
; Return values .: Success - True
;                  Failure - False and sets @error
;                  | 1 - $oControl doesn't support setting the value
;                  | 2 - COM Error. @extended = COM Error
; Author ........: Seadoggie01
; Modified ......: November 21, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_SetValue($oElement, $sText)

	Local $oValue = _UIW_GetCurrentPattern($oElement, $UIW_ValuePattern)
	If @error Then Return SetError(1, 0, False)

	Local $hErr = __UIW_ErrHnd()
	#forceref $hErr
	$oValue.SetValue($sText)
	If @error Then
		_UIW_ErrorStack(2, "_UIW_SetValue")
		Return SetError(2, @error, False)
	EndIf

	Return True

EndFunc   ;==>_UIW_SetValue

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_Invoke
; Description ...: Invokes a control
; Syntax ........: _UIW_Invoke($oControl)
; Parameters ....: $oControl            - an object.
; Return values .: Success - True
;                  Failure - False and sets @error = 1
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......: Like clicking without the mouse
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_Invoke($oControl)

	Local $oInvoke = _UIW_GetCurrentPattern($oControl, $UIW_InvokePattern)
	If @error Then
		_UIW_ErrorStack(1, "_UIW_SetValue")
		Return SetError(1, 0, False)
	EndIf
	$oInvoke.Invoke()

EndFunc   ;==>_UIW_Invoke

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ExpandCollapse
; Description ...: Expands or collapses a control
; Syntax ........: _UIW_ExpandCollapse($oControl[, $bExpand = True])
; Parameters ....: $oControl            - an object.
;                  $bExpand             - [optional] a boolean value. Default is True.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: November 25, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ExpandCollapse($oControl, $bExpand = Default)

	If $bExpand = Default Then $bExpand = True

	Local $oExpand = _UIW_GetCurrentPattern($oControl, $UIW_ExpandCollapsePattern)
	If @error Then Return SetError(1, 0, False)
	If $bExpand Then
		$oExpand.Expand()
	Else
		$oExpand.Collapse()
	EndIf
	If @error Then
		SetError(2, @error)
		_UIW_ErrorStack(2, "_UIW_ExpandCollapse")
		Return False
	EndIf

	Return True

EndFunc   ;==>_UIW_ExpandCollapse

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_BoundingRectangle
; Description ...:
; Syntax ........: _UIW_BoundingRectangle($oControl)
; Parameters ....: $oControl            - an object.
; Return values .: Success - a bounding array
;                  Failure - False and sets @error = 1
; Author ........: Seadoggie01
; Modified ......: November 21, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_BoundingRectangle($oControl)

	Local $aRect
	$oControl.GetCurrentPropertyValue($UIA_BoundingRectanglePropertyId, $aRect)
	If Not IsArray($aRect) Then
		_UIW_ErrorStack(1, "_UIW_BoundingRectangle")
		Return SetError(1, 0, False)
	EndIf
	Return $aRect

EndFunc   ;==>_UIW_BoundingRectangle

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_MouseClick
; Description ...: Clicks on a control using the bounding rectange with $sButton
; Syntax ........: _UIW_MouseClick($oControl[, $sButton = Default[, $bBounce = Default]])
; Parameters ....: $oControl            - an object.
;                  $sButton             - [optional] a string value. Default is "left".
;                  $bBounce             - [optional] a boolean value. Default is True.
; Return values .: Success - True
;                  Failure - False and sets @error
;                  | 1 - Unable to get bounding rectange
; Author ........: LarsJ
; Modified ......: Seadoggie01 - November 25, 2019
; Remarks .......: I created a personal mouse click bounce function which had an option for which button to use... I copied _
;                    LarJ's idea for hidding the mouse. This is a modification of both of our functions.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_MouseClick($oControl, $sButton = Default, $bBounce = Default)

	If $sButton = Default Then $sButton = "left"
	If $bBounce = Default Then $bBounce = True

	Local $aBounds = _UIW_BoundingRectangle($oControl)
	If @error Then
		_UIW_ErrorStack("_UIW_MouseClick", 1)
		Return SetError(1, 0, False)
	EndIf

	_UIW_SetFocus($oControl)

	DllCall("user32.dll", "int", "ShowCursor", "bool", False)
	Local $aMousePos = MouseGetPos()
	MouseClick($sButton, $aBounds[0] + $aBounds[2] / 2, $aBounds[1] + $aBounds[3] / 2, 1, 0)
	If $bBounce Then MouseMove($aMousePos[0], $aMousePos[1], 0)
	DllCall("user32.dll", "int", "ShowCursor", "bool", True)

EndFunc   ;==>_UIW_MouseClick

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_SetFocus
; Description ...: Sets the current focus to an element
; Syntax ........: _UIW_SetFocus($oElement)
; Parameters ....: $oElement            - the element to use.
; Return values .: Success - True
;                  Failure - False and sets @error = 1
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_SetFocus($oElement)
	$oElement.SetFocus()
	If @error Then
		_UIW_ErrorStack(1, "_UIW_SetFocus")
		Return SetError(1, 0, False)
	EndIf
	Return True
EndFunc   ;==>_UIW_SetFocus

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ParseCondition
; Description ...: Depreciated
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ParseCondition($oUIAutomation, $sProperties)

	Debug("Depreciated Function! Pass properties string directly from now on.", "---> ")
	Local $ret = __UIW_ParseCondition($oUIAutomation, $sProperties)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_ParseCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ParseObject
; Description ...: Depreciated
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ParseObject($oUIAutomation, $oParent, $sProperties)
	#forceref $oUIAutomation
	Debug("Depreciated function! Replace with _UIW_FindFirst()", "---> ")

	; Pass commands to UIW Find First and return everything the same
	Local $ret = _UIW_FindFirst($oParent, $sProperties)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_ParseObject

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ErrorStack
; Description ...: Call this to get the stack of errors. Don't pass params to get the stack.
; Syntax ........: _UIW_ErrorStack([$iError = 0[, $sFunction = ""]])
; Parameters ....: $iError              - [optional] an integer value. Default is 0.
;                  $sFunction           - [optional] a string value. Default is "".
; Return values .: 0-Based 2D array [Function Name, Error]
; Author ........: Seadoggie01
; Modified ......: November 8, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ErrorStack($iError = 0, $sFunction = "")

	Static $aErrors[0]
	If $iError = 0 Then
		; Copy the errors
		Local $aRet = $aErrors
		; Clear the error stack
		ReDim $aErrors[0]
		; Return the error stack
		Return $aRet
	Else
		ReDim $aErrors[UBound($aErrors) + 1]
		$aErrors[UBound($aErrors) - 1] = $sFunction & ":" & $iError
		Return SetError($iError)
	EndIf

EndFunc   ;==>_UIW_ErrorStack

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_TreeWalkerCreate
; Description ...: Creates a Tree Walker using the specified condition
; Syntax ........: _UIW_TreeWalkerCreate($oUIAutomation, $vCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $vCondition          - a pointer value or string to be parsed.
; Return values .: Success - an IUIAutomationTreeWalker
;                  Failure - False and sets @error:
;                  | 1 - $vCondtion isn't a pointer and couldn't be parsed
;                  | 2 - Can't create tree walker from pointer
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_TreeWalkerCreate($oUIAutomation, $vCondition)

	$vCondition = __UIW_ParseCondition($oUIAutomation, $vCondition)
	If @error Then
		_UIW_ErrorStack(1, "_UIW_TreeWalkerCreate")
		Return SetError(1, 0, False)
	EndIf

	Local $oWalker
	$oUIAutomation.RawViewWalker($vCondition)
	$oWalker = ObjCreateInterface($vCondition, $sIID_IUIAutomationTreeWalker, $dtagIUIAutomationTreeWalker)
	If Not IsObj($oWalker) Then
		_UIW_ErrorStack(2, "_UIW_CreateTreeWalker")
		Return SetError(2, 0, False)
	EndIf
	Return $oWalker

EndFunc   ;==>_UIW_CreateTreeWalker

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_TreeWalkerGetFirst
; Description ...: Gets the first matching element
; Syntax ........: _UIW_TreeWalkerGetFirst($oWalker, $oControl, $pCondition)
; Parameters ....: $oWalker             - a Tree walker object.
;                  $oControl            - the object to search in.
;                  $pCondition          - the condition to match.
; Return values .: Success - the first child object matching the condition
;                  Failure - False and sets @error:
;                  | 1 - COM Error sets @extended to COM Error
; Author ........: Seadoggie01
; Modified ......: November 25, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_TreeWalkerGetFirst($oWalker, $oControl, $pCondition)

	Local $ret = $oWalker.GetFirstChildElement($oControl, $pCondition)
	If @error Then
		SetError(1, @error)
		_UIW_ErrorStack(2, "_UIW_TreeWalkerGetFirst")
		Return False
	EndIf
	Return $ret

EndFunc   ;==>_UIW_TreeWalkerGetFirst

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ElementProperty
; Description ...: Gets the property of an element
; Syntax ........: _UIW_ElementProperty($oElement, $sProperty)
; Parameters ....: $oElement            - an object.
;                  $sProperty           - the property name to get.
; Return values .: Success - The requested property value
;                  Failure - False and sets @error:
;                  | 1 - Unsupported Property name
;                  | 2 - COM Error and sets @extended = COM error
; Author ........: Seadoggie01
; Modified ......: November 21, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ElementProperty($oElement, $sProperty)
	Local $vRet = ""
	Local $hErr = __UIW_ErrHnd()
	#forceref $hErr
	Switch StringLower($sProperty)
		Case "name"
			$oElement.CurrentName($vRet)
		Case "value"
			$oElement.CurrentValue($vRet)
		Case Else
			Return SetError(1, 0, False)
	EndSwitch
	If @error Then Return SetError(2, @error, False)
	Return $vRet
EndFunc   ;==>_UIW_ElementProperty

#Region ### Conditions ###

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_BoolCondition
; Description ...: Creates a boolean condition for matching all or no elements
; Syntax ........: _UIW_BoolCondition($oUIAutomation, $bValue)
; Parameters ....: $oUIAutomation       - an object.
;                  $bValue              - a boolean value.
; Return values .: Success - A pointer to the requested bool condition
;                  Failure - False and sets @error = 1
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_BoolCondition($oUIAutomation, $bValue)

	Local $pCondition

	If $bValue Then
		$oUIAutomation.CreateTrueCondition($pCondition)
	Else
		$oUIAutomation.CreateFalseCondition($pCondition)
	EndIf

	; If it's not a pointer
	If Not IsPtr($pCondition) Then
		Return SetError(1, 0, False)
	EndIf

	Return $pCondition

EndFunc   ;==>_UIW_BoolCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_AccessKeyPropery
; Description ...:
; Syntax ........: _UIW_AccessKeyPropery($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_AccessKeyProperyCondition($oUIAutomation, $sCondition)

	Local $ret = __UIW_PropertyCondition($oUIAutomation, $UIA_AccessKeyPropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_AccessKeyPropery

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_AcceleratorKey
; Description ...:
; Syntax ........: _UIW_AcceleratorKey($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_AcceleratorKeyPropertyCondition($oUIAutomation, $sCondition)

	Local $ret = __UIW_PropertyCondition($oUIAutomation, $UIA_AcceleratorKeyPropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ClassNameProperty
; Description ...: Creates a class name property from the supplied string
; Syntax ........: _UIW_ClassNameProperty($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: Success - A pointer to a class name property
;                  Failure -
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ClassNamePropertyCondition($oUIAutomation, $sCondition)

	Local $ret = __UIW_PropertyCondition($oUIAutomation, $UIA_ClassNamePropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_ClassNameProperty

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_AutomationIdProperty
; Description ...:
; Syntax ........: _UIW_AutomationIdProperty($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_AutomationIdPropertyCondition($oUIAutomation, $sCondition)

	Local $ret = __UIW_PropertyCondition($oUIAutomation, $UIA_AutomationIdPropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_AutomationIdProperty

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_NameProperty
; Description ...:
; Syntax ........: _UIW_NameProperty($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_NamePropertyCondition($oUIAutomation, $sCondition)

	Local $ret = __UIW_PropertyCondition($oUIAutomation, $UIA_NamePropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_NameProperty

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ControlTypeProperty
; Description ...:
; Syntax ........: _UIW_ControlTypeProperty($oUIAutomation, $ControlTypeId)
; Parameters ....: $oUIAutomation       - an object.
;                  $ControlTypeId       - an unknown value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ControlTypePropertyCondition($oUIAutomation, $ControlTypeId)

	Local $ret = __UIW_PropertyCondition($oUIAutomation, $UIA_ControlTypePropertyId, $ControlTypeId)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_ControlTypeProperty

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_CreateOrCondition
; Description ...:
; Syntax ........: _UIW_CreateOrCondition($oUIAutomation, $pCondition1, $pCondition2)
; Parameters ....: $oUIAutomation       - an object.
;                  $pCondition1         - a pointer value.
;                  $pCondition2         - a pointer value.
; Return values .: Success - an AndCondtion
;                  Failure - False and Sets @error = 1
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_CreateOrCondition($oUIAutomation, $pCondition1, $pCondition2)
	Local $pRetCondition
	$oUIAutomation.CreateOrCondition($pCondition1, $pCondition2, $pRetCondition)
	If Not $pRetCondition Then
		_UIW_ErrorStack(1, "_UIW_CreateAndCondition")
		Return SetError(1, 0, False)
	EndIf
	Return $pRetCondition

EndFunc   ;==>_UIW_CreateAndCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_CreateAndCondition
; Description ...:
; Syntax ........: _UIW_CreateAndCondition($oUIAutomation, $pCondition1, $pCondition2)
; Parameters ....: $oUIAutomation       - an object.
;                  $pCondition1         - a pointer value.
;                  $pCondition2         - a pointer value.
; Return values .: Success - an AndCondtion
;                  Failure - False and Sets @error = 1
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_CreateAndCondition($oUIAutomation, $pCondition1, $pCondition2)

	Local $pRetCondition
	$oUIAutomation.CreateAndCondition($pCondition1, $pCondition2, $pRetCondition)
	If Not $pRetCondition Then
		_UIW_ErrorStack(1, "_UIW_CreateAndCondition")
		Return SetError(1, 0, False)
	EndIf
	Return $pRetCondition

EndFunc   ;==>_UIW_CreateAndCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_CreateAndConditionFromArray
; Description ...:
; Syntax ........: _UIW_CreateAndConditionFromArray($oUIAutomation, $aConditions)
; Parameters ....: $oUIAutomation       - an object.
;                  $aConditions         - an array of unknowns.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_CreateAndConditionFromArray($oUIAutomation, $aConditions)

	#TODO: Works, but check if this is okay. Performance benefit from using CreateAndConditionFromArray?

	Local $pAndCondition = $aConditions[0]
	For $i = 1 To UBound($aConditions) - 1
		$pAndCondition = _UIW_CreateAndCondition($oUIAutomation, $pAndCondition, $aConditions[$i])
	Next

	Return $pAndCondition

EndFunc   ;==>_UIW_CreateAndConditionFromArray

#EndRegion ### Conditions ###

#Region #INTERNAL_USE_ONLY# =====================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __UIW_PropertyCondition
; Description ...: Creates a Property Condition
; Syntax ........: __UIW_PropertyCondition($oUIAutomation, $UIA_PROPERTY, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $UIA_PROPERTY        - an unknown value.
;                  $sCondition          - a string value.
; Return values .: Success - A pointer to a condition of $UIA_PROPERTY type
;                  Failure - False and sets @error = 1
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __UIW_PropertyCondition($oUIAutomation, $UIA_PROPERTY, $vCondition)

	Local $pCondition
	$oUIAutomation.CreatePropertyCondition($UIA_PROPERTY, $vCondition, $pCondition)
	If $pCondition Then Return $pCondition
	_UIW_ErrorStack("__UIW_PropertyCondition - UIA Property: " & $UIA_PROPERTY, 1)
	Return SetError(1, 0, False)

EndFunc   ;==>__UIW_PropertyCondition

; #INTERNAL_USE_ONLY# ========================f===================================================================================
; Name ..........: __UIW_ParseProperty
; Description ...: Takes a single property as a string and parses it to get that type of property conidtion
; Syntax ........: __UIW_ParseProperty($oUIAutomation, $sProperty)
; Parameters ....: $oUIAutomation       - an object.
;                  $sProperty           - a string value.
; Return values .: Success - $pCondition
;                  Failure - False and sets @error:
;                  | 1  - individual property condition error
;                  | 42 - unparseable
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __UIW_ParseProperty($oUIAutomation, $sProperty)

	Local $sPropertyName = StringSplit($sProperty, ":", 3)[0]
	Local $sPropertyValue = StringSplit($sProperty, ":", 3)[1]

	; Unescape all the characters!
	$sPropertyValue = StringReplace($sPropertyValue, "\\", "\")
	$sPropertyValue = StringReplace($sPropertyValue, "\;", ";")
	$sPropertyValue = StringReplace($sPropertyValue, "\:", ":")


;~ 	Debug($sPropertyName & "|" & $sPropertyValue)
	Local $vTemp
	Switch StringLower($sPropertyName)
		Case "type"
			$vTemp = _UIW_ControlTypeProperty($oUIAutomation, Number($sPropertyValue))
		Case "class"
			$vTemp = _UIW_ClassNameProperty($oUIAutomation, $sPropertyValue)
		Case "name"
			$vTemp = _UIW_NameProperty($oUIAutomation, $sPropertyValue)
		Case "id"
			$vTemp = _UIW_AutomationIdProperty($oUIAutomation, $sPropertyValue)
		Case "accesskey"
			$vTemp = _UIW_AccessKeyPropery($oUIAutomation, $sPropertyValue)
		Case "bool"
			$vTemp = _UIW_BoolCondition($oUIAutomation, $sPropertyValue)
		Case "acceleratorkey"
			$vTemp = _UIW_AcceleratorKeyPropertyCondition($oUIAutomation, $sPropertyValue)
		Case Else
			_UIW_ErrorStack("__UIW_ParseProperty", -1)
			Return SetError(-1, 0, False)
	EndSwitch

	Return SetError(@error, @extended, $vTemp)

EndFunc   ;==>__UIW_ParseProperty

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __UIW_ParseCondition
; Description ...: Creates a condition from a string that is parsed and has the properties parsed into conditions
; Syntax ........: _UIW_ParseCondition($oUIAutomation, $sProperties)
; Parameters ....: $oUIAutomation       - an object.
;                  $vProperties         - a string value or a pointer.
; Return values .: Success - a pointer to a condition
;                  Failure - False and sets @error:
;                  | 1 -
; Author ........: Seadoggie01
; Modified ......: November 7, 2019
; Remarks .......: Use Name:Value;Name2:Value2;Name3:Value3 format
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __UIW_ParseCondition($oUIAutomation, $vProperties)

	If IsPtr($vProperties) Then Return $vProperties

	; Split on semi-colons, ignoring if they are escaped with a backslash
	Local $asProperties = StringRegExp($vProperties, "((?:\\.|[^;\\]++)+)", 3)
	Local $aConditions[0], $pCondition
	; For each property name pair
	For $i = 0 To UBound($asProperties) - 1
		$pCondition = __UIW_ParseProperty($oUIAutomation, $asProperties[$i])
		If @error Then
			_UIW_ErrorStack(1, "__UIW_ParseCondition")
			Return SetError(1, $i, False)
		Else
			_Arr_ItemAdd($aConditions, $pCondition)
		EndIf
	Next

	If UBound($aConditions) > 2 Then
		$pCondition = _UIW_CreateAndConditionFromArray($oUIAutomation, $aConditions)
		If @error Then
			Return SetError(2, 0, False)
		EndIf
	ElseIf UBound($aConditions) = 1 Then
		$pCondition = $aConditions[0]
	Else
		$pCondition = _UIW_CreateAndCondition($oUIAutomation, $aConditions[0], $aConditions[1])
		If @error Then
			Return SetError(3, 0, False)
		EndIf
	EndIf
	; Don't put anything between below line and if statements, this passes back @error and @extended!
	Return SetError(@error, @extended, $pCondition)

EndFunc

Func __UIW_Param($vParam, $sType, $sObjName)
;~ 	Debug(VarGetType($vParam))
	If VarGetType($vParam) = $sType Then
		If $sType = "Object" Then
;~ 			Debug("Obj Name: " & ObjName($vParam))
			Return ObjName($vParam) = $sObjName
		Else
			Return True
		EndIf
	Else
		Return False
	EndIf

EndFunc   ;==>__UIW_Param

Func __UIW_ErrHnd()
	Return ObjEvent("AutoIt.Error", "__UIW_ErrorHandler")
	; 	Copy to add error handler to function
;~ 	Local $hErr = __UIW_ErrHnd()
;~ 	#forceref $hErr
EndFunc   ;==>__UIW_ErrHnd

Func __UIW_ErrorHandler($oError)
	#forceref $oError
	Debug("COM Error Encountered in " & @ScriptName & @CRLF & _
			"@AutoItVersion = " & @AutoItVersion & @CRLF & _
			"@AutoItX64 = " & @AutoItX64 & @CRLF & _
			"@Compiled = " & @Compiled & @CRLF & _
			"@OSArch = " & @OSArch & @CRLF & _
			"@OSVersion = " & @OSVersion & @CRLF & _
			"Scriptline = " & $oError.scriptline & @CRLF & _
			"NumberHex = " & Hex($oError.number, 8) & @CRLF & _
			"Number = " & $oError.number & @CRLF & _
			"WinDescription = " & StringStripWS($oError.WinDescription, 2) & @CRLF & _
			"Description = " & StringStripWS($oError.Description, 2) & @CRLF & _
			"Source = " & $oError.Source & @CRLF & _
			"HelpFile = " & $oError.HelpFile & @CRLF & _
			"HelpContext = " & $oError.HelpContext & @CRLF & _
			"LastDllError = " & $oError.LastDllError)
EndFunc   ;==>__UIW_ErrorHandler

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __UIW_ElementArrayToArray
; Description ...: Converts a IUIElementArray to an AutoIt array
; Syntax ........: __UIW_ElementArrayToArray($oElementArray)
; Parameters ....: $oElementArray       - an object.
; Return values .: A 1D 0-based array of the UIElements from the Element Array
; Author ........: Seadoggie01
; Modified ......: November 24, 2019
; Remarks .......: Uses IUIAutomationElementArray::get_Length and IUIAutomationElementArray::GetElement
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __UIW_ElementArrayToArray($oElementArray)

	Local $hErr = __UIW_ErrHnd()
	#forceref $hErr

	Local $iTemp, $pTemp, $oTemp
	$oElementArray.Length($iTemp)
	If @error Then Return SetError(@error, 0, False)
	Local $aReturn[$iTemp]
	For $i = 0 To $iTemp - 1
		$oElementArray.GetElement($i, $pTemp)
		If @error Then Return SetError(@error, $i, False)
		$oTemp = ObjCreateInterface($pTemp, $sIID_IUIAutomationElement, $dtagIUIAutomationElement)
		$aReturn[$i] = $oTemp
	Next
	Return $aReturn

EndFunc   ;==>__UIW_ElementArrayToArray

#EndRegion #INTERNAL_USE_ONLY# =====================================================================================================

#CS
#Region ### Testing ###

; For testing purposes
#include <CustomDebugging.au3>
#include <MyMisc.au3>

If @ScriptName = "UISimpleWrappers.au3" Then __UIW__INTERNALTESTING()

Func __UIW__INTERNALTESTING()

	WinActivate("Untitled - Notepad")
	WinWaitActive("Untitled - Notepad")

	Local $oUIAutomation = _UIW_Create()
	Local $oDesktop = _UIW_RootObject($oUIAutomation)
	Local $oNotepad = _UIW_FindFirst($oDesktop, "NAME:Untitled - Notepad;CLASS:Notepad")
	Local $oNoteEdit = _UIW_FindFirst($oNotepad, "NAME:Text Editor;ID:15;TYPE:" & $UIA_EditControlTypeId)
	If @error Then Exit Debug(_UIW_ErrorStack())
	_UIW_SetValue($oNoteEdit, "temporary file contents")
	Local $oFileMenu = _UIW_FindFirst($oNotepad, "NAME:File;TYPE:" & $UIA_MenuItemControlTypeId)
	_UIW_Invoke($oFileMenu)
	Sleep(250)
	Local $oSaveAsMenu = _UIW_FindFirst($oNotepad, "NAME:Save As...;TYPE:" & $UIA_MenuItemControlTypeId)
	_UIW_Invoke($oSaveAsMenu)

	WinWait("Save As", "")

	Local $oSaveAs = _UIW_FindFirst($oNotepad, "NAME:Save As;TYPE:" & $UIA_WindowControlTypeId)
	Local $oFileName = _UIW_FindFirst($oSaveAs, "CLASS:Edit;ACCESSKEY:Alt+n")
	_UIW_SetValue($oFileName, "temp.txt")
	Local $oSaveBtn = _UIW_FindFirst($oSaveAs, "CLASS:Button;NAME:Save")
	_UIW_Invoke($oSaveBtn)

	If WinWait("Confirm Save As", "", 2) Then
		Local $oConfirmSaveAs = _UIW_FindFirst($oSaveAs, "CLASS:CCPushButton;NAME:Yes")
		If @error Then Exit Debug(_Arr_ToString(_UIW_ErrorStack()))
		_UIW_Invoke($oConfirmSaveAs)
		If @error Then Exit Debug(_Arr_ToString(_UIW_ErrorStack()))
	EndIf

EndFunc   ;==>__UIW__INTERNALTESTING

#EndRegion ### Testing ###
#CE
