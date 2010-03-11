<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%

dim cmd
set cmd = Server.CreateObject("ADODB.Command")

plCon_Open()

plCmd_Set cmd, plCon, "con451.Recruiting_Add"

plCmd_Param_Add cmd, "Contact_Name VARCHAR(50)", plNullCheck(Request.Form("txtName_RQD"),"")
plCmd_Param_Add cmd, "Contact_Phone VARCHAR(25)", plNullCheck(Request.Form("txtPhone_RQD"),"")
plCmd_Param_Add cmd, "Contact_Email VARCHAR(128)", plNullCheck(Request.Form("txtEmail_EML"),"")
plCmd_Param_Add cmd, "Consultants VARCHAR(50)", plNullCheck(Request.Form("txtConsultants"),"")
plCmd_Param_Add cmd, "Geography VARCHAR(500)", plNullCheck(Request.Form("txtGeography"),"")
plCmd_Param_Add cmd, "Start_Date DATETIME", plNullCheck(Request.Form("txtStart_Date_DTE"),null)
plCmd_Param_Add cmd, "Program_Begin_Date DATETIME", plNullCheck(Request.Form("txtProgram_Begin_Date_DTE"),null)
plCmd_Param_Add cmd, "Program_End_Date DATETIME", plNullCheck(Request.Form("txtProgram_End_Date_DTE"),null)
plCmd_Param_Add cmd, "Recruiting_Key INT OUTPUT", 0

cmd.Execute,,adExecuteNoRecords

dim ivRecruiting_Key
ivRecruiting_Key = plNullCheck(cmd.Parameters("Recruiting_Key").Value,0)

if ivRecruiting_Key > 0 then

	dim svItem, svBody, svExpertise, svExpertise_List

	for each svItem in request.form
		svBody = svBody & svItem & " = " & request.form(svItem) & "<br>"
		if instr(svItem, "chkExpertise_") <> 0 then
			svExpertise_List = svExpertise_List & plNullCheck(replace(svItem, "chkExpertise_", ""), 0) & ","
		end if
	next

	if right(svExpertise_List,1) = "," then
		svExpertise_List = left(svExpertise_List,len(svExpertise_List)-1)
	end if

	plCmd_Params_Clear cmd, 0
	plCmd_Set cmd, plCon, "con451.Recruiting_Expertise_Add"
	plCmd_Param_Add cmd, "Recruiting_Key INT", ivRecruiting_Key
	plCmd_Param_Add cmd, "Expertise_List VARCHAR(1000)", plNullCheck(svExpertise_List,"")

	cmd.Execute,,adExecuteNoRecords

	plCmd_Params_Clear cmd, 0
	plCmd_Set cmd, plCon, "con451.Recruiting_Expertise_Get"
	plCmd_Param_Add cmd, "Recruiting_Key INT", ivRecruiting_Key
	plCmd_Param_Add cmd, "Expertise_List VARCHAR(4000) OUTPUT", ""

	cmd.Execute,,adExecuteNoRecords

	svExpertise = plNullCheck(cmd.Parameters("Expertise_List").Value,"")

	svBody = svBody & "Skills = " & svExpertise

	Send_Mail "recruiting@connectwithaca.com", "jjames@connectwithaca.com", "Recruiting Request", svBody, "jjames@connectwithaca.com", "jhappell@comcast.net"

end if

plCon_Close()

set cmd = nothing

response.redirect "recruiting.asp"
%>