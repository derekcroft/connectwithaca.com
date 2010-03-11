<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%

dim cmd, rs
set cmd = Server.CreateObject("ADODB.Command")

plCon_Open()

plCmd_Set cmd, plCon, "con451.Password_Validate"

plCmd_Param_Add cmd, "Email_Address VARCHAR(255)", plNullCheck(Request.Form("Email_Address_EML_RQD"),"")
plCmd_Param_Add cmd, "Login_Password VARCHAR(255)", plNullCheck(Request.Form("Password_RQD"),"")
plCmd_Param_Add cmd, "Membership_Key INT OUTPUT", 0

cmd.Execute,,adExecuteNoRecords

dim ivMembership_Key
ivMembership_Key = plNullCheck(cmd.Parameters("Membership_Key"),0)

if ivMembership_Key <> 0 then

	set rs = Server.CreateObject("ADODB.Recordset")

	plCmd_Params_Clear cmd, 0
	plCmd_Set cmd, plCon, "con451.Membership_Get"
	plCmd_Param_Add cmd, "Membership_Key INT", ivMembership_Key

	rs.open cmd,,adOpenForwardOnly,adLockReadOnly
	if not (rs.eof and rs.bof) then
		Session("Membership_Key") = rs.Fields.Item("Membership_Key").Value
		Session("First_Name") = rs.Fields.Item("First_Name").Value
		Session("Last_Name") = rs.Fields.Item("Last_Name").Value
		Session("Admin") = rs.Fields.Item("Admin").Value
		Session("Profile_Key") = plNullCheck(rs.Fields.Item("Profile_Key").Value,0)

		if plNullCheck(Request.Form("chkRemember"),0) = "1" then
			Response.Cookies("ACA_EMail") = plNullCheck(Request.Form("Email_Address_EML_RQD"),"")
			Response.Cookies("ACA_EMail").Expires = dateadd("yyyy", 1, date())
		end if

		if plNullCheck(rs.Fields.Item("Profile_Key").Value,0) = 0 then
			response.redirect "profile.asp"
		else
			response.redirect "profile.asp?Print=True"
		end if

		'response.redirect "member.asp?login=ok"
	else
		Response.write "Error Retrieving Membership"
	end if
	rs.close
	set rs = nothing

else
	Session("Membership_Key") = ""
	Session("First_Name") = ""
	Session("Last_Name") = ""
	Session("Admin") = ""
	Session("Profile_Key") = ""
	response.redirect "member.asp?login=invalid"
end if

plCon_Close()

set cmd = nothing
%>