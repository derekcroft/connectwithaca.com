<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/login_required.asp" -->
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%

dim svItem

'dim bvAdmin
'bvAdmin = Session("Admin")

'dim ivMembership_Key, ivProfile_Key, bvUpdate
'ivMembership_Key = plNullCheck(Request.Form("hdnMembership_Key"),0)
'ivProfile_Key = plNullCheck(Request.Form("hdnProfile_Key"),0)

'if not bvAdmin then
'	if ivMembership_Key <> Session("Membership_Key") then
'		response.write "You do not have permission to update this record."
'		response.end
'	end if
'end if

dim cmd
set cmd = Server.CreateObject("ADODB.Command")

plCon_Open()

if ivProfile_Key = 0 then

	bvUpdate = false

	plCmd_Set cmd, plCon, "con451.Profile_Add"
	plCmd_Param_Add cmd, "Membership_Key INT", ivMembership_Key
	plCmd_Param_Add cmd, "Title VARCHAR(255)", plNullCheck(Request.Form("txtTitle_RQD"),"")
	plCmd_Param_Add cmd, "Location VARCHAR(255)", plNullCheck(Request.Form("txtLocation_RQD"),"")
	plCmd_Param_Add cmd, "Years_of_Experience INT", plNullCheck(Request.Form("txtYears_INT"),0)
	plCmd_Param_Add cmd, "Biography VARCHAR(4000)", plNullCheck(Request.Form("txaBiography_TXA_4000_RQD"),"")
	plCmd_Param_Add cmd, "Profile_Key INT OUTPUT", 0

	cmd.Execute,,adExecuteNoRecords

	ivProfile_Key = plNullCheck(cmd.Parameters("Profile_Key"),0)

	if ivProfile_Key = 0 then
		response.write "Error Adding Profile"
		response.end
	end if

	if cint(ivMembership_Key) = cint(ivMember) then
		Session("Profile_Key") = ivProfile_Key
	end if

else

	bvUpdate = true

	plCmd_Set cmd, plCon, "con451.Profile_Update"
	plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key
	plCmd_Param_Add cmd, "Title VARCHAR(255)", plNullCheck(Request.Form("txtTitle_RQD"),"")
	plCmd_Param_Add cmd, "Location VARCHAR(255)", plNullCheck(Request.Form("txtLocation_RQD"),"")
	plCmd_Param_Add cmd, "Years_of_Experience INT", plNullCheck(Request.Form("txtYears_INT"),0)
	plCmd_Param_Add cmd, "Biography VARCHAR(4000)", plNullCheck(Request.Form("txaBiography_TXA_4000_RQD"),"")
	plCmd_Param_Add cmd, "Sample BIT", plNullCheck(Request.Form("chkSample"),0)

	cmd.Execute,,adExecuteNoRecords

end if

if bvUpdate then
	plCmd_Params_Clear cmd, 0
	plCmd_Set cmd, plCon, "con451.Profile_Expertise_Delete"
	plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key

	cmd.Execute,,adExecuteNoRecords
end if

plCmd_Params_Clear cmd, 0
plCmd_Set cmd, plCon, "con451.Profile_Expertise_Add"
plCmd_Param_Add cmd, "Profile_Key INT", 0
plCmd_Param_Add cmd, "Expertise_Key INT", 0
plCmd_Param_Add cmd, "Years_of_Experience INT", 0

for each svItem in request.form
	if instr(svItem, "chkExpertise_") <> 0 then

		dim ivExpertise_Key, ivYears
		ivExpertise_Key = plNullCheck(replace(svItem, "chkExpertise_", ""), 0)
		ivYears = plNullCheck(Request.Form("txtExpertise_Years_" & ivExpertise_Key & "_INT"),0)

		cmd.Parameters("Profile_Key").value = ivProfile_Key
		cmd.Parameters("Expertise_Key").value = ivExpertise_Key
		cmd.Parameters("Years_of_Experience").value = ivYears

		cmd.Execute,,adExecuteNoRecords

	end if
next

if bvUpdate then
	plCmd_Params_Clear cmd, 0
	plCmd_Set cmd, plCon, "con451.Profile_Project_Delete"
	plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key

	cmd.Execute,,adExecuteNoRecords
end if

plCmd_Params_Clear cmd, 0
plCmd_Set cmd, plCon, "con451.Profile_Project_Add"
plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key
plCmd_Param_Add cmd, "Client VARCHAR(255)", ""
plCmd_Param_Add cmd, "Project VARCHAR(500)", ""
plCmd_Param_Add cmd, "Show_on_Profile BIT", 0

for each svItem in request.form
	if instr(svItem, "txtProject_") <> 0 then

		dim ivKey, svProject, svClient, ivShow
		ivKey = plNullCheck(replace(svItem, "txtProject_", ""), 0)

		svClient = plNullCheck(Request.Form("txtClient_" & ivKey), "")
		svProject = plNullCheck(Request.Form("txtProject_" & ivKey), "")
		ivShow = plNullCheck(Request.Form("chkShow_" & ivKey), 0)

		cmd.Parameters("Client").value = svClient
		cmd.Parameters("Project").value = svProject
		cmd.Parameters("Show_on_Profile").value = ivShow

		cmd.Execute,,adExecuteNoRecords

	end if
next

plCon_Close()

set cmd = nothing

if bvAdmin then
	response.redirect "profile.asp?Membership_Key=" & ivMembership_Key & "&Profile_Key=" & ivProfile_Key
else
	response.redirect "profile.asp"
end if

%>