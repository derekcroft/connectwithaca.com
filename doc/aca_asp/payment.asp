<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%

dim ivMembership_Key
ivMembership_Key = plNullCheck(Session("Membership_Key"),0)

if ivMembership_Key > 0 then

	dim cmd
	set cmd = Server.CreateObject("ADODB.Command")

	plCon_Open()

	plCmd_Set cmd, plCon, "con451.Membership_Payment_Add"
	plCmd_Param_Add cmd, "Membership_Key INT", ivMembership_Key

	cmd.Execute,,adExecuteNoRecords

	plCon_Close()

	set cmd = nothing

end if

response.redirect "profile.asp?Print=True"
%>