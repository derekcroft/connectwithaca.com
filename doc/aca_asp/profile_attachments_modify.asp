<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/login_required.asp" -->
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%
Const svUpload_Data = "/upload_data"

'dim bvAdmin
'bvAdmin = Session("Admin")

dim cmd
set cmd = Server.CreateObject("ADODB.Command")

plCon_Open()

dim svDo
svDo = Request.QueryString("Do")

'dim ivMembership_Key, ivProfile_Key
dim ivCount, Upload
dim ivProfile_Attachment_Key
dim ivPrimary

if svDo = "Delete" or svDo = "Update" then

	set Upload = Server.CreateObject ("Persits.Upload.1")
	ivCount = Upload.SaveVirtual (svUpload_Data)

	ivProfile_Attachment_Key = plNullCheck(Upload.Form("hdnProfile_Attachment_Key"),0)
	'ivMembership_Key = plNullCheck(Upload.Form("hdnMembership_Key"),0)
	'ivProfile_Key = plNullCheck(Upload.Form("hdnProfile_Key"),0)
	ivPrimary = plNullCheck(Upload.Form("chkImage"),0)

	set Upload = nothing

	'if not bvAdmin then
	'	if ivMembership_Key <> Session("Membership_Key") then
	'		response.write "You do not have permission to delete this record."
	'		response.end
	'	end if
	'end if

	if svDo = "Delete" and ivProfile_Attachment_Key > 0 then

		plCmd_Set cmd, plCon, "con451.Profile_Attachment_Delete"
		plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key
		plCmd_Param_Add cmd, "Profile_Attachment_Key INT", ivProfile_Attachment_Key

		cmd.Execute,,adExecuteNoRecords

	end if

	if svDo = "Update" and ivProfile_Attachment_Key > 0 then

		plCmd_Set cmd, plCon, "con451.Profile_Attachment_Picture_Update"
		plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key
		plCmd_Param_Add cmd, "Profile_Attachment_Key INT", ivProfile_Attachment_Key
		plCmd_Param_Add cmd, "Primary_Image BIT", ivPrimary

		cmd.Execute,,adExecuteNoRecords

	end if

else

	Set Upload = Server.CreateObject ("Persits.Upload.1")
	Upload.ProgressID = Request.QueryString("PID")
	Upload.SetMaxSize 1400000, True
	ivCount = Upload.SaveVirtual (svUpload_Data)

	' 8 is the number of "File too large" exception
	'if Err.Number = 8 then
	'   Response.Write "Your file is too large. Please try again."
	'else
	'   if Err <> 0 then
	'      Response.Write "An error occurred: " & Err.Description
	'   end if
	'end if

	'ivMembership_Key = plNullCheck(Upload.Form("hdnMembership_Key"),0)
	'ivProfile_Key = plNullCheck(Upload.Form("hdnProfile_Key"),0)

	'if not bvAdmin then
	'	if ivMembership_Key <> Session("Membership_Key") then
	'		response.write "You do not have permission to update this record."
	'		response.end
	'	end if
	'end if

	dim svName, ivType, svOriginal_Name, svNew_Name
	dim svGuid, svDirectory, File1
	svName = plNullCheck(Upload.Form("txtName_RQD"), "")
	ivType = plNullCheck(Upload.Form("lstAttachment_Type_RQD"), 0)


	if ivType = 4 then
		svOriginal_Name = plNullCheck(Upload.Form("txtURL"), "")
	else

		if ivCount = 1 then
			svDirectory = server.mappath(svUpload_Data)
			svGuid = CreateWindowsGUID()

			set File1 = Upload.Files("FILE1")
			svOriginal_Name = File1.FileName
			svNew_Name = svGuid & File1.Ext
			File1.Copy svDirectory & "\" & svNew_Name
			File1.Delete
			set File1 = nothing
		end if

	end if

	set Upload = Nothing

	plCmd_Set cmd, plCon, "con451.Profile_Attachment_Add"
	plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key
	plCmd_Param_Add cmd, "Profile_Attachment VARCHAR(255)", svName
	plCmd_Param_Add cmd, "Original_Attachment_Name VARCHAR(255)", svOriginal_Name
	plCmd_Param_Add cmd, "Filesystem_Name VARCHAR(255)", plNullCheck(svNew_Name,"")
	plCmd_Param_Add cmd, "Profile_Attachment_Type_Key INT", ivType
	plCmd_Param_Add cmd, "Primary_Image BIT", 0
	plCmd_Param_Add cmd, "Profile_Attachment_Key INT OUTPUT", 0

	cmd.Execute,,adExecuteNoRecords

end if

plCon_Close()

set cmd = nothing

if bvAdmin then
	response.redirect "profile_attachments.asp?Membership_Key=" & ivMembership_Key & "&Profile_Key=" & ivProfile_Key
else
	response.redirect "profile_attachments.asp"
end if

%>