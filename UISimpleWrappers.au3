#include-once

; #INDEX# =======================================================================================================================
; Title .........: UI Simple Wrappers
; AutoIt Version : 3.3.14.5
; UDF Version ...: 0.0.0.1
; Language ......: English
; Description ...: A collection of functions for using UI Automation. Simply.
; Author(s) .....: Seadoggie01
; Modified.......: 20210120 (YYYYMMDD)
; Contributors ..: LarsJ (this is based almost entirely off of his examples)
;                  junkew (without his UDF, I never would've attempted this)
; Resources .....:
; ===============================================================================================================================

#include <CUIAutomation2.au3> ; This needs to be downloaded elsewhere. I've used the version available here --> https://www.autoitscript.com/forum/topic/201683-ui-automation-udfs/
; #include <UIAWrappers.au3> ; This was here for my reference (with TreeView scope(?). I still don't quite get them)

; Currently supported property values for text parsing: Bool, Type, Class, Name, ID, AccessKey, AcceleratorKey, LegacyIAccessibleState
; 	See __UIW_ParsePropertyCondition for more info

#CS

This has been a long journey. It all started with a program that default AutoIt functions couldn't handle. I started trying to use junkew's UDF,
but I was too new to AutoIt and too impatient. When I didn't get results fast enough, I switched to Mouse* functions. Later, I returned to find
LarsJ's examples. I was confused how his code was so different, but I gave it a shot. I got a couple things working, but I hated pointer variables.
This UDF stems from my hatred of pointers. Yeah. After I started getting things working, I noticed the repetitiveness of the code. Then I got
the idea to start combining some of the conditions into simpler terms. I realized the AutoIt methods made a lot of sense, so I modeled it after
them. Hopefully, you find this UDF helpful, enlighning, and/or hysterical.

-- Seadoggie01

P.S. Like with all my code, steal it, break it, warp it, just don't pretend it's yours... unless it's broken... then it's all yours!

Remarks:

	* This looks like a TON of functions, I know. However, a lot of these are shortcuts for _UIW_PropertyCondition. They just specify the $UIA_PropertyId for you.
		AND most of the functions accept a string instead of a control, skipping these functions entirely. Again, see examples!

	* Because of the compound nature of some of these functions, I've implemented the function _UIW_ErrorStack. This contains the name and error from each function
		The stack is only ever cleared by YOU! It returns an array of [[function, error]], which you can pass to _ArrayDisplay to track down errors. Hopefully, I can
		ditch this in the future, as I hate it now.

	* The global UI Automation object is used when a string is passed to a function instead of a condition. This allows me to build a condition from the string.
		See Examples. The object is only set when _UIW_Create is called, so it's a good idea (mandatory?) to use this function first.

	* I don't think I implemented nearly enough error handlers in these functions (I got bored), so a global error handler probably isn't a bad idea

#CE

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
Global Const $UIW_ExpandCollapseState[3] = [$sIID_IUIAutomationExpandCollapsePattern, $dtagIUIAutomationExpandCollapsePattern, $UIA_ExpandCollapsePatternId]
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
; Name ..........: _UIW_AcceleratorKey
; Description ...:
; Syntax ........: _UIW_AcceleratorKey($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: June 1, 2020 (@14:55:10)
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_AcceleratorKeyPropertyCondition($oUIAutomation, $sCondition)

	Local $ret = _UIW_PropertyCondition($oUIAutomation, $UIA_AcceleratorKeyPropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_AcceleratorKeyPropertyCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_AccessKeyPropery
; Description ...:
; Syntax ........: _UIW_AccessKeyPropery($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_AccessKeyProperyCondition($oUIAutomation, $sCondition)

	Local $ret = _UIW_PropertyCondition($oUIAutomation, $UIA_AccessKeyPropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_AccessKeyProperyCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_AutomationIdProperty
; Description ...:
; Syntax ........: _UIW_AutomationIdProperty($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_AutomationIdPropertyCondition($oUIAutomation, $sCondition)

	Local $ret = _UIW_PropertyCondition($oUIAutomation, $UIA_AutomationIdPropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_AutomationIdPropertyCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_BoolCondition
; Description ...: Creates a boolean condition for matching all or no elements
; Syntax ........: _UIW_BoolCondition($oUIAutomation, $bValue)
; Parameters ....: $oUIAutomation       - an object.
;                  $bValue              - a boolean value.
; Return values .: Success - A pointer to the requested bool condition
;                  Failure - False and sets @error = 1
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_BoolCondition($oUIAutomation, $bValue)

	If Not IsBool($bValue) Then $bValue = StringLower($bValue) = "true"

	Local $pCondition

	If $bValue Then
		$oUIAutomation.CreateTrueCondition($pCondition)
	Else
		$oUIAutomation.CreateFalseCondition($pCondition)
	EndIf

	; If it's not a pointer
	If Not $pCondition Then Return SetError(_UIW_ErrorStack(1, "_UIW_BoolCondition"), 0, False)

	Return $pCondition

EndFunc   ;==>_UIW_BoolCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_BoundingRectangle
; Description ...: Gets the edges of a control. Useful for clicking.
; Syntax ........: _UIW_BoundingRectangle($oControl)
; Parameters ....: $oControl            - an object.
; Return values .: Success - a bounding array
;                  Failure - False and sets @error = 1
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_BoundingRectangle($oControl)

	Local $aRect
	$oControl.GetCurrentPropertyValue($UIA_BoundingRectanglePropertyId, $aRect)
	If Not IsArray($aRect) Then Return SetError(_UIW_ErrorStack(1, "_UIW_BoundingRectangle"), 0, False)
	Return $aRect

EndFunc   ;==>_UIW_BoundingRectangle

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ClassNameProperty
; Description ...: Creates a class name property from the supplied string
; Syntax ........: _UIW_ClassNameProperty($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: Success - A pointer to a class name property
;                  Failure -
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ClassNamePropertyCondition($oUIAutomation, $sCondition)

	Local $ret = _UIW_PropertyCondition($oUIAutomation, $UIA_ClassNamePropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_ClassNamePropertyCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ControlPattern
; Description ...: Gets the value of the specified Control pattern for the control
; Syntax ........: _UIW_ControlPattern($oControl, $iProperty)
; Parameters ....: $oControl            - an object.
;                  $iProperty           - an integer value.
; Return values .: Success - the value of the Control pattern
;                  Failure - False and sets @error:
;                  |1 - $oControl isn't an object
;                  |2 - COM Error: @extended is set to error
; Author ........: Seadoggie01 - December 4, 2019
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ControlPattern($oControl, $iProperty)

	If Not __UIW_Param($oControl, "Object", "InterfaceDispatch") Then Return SetError(1, 0, False)
	Local $iRet
	$oControl.GetCurrentPropertyValue($iProperty, $iRet)
	If @error Then Return SetError(2, @error, False)
	Return $iRet

EndFunc   ;==>_UIW_ControlPattern

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ControlTypeProperty
; Description ...:
; Syntax ........: _UIW_ControlTypeProperty($oUIAutomation, $ControlTypeId)
; Parameters ....: $oUIAutomation       - an object.
;                  $ControlTypeId       - an unknown value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ControlTypePropertyCondition($oUIAutomation, $ControlTypeId)

	Local $ret = _UIW_PropertyCondition($oUIAutomation, $UIA_ControlTypePropertyId, $ControlTypeId)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_ControlTypePropertyCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_Create
; Description ...: Gets a UIAutomation object
; Syntax ........: _UIW_Create()
; Parameters ....: None
; Return values .: Success - A UI Automation object
;                  Failure - False and sets @error to 1
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
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
; Name ..........: _UIW_CreateAndCondition
; Description ...:
; Syntax ........: _UIW_CreateAndCondition($oUIAutomation, $pCondition1, $pCondition2)
; Parameters ....: $oUIAutomation       - an object.
;                  $pCondition1         - a pointer value.
;                  $pCondition2         - a pointer value.
; Return values .: Success - an AndCondtion
;                  Failure - False and Sets @error = 1
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
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
; Description ...: Creates a single condition from an array of conditions
; Syntax ........: _UIW_CreateAndConditionFromArray($oUIAutomation, $aConditions)
; Parameters ....: $oUIAutomation       - an object.
;                  $aConditions         - an 0-based 1D array of conditions.
; Return values .: a condition that includes all conditions
; Author ........: Seadoggie01
; Modified ......: January 21, 2021
; Remarks .......: This is a cheap trick because I couldn't get it to work. It works though.
;                  This is useful when you need many conditions to find an object.
; Related .......: _UIW_CreateAndCondition
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_CreateAndConditionFromArray($oUIAutomation, $aConditions)

	;#ToDo: Works, but check if performance benefit from using CreateAndConditionFromArray? @LarsJ

	Local $pAndCondition = $aConditions[0]
	For $i = 1 To UBound($aConditions) - 1
		$pAndCondition = _UIW_CreateAndCondition($oUIAutomation, $pAndCondition, $aConditions[$i])
	Next

	Return $pAndCondition

EndFunc   ;==>_UIW_CreateAndConditionFromArray

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
; Modified ......: October 14, 2020
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

EndFunc   ;==>_UIW_CreateOrCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ElementFromPoint
; Description ...: Gets the element underneath a point on the screen
; Syntax ........: _UIW_ElementFromPoint($oUIAutomation, $iX, $iY)
; Parameters ....: $oUIAutomation       - an object.
;                  $iX                  - an integer value.
;                  $iY                  - an integer value.
; Return values .: Success - the element underneath the point
;                  Failure - False and sets @error:
;                  |3 - Unable to create element from point
; Author ........: Seadoggie01
; Modified ......: January 21, 2021
; Remarks .......: Not well tested... if at all. Use caution?
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ElementFromPoint($oUIAutomation, $iX, $iY)

	Local $tStructPoint = DllStructCreate("int x; int y")
	DllStructSetData($tStructPoint, "x", $iX)
	DllStructSetData($tStructPoint, "y", $iY)

	Local $pElement
	$oUIAutomation.GetElementFromPoint($tStructPoint, $pElement)

	Local $oElement = ObjCreateInterface($pElement, $sIID_IUIAutomationElement, $dtagIUIAutomationElement)
	If Not IsObj($oElement) Then Return SetError(3, 0, False)

	Return $oElement

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ElementProperty
; Description ...: Gets the property of an element
; Syntax ........: _UIW_ElementProperty($oElement, $sProperty)
; Parameters ....: $oElement            - an object.
;                  $sProperty           - the property name to get.
; Return values .: Success - The requested property value
;                  Failure - False and sets @error:
;                  |1 - $oElement isn't an Object
;                  |2 - Unsupported Property name
;                  |3 - COM Error and sets @extended = COM error
; Author ........: Seadoggie01
; Modified ......: January 21, 2021
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ElementProperty($oElement, $sProperty)

	If Not __UIW_Param($oElement, "Object", "InterfaceDispatch") Then
		_UIW_ErrorStack(1, "_UIW_ElementProperty")
		Return SetError(1, 0, False)
	EndIf
	Local $vRet = ""
	Local $hErr = __UIW_ErrHnd()
	#forceref $hErr
	Switch StringLower($sProperty)
		Case "acceleratorkey"
			$oElement.CurrentAcceleratorKey($vRet)
		Case "accesskey"
			$oElement.CurrentAccessKey($vRet)
		Case "ariaproperties"
			$oElement.CurrentAriaProperties($vRet)
		Case "ariarole"
			$oElement.CurrentAriaRole($vRet)
		Case "automationid"
			$oElement.CurrentAutomationId($vRet)
		Case "boundingrectangle"
			$oElement.CurrentBoundingRectangle($vRet)
		Case "classname"
			$oElement.CurrentClassName($vRet)
		Case "controllerfor"
			$oElement.CurrentControllerFor($vRet)
		Case "controltype"
			$oElement.CurrentControlType($vRet)
		Case "culture"
			$oElement.CurrentCulture($vRet)
		Case "describedby"
			$oElement.CurrentDescribedBy($vRet)
		Case "flowsto"
			$oElement.CurrentFlowsTo($vRet)
		Case "frameworkid"
			$oElement.CurrentFrameworkId($vRet)
		Case "haskeyboardfocus"
			$oElement.CurrentHasKeyboardFocus($vRet)
		Case "helptext"
			$oElement.CurrentHelpText($vRet)
		Case "iscontentelement"
			$oElement.CurrentIsContentElement($vRet)
		Case "iscontrolelement"
			$oElement.CurrentIsControlElement($vRet)
		Case "isdatavalidforform"
			$oElement.CurrentIsDataValidForForm($vRet)
		Case "isenabled"
			$oElement.CurrentIsEnabled($vRet)
		Case "iskeyboardfocusable"
			$oElement.CurrentIsKeyboardFocusable($vRet)
		Case "isoffscreen"
			$oElement.CurrentIsOffscreen($vRet)
		Case "ispassword"
			$oElement.CurrentIsPassword($vRet)
		Case "isrequiredforform"
			$oElement.CurrentIsRequiredForForm($vRet)
		Case "itemstatus"
			$oElement.CurrentItemStatus($vRet)
		Case "itemtype"
			$oElement.CurrentItemType($vRet)
		Case "labeledby"
			$oElement.CurrentLabeledBy($vRet)
		Case "localizedcontroltype"
			$oElement.CurrentLocalizedControlType($vRet)
		Case "name"
			$oElement.CurrentName($vRet)
		Case "nativewindowhandle"
			$oElement.CurrentNativeWindowHandle($vRet)
		Case "orientation"
			$oElement.CurrentOrientation($vRet)
		Case "processid"
			$oElement.CurrentProcessId($vRet)
		Case "providerdescription"
			$oElement.CurrentProviderDescription($vRet)
		Case "getcurrentpattern"
			$oElement.GetCurrentPattern($vRet)
		Case "getcurrentpatternas"
			$oElement.GetCurrentPatternAs($vRet)
		Case "getcurrentpropertyvalue"
			$oElement.GetCurrentPropertyValue($vRet)
		Case "getcurrentpropertyvalueex"
			$oElement.GetCurrentPropertyValueEx($vRet)
		Case "runtimeid"
			$oElement.GetRuntimeId($vRet)
		Case Else
			Return SetError(2, 0, False)
	EndSwitch
	If @error Then Return SetError(3, @error, False)
	Return $vRet
EndFunc   ;==>_UIW_ElementProperty

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ErrorStack
; Description ...: Call this to get the stack of errors. Don't pass params to get the stack.
; Syntax ........: _UIW_ErrorStack([$iError = 0[, $sFunction = ""]])
; Parameters ....: $iError              - [optional] an integer value. Default is 0.
;                  $sFunction           - [optional] a string value. Default is "".
; Return values .: 0-Based 2D array of [Function Name, Error] in the order of occurance
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
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
		Return $iError
	EndIf

EndFunc   ;==>_UIW_ErrorStack

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ExpandCollapse
; Description ...: Expands or collapses a control
; Syntax ........: _UIW_ExpandCollapse($oControl[, $bExpand = True])
; Parameters ....: $oControl            - an object.
;                  $bExpand             - [optional] a boolean value. Default is True.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
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
; Name ..........: _UIW_FindAll
; Description ...: Finds all elements matching the condition
; Syntax ........: _UIW_FindAll($oParent, $vCondition[, $TreeScope = $TreeScope_Children])
; Parameters ....: $oParent             - an object.
;                  $vCondition          - a pointer value or a string to create a condtion with.
;                  $TreeScope           - [optional] the scope of the search, a value of TreeScope. Default is $TreeScope_Children.
; Return values .: Success - an array of matching elements.
;                  Failue - False and sets @error:
;                  | 1 - $vCondtion isn't a pointer and couldn't be parsed
;                  | 2 - $oParent.FindAll returned no matches
;                  | 3 - $oParent isn't an object
; Author ........: Seadoggie01
; Modified ......: January 21, 2021
; Remarks .......:
; Related .......: _UIW_FindFirst
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_FindAll($oParent, $vCondition, $TreeScope = $TreeScope_Children)

	If Not __UIW_Param($oParent, "Object", "InterfaceDispatch") Then
		_UIW_ErrorStack(3, "_UIW_FindAll")
		Return SetError(3, 0, False)
	EndIf

	$vCondition = __UIW_ParseCondition($__g_oUIAutomation, $vCondition)
	If @error Then
		_UIW_ErrorStack(1, "_UIW_FindAll")
		Return SetError(1, 0, False)
	EndIf

	Local $pCollection
	$oParent.FindAll($TreeScope, $vCondition, $pCollection)
	Local $oCollection = ObjCreateInterface($pCollection, $sIID_IUIAutomationElementArray, $dtagIUIAutomationElementArray)
	If Not IsObj($oCollection) Then Return SetError(_UIW_ErrorStack(2, "_UIW_FindAll"), 0, False)

	Return __UIW_ElementArrayToArray($oCollection)

EndFunc   ;==>_UIW_FindAll

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_FindFirst
; Description ...: Finds the first child matching the condition
; Syntax ........: _UIW_FindFirst($oParent, $vCondition[, $TreeScope = $TreeScope_Children])
; Parameters ....: $oParent             - an object.
;                  $vCondition          - a condition pointer or a string to be parsed.
;                  $TreeScope           - [optional] the scope of the search, a value of TreeScope. Default is $TreeScope_Children.
; Return values .: Success - the first object matching the condition
;                  Failure - False and sets @error:
;                  | 1 - $oParent isn't an object
;                  | 2 - Can't parse string condition
;                  | 3 - No children found matching
;                  | 4 - Can't create object from child pointer
;                  | 5 - COM error. @extended = COM Error
; Author ........: Seadoggie01
; Modified ......: January 21, 2021
; Remarks .......:
; Related .......: _UIW_FindAll
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_FindFirst($oParent, $vCondition, $TreeScope = Default)

	If Not IsObj($oParent) Then Return SetError(_UIW_ErrorStack(1, "_UIW_FindFirst"), @error, False)
	If IsKeyword($TreeScope) Then $TreeScope = $TreeScope_Children

	$vCondition = __UIW_ParseCondition($__g_oUIAutomation, $vCondition)
	If @error Then Return SetError(2, @extended, _UIW_ErrorStack(2, "_UIW_FindFirst"))

	Local $hErr = __UIW_ErrHnd()
	#forceref $hErr

	Local $pResult
	$oParent.FindFirst($TreeScope, $vCondition, $pResult)
	If @error Then Return SetError(_UIW_ErrorStack(5, "_UIW_FindFirst"), @error, False)

	If Not $pResult Then Return SetError(_UIW_ErrorStack(3, "_UIW_FindFirst"), @error, False)

	Local $oResult = ObjCreateInterface($pResult, $sIID_IUIAutomationElement, $dtagIUIAutomationElement)
	If Not IsObj($oResult) Then Return SetError(_UIW_ErrorStack(4, "_UIW_FindFirst"), @error, False)

	Return $oResult

EndFunc   ;==>_UIW_FindFirst

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
; Modified ......: October 14, 2020
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
; Name ..........: _UIW_Invoke
; Description ...: Invokes a control
; Syntax ........: _UIW_Invoke($oControl)
; Parameters ....: $oControl            - an object.
; Return values .: Success - True
;                  Failure - False and sets @error = 1
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......: Like clicking without the mouse
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_Invoke($oControl)

	Local $oInvoke = _UIW_GetCurrentPattern($oControl, $UIW_InvokePattern)
	If @error Then Return SetError(_UIW_ErrorStack(1, "_UIW_SetValue"), 0, False)
	$oInvoke.Invoke()

EndFunc   ;==>_UIW_Invoke

Func _UIW_LegacyIAccessibleStatePropertyCondition($oUIAutomation, $sCondition)

	Local $ret = _UIW_PropertyCondition($oUIAutomation, $UIA_LegacyIAccessibleStatePropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_LegacyIAccessibleStatePropertyCondition

Func _UIW_LegacyIAccessibleSelect($oControl)

	Local $oSelect = _UIW_GetCurrentPattern($oControl, $UIW_LegacyIAccessiblePattern)
	If @error Then Return SetError(1, 0, False)

	$oSelect.Select(0x8)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_MouseClick
; Description ...: Clicks on a control using the bounding rectange with $sButton
; Syntax ........: _UIW_MouseClick($oControl[, $sButton = Default[, $bBounce = Default]])
; Parameters ....: $oControl            - an object.
;                  $sButton             - [optional] button to click with. Default is "left".
;                  $bBounce             - [optional] True to move mouse and return when finished. Default is True.
; Return values .: Success - True
;                  Failure - False and sets @error
;                  | 1 - Unable to get bounding rectange
; Author ........: LarsJ, Seadoggie01
; Modified ......: January 21, 2021
; Remarks .......: I created a mouse click bounce function which had an option for which button to use... I copied
;                + LarJ's idea for hidding the mouse. This is a modification of both of our functions.
;                  It seems to not work in some locations on a multi-monitor setup (mine uses two differently sized screens)
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_MouseClick($oControl, $sButton = Default, $bBounce = Default)

	If IsKeyword($sButton) Then $sButton = "left"
	If IsKeyword($bBounce) Then $bBounce = True

	; Get the edges of the control
	Local $aBounds = _UIW_BoundingRectangle($oControl)
	If @error Then Return SetError(_UIW_ErrorStack("_UIW_MouseClick", 1), 0, False)

	; get the mouse's current position
	Local $aMousePos = MouseGetPos()

	; Hide the mouse
	DllCall("user32.dll", "int", "ShowCursor", "bool", False)
	; Trap the mouse at the specified location
	__UIW_MouseTrap($aBounds[0] + $aBounds[2] / 2, $aBounds[1] + $aBounds[3] / 2, $aBounds[0] + $aBounds[2] / 2, $aBounds[1] + $aBounds[3] / 2)
	; Perform the click
	MouseClick($sButton, $aBounds[0] + $aBounds[2] / 2, $aBounds[1] + $aBounds[3] / 2, 1, 0)
	; Release the trap
	__UIW_MouseTrap()
	; Move the mouse back
	If $bBounce Then MouseMove($aMousePos[0], $aMousePos[1], 0)
	; Show the mouse
	DllCall("user32.dll", "int", "ShowCursor", "bool", True)

	Return True

EndFunc   ;==>_UIW_MouseClick

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_NameProperty
; Description ...:
; Syntax ........: _UIW_NameProperty($oUIAutomation, $sCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $sCondition          - a string value.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_NamePropertyCondition($oUIAutomation, $sCondition)

	Local $ret = _UIW_PropertyCondition($oUIAutomation, $UIA_NamePropertyId, $sCondition)
	Return SetError(@error, @extended, $ret)

EndFunc   ;==>_UIW_NamePropertyCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ParseCondition
; Description ...: Depreciated
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Seadoggie01
; Modified ......: November 16, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ParseCondition($oUIAutomation, $sProperties)

	#forceref $oUIAutomation
	__UIW_Debug("_UIW_ParseCondition: Depreciated Function! Pass properties string directly from now on.", "---> ")
	Return $sProperties

EndFunc   ;==>_UIW_ParseCondition

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_ParseObject
; Description ...: Depreciated
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Seadoggie01
; Modified ......: November 16, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_ParseObject($oUIAutomation, $oParent, $sProperties)
	#forceref $oUIAutomation, $oParent
	__UIW_Debug("_UIW_ParseObject: Depreciated function! Replace with _UIW_FindFirst()", "---> ")
	Return $sProperties

EndFunc   ;==>_UIW_ParseObject

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_PropertyCondition
; Description ...: Creates a property condition
; Syntax ........: _UIW_PropertyCondition($oUIAutomation, $UIA_PropertyId, $vCondition)
; Parameters ....: $oUIAutomation       - an object.
;                  $UIA_PropertyId      - a Property ID, see module UIA_PropertyIds in CUIAutomation2.
;                  $vCondition          - a variant value.
; Return values .: Success - a pointer to the condition requested
;                  Failure - False and sets @error:
;                  |1 - Unable to create property condition, @extended set to COM error.
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_PropertyCondition($oUIAutomation, $UIA_PropertyId, $vCondition)

	Local $pCondition
	$oUIAutomation.CreatePropertyCondition($UIA_PropertyId, $vCondition, $pCondition)
	If $pCondition Then Return $pCondition
	Return SetError(_UIW_ErrorStack(1, "_UIW_PropertyCondition - UIA Property: " & $UIA_PropertyId), @extended, False)

EndFunc   ;==>_UIW_PropertyCondition

Func _UIW_RawViewWalker($oUIAutomation)

	Local $pRawViewWalker
	$oUIAutomation.RawViewWalker($pRawViewWalker)
	Local $oTreeView = ObjCreateInterface($pRawViewWalker, $sIID_IUIAutomationTreeWalker, $dtagIUIAutomationTreeWalker)
	If Not IsObj($oTreeView) Then Return SetError(_UIW_ErrorStack(1, "_UIW_RawViewWalker"), 0, False)
	Return $oTreeView

EndFunc   ;==>_UIW_RawViewWalker

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
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_RootObject($oUIAutomation)

	If Not __UIW_Param($oUIAutomation, "Object", "InterfaceDispatch") Then Return SetError(_UIW_ErrorStack(1, "_UIW_RootObject"), 0, False)

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
; Name ..........: _UIW_Select
; Description ...: Selects a control
; Syntax ........: _UIW_Select($oControl)
; Parameters ....: $oControl            - an object.
; Return values .: None
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_Select($oControl)

	Local $oSelect = _UIW_GetCurrentPattern($oControl, $UIW_SelectionItemPattern)
	If @error Then
		_UIW_ErrorStack(1, "_UIW_Select")
		Return SetError(1, 0, False)
	EndIf
	$oSelect.Select()

EndFunc   ;==>_UIW_Select

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_SetFocus
; Description ...: Sets the current focus to an element
; Syntax ........: _UIW_SetFocus($oElement)
; Parameters ....: $oElement            - the element to use.
; Return values .: Success - True
;                  Failure - False and sets @error = 1
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
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
; Modified ......: October 14, 2020
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
	If @error Then Return SetError(_UIW_ErrorStack(2, "_UIW_SetValue"), @error, False)

	Return True

EndFunc   ;==>_UIW_SetValue

Func _UIW_GetValue($oElement)

;~ 	Local $oValue = _UIW_GetCurrentPattern($oElement, $UIW_ValuePatternId)
;~ 	If @error Then Return SetError(1, 0, False)
	Local $sValue
	$oElement.GetCurrentPropertyValue($UIA_ValueValuePropertyId, $sValue)
	Return $sValue

EndFunc

#Region ### Tree Walker Code ###

; Use at your own risk, I don't think it works!

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
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_TreeWalkerCreate($oUIAutomation, $vCondition)

	$vCondition = __UIW_ParseCondition($oUIAutomation, $vCondition)
	If @error Then Return SetError(_UIW_ErrorStack(1, "_UIW_TreeWalkerCreate"), 0, False)

	Local $oWalker
	$oUIAutomation.RawViewWalker($vCondition)
	$oWalker = ObjCreateInterface($vCondition, $sIID_IUIAutomationTreeWalker, $dtagIUIAutomationTreeWalker)
	If Not IsObj($oWalker) Then Return SetError(_UIW_ErrorStack(2, "_UIW_CreateTreeWalker"), 0, False)

	Return $oWalker

EndFunc   ;==>_UIW_TreeWalkerCreate

Func _UIW_TreeWalkerGetAll($oWalker, $vCondition)

	If Not __UIW_Param($oWalker, "Object", "InterfaceDispatch") Then
		_UIW_ErrorStack(1, "_UIW_TreeWalkerGetFirst")
		Return SetError(1, 0, False)
	EndIf

	$vCondition = __UIW_ParseCondition($__g_oUIAutomation, $vCondition)
	If @error Then
		SetError(2, @extended)
		_UIW_ErrorStack(2, "_UIW_TreeWalkerGetFirst")
		Return False
	EndIf

EndFunc   ;==>_UIW_TreeWalkerGetAll

; #FUNCTION# ====================================================================================================================
; Name ..........: _UIW_TreeWalkerGetFirst
; Description ...: Gets the first matching element
; Syntax ........: _UIW_TreeWalkerGetFirst($oWalker, $oControl, $vCondition)
; Parameters ....: $oWalker             - a Tree walker object.
;                  $oControl            - the object to search in.
;                  $vCondition          - the condition to match.
; Return values .: Success - the first child object matching the condition
;                  Failure - False and sets @error:
;                  | 1 - COM Error sets @extended to COM Error
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UIW_TreeWalkerGetFirst($oWalker, $oControl)

	If Not __UIW_Param($oWalker, "Object", "InterfaceDispatch") Then Return SetError(_UIW_ErrorStack(1, "_UIW_TreeWalkerGetFirst"), 0, False)

	Local $pElement
	$oWalker.GetFirstChildElement($oControl, $pElement)
	If @error Then Return SetError(_UIW_ErrorStack(2, "_UIW_TreeWalkerGetFirst"), @error, False)

	If Not $pElement Then Return SetError(_UIW_ErrorStack(3, "_UIW_TreeWalkerGetFirst"), @error, False)

	Local $oResult = ObjCreateInterface($pElement, $sIID_IUIAutomationElement, $dtagIUIAutomationElement)
	If Not IsObj($oResult) Then Return SetError(_UIW_ErrorStack(4, "_UIW_TreeWalkerGetFirst"), @error, False)

	Return $oResult

EndFunc   ;==>_UIW_TreeWalkerGetFirst

Func _UIW_TreeWalkerGetNext($oWalker, $oControl)

	If Not __UIW_Param($oWalker, "Object", "InterfaceDispatch") Then Return SetError(_UIW_ErrorStack(1, "_UIW_TreeWalkerGetNext"), 0, False)

	Local $pElement
	$oWalker.GetNextSiblingElement($oControl, $pElement)
	If @error Then Return SetError(_UIW_ErrorStack(2, "_UIW_TreeWalkerGetNext"), @error, False)

	If Not $pElement Then Return SetError(_UIW_ErrorStack(3, "_UIW_TreeWalkerGetNext"), @error, False)

	Local $oResult = ObjCreateInterface($pElement, $sIID_IUIAutomationElement, $dtagIUIAutomationElement)
	If Not IsObj($oResult) Then Return SetError(_UIW_ErrorStack(4, "_UIW_TreeWalkerGetNext"), @error, False)

	If $oResult = Null Then
		__UIW_Debug("Null!")
		Return SetError(_UIW_ErrorStack(5, "_UIW_TreeWalkerGetNext"), 0, False)
	EndIf

	Return $oResult

EndFunc   ;==>_UIW_TreeWalkerGetNext

#EndRegion ### Tree Walker Code ###

#Region #INTERNAL_USE_ONLY# =====================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __UIW_ElementArrayToArray
; Description ...: Converts a IUIElementArray to an AutoIt array
; Syntax ........: __UIW_ElementArrayToArray($oElementArray)
; Parameters ....: $oElementArray       - an object.
; Return values .: Success - A 1D 0-based array of the UIElements from the Element Array
;                  Failure - False and sets @error:
;                  |1 - Length property isn't supported. @extended is set to COM error
;                  |2 - GetElement failed. @extended is set to array index.
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......: Uses IUIAutomationElementArray::get_Length and IUIAutomationElementArray::GetElement
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __UIW_ElementArrayToArray($oElementArray)

	Local $hErr = __UIW_ErrHnd()
	#forceref $hErr

	If Not IsObj($oElementArray) Then Return SetError(1, 0, False)

	Local $iTemp, $pTemp, $oTemp
	$oElementArray.Length($iTemp)
	If @error Then Return SetError(1, @error, False)
	Local $aReturn[$iTemp]
	For $i = 0 To $iTemp - 1
		$oElementArray.GetElement($i, $pTemp)
		If @error Then Return SetError(@error, $i, False)
		$oTemp = ObjCreateInterface($pTemp, $sIID_IUIAutomationElement, $dtagIUIAutomationElement)
		$aReturn[$i] = $oTemp
	Next
	Return $aReturn

EndFunc   ;==>__UIW_ElementArrayToArray

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __UIW_ErrHnd
; Description ...: Creates an error handler
; Syntax ........: __UIW_ErrHnd()
; Parameters ....: None
; Return values .: An error handler
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __UIW_ErrHnd()
	Return ObjEvent("AutoIt.Error", "__UIW_ErrorHandler")
	; 	Copy to add error handler to function
;~ 	Local $hErr = __UIW_ErrHnd()
;~ 	#forceref $hErr
EndFunc   ;==>__UIW_ErrHnd

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __UIW_ErrorHandler
; Description ...: Handles an error around suspect functions
; Syntax ........: __UIW_ErrorHandler($oError)
; Parameters ....: $oError              - an object.
; Return values .: Sets @error to COM error
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......: I think this is a modified version of Water's error handler
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __UIW_ErrorHandler($oError)
	#forceref $oError
	ConsoleWrite("! ---- UI Simple Wrapper COM Error ---- !" & @CRLF & _
			"COM Error Encountered in " & @ScriptName & @CRLF & _
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
			"LastDllError = " & $oError.LastDllError & @CRLF & _
			"! -------------------------- !" & @CRLF & @CRLF)
EndFunc   ;==>__UIW_ErrorHandler

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __UIW_MouseTrap
; Description ...: Causes the mouse to not be able to leave a rectangle.
; Syntax ........: __UIW_MouseTrap([$iLeft = 0[, $iTop = 0[, $iRight = 0[, $iBottom = 0]]]])
; Parameters ....: $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is 0.
;                  $iBottom             - [optional] an integer value. Default is 0.
; Return values .: None
; Author ........: Gary Frost (gafrost)
; Modified ......: October 14, 2020
; Remarks .......: I use this internally when an object must be clicked and I don't want user interaction to mess with the click
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __UIW_MouseTrap($iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0)
	Local $aReturn = 0
	If $iLeft = Default Then $iLeft = 0
	If $iTop = Default Then $iTop = 0
	If $iRight = Default Then $iRight = 0
	If $iBottom = Default Then $iBottom = 0
	If @NumParams = 0 Then
		$aReturn = DllCall("user32.dll", "bool", "ClipCursor", "ptr", 0)
		If @error Or Not $aReturn[0] Then Return SetError(1, 0, False)
	Else
		If @NumParams = 2 Then
			$iRight = $iLeft + 1
			$iBottom = $iTop + 1
		EndIf
		Local $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"
		Local $tRECT = DllStructCreate($tagRECT)
		DllStructSetData($tRECT, "Left", $iLeft)
		DllStructSetData($tRECT, "Top", $iTop)
		DllStructSetData($tRECT, "Right", $iRight)
		DllStructSetData($tRECT, "Bottom", $iBottom)
		$aReturn = DllCall("user32.dll", "bool", "ClipCursor", "struct*", $tRECT)
		If @error Or Not $aReturn[0] Then Return SetError(2, 0, False)
	EndIf
	Return True
EndFunc   ;==>__UIW_MouseTrap

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __UIW_Param
; Description ...: Checks that a variable is the correct type and the name if it's an object
; Syntax ........: __UIW_Param($vParam, $sType[, $sObjName = Default])
; Parameters ....: $vParam              - a variant value.
;                  $sType               - a string value.
;                  $sObjName            - [optional] a string value. Default is Default.
; Return values .: True if the variable is the correct type and name, otherwise false
; Author ........: Seadoggie01
; Modified ......: October 14, 2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __UIW_Param($vParam, $sType, $sObjName = Default)

	If VarGetType($vParam) = $sType Then
		If $sType = "Object" Then
			Return ObjName($vParam) = $sObjName
		Else
			Return True
		EndIf
	Else
		Return False
	EndIf

EndFunc   ;==>__UIW_Param

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
; Modified ......: October 14, 2020
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
		$pCondition = __UIW_ParsePropertyCondition($oUIAutomation, $asProperties[$i])
		If @error Then
			Return SetError(_UIW_ErrorStack(1, "__UIW_ParseCondition - Part " & $i), $i, False)
		Else
			ReDim $aConditions[UBound($aConditions) + 1]
			$aConditions[UBound($aConditions) - 1] = $pCondition
		EndIf
	Next

	If Not IsArray($aConditions) Then Return SetError(_UIW_ErrorStack(2, "__UIW_ParseCondition"), 0, False)

	Switch UBound($aConditions)
		Case 2
			$pCondition = _UIW_CreateAndCondition($oUIAutomation, $aConditions[0], $aConditions[1])
			If @error Then Return SetError(_UIW_ErrorStack(3, "__UIW_ParseCondition"), 0, False)
		Case 1
			$pCondition = $aConditions[0]
		Case Else
			$pCondition = _UIW_CreateAndConditionFromArray($oUIAutomation, $aConditions)
			If @error Then Return SetError(_UIW_ErrorStack(4, "__UIW_ParseCondition"), 0, False)
	EndSwitch

	Return $pCondition

EndFunc   ;==>__UIW_ParseCondition

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __UIW_ParsePropertyCondition
; Description ...: Takes a single property as a string and parses it to get that type of property conidtion
; Syntax ........: __UIW_ParsePropertyCondition($oUIAutomation, $sProperty)
; Parameters ....: $oUIAutomation       - an object.
;                  $sProperty           - a string value.
; Return values .: Success - $pCondition
;                  Failure - False and sets @error:
;                  | 1  - individual property condition error
;                  | 42 - unparseable
; Author ........: Seadoggie01
; Modified ......: January 21, 2021
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: __UIW_ParsePropertyCondition($oUIAutomation, "TYPE:" & $UIA_ButtonControlTypeId)
; ===============================================================================================================================
Func __UIW_ParsePropertyCondition($oUIAutomation, $sProperty)

	; Split using a regular expression that verifies that the colon isn't escaped with a backslash
	Local $aSplit = StringRegExp($sProperty, "(.*)(?<!\\):(.*)", 3)
	If @error Then Return SetError(1, 0, False)

	Local $sPropertyName = $aSplit[0]
	Local $sPropertyValue = $aSplit[1]

	; Unescape all the characters!
	$sPropertyValue = StringReplace($sPropertyValue, "\\", "\")
	$sPropertyValue = StringReplace($sPropertyValue, "\;", ";")
	$sPropertyValue = StringReplace($sPropertyValue, "\:", ":")

	Local $vTemp
	Switch StringLower($sPropertyName)
		Case "type"
			$vTemp = _UIW_ControlTypePropertyCondition($oUIAutomation, Number($sPropertyValue))
		Case "class"
			$vTemp = _UIW_ClassNamePropertyCondition($oUIAutomation, $sPropertyValue)
		Case "name"
			$vTemp = _UIW_NamePropertyCondition($oUIAutomation, $sPropertyValue)
		Case "id"
			$vTemp = _UIW_AutomationIdPropertyCondition($oUIAutomation, $sPropertyValue)
		Case "accesskey"
			$vTemp = _UIW_AccessKeyProperyCondition($oUIAutomation, $sPropertyValue)
		Case "bool"
			$vTemp = _UIW_BoolCondition($oUIAutomation, $sPropertyValue)
		Case "acceleratorkey"
			$vTemp = _UIW_AcceleratorKeyPropertyCondition($oUIAutomation, $sPropertyValue)
		Case "legacyiaccessiblestate"
			$vTemp = _UIW_LegacyIAccessibleStatePropertyCondition($oUIAutomation, $sPropertyValue)
		Case Else
			$vTemp = _UIW_PropertyCondition($oUIAutomation, $sPropertyName, $sPropertyValue)
			If @error Then Return SetError(_UIW_ErrorStack(-1, "__UIW_ParsePropertyCondition - Other"), 0, False)
	EndSwitch

	Return SetError(@error, @extended, $vTemp)

EndFunc   ;==>__UIW_ParsePropertyCondition

Func __UIW_TreeViewGetAll($oWalker, $oControl, $pCondition)

	; Get the first element
	Local $oElement = _UIW_TreeWalkerGetFirst($oWalker, $oControl)
	; While there is an element
	While IsObj($oElement)
		$oWalker.GetNextSiblingElement($oControl, $pCondition)
	WEnd
EndFunc   ;==>__UIW_TreeViewGetAll

Func __UIW_Debug($sText, $sPrefix = "+")

	If StringLen($sPrefix) = 1 Then $sPrefix &= " "
	ConsoleWrite($sPrefix & $sText & @CRLF)

EndFunc

#EndRegion #INTERNAL_USE_ONLY# =====================================================================================================
