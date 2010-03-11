<%

dim plCon
Sub plCon_Open()
  set plcon = server.CreateObject("ADODB.Connection")
  plcon.ConnectionString = "Provider=SQLOLEDB.1;Server=sql1910.mssqlservers.com;Initial Catalog=con451;User ID=con451;Password=goaca123;"
  plcon.CursorLocation = adUseServer
  plcon.Open
End Sub

Sub plCon_Close()
  if plcon.State > 0 then plcon.Close
  set plcon = nothing
End Sub

'******* Command Object functions ********
Function plCmd_Set(ByRef cmd, ByRef con, vSP)
  cmd.CommandType = adCmdStoredProc
  cmd.ActiveConnection = con

  If InStr(1, vSP, ".") > 0 Then
    cmd.CommandText = vSP
  Else
    cmd.CommandText = "dbo." & vSP
  End If

End Function

Function plCmd_RetVal_Add(ByRef cmd,svName)
  ' 11/10/1004 TGIL
  ' Since all return value parameters are integers, there is no need to parse for data type.
  ' Plus, there is no incoming value for return value parameters.
  cmd.Parameters.Append cmd.CreateParameter(svName, adInteger, adParamReturnValue)
End Function

Function plCmd_Param_Add(ByRef cmd, sParameter, ByVal sValue)
  ' sParameter is in the format of a stored procedure's parameters
  ' Examples:
  '   "@First_Name VARCHAR(50)"
  '   "@New_Key INT OUTPUT"
  'TODO: Add support for xml and binary types

  ' Make sure the parameter is ready for parsing
  sParameter = trim(sParameter)
  If InStr(1, sParameter, " ") < 1 Then
    Err.Raise 513, "plCmd_Param_Add", "The input/output parameter argument with the value " & Chr(34) & sParameter & Chr(34) & " is not in the required format of " & Chr(34) & "Name DATATYPE" & Chr(34) & ".", Empty, Empty
    Exit Function
  End If
  sParameter = lcase(sParameter)  ' make all lower for easier parsing
  sParameter = replace(sParameter, "char (", "char(")       ' make sure there is no space between varchar/char and the size
  sParameter = replace(sParameter, "decimal (", "decimal(") ' make sure there is no space between decimal and the size
  do while instr(1, sParameter, "  ") > 0
    ' remove any double spaces
    sParameter = replace(sParameter, "  ", " ")
  loop

  dim aParameter, iDataType, iInOut, sName, sDataType, sSizeTemp, iSize
  dim iParenOpen,iParenClose
  dim sParameterTemp
  dim sMessage
  dim iMaxLen

  iMaxLen = 2147483646

  ' Check for a space in the middle of the data type part and remove it. Example: DECIMAL(9, 2) should be DECIMAL(9,2)
  iParenOpen = instr(1,sParameter,"(")
  if iParenOpen > 0 then
    iParenClose = instr(iParenOpen,sParameter,")")
    sParameterTemp = left(sParameter,iParenOpen) & replace(mid(sParameter,iParenOpen + 1,iParenClose - iParenOpen)," ","") & mid(sParameter,iParenClose + 1)
    sParameter = sParameterTemp
  end if

  aParameter = split(sParameter, " ")

  sName = aParameter(0)
  sDataType = aParameter(1)

  ' Determine parameter direction
  iInOut = adParamInput
  if ubound(aParameter) = 2 then
    if aParameter(2) = "output" then
      iInOut = adParamOutput
    elseif aParameter(2) = "inout" then
      iInOut = adParamInputOutput
    end if
  end if

  If instr(1, sDataType, "char") > 0 or left(sDataType, 7) = "decimal" then
    ' Since VARCHAR, CHAR, and DECIMAL specifies the size, parse the size from the type
    sSizeTemp = mid(sDataType, instr(1, sDataType, "(") + 1)
    sSizeTemp = left(sSizeTemp, len(sSizeTemp)-1)

    if lcase(sSizeTemp) = "max" then
      if iInOut = adParamInput then
        iSize = len(sValue)
      else
        iSize = iMaxLen
      end if
    else
      iSize = clng(sSizeTemp)
    end if

    if instr(1,sDataType,"nvarchar") > 0 then
      iDataType = adVarWChar
    elseif instr(1,sDataType,"varchar") > 0 then
      iDataType = adVarChar
    elseif instr(1,sDataType,"nchar") > 0 then
      iDataType = adWChar
    elseif instr(1,sDataType,"char") > 0 then
      iDataType = adChar
    else
      iDataType = adDouble
      ' For DECIMAL, the syntax is (precision,scale) but we only need the precision to determine the byte size.
      sSizeTemp = left(sSizeTemp,instr(1, sSizeTemp, ",")-1)
      if clng(sSizeTemp) <= 9 then
        iSize = 5
      else
        iSize = 9
      end if
    end if
  else
    ' VARCHARs, CHARs, and DECIMALs are handled above, all other types are handled here.

    iSize = 0 ' default value

    ' If a developer specifies a TEXT size, then use it instead of the length of the value.
    ' This is useful when setting up a parameter to be used multiple times with values of varying lengths.
    if instr(1, sDataType, "(") > 0 Then
      sSizeTemp = mid(sDataType, instr(1, sDataType, "(") + 1)
      sSizeTemp = left(sSizeTemp, len(sSizeTemp)-1)
      iSize = clng(sSizeTemp)
      sDataType = LCase(Trim(Left(sDataType, instr(1, sDataType, "(") - 1)))
    end if

    select case sDataType
      case "bit"
        iDataType = adBoolean
        iSize = 1
      case "tinyint"
        iDataType = adTinyInt
        iSize = 1
      case "smallint"
        iDataType = adSmallInt
        iSize = 2
      case "int","integer"
        iDataType = adInteger
        iSize = 4
      case "bigint"
        iDataType = adBigInt
        iSize = 8
      case "smalldatetime"
        iDataType = adDBTimeStamp
        iSize = 4
      case "datetime"
        iDataType = adDBTimeStamp
        iSize = 8
      case "uniqueidentifier"
        iDataType = adGUID
        iSize = 16
      case "text"
        iDataType = adLongVarChar
        if iSize = 0 then
          iSize = iMaxLen
        end if
      case "ntext"
        iDataType = adLongVarWChar
        if iSize = 0 then
          iSize = iMaxLen
        end if
      case else
        Err.Raise 514, "plCmd_Param_Add", "The T-SQL datatype " & Chr(34) & sDataType & Chr(34) & " entered for parameter " & Chr(34) & sParameter & Chr(34) & " is not supported by plCmd_Param_Add", Empty, Empty
        Exit Function
    end select
  end if

  On Error Resume Next
  cmd.Parameters.Append cmd.CreateParameter(sName, iDataType, iInOut, iSize, sValue)

  If Err.number <> 0 Then
    sMessage = "Error occurred in plCmd_Param_Add:" & _
                "<br>Page: " & plScript_Name & _
                "<br>Error: [" & Err.Number & "] " & Err.Description

    On Error GoTo 0

    If IsEmpty(sValue) Then
      sValue = "Empty (no value)"
    ElseIf IsNull(sValue) Then
      sValue = "Null (no value)"
    Else
      sValue = Chr(34) & sValue & Chr(34)
    End If

    if cmd.CommandText <> "" then
      sMessage = sMessage & ("<br>Procedure: " & cmd.CommandText)
    end if

    sMessage = sMessage & ("<br>Parameter: " & sName & _
    "<br>Data type: " & UCase(sDataType) & _
    "<br>Value: " & sValue)

      Err.Raise 515, "plCmd_Param_Add", replace(sMessage, "<br>", vbcrlf & " | "), Empty, Empty
  End If

End Function

Function plCmd_Params_Clear(ByRef cmd, iKeepAmount)
  do while cmd.Parameters.Count > iKeepAmount
    cmd.Parameters.Delete(iKeepAmount)
  loop
End Function
  '******* end of Command Object functions *******
%>