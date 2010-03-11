<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/login_required.asp" -->
<!-- #include file="include/header.asp" -->
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%

dim svCurrent, svNew, svConfirm
dim svMessage

svCurrent = plNullCheck(Request.Form("Current_Password_RQD"),"")
svNew = plNullCheck(Request.Form("New_Password_RQD"),"")
svConfirm = plNullCheck(Request.Form("Confirm_New_Password_RQD"),"")

if len(svCurrent) > 0 and len(svNew) > 0 and len(svConfirm) > 0 then

	if len(svNew) < 8 then
		svMessage = "Passwords must be at least 8 characters long."
	elseif svNew = svConfirm then

		dim cmd
		set cmd = Server.CreateObject("ADODB.Command")

		plCon_Open()

		plCmd_Set cmd, plCon, "con451.Password_Change"
		plCmd_Param_Add cmd, "Membership_Key INT", Session("Membership_Key")
		plCmd_Param_Add cmd, "Old_Login_Password VARCHAR(255)", svCurrent
		plCmd_Param_Add cmd, "New_Login_Password VARCHAR(255)", svNew
		plCmd_Param_Add cmd, "Success BIT OUTPUT", 0

		cmd.Execute,,adExecuteNoRecords

		if cbool(plNullCheck(cmd.Parameters("Success"),0)) then
			svMessage = "Password Successfully Changed."
		else
			svMessage = "Error Changing Password."
		end if

		set cmd = nothing
		plCon_Close


	else
		svMessage = "New Passwords do NOT match."
	end if

end if

%>
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
		if(document.thisForm.New_Password_RQD.value.length < 8){
			Notify("Passwords must be at least 8 characters long.");
			return;
		}
		if(document.thisForm.New_Password_RQD.value != document.thisForm.Confirm_New_Password_RQD.value){
			Notify("New Passwords do NOT match.");
			return;
		}
		document.thisForm.action = "change_password.asp";
		document.thisForm.submit();
	}
	return
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
							<ul id="cust" class="nav">
								<%if Session("Membership_Key") <> "" then%>
								<li>
										<a id="four" href="javascript:toggle('four','foursub');">> Logged in as... <%=Session("First_Name")%>&nbsp;<%=Session("Last_Name")%></a>
										<ul id="foursub" class="sub">
											<%if cbool(Session("Admin")) then%>
											<!--<li><a href="admin.asp">Admin</a></li>-->
											<%end if%>
											<li><a href="change_password.asp">Change Password</a></li>
											<li><a href="logout.asp">Logout</a></li>
										</ul>
								</li>
								<li>
									<a id="two" href="javascript:toggle('two','twosub');">> Member Profiles</a>
									<ul id="twosub" class="sub">
										<li><a href="profile.asp">Edit My Profile</a></li>
									</ul>
								</li>
								<li>
									<a id="three" href="javascript:toggle('three','threesub');">> Member Directory</a>
									<ul id="threesub" class="sub">
										<li><a href="member_list.asp">All Members</a></li>
									</ul>
								</li>
								<%end if%>
							</ul>
						</div>
					</td>
					<td valign="top">
						<!-- CONTENT AREA //-->
						<table id="content_table" cellspacing="0" cellpadding="0">
							<tr>
								<td id="content_top">Change Password</td>
							</tr>
							<tr>
								<td id="content_main" style="background-repeat:no-repeat;background-position:right bottom;">

									<table border="0" width="80%" align="center">
									<%if svMessage <> "" then%>
										<tr>
											<td colspan="2" align="center" style="color:#c60a27;"><%=svMessage%></td>
										</tr>
									<%end if%>
									<tr>
										<td align="right">Current Password:&nbsp;</td>
										<td align="left"><input type="password" name="Current_Password_RQD" value="" size="20" maxlength="128"></td>
									</tr>
									<tr>
										<td align="right">New Password:&nbsp;</td>
										<td align="left"><input type="password" name="New_Password_RQD" value="" size="20" maxlength="128"></td>
									</tr>
									<tr>
										<td align="right">New Password (Confirm):&nbsp;</td>
										<td align="left"><input type="password" name="Confirm_New_Password_RQD" value="" size="20" maxlength="128"></td>
									</tr>
									<tr>
										<td colspan="2" align="center"><input type="image" src="images/button.jpg" onclick="javascript:SubmitForm();"></td>
									</tr>
									</table>

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

