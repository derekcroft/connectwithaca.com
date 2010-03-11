<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/login_required.asp" -->
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%

dim cmd
set cmd = Server.CreateObject("ADODB.Command")

dim ivNew_Membership_Key, svNew_Email_Address, svNew_Password

plCon_Open()

if Request.Form("Do") = "Add" then

	if not bvAdmin then
		Response.write "You do not have permission to manage Members."
		Response.end
	end if

	plCmd_Set cmd, plCon, "con451.Membership_Add"

	plCmd_Param_Add cmd, "Personal_Email_Address VARCHAR(255)", plNullCheck(Request.Form("txtPersonal_Email_Address_EML_RQD"),"")
	plCmd_Param_Add cmd, "Last_Name VARCHAR(50)", plNullCheck(Request.Form("txtLast_Name_RQD"),"")
	plCmd_Param_Add cmd, "First_Name VARCHAR(50)", plNullCheck(Request.Form("txtFirst_Name_RQD"),"")
	plCmd_Param_Add cmd, "Address_Line1 VARCHAR(255)", plNullCheck(Request.Form("txtAddress_Line1"),"")
	plCmd_Param_Add cmd, "Address_Line2 VARCHAR(255)", plNullCheck(Request.Form("txtAddress_Line2"),"")
	plCmd_Param_Add cmd, "City VARCHAR(255)", plNullCheck(Request.Form("txtCity"),"")
	plCmd_Param_Add cmd, "State VARCHAR(2)", plNullCheck(Request.Form("txtState"),"")
	plCmd_Param_Add cmd, "Postal_Code VARCHAR(25)", plNullCheck(Request.Form("txtZip_Code"),"")
	plCmd_Param_Add cmd, "Home_Phone VARCHAR(25)", plNullCheck(Request.Form("txtHome_Phone"),"")
	plCmd_Param_Add cmd, "Business_Phone VARCHAR(25)", plNullCheck(Request.Form("txtBusiness_Phone"),"")
	plCmd_Param_Add cmd, "Mobile_Phone VARCHAR(25)", plNullCheck(Request.Form("txtMobile_Phone"),"")
	plCmd_Param_Add cmd, "Admin_Note VARCHAR(4000)", plNullCheck(Request.Form("txaInternal_Note_TXA_4000"),"")
	plCmd_Param_Add cmd, "Add_By INT", Session("Membership_Key")
	plCmd_Param_Add cmd, "Membership_Key INT OUTPUT", 0
	plCmd_Param_Add cmd, "URL VARCHAR(255)", plNullCheck(Request.Form("txtURL"),"")
	plCmd_Param_Add cmd, "ACA_Email_Address VARCHAR(255) OUTPUT", ""
	plCmd_Param_Add cmd, "New_Password VARCHAR(50) OUTPUT", ""

	cmd.Execute,,adExecuteNoRecords

	ivNew_Membership_Key = plNullCheck(cmd.Parameters("Membership_Key"),0)
	svNew_Email_Address = plNullCheck(cmd.Parameters("ACA_Email_Address"),"")
	svNew_Password = plNullCheck(cmd.Parameters("New_Password"),"")

	if ivNew_Membership_Key = 0 then
		response.write "Error Adding Membership"
		response.end
	else

		dim svBody
		svBody = "Welcome -- Your membership has been created!<br><br>"
		svBody = svBody & "You can sign in at <a href='http://www.connectwithaca.com/'>http://www.connectwithaca.com/</a> by clicking on Member Log-In.<br>"
		svBody = svBody & "Your login email address is " & svNew_Email_Address & " and your default password is " & svNew_Password & "."

		Send_Mail "newmember@connectwithaca.com", Request.Form("txtPersonal_Email_Address_EML_RQD"), "Welcome to the ACA", svBody, "newmember@connectwithaca.com", "jhappell@comcast.net"

	end if

elseif Request.Form("Do") = "Update" then

	plCmd_Set cmd, plCon, "con451.Membership_Update"

	plCmd_Param_Add cmd, "Membership_Key INT", plNullCheck(Request.Querystring("Membership_Key"),0)
	plCmd_Param_Add cmd, "Email_Address VARCHAR(255)", plNullCheck(Request.Form("txtEmail_Address_EML_RQD"),"")
	plCmd_Param_Add cmd, "Last_Name VARCHAR(50)", plNullCheck(Request.Form("txtLast_Name_RQD"),"")
	plCmd_Param_Add cmd, "First_Name VARCHAR(50)", plNullCheck(Request.Form("txtFirst_Name_RQD"),"")
	plCmd_Param_Add cmd, "Address_Line1 VARCHAR(255)", plNullCheck(Request.Form("txtAddress_Line1"),"")
	plCmd_Param_Add cmd, "Address_Line2 VARCHAR(255)", plNullCheck(Request.Form("txtAddress_Line2"),"")
	plCmd_Param_Add cmd, "City VARCHAR(255)", plNullCheck(Request.Form("txtCity"),"")
	plCmd_Param_Add cmd, "State VARCHAR(2)", plNullCheck(Request.Form("txtState"),"")
	plCmd_Param_Add cmd, "Postal_Code VARCHAR(25)", plNullCheck(Request.Form("txtZip_Code"),"")
	plCmd_Param_Add cmd, "Home_Phone VARCHAR(25)", plNullCheck(Request.Form("txtHome_Phone"),"")
	plCmd_Param_Add cmd, "Business_Phone VARCHAR(25)", plNullCheck(Request.Form("txtBusiness_Phone"),"")
	plCmd_Param_Add cmd, "Mobile_Phone VARCHAR(25)", plNullCheck(Request.Form("txtMobile_Phone"),"")
	plCmd_Param_Add cmd, "Active BIT", plNullCheck(Request.Form("chkActive"),0)
	plCmd_Param_Add cmd, "Admin_Note VARCHAR(4000)", plNullCheck(Request.Form("txaInternal_Note_TXA_4000"),NULL)
	plCmd_Param_Add cmd, "Updated_By INT", Session("Membership_Key")
	plCmd_Param_Add cmd, "URL VARCHAR(255)", plNullCheck(Request.Form("txtURL"),"")

	cmd.Execute,,adExecuteNoRecords

end if

plCon_Close()

set cmd = nothing

response.redirect "member_list.asp"

%>