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
/*function SubmitMembershipForm(ivKey){
	document.thisForm.hdnMembership_Key.value = ivKey;
	document.thisForm.action = "membership_form.asp";
	document.thisForm.submit();
}
function SubmitProfileForm(ivMembership_Key, ivProfile_Key){
	document.thisForm.hdnMembership_Key.value = ivMembership_Key;
	document.thisForm.hdnProfile_Key.value = ivProfile_Key;
	document.thisForm.action = "profile.asp";
	document.thisForm.submit();
}*/
function ResetPassword(ivKey){
	if(confirm("Are you sure you want to reset this member's password?")){
		document.thisForm.hdnMembership_Key.value = ivKey;
		document.thisForm.action = "reset_password.asp";
		document.thisForm.submit();
	}else{
		document.thisForm.reset();
	}
}
</script>
</head>
<body>
<form name="thisForm" method="POST">
<input type="hidden" name="hdnMembership_Key" value="">
<!--<input type="hidden" name="hdnProfile_Key" value="">-->
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
							<ul id="cust" class="nav">
								<!-- #include file="include/member_sidebar.asp" -->
							</ul>
						</div>
					</td>
<%
	'dim bvAdmin
	'bvAdmin = Session("Admin")
%>
					<td valign="top">
						<!-- CONTENT AREA //-->
						<table id="content_table" cellspacing="0" cellpadding="0">
							<tr>
								<td id="content_top">Member List
									<%if bvAdmin then%>
										- <a href="membership_form.asp?Do=Add">Add New</a>
									<%end if%>
								</td>
							</tr>
							<tr>
								<td id="content_main" style="background-repeat:no-repeat;background-position:right bottom;">
<%
	dim cmd, rs
	set cmd = Server.CreateObject("ADODB.Command")
	set rs = Server.CreateObject("ADODB.Recordset")

	plCon_Open()

	plCmd_Set cmd, plCon, "con451.Memberships_Get"
	plCmd_Param_Add cmd, "Active BIT", plIIF(bvAdmin, 0, 1)

	rs.open cmd,,adOpenForwardOnly,adLockReadOnly
	if not (rs.eof and rs.bof) then
%>
		<table border="0" width="99%" align="center">
		<tr valign="bottom">
			<th>Name</th>
			<th>Email<br>@connectwithaca.com</th>
			<th>Profile</th>
			<%if bvAdmin then%>
				<th>Active</th>
				<th>Membership<br>Added</th>
				<th>Reset<br>Password</th>
			<%end if%>
		</tr>
<%
		do while not rs.eof
%>
		<tr>
			<td align="left">
				<%if bvAdmin or Session("Membership_Key") = rs.Fields.Item("Membership_Key").Value then%>
					<a href="membership_form.asp?Membership_Key=<%=rs.Fields.Item("Membership_Key").Value%>">
				<%end if%>
				<%=rs.Fields.Item("Last_Name").Value%>, <%=rs.Fields.Item("First_Name").Value%>
				<%if bvAdmin then%>
					</a>
				<%end if%>
			</td>
			<td align="left"><%=left(rs.Fields.Item("Email_Address").Value, instr(rs.Fields.Item("Email_Address").Value,"@")-1)%></td>
			<td>
				<%if bvAdmin then%>
				<a href="profile.asp?Membership_Key=<%=rs.Fields.Item("Membership_Key").Value%>&Profile_Key=<%=plNullCheck(rs.Fields.Item("Profile_Key").Value,0)%>">Edit</a>
				<%else%>
				<%if plNullCheck(rs.Fields.Item("Profile_Key").Value,0) <> 0 then%>
				<a href="profile_print.asp?Membership_Key=<%=rs.Fields.Item("Membership_Key").Value%>&Profile_Key=<%=plNullCheck(rs.Fields.Item("Profile_Key").Value,0)%>">View</a>
				<%end if%>
				<%end if%>
			</td>
			<%if bvAdmin then%>
				<td><%=plIIF(rs.Fields.Item("Active").Value, CheckMark, "")%></td>
				<td><font color="<%=plIIF(plNullCheck(rs.Fields.Item("Needs_Attention").Value,0) = 0, "black", "red")%>"><%=rs.Fields.Item("Membership_Add_Date").Value%></font></td>
				<td><%=plsCheckbox("chkReset", "1", "0", "1", "onclick=ResetPassword(" & rs.Fields.Item("Membership_Key").Value & ")", true)%></td>
			<%end if%>
		</tr>
<%			rs.movenext
		loop
%>
		</table>
<%
	else
		Response.write "No Records Found!"
	end if
	rs.Close
	plCon_Close
	set rs = nothing
	set cmd = nothing
%>
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

