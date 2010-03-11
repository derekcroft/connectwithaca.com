<%@Language="VBSCRIPT"%>
<%Option Explicit%>
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
		document.thisForm.action = "member_find.asp";
		document.thisForm.submit();
	}
}
function Init(){
	document.thisForm.ACA_ID_RQD.select();
	document.thisForm.ACA_ID_RQD.focus();
}
</script>
</head>
<body onLoad="Init();">
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
						  <div style="margin:5px 0px 0px 20px;padding:0px 0px 0px 0px;">&nbsp;</div>
						</div>
					</td>
					<td valign="top">
						<!-- CONTENT AREA //-->
						<table id="content_table" cellspacing="0" cellpadding="0">
							<tr>
								<td id="profile_top" style="background-image:url();background-repeat:no-repeat;height=50px;">
									<div id="profile_top_text">
										Member Find > <span style="font-size:0.6em;"> Search by ACA Member Name</span>
									</div>
								</td>
							</tr>
								<tr>
									<td id="content_main">
										<p>

										<table style="margin:0px 0px 10px 20px;padding:0px 0px 0px 0px;" cellspacing="0" cellpadding="0" border="0">
										  <tr>
											<td><input style="margin: 0px 0px 0px 0px;width:130px;" type="text" name="ACA_ID_RQD"></td>
											<td id="member_btn"><a href="javascript:SubmitForm()"><img src="images/button.jpg" alt="Login" title="Find" border="0" /></a></td>
										  </tr>
										</table>


<%
if plNullCheck(Request.Form("ACA_ID_RQD"),"") <> "" then

	dim cmd, rs
	set cmd = Server.CreateObject("ADODB.Command")
	set rs = Server.CreateObject("ADODB.Recordset")

	rs.CursorLocation = adUseClient

	plCon_Open()

	plCmd_Params_Clear cmd, 0
	plCmd_Set cmd, plCon, "con451.Members_Find_Get"
	plCmd_Param_Add cmd, "Search VARCHAR(50)", plNullCheck(Request.Form("ACA_ID_RQD"),"")

	rs.open cmd,,adOpenForwardOnly,adLockReadOnly
	if not (rs.eof and rs.bof) then
	%>
		<table border="0" width="300" align="left">
	<%
		do until rs.eof
			%>
			<tr>
				<td><a href="member_find_profile.asp?ACA_ID_RQD=<%=rs.Fields.Item("ACA_ID").Value%>"><%=rs.Fields.Item("First_Name").Value%>&nbsp;<%=rs.Fields.Item("Last_Name").Value%></a></td>
			</tr>
			<%
			rs.movenext
		loop
		%>
		</table>
		<%
	else
		%>
		<div style="margin:10px 0px 0px 20px;padding:0px 0px 0px 0px;" style="color: #c60a27;">Your search did not match any members</div>
		<%
	end if
	rs.close

	plCon_Close
	set rs = nothing
	set cmd = nothing

end if
%>

										<%if request.querystring("error") = "1" then%>
										<div style="margin:10px 0px 0px 20px;padding:0px 0px 0px 0px;" style="color: #c60a27;">Member Not Found</div>
										<%end if%>

										</p>
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
