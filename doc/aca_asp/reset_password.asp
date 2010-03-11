<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/login_required.asp" -->
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%

dim cmd, rs
set cmd = Server.CreateObject("ADODB.Command")

plCon_Open()

plCmd_Set cmd, plCon, "con451.Password_Reset"

plCmd_Param_Add cmd, "Membership_Key INT", plNullCheck(Request.Form("hdnMembership_Key"),0)
plCmd_Param_Add cmd, "Update_By INT", Session("Membership_Key")

cmd.Execute,,adExecuteNoRecords

plCon_Close()

set cmd = nothing

response.redirect "member_list.asp"
%>