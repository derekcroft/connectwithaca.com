<!-- #include file="Input_Fields.asp" -->
<!-- #include file="datetime_library.asp" -->
<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D" NAME="CDO for Windows Library" -->
<!--METADATA TYPE="typelib" UUID="00000205-0000-0010-8000-00AA006D2EA4" NAME="ADODB Type Library" -->
<%

dim gsSSL_Site
gsSSL_Site = "https://con451.sslcert19.com/"

Function plIIF( bvBoolean, svTrue, svFalse )
  if bvBoolean then
    plIIF = svTrue
  else
    plIIF = svFalse
  end if
End Function

Function plIsNull(ByVal vValue, vNull)
  If plNull(vValue) Then
		plIsNull = vNull
  Else
		plIsNull = vValue
  End If
End Function

Function plNull(ByVal svValue)
	If Isnull(svValue) Then
		plNull = True
	Else
		plNull = not (Trim(svValue) > "")
	End If
End Function

Function plNullCheck( vValue, vNull )
  dim ivErr, svDesc
  on error resume next
  vValue = trim(vValue) 'Trim out empty spaces. This is protecting against the case where vValue = " ".  It wasn't returning the default in this case. Update by SSIG on 8/9/00
  if err.number = 0 then
    on error goto 0
    plNullCheck = plIIF(plNull(vValue),vNull,vValue)
  else
    ivErr = err.number
    svDesc = err.Description
    on error goto 0
 	Err.Raise ivErr, "plNullCheck", svDesc, empty, empty
  end if
End Function

sub Send_Mail(svFrom, svTo, svSubject, svBody, svCC, svBCC)

	Dim objCDO
	Dim iConf
	Dim Flds

	set objCDO = Server.CreateObject("CDO.Message")
	set iConf = Server.CreateObject("CDO.Configuration")

	set Flds = iConf.Fields
	With Flds
		.Item(cdoSendUsingMethod) = 2
		.Item(cdoSMTPServer) = "mail-fwd"
		.Item(cdoSMTPServerPort) = 25
		.Item(cdoSMTPconnectiontimeout) = 10
		.Update
	End With

	set objCDO.Configuration = iConf

	objCDO.From= svFrom
	objCDO.To= svTo
	objCDO.Cc= svCC
	objCDO.Bcc= svBCC
	objCDO.Subject= svSubject
	objCDO.HTMLBody = svBody
	objCDO.Send

	set iConf=nothing
	set objCDO=nothing

end sub

function CheckMark
	CheckMark = "<img src='images/checkmark.gif' border='0'>"
end function

function plGlossary(svPlexus_Word,svData,svOptions)
  if plNull(svPlexus_Word) then exit function
  plGlossary = svPlexus_Word
end function

Function plMake_Dredd_Name(vSelectName)
  ' vSelectName is passed by reference and modified if a Dredd name is included.
  ' The Dredd name is the return value
  dim vPipe
  vPipe = instr(1,vSelectName,"|")
  ' Dredd "friendly field names" ability added 6/12/2001 by TGIL
  if vPipe > 0 then
    plMake_Dredd_Name = mid(vSelectName,vPipe + 1)
    vSelectName = left(vSelectName,vPipe - 1)
  end if
End Function

Function plSingleQuote_C( vValue )

	if plNullCheck(vValue,"") <> "" then
		on error resume next
		vValue = CStr(vValue)
		if err.number then
			Response.Write "plSingleQuote_C Error! " & err.description
			Exit Function
		end if
		on error goto 0
		plSingleQuote_C = replace(vValue,"'","&#39;")
	else
		plSingleQuote_C = ""
	end if

End Function

Function CreateWindowsGUID()
  CreateWindowsGUID = CreateGUID(8) & "-" & _
    CreateGUID(4) & "-" & _
    CreateGUID(4) & "-" & _
    CreateGUID(4) & "-" & _
    CreateGUID(12)
End Function

Function CreateGUID(tmpLength)
  Randomize Timer
  Dim tmpCounter,tmpGUID
  Const strValid = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  For tmpCounter = 1 To tmpLength
    tmpGUID = tmpGUID & Mid(strValid, Int(Rnd(1) * Len(strValid)) + 1, 1)
  Next
  CreateGUID = tmpGUID
End Function

function plErrorMessage(svMessage)
	Response.Write plErrorMessage
	Response.End
end function

%>