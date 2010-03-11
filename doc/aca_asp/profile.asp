<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/login_required.asp" -->
<!-- #include file="include/header.asp" -->
<!-- #include file="include/library.asp" -->
<!-- #include file="include/db.asp" -->
<%
	'dim bvAdmin
	'bvAdmin = Session("Admin")

	dim bvPrint
	bvPrint = (Request.Querystring("Print") = "True")

	'dim ivMembership_Key, ivProfile_Key
	'ivMembership_Key = plNullCheck(Request.Form("hdnMembership_Key"),Session("Membership_Key"))
	'ivProfile_Key = plNullCheck(Request.Form("hdnProfile_Key"),0)

	'ivMembership_Key = plNullCheck(Request.QueryString("Membership_Key"),Session("Membership_Key"))
	'ivProfile_Key = plNullCheck(Request.QueryString("Profile_Key"),0)

	'if not bvAdmin then
	'	if ivMembership_Key <> Session("Membership_Key") then
	'		response.write "You do not have permission to update this record."
	'		response.end
	'	end if
	'end if

	dim cmd, rs
	set cmd = Server.CreateObject("ADODB.Command")
	set rs = Server.CreateObject("ADODB.Recordset")

	rs.CursorLocation = adUseClient

	plCon_Open()

	dim svFirst_Name, svLast_Name, svEmail, svURL
	dim svTitle, svLocation, ivYears_of_Experience, svBiography, svImage, svImage_Small
	dim ivSample

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

		if ivProfile_Key = 0 then
			ivProfile_Key = plNullCheck(rs.Fields.Item("Profile_Key").Value,0)
		end if

	else
		response.write "Error Retrieving Membership"
		response.end
	end if
	rs.close

	if ivProfile_Key > 0 then

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
			ivSample = plIIF(plNullCheck(rs.Fields.Item("Sample").Value,0), 1, 0)

			if svImage <> "" then
				svImage = "/upload_data/" & svImage
			end if

			if svImage_Small <> "" then
				svImage_Small = "/upload_data/" & svImage_Small
			end if

			'NEEDS TO BE RESIZED
			'if ivProfile_Key = 1 then
			'svImage  = "images/Jim150x180.jpg"
			'svImage_Small = "images/Jim42x50.jpg"
			'else
			'svImage = ""
			'svImage_Small = ""
			'end if

		else
			response.write "Error Retrieving Profile"
			response.end
		end if
		rs.close

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
function SubmitProfileForm(ivKey){
	if(Validate_Form_No_Submit()){
		document.thisForm.action = "profile_modify.asp?Membership_Key=<%=ivMembership_Key%>&Profile_Key=<%=ivProfile_Key%>";
		document.thisForm.submit();
	}
}
function Bio(){
<%if ivProfile_Key = 0 then%>
	Notify("Profile has not been created yet.");
	return
<%else%>
	<%if bvPrint then%>
		<%if bvAdmin then%>
		document.location.href = "profile.asp?Membership_Key=<%=ivMembership_Key%>&Profile_Key=<%=ivProfile_Key%>";
		<%else%>
		document.location.href = "profile.asp"
		<%end if%>
	<%else%>
		<%if bvAdmin then%>
		document.location.href = "profile.asp?Print=True&Membership_Key=<%=ivMembership_Key%>&Profile_Key=<%=ivProfile_Key%>";
		<%else%>
		document.location.href = "profile.asp?Print=True"
		<%end if%>
	<%end if%>
<%end if%>
	//if(document.thisForm.hdnProfile_Key.value != "0"){
	//	document.thisForm.action = "profile.asp?Print=True&Membership_Key=<%=ivMembership_Key%>&Profile_Key=<%=ivProfile_Key%>";
	//	document.thisForm.submit();
	//}else{
	//	Notify("Profile has not been created yet.");
	//	return
	//}
}
function Upload(){

	<%if bvAdmin then%>
	document.location.href = "profile_attachments.asp?Print=True&Membership_Key=<%=ivMembership_Key%>&Profile_Key=<%=ivProfile_Key%>";
	<%else%>
	document.location.href = "profile_attachments.asp"
	<%end if%>

	/*
	if(document.thisForm.hdnProfile_Key.value != "0"){
		document.thisForm.action = "profile_attachments.asp";
		document.thisForm.submit();
	}else{
		Notify("Profile has not been created yet.");
		return
	}*/
}
function Resume(){
	Notify("Under Construction");
	return
}
function Refs(){
	Notify("Under Construction");
	return
}
</script>
</head>
<body>
<form name="thisForm" method="POST" onSubmit="return(false)">
<!--<input type="hidden" name="hdnMembership_Key" value="<%=ivMembership_Key%>">
<input type="hidden" name="hdnProfile_Key" value="<%=ivProfile_Key%>">-->
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
						<div id="sidebar">
							<ul id="cust" class="nav">
								<!--<li>
									<a id="one" href="javascript:Resume();">> View/Print Resume</a>
								</li>-->
								<li>
									<a id="two" href="javascript:Bio();">> <%=plIIF(bvPrint, "Edit Biography", "View/Print Biography")%></a>
								</li>
								<!--<li>
									<a id="three" href="javascript:Refs();">> References</a>
								</li>-->
								<li>
									<a id="four" href="javascript:toggle('four','foursub');">> Links</a>
									<ul id="foursub" class="sub">
										<li><a href="mailto:<%=svEmail%>">Contact Me</a></li>
										<%if svURL <> "" then%>
											<li><a href="<%=svURL%>" target="_new">Consultant Web Site</a></li>
										<%end if%>
									</ul>
								</li>
								<li>
								  <a id="six" href="javascript:Upload();">> Attachments</a>
								</li>
								<li>
								  <a id="five" href="javascript:toggle('five','fivesub');">> Member Directory</a>
								  <ul id="fivesub" class="sub">
									<li><a href="member_list.asp">All Members</a></li>
								  </ul>
								</li>
							</ul>
						</div>
						<br>
						<div align="center">
							<%if svImage <> "" then%>
							<img src="<%=svImage%>" border="0">
							<%end if%>
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
							<%if bvPrint then%>
								<tr>
									<td id="content_main">
										<p><%=svBiography%></p>
									</td>
								</tr>
							<%end if%>
							<tr>
								<td id="content_main" style="text-align:left;">

									<table id="profile" cellspacing="0" cellpadding="0">
										<%if not bvPrint and bvAdmin then%>
											<tr>
												<td id="profile_red">Sample:</td>
												<td><%plCheckbox "chkSample", ivSample, 1%></td>
											</tr>
										<%else%>
											<input type="hidden" name="chkSample" value="<%=ivSample%>">
										<%end if%>
										<%if not bvPrint then%>
											<tr>
												<td id="profile_red">Title:</td>
												<td><%plTextbox "txtTitle_RQD", svTitle, 25, 255, ""%></td>
											</tr>
											<tr valign="top">
												<td id="profile_red">Biography:</td>
												<td><%plTextArea "txaBiography_TXA_4000_RQD", svBiography, 50, 8, ""%></td>
											</tr>
										<%end if%>
										<tr>
											<td id="profile_red">Location:</td>
											<td>
											<%if bvPrint then%>
												<%=svLocation%>
											<%else%>
												<%plTextbox "txtLocation_RQD", svLocation, 25, 255, ""%>
											<%end if%>
											</td>
										</tr>
										<tr valign="top">
											<td id="profile_red">Expertise:</td>
											<td>

												<%if not bvPrint then%>
													<table id="profile" cellspacing="0" cellpadding="0" width="100%">
													<tr>
														<th>Expertise</th>
														<th>Yes/No</th>
														<th># of Years</th>
													</tr>
												<%end if%>
