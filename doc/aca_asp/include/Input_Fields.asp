<%
Dim vReadOnlyColor
'vReadOnlyColor = "#" & plIsNull(plSingleton("Standard_Color_Get","plReadOnly","Plexus_Control"),"dddddd")
vReadOnlyColor = "#dddddd"

Function plsTextbox(vName, vValue, vWidth, vMaxLength, vOnChange, vSecurity)
	plsTextbox = plsInputBox(vName, vValue, vWidth, vMaxLength, vOnChange, vSecurity, "Text")
End Function

Function plsNumbox(vName, vValue, vWidth, vMaxLength, vOnChange, vSecurity)
	plsNumbox = plsInputBox(vName, vValue, vWidth, vMaxLength, vOnChange, vSecurity, "Number")
End Function

Function plsInputBox(vName, vValue, vWidth, vMaxLength, vOnChange, vSecurity, vType)

  dim vDredd,svRevisionLabel
  svRevisionLabel = plMake_Dredd_Name(vName) ' vName is passed by reference and may be modified
  vDredd = plGlossary(svRevisionLabel,"","")

' This is disabled until we can use plFormatNumberSQL on all data being saved to the database.
'  if right(vName,4) = "_DEC" or right(vName,4) = "_INT" or instr(1,vName,"_DEC_") > 0 or instr(1,vName,"_INT_") > 0 then
'    vValue = plFormatNumber(vValue,-1, true, "", "")
'  end if

	vValue = plSingleQuote_C(vValue)

  'NOTE: ID, NAME Attribs have values in single-quotes. Do not change without notifying TSCH, 02/24/03
  plsInputBox = "<INPUT maxlength=" & vMaxLength & " size=" & vWidth & " type='text' value ='" & plIsNull(vValue,"") & "' id='" & vName & "' name='" & vName & "' Dredd=""" & vDredd & """ RevisionLabel=""" & svRevisionLabel & """ "

  If Not vSecurity Then
		plsInputBox = plsInputBox & "readonly style='background-color:" & vReadOnlyColor & "' "
  End If

	plsInputBox = plsInputBox & plOnChange_Format(vOnChange)

	Select Case vType
		Case "Number"
			plsInputBox = plsInputBox & " style='text-align:right' onKeypress='javascript:if (event.keyCode < 45 || event.keyCode > 57 || event.keyCode == 47) return false;'"
	End Select

	plsInputBox = plsInputBox & ">"	' 8/5/2003 TGIL: moved the closing bracket down here to unconditional

End Function

Function plsTextArea(vName, vValue, vWidth, vRows, vOnChange, vSecurity)

  dim vDredd,svRevisionLabel
  svRevisionLabel = plMake_Dredd_Name(vName) ' vName is passed by reference and may be modified
  vDredd = plGlossary(svRevisionLabel,"","")

	plsTextArea = "<TEXTAREA rows=" & vRows & " cols=" & vWidth & " id=" & vName & " name=" & vName & " Dredd=""" & vDredd & """ RevisionLabel=""" & svRevisionLabel & """ "

	If Not vSecurity Then
		plsTextArea = plsTextArea & "readonly style='background-color:" & vReadOnlyColor & "' "
	End If

  plsTextArea = plsTextArea & plOnChange_Format(vOnChange)

	plsTextArea = plsTextArea & ">" & plIsNull(vValue,"") & "</TEXTAREA>"

End Function

Function plsCheckbox( vName, vValue, vValue_For_Check, vCheckbox_Value, vOnChange, vSecurity )

  dim vDredd,svRevisionLabel
  svRevisionLabel = plMake_Dredd_Name(vName) ' vName is passed by reference and may be modified
  vDredd = plGlossary(svRevisionLabel,"","")

	dim vLogical
	on error resume next
	vLogical = (CStr(plIsNull(vValue,"~")) = Cstr(plIsNull(vValue_For_Check,"!~")))
	if err.number then
		Response.Write "plCheckbox Error!" & err.description
		Exit Function
	end if
	on error goto 0

	plsCheckbox = "<input type='checkbox' id='" & vName & "' name='" & vName & "' value='" & vCheckbox_Value & "' Dredd=""" & vDredd & """ RevisionLabel=""" & svRevisionLabel & """ "
	plsCheckbox = plsCheckbox & plOnChange_Format(vOnChange)
	If vLogical Then plsCheckbox = plsCheckbox & " CHECKED "

	If Not vSecurity Then plsCheckbox = plsCheckbox & "onClick='window.focus;return false' style='background-color:" & vReadOnlyColor & "' "

	plsCheckbox = plsCheckbox & ">"

End Function

function plsRadio(vName, vValue, vChecked1, vChecked2, vOnChange, vSecurity)
  ' 6/2/2004 TGIL: Added vLabel for revision tracking support.
  dim vDredd,vLabel,svRevisionLabel
  svRevisionLabel = plMake_Dredd_Name(vName) ' vName is passed by reference and may be modified
  vDredd = plGlossary(svRevisionLabel,"","")
  vLabel = plMake_Dredd_Name(vValue) ' vValue is passed by reference and may be modified

	dim vChecked
	if vChecked1 = vChecked2 then vChecked = "CHECKED"
	plsRadio = "<input type='radio' id='" & vName & "' name='" & vName & "' " & vChecked & " value='" & vValue & "' RevisionValue=""" & vLabel & """ Dredd=""" & vDredd & """ RevisionLabel=""" & svRevisionLabel & """ " & plOnChange_Format(vOnChange)

	if not vSecurity then
		plsRadio = plsRadio & " onClick='var el, e = 0, f = this.form; while (el = f[this.name][e++]) el.checked = el.defaultChecked;' style='background-color:" & vReadOnlyColor & "'"
	end if
	plsRadio = plsRadio & ">"
end function

dim plWindowsListbox, plWildcard
Function plsSelect_List( vSelectName, vValue, vText, vRS, vTargetValue, vForceBlankOption, vOnChange, vSecurity ) 'Requires Plexus_Library_No_Interface in order to check for RecordSet size, TSCH 05/14/04
	'If Not vSecurity then only add the SELECTED option.
  dim vDredd,svRevisionLabel, vTargetFound, vParamStr, vCacheSize
  if not isobject(vRS) then plErrorMessage("Object not passed in for vRS to" & vParamStr)
  if vRS.CacheSize = 1 then vRS.CacheSize = 100 'TSCH 05/04/04 for optimal performance, if value is 1, we go ahead and set this, otherwise it was considered by the developer and done already
  vParamStr = "<BR>plSelect_List(<BR> '" & vSelectName & "', '" & vValue & "', '" & vText & "', vRS, '" & plNullCheck(vTargetValue,"") & "', '" & vForceBlankOption & "', '" & vOnChange & "')"
  vTargetFound = false
  svRevisionLabel = plMake_Dredd_Name(vSelectName) ' vName is passed by reference and may be modified
  vDredd = plGlossary(svRevisionLabel,"","")

	vValue = plSingleQuote_C(vValue)

	'if instr(1,vOnChange,"onkeypress",1) = 0 then
	dim vWindowsListbox
	if vOnChange = "" then 'User Setting for Windows Listbox, TSCH 10/16/03
	  'TSCH 05/04/04. Only find this setting once on the page
	  'if plWindowsListbox = "" then plWindowsListbox = cBool(plSingleton_Field("EXEC Plexus_Control.dbo.Setting_Value_Get 'User'," & plNullCheck(plSession("Plexus_User_No"),0) & ",'Appearance','Windows Listbox'","Setting","Plexus_Control"))
	  'vWindowsListbox = plWindowsListbox
	  vWindowsListbox = false
	else
	  vWindowsListbox = false
	end if
	if vOnChange = "" and vWindowsListbox then  'It was found the above could confound onChange events, as with the related listboxes on Hours tracking
  	plsSelect_List = "<select onKeyPress='return plListselect(event.keyCode, this);'"
	else
  	plsSelect_List = "<select"
	end if
	plsSelect_List = plsSelect_List & " name=" & vSelectName & " id=" & vSelectName & " Dredd=""" & vDredd & """ RevisionLabel=""" & svRevisionLabel & """ "
	If Not vSecurity Then plsSelect_List = plsSelect_List & "style='background-color:" & vReadOnlyColor & "' "

	plsSelect_List = plsSelect_List & plOnChange_Format(vOnChange) & ">" & vbcrlf

	on error resume next
	vTargetValue = plNullCheck(vTargetValue,"")
	if err.number then
		on error goto 0
		plsSelect_List = plsSelect_List & "<OPTION>plSelect_List Error!" & err.description & "</OPTION></SELECTED>"
		Exit Function
	end if
	on error goto 0

	if vRS.State <> adStateOpen then
	  set vRS = nothing 'TSCH 05/04/04 ADO cleanup
	  plErrorMessage( "RecordSet not open Error in plSelectList" & vParamStr )
	end if

	if instr(1,vForceBlankOption,"true",1) then
		if instr(vForceBlankOption,"|") > 0 and instr(vForceBlankOption,",") > 0  then 'Changed from instr(vForceBlankOption,"|") and instr(vForceBlankOption,",") as this returned numeric, not Boolean values, TSCH 8/4/01
			dim vBlankOptionString,arrayBlankOptionString
			vBlankOptionString = mid(vForceBlankOption,instr(vForceBlankOption,"|")+1,len(vForceBlankOption)-instr(vForceBlankOption,"|"))
			arrayBlankOptionString = split(vBlankOptionString,",")

			If (Not vSecurity And lcase(trim(vTargetValue)) = lcase(trim(Cstr(plNullCheck(arrayBlankOptionString(0),"")))) and not vTargetFound) Or vSecurity then
				plsSelect_List = plsSelect_List & "<option "
				if lcase(trim(vTargetValue)) = lcase(trim(Cstr(plNullCheck(arrayBlankOptionString(0),"")))) and not vTargetFound then
					plsSelect_List = plsSelect_List & "SELECTED "
					vTargetFound = true
				end if
				plsSelect_List = plsSelect_List & "value='" & arrayBlankOptionString(0) & "'>" & arrayBlankOptionString(1) & "</option>" & vbcrlf
			End If

		else

			If (Not vSecurity And "" = vTargetValue and not vTargetFound) Or vSecurity Then
				plsSelect_List = plsSelect_List & "<option "
				if "" = vTargetValue and not vTargetFound then
					plsSelect_List = plsSelect_List & "SELECTED "
					vTargetFound = true
				end if
				'if plWildcard = "" then plWildcard = plSetting("Customer", vCustomer, "Appearance", "Wildcard" ) 'TSCH 05/04/04. Only find this setting once on the page
				plsSelect_List = plsSelect_List & "value=''>" & plWildcard & "</option>" & vbcrlf
			End If

		end if
	end if

	if not vRS.EOF then
		dim vValueFieldVal, plRecordCount, vValueFieldRef, vTextFieldRef 'Added by TSCH 10/10/02 for 50% demonstrable perf gain
		plRecordCount = 0
		on error resume next 'Column existence error checking, TSCH 2/11/02
		set vValueFieldRef = vRS.Fields.Item(vValue)
		if err.number > 0 then plErrorMessage( "Error in plSelectList reading column '" & vValue & "' (Value)" & vParamStr )
		set vTextFieldRef = vRS.Fields.Item(vText)
		if err.number > 0 then plErrorMessage( "Error in plSelectList reading column '" & vText & "' (Text)" & vParamStr )
		dim vText_Value
		vText_Value = vValueFieldRef.Value
		if err.number > 0 then plErrorMessage( "Error in plSelectList reading column '" & vValue & "' (Value)" & vParamStr )
		vText_Value = vTextFieldRef.Value
		if err.number > 0 then plErrorMessage( "Error in plSelectList reading column '" & vText & "' (Text)" & vParamStr )
		on error goto 0

		do while not vRS.EOF
		  plRecordCount = plRecordCount + 1
			vText_Value = vTextFieldRef.Value
			vValueFieldVal = vValueFieldRef.Value 'TSCH 05/04/04. Ask for value propery once per row, not three times
			if len(vText_Value) > 0 then vText_Value = server.HTMLEncode(vText_Value) 'Added by TSCH 5/30/01 because empty string values throw error messages from HTMLEncode()
			If (Not vSecurity And lcase(trim(vTargetValue)) = lcase(trim(Cstr(plNullCheck(vValueFieldVal,"")))) and not vTargetFound) Or vSecurity Then
				plsSelect_List = plsSelect_List & "<option "
				if lcase(trim(vTargetValue)) = lcase(trim(Cstr(plNullCheck(vValueFieldVal,"")))) and not vTargetFound then
					vTargetFound = true
					plsSelect_List = plsSelect_List & "SELECTED "
				end if
				plsSelect_List = plsSelect_List & "value='" & plSingleQuote_C(vValueFieldVal) & "'>" & vText_Value & "</option>" & vbcrlf
			End If

			on error resume next
			vRS.MoveNext()
			if err.number then
				dim vError
				vError = err.number & " " & err.description & " (" & err.source & ")"
				on error goto 0
				plsSelect_List = plsSelect_List & "<option value='NOVAL!'>ERROR!!!! " & vError & "</option>"
				vRS.Close()
				set vRS = nothing
				Exit Function
			end if
			on error goto 0
		loop
		'plSQLLoadCheck vRS.Source, vRS, "plsSelect_List", 5000, plRecordCount 'TSCH 05/13/04. Made conditional on 6/30/04 because only client-side cursors will return accurate info here

	end if

	plsSelect_List = plsSelect_List & "</select>" & vbcrlf

End Function

Function plsDate(vForm,vField,vDigits,vDate, vOnChange, vSecurity)

  dim vTextBoxField, vJScriptName, strImagePath
  if instr(1,vField,"[") then
    vTextBoxField = left(vField,instr(1,vField,"[")-1)
  else
    vTextBoxField = vField
  end if

  strImagePath = "" 'plPath_To_Root()

  vJScriptName = vField
  call plMake_Dredd_Name(vJScriptName)  ' strip the Dredd name to get only the field name

  plsDate = plsTextbox(vTextBoxField,plDateTime(vDate,cstr(vDigits)),9,10,plOnChange_Format(vOnChange) & " YearDigits=" & vDigits & " onKeyPress=" & chr(34) & "if(window.event.keyCode == 43 || window.event.keyCode == 45){return DateKeypress('" & vJScriptName & "'," & vDigits & ")}" & chr(34),vSecurity)

  If vSecurity Then
		 plsDate = plsDate & "&nbsp;<a href='Javascript:GetDate(" & chr(34) & vForm & chr(34) & "," & chr(34) & vJScriptName & chr(34) & "," & vDigits & ")'><img alt='' src=" & strImagePath & "images/GetDate.gif border=0 align=absmiddle onMouseOver=" & chr(34) & "status='Select a date with the calendar.';return true" & chr(34) & " onMouseOut=" & chr(34) & "status=''" & chr(34) & "></a>"
  End If

End Function

Function plsSelectRadio(fRadioName, fValueField, fTextField, frs, fTargetValue, fBlank, fOnChange, fSecurity, fOptions)

	'Options
	Dim oTextStyle, oRowsPerColumn, oLimitRows, oBlank
	oTextStyle = "GridText"
	oRowsPerColumn = 1
	oLimitRows = False
	oBlank = ""

	Dim vOptions, vOptionPair, vOptionValue, vOptionCount
	vOptions = Split(fOptions,"|")
	For vOptionCount = 0 To Ubound(vOptions)
		vOptionPair = split(vOptions(vOptionCount),"=")
		Select Case lcase(vOptionPair(0))
			Case "textstyle"
				oTextStyle = vOptionPair(1)
			Case "rowspercolumn"
				oRowsPerColumn = Cint(vOptionPair(1))
				oLimitRows = True
			Case "blanktitle"
				oBlank = vOptionPair(1)

		End Select
	Next

	Dim vRDO, vColumnRDO, vRowCount, vDisabled, vChecked

	vRDO = "<table class='" & oTextStyle & "'><tr>"
	vColumnRDO = ""
	vRowCount = 0
	call plMake_Dredd_Name(fRadioName)

	Do While Not frs.EOF

		If oLimitRows And vRowCount = 0 Then
			vColumnRDO = "<td valign='top'>"
		Else
			If vColumnRDO = "" Then
				vColumnRDO = "<td valign='top'>"
			Else
				vColumnRDO = vColumnRDO & "<br>"
			End If
		End If
		vRowCount = vRowCount + 1

		vColumnRDO = vColumnRDO & plsRadio(fRadioName, frs.Fields.Item(fValueField).Value, fTargetValue, frs.Fields.Item(fValueField).Value, fOnChange, fSecurity) & frs.Fields.Item(fTextField).Value

		If oLimitRows And vRowCount = oRowsPerColumn Then
			vRDO = vRDO & vColumnRDO & "</td>"
			vColumnRDO = ""
			vRowCount = 0
		End If

		frs.MoveNext
	Loop

	'Blank value
	If fBlank Then
		If oLimitRows And vRowCount = 0 Then
			vColumnRDO = "<td valign='top'>"
		Else
			If vColumnRDO = "" Then
				vColumnRDO = "<td valign='top'>"
			Else
				vColumnRDO = vColumnRDO & "<br>"
			End If
		End If
		vRowCount = vRowCount + 1

		vColumnRDO = vColumnRDO & plsRadio(fRadioName, frs.Fields.Item(fValueField).Value, fTargetValue, "", fOnChange, fSecurity) & frs.Fields.Item(fTextField).Value

		If oLimitRows And vRowCount = oRowsPerColumn Then
			vRDO = vRDO & vColumnRDO & "</td>"
			vColumnRDO = ""
			vRowCount = 0
		End If
	End If

	If oLimitRows Then
		If vRowCount > 0 Then
			vRDO = vRDO & vColumnRDO & "</td>"
		End If
	Else
		vRDO = vRDO & vColumnRDO & "</td>"
	End If


	plsSelectRadio = vRDO & "</tr></table>"
End Function

Function plsSelect_List_Array(svName, ByVal svTargetValue, aOptions, bvForceBlankOption, svOnChange, bvSecurity)
  ' 2/24/2005 TGIL
  ' Takes an array of values in the format "value|text", creates a recordset, and returns a select list.
  ' Makes use of plsSelect_List()

  If IsEmpty(aOptions) Or (UBound(aOptions) - LBound(aOptions) = 0) Then
    Exit Function
  End If

  Dim i, iPos
  Dim svValue, svText
  dim rs
  set rs = server.CreateObject("ADODB.Recordset")

  rs.CursorLocation = adUseClient
  rs.CursorType = adOpenStatic
  Set rs.ActiveConnection = Nothing
  With rs
  	.Fields.Append "Value_Field",adVarChar,500
  	.Fields.Append "Text_Field", adVarChar,500
  	'open the recordset
  	.Open

    For i = LBound(aOptions) To UBound(aOptions)

      iPos = InStr(1, aOptions(i), "|")

      If iPos > 0 Then
        svValue = Left(aOptions(i),iPos-1)
        svText = Mid(aOptions(i),iPos+1)
      Else
        svValue = aOptions(i)
        svText = svValue
      End If

  	  .AddNew
  	  .Fields("Value_Field").Value = svValue
  	  .Fields("Text_Field").Value = svText
  	  .Update
  	next
  End With

  rs.MoveFirst()

  plsSelect_List_Array = plsSelect_List( svName, "Value_Field", "Text_Field", rs, svTargetValue, bvForceBlankOption, svOnChange, bvSecurity)

  rs.close
  set rs = nothing
End Function


Function plOnChange_Format( ByVal vOnChange )

		If instr(1,vOnChange,"=",1) Then
			plOnChange_Format = vOnChange
		Else
			plOnChange_Format = "onchange=" & chr(34) & vOnChange & chr(34)
		End If

End Function

'---------------------------------------------------------------------------------------
'--Original code--
'---------------------------------------------------------------------------------------
Sub plTextbox(vName, vValue, vWidth, vMaxLength, vOnChange)
	Response.Write plsTextbox(vName, vValue, vWidth, vMaxLength, vOnChange, True)
End Sub

Sub plTextArea(vName, vValue, vWidth, vRows, vOnChange)
	Response.Write plsTextArea(vName, vValue, vWidth, vRows, vOnChange, True)
End Sub

Sub plCheckbox( vName, vValue, vValue_For_Check ) 'Do not submit NULLs for vValue or vValue_For_Check
	Response.Write plsCheckbox( vName, vValue, vValue_For_Check, 1, "", True )
End Sub

Sub plSelect_List( vSelectName, vValue, vText, vRS, vTargetValue, vForceBlankOption, vOnChange )
	Response.Write plsSelect_List( vSelectName, vValue, vText, vRS, vTargetValue, vForceBlankOption, vOnChange, True)
End Sub

Function plFSelect_List( vSelectName, vValue, vText, vRS, vTargetValue, vForceBlankOption, vOnChange )
	plFSelect_List = plsSelect_List( vSelectName, vValue, vText, vRS, vTargetValue, vForceBlankOption, vOnChange, True)
End Function%>