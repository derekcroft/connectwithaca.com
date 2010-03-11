<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/login_required.asp" -->
<!-- #include file="include/header.asp" -->
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>ACA</title>
<link rel="stylesheet" href="css/aca_global.css" type="text/css">
<script type="text/javascript" src="js/aca_main.js"></script>
<script type="text/javascript" src="js/plexus.js"></script>
<script type="text/javascript" src="js/pickers.js"></script>
<script type="text/javascript" src="js/dredd.js"></script>
<script>
function SubmitForm(){
	if(Validate_Form_No_Submit()){
		document.thisForm.action = "membership_modify.asp?Membership_Key=<%=ivMembership_Key%>";
		document.thisForm.submit();
	}
}
</script>
</head>
<body>
<form name="thisForm" method="POST" onSubmit="return(false)">
<center>
<table id="container" cellspacing="0" cellpadding="0">
	<tr>
		<td id="top"></td>
	</tr>
	<tr>
		<td id="header">
			<%header 2%>
		</td>
	</tr>
	<tr>
		<td id="content">
			<div id="member_img"><div id="pg_title">Member Center</div></div>
			<table id="pg_container" cellspacing="0" cellpadding="0">
				<tr>
					<td id="menu_area">
						<!-- SIDE MENU //-->
						<div id="sidebar">
							<!-- #include file="include/member_sidebar.asp" -->
						</div>
					</td>
					<td valign="top">
						<!-- CONTENT AREA //-->
						<table id="content_table" cellspacing="0" cellpadding="0">
							<tr>
								<td id="content_top">Member List</td>
							</tr>
							<tr>
								<td id="content_main" style="background-repeat:no-repeat;background-position:right bottom;">
<%
	'dim bvAdmin
	'bvAdmin = Session("Admin")

	'dim ivMembership_Key
	'dim bvUpdate
	if Request.QueryString("Do") = "Add" then
		if not bvAdmin then
			Response.write "You do not have permission to manage Members."
			Response.end
		end if
		bvUpdate = false
	else
		bvUpdate = true
		'if Request.Form("hdnMembership_Key") <> "" then
		'	ivMembership_Key = Request.Form("hdnMembership_Key")
		'else
		'	Response.write "You do not have permission to manage Members."
		'	Response.end
		'end if
	end if

	dim svEmail, svLast_Name, svFirst_Name
	dim svAddress_Line1, svAddress_Line2, svAddress_Line3
	dim svCity, svState, svZip
	dim svHome_Phone, svBusiness_Phone, svMobile_Phone
	dim ivActive, svAdmin_Note, svURL
	dim svPersonal_Email_Address

	if bvUpdate then

		dim cmd, rs
		set cmd = Server.CreateObject("ADODB.Command")
		set rs = Server.CreateObject("ADODB.Recordset")

		plCon_Open()

		plCmd_Set cmd, plCon, "con451.Membership_Get"
		plCmd_Param_Add cmd, "Membership_Key INT", ivMembership_Key

		rs.open cmd,,adOpenForwardOnly,adLockReadOnly
		if not (rs.eof and rs.bof) then

			svEmail = plNullCheck(rs.Fields.Item("Email_Address").Value,"")
			svLast_Name = plNullCheck(rs.Fields.Item("Last_Name").Value,"")
			svFirst_Name = plNullCheck(rs.Fields.Item("First_Name").Value,"")
			svAddress_Line1 = plNullCheck(rs.Fields.Item("Address_Line1").Value,"")
			svAddress_Line2 = plNullCheck(rs.Fields.Item("Address_Line2").Value,"")
			svAddress_Line3 = plNullCheck(rs.Fields.Item("Address_Line3").Value,"")
			svCity = plNullCheck(rs.Fields.Item("City").Value,"")
			svState = plNullCheck(rs.Fields.Item("State").Value,"")
			svZip = plNullCheck(rs.Fields.Item("Postal_Code").Value,"")
			svHome_Phone = plNullCheck(rs.Fields.Item("Home_Phone").Value,"")
			svBusiness_Phone = plNullCheck(rs.Fields.Item("Business_Phone").Value,"")
			svMobile_Phone = plNullCheck(rs.Fields.Item("Mobile_Phone").Value,"")
			ivActive = plIIF(plNullCheck(rs.Fields.Item("Active").Value,0), 1, 0)
			svAdmin_Note = plNullCheck(rs.Fields.Item("Admin_Note").Value,"")
			svURL = plNullCheck(rs.Fields.Item("URL").Value,"")
			svPersonal_Email_Address = plNullCheck(rs.Fields.Item("Personal_Email_Address").Value,"")

		else
			response.write "Error Retrieving Membership"
			response.end
		end if
		rs.close

		plCon_Close
		set rs = nothing
		set cmd = nothing

	end if