<%
'dim svExpertise
'svExpertise = ""

plCmd_Params_Clear cmd, 0
plCmd_Set cmd, plCon, "con451.Profile_Expertise_Get"
plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key

rs.open cmd,,adOpenForwardOnly,adLockReadOnly
if not (rs.eof and rs.bof) then
  do until rs.eof
  	  if bvPrint then

		if plNullCheck(rs.Fields.Item("Profile_Key").Value,0) > 0 then
			'svExpertise = svExpertise & rs.Fields.Item("Expertise").Value & ", "
			response.write rs.Fields.Item("Expertise").Value & "<br>"
		end if

	  else
%>
	  <tr>
		<td><%=rs.Fields.Item("Expertise").Value%></td>
		<td><%plCheckbox "chkExpertise_" & rs.Fields.Item("Expertise_Key").Value, plIIF(plNullCheck(rs.Fields.Item("Profile_Key").Value,0) > 0, 1, 0), "1"%></td>
		<td><%=plsNumbox("txtExpertise_Years_" & rs.Fields.Item("Expertise_Key").Value & "_INT", plNullCheck(rs.Fields.Item("Years_of_Experience").Value,0), 5, 10, "", true)%></td>
	  </tr>
<%
	end if
    rs.movenext
  loop
end if
rs.close

