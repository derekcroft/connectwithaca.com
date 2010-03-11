<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/login_required_print_only.asp" -->
<!-- #include file="include/header.asp" -->
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%
	dim cmd, rs
	set cmd = Server.CreateObject("ADODB.Command")
	set rs = Server.CreateObject("ADODB.Recordset")

	rs.CursorLocation = adUseClient

	plCon_Open()

	dim svFirst_Name, svLast_Name, svEmail, svURL
	dim svTitle, svLocation, ivYears_of_Experience, svBiography, svImage, svImage_Small

	plCmd_Params_Clear cmd, 0
	plCmd_Set cmd, plCon, "con451.Membership_Get"
	plCmd_Param_Add cmd, "Membership_Key INT", ivMembership_Key

	rs.open cmd,,adOpenForwardOnly,adLockReadOnly
	if not (rs.eof and rs.bof) then

		svFirst_Name = plNullCheck(rs.Fields.Item("First_Name").Value,"")
		svLast_Name = plNullCheck(rs.Fields.Item("Last_Name").Value,"")
		svEmail = plNullCheck(rs.Fields.Item("Email_Address").Value,0)
		svURL = plNullCheck(rs.Fields.Item("URL").Value,"")

		if svURL <> "" then
			if left(svURL, 4) <> "http" then
				svURL = "http://" & svURL
			end if
		end if

	else
		response.write "Error Retrieving Membership"
		response.end
	end if
	rs.close

	plCmd_Params_Clear cmd, 0
	plCmd_Set cmd, plCon, "con451.Profile_Get"
	plCmd_Param_Add cmd, "Membership_Key INT", ivMembership_Key
	plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key

	rs.open cmd,,adOpenForwardOnly,adLockReadOnly
	if not (rs.eof and rs.bof) then

		svTitle = plNullCheck(rs.Fields.Item("Title").Value,"")
		svLocation = plNullCheck(rs.Fields.Item("Location").Value,"")
		ivYears_of_Experience = plNullCheck(rs.Fields.Item("Years_of_Experience").Value,0)
		svBiography = plNullCheck(rs.Fields.Item("Biography").Value,"")
		svImage = plNullCheck(rs.Fields.Item("Image").Value,"") '"images/member_profile.jpg"
		svImage_Small = plNullCheck(rs.Fields.Item("Image_Small").Value,"")

		if svImage <> "" then
			svImage = "/upload_data/" & svImage
		end if

		if svImage_Small <> "" then
			svImage_Small = "/upload_data/" & svImage_Small
		end if

	else
		response.write "Error Retrieving Profile"
		response.end
	end if
	rs.close


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
			<div id="member_img"><div id="pg_title">Member Profiles</div></div>
			<table id="pg_container" cellspacing="0" cellpadding="0">
				<tr>
					<td id="menu_area">
						<!-- SIDE MENU //-->
						<br>
						<div align="center">
							<%if svImage <> "" then%>
							<img src="<%=svImage%>" border="0">
							<%end if%>
							<br><br>
							<a href="mailto:<%=svEmail%>">Contact Me</a>
						</div>
					</td>
					<td valign="top">
						<!-- CONTENT AREA //-->
						<table id="content_table" cellspacing="0" cellpadding="0">
							<tr>
								<td id="profile_top" style="background-image:url(<%=svImage_Small%>);background-repeat:no-repeat;height=50px;">
									<div id="profile_top_text">
										<%=svFirst_Name%>&nbsp;<%=svLast_Name%> > <span style="font-size:0.6em;"><%=svTitle%></span>
									</div>
								</td>
							</tr>
								<tr>
									<td id="content_main">
										<p><%=svBiography%></p>
									</td>
								</tr>
							<tr>
								<td id="content_main" style="text-align:left;">

									<table id="profile" cellspacing="0" cellpadding="0">
										<tr>
											<td id="profile_red">Location:</td>
											<td>
												<%=svLocation%>
											</td>
										</tr>
										<tr valign="top">
											<td id="profile_red">Expertise:</td>
											<td>
<%

plCmd_Params_Clear cmd, 0
plCmd_Set cmd, plCon, "con451.Profile_Expertise_Get"
plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key

rs.open cmd,,adOpenForwardOnly,adLockReadOnly
if not (rs.eof and rs.bof) then
  do until rs.eof
	if plNullCheck(rs.Fields.Item("Profile_Key").Value,0) > 0 then
		response.write rs.Fields.Item("Expertise").Value & "<br>"
	end if
    rs.movenext
  loop
end if
rs.close
%>
											</td>
										</tr>
										<tr valign="top">
											<td id="profile_red">Latest Projects:</td>
											<td>
<%
plCmd_Params_Clear cmd, 0
plCmd_Set cmd, plCon, "con451.Profile_Project_Get"
plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key

rs.open cmd,,adOpenForwardOnly,adLockReadOnly
if not (rs.eof and rs.bof) then
	do until rs.eof
		if plNullCheck(rs.Fields.Item("Show_on_Profile").Value,0) and plNullCheck(rs.Fields.Item("Project").Value,"") <> "" then
			response.write plNullCheck(rs.Fields.Item("Project").Value,"") & "<BR>"
		end if
		rs.movenext
	loop
end if
rs.close
%>
											</td>
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
</center>
</form>
</body>
</html>
<%
plCon_Close
set rs = nothing
set cmd = nothing
%>