%>

	<table border="0" width="95%" align="center">
	<tr>
		<td align="right">Personal Email:&nbsp;</td>
		<td align="left"><%plTextbox "txtPersonal_Email_Address_EML_RQD", svPersonal_Email_Address, 20, 255, ""%></td>
		<%if bvAdmin and bvUpdate then%>
			<td align="right">Active:&nbsp;</td>
			<td align="left"><%plCheckbox "chkActive", ivActive, "1"%></td>
		<%else%>
			<input type="hidden" name="chkActive" value="<%=ivActive%>">
			<td align="right"></td>
			<td align="left"></td>
		<%end if%>
	</tr>
	<tr>
		<td align="right">Last Name:&nbsp;</td>
		<td align="left"><%plTextbox "txtLast_Name_RQD", svLast_Name, 20, 50, ""%></td>
		<td align="right">First Name:&nbsp;</td>
		<td align="left"><%plTextbox "txtFirst_Name_RQD", svFirst_Name, 20, 50, ""%></td>
	</tr>
	<tr>
		<td align="right">Address:&nbsp;</td>
		<td align="left"><%plTextbox "txtAddress_Line1", svAddress_Line1, 20, 255, ""%></td>
		<td align="right">Address 2:&nbsp;</td>
		<td align="left"><%plTextbox "txtAddress_Line2", svAddress_Line2, 20, 255, ""%></td>
	</tr>
	<tr>
		<td align="right">City:&nbsp;</td>
		<td align="left"><%plTextbox "txtCity", svCity, 20, 255, ""%></td>
		<td align="right">State:&nbsp;</td>
		<td align="left"><%plTextbox "txtState", svState, 5, 2, ""%></td>
	</tr>
	<tr>
		<td align="right">Zip Code:&nbsp;</td>
		<td align="left"><%plTextbox "txtZip_Code", svZip, 10, 25, ""%></td>
		<td align="right">Home Phone:&nbsp;</td>
		<td align="left"><%plTextbox "txtHome_Phone", svHome_Phone, 10, 25, ""%></td>
	</tr>
	<tr>
		<td align="right">Business Phone:&nbsp;</td>
		<td align="left"><%plTextbox "txtBusiness_Phone", svBusiness_Phone, 10, 25, ""%></td>
		<td align="right">Mobile Phone:&nbsp;</td>
		<td align="left"><%plTextbox "txtMobile_Phone", svMobile_Phone, 10, 25, ""%></td>
	</tr>
	<tr>
		<td align="right">Web Site:&nbsp;</td>
		<td align="left" colspan="3"><%plTextbox "txtURL", svURL, 50, 255, ""%></td>
	</tr>
	<%if bvUpdate then%>
	<tr>
		<td align="right">ACA Email Address:&nbsp;</td>
		<td align="left">
		<%
			if bvAdmin then
				plTextbox "txtEmail_Address_EML_RQD", svEmail, 20, 255, ""
			else
				%>
				<b><%=svEmail%></b>
				<input type="hidden" name="txtEmail_Address_EML_RQD" value="<%=svEmail%>">
				<%
			end if
		%>
		</td>
		<td align="right"></td>
		<td align="left"></td>
	</tr>
	<%end if%>
	<%if bvAdmin then%>
		<tr valign="top">
			<td align="right">Internal Note:&nbsp;</td>
			<td align="left" colspan="3"><%plTextArea "txaInternal_Note_TXA_4000", svAdmin_Note, 45, 5, ""%></td>
		</tr>
	<%end if%>
	<tr>
		<td colspan="4" align="center"><input type="image" src="images/button.jpg" onclick="javascript:SubmitForm();"></td>
	</tr>
	</table>

	<%if bvUpdate then%>
		<!--<input type="hidden" name="Membership_Key" value="<%=ivMembership_Key%>">-->
		<input type="hidden" name="Do" value="Update">
	<%else%>
		<input type="hidden" name="Do" value="Add">
	<%end if%>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td id="bottom-footer"><%footer%></td>
	</tr>
</table>
</form>
</center>
</body>
</html>