'if bvPrint then
'	svExpertise = trim(svExpertise)
	'response.write left(svExpertise,len(svExpertise)-1)
'end if
%>
												<%if not bvPrint then%>
													</table>
												<%end if%>

											</td>
										</tr>
										<!--<tr>
											<td id="profile_red">Years:</td>
											<td><%=plsNumbox("txtYears_INT", ivYears_of_Experience, 5, 10, "", true)%></td>
										</tr>-->
										<tr valign="top">
											<td id="profile_red">Latest Projects:</td>
											<td>
												<%if not bvPrint then%>
													<table id="profile" cellspacing="0" cellpadding="0" width="100%">
													<tr>
														<!--<th>Client</th>-->
														<th>Project Name</th>
														<th>Show on Profile</th>
													</tr>
												<%end if%>
<%
'dim svProjects
'svProjects = ""

dim ivLoop, ivCount, ivMaxProjects
ivCount = 0
ivMaxProjects = 5

plCmd_Params_Clear cmd, 0
plCmd_Set cmd, plCon, "con451.Profile_Project_Get"
plCmd_Param_Add cmd, "Profile_Key INT", ivProfile_Key

rs.open cmd,,adOpenForwardOnly,adLockReadOnly
if not (rs.eof and rs.bof) then
	do until rs.eof
		if bvPrint then
			if plNullCheck(rs.Fields.Item("Show_on_Profile").Value,0) and plNullCheck(rs.Fields.Item("Project").Value,"") <> "" then
				'svProjects = svProjects & plNullCheck(rs.Fields.Item("Project").Value,"") & ", " 'plIIF(ivRecord_Count <> rs.RecordCount, ", ", "")
				response.write plNullCheck(rs.Fields.Item("Project").Value,"") & "<BR>"
			end if
		else
			Project_Row	rs.Fields.Item("Profile_Project_Key").Value, plNullCheck(rs.Fields.Item("Client").Value,""), plNullCheck(rs.Fields.Item("Project").Value,""), plIIF(plNullCheck(rs.Fields.Item("Show_on_Profile").Value,0), 1, 0)
			ivCount = ivCount + 1
		end if
		rs.movenext
	loop

	if not bvPrint and ivCount < ivMaxProjects then
		for ivLoop = ivCount to ivMaxProjects - 1
			Project_Row ivLoop, "", "", 1
		next
	end if
else

	if not bvPrint then
		for ivLoop = 1 to ivMaxProjects
			Project_Row ivLoop, "", "", 1
		next
	end if

end if
rs.close

'if bvPrint then
'	svProjects = trim(svProjects)
'	response.write left(svProjects,len(svProjects)-1)
'end if
%>
												<%if not bvPrint then%>
													</table>
												<%end if%>

											</td>
										</tr>
										<%if not bvPrint then%>
											<tr>
												<td id="profile_red"></td>
												<td><input type="image" src="images/button.jpg" onclick="javascript:SubmitProfileForm();"></td>
											</tr>
										<%end if%>

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

sub Project_Row(ivKey, svClient, svProject, ivShow)
%>
	<tr>
		<!--<td><%plTextbox "txtClient_" & ivKey, svClient, 20, 255, ""%></td>-->
		<td><%plTextbox "txtProject_" & ivKey, svProject, 50, 500, ""%></td>
		<td><%plCheckbox "chkShow_" & ivKey, ivShow, "1"%></td>
	</tr>
<%
end sub
%>
