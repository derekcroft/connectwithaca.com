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
function SubmitForm() {
	if(Validate_Form_No_Submit()){
		alert("Thank you! You will be contacted within 1 business day or less.");
		document.thisForm.submit();
	}
}
function Set_Begin() {
	document.thisForm.txtProgram_Begin_Date_DTE.value = document.thisForm.txtStart_Date_DTE.value;
}
</script>
</head>
<body>
<center>
<form name="thisForm" method="POST" action="recruiting_modify.asp" onSubmit="return false;">
<table id="container" cellspacing="0" cellpadding="0">
	<tr>
		<td id="top"></td>
	</tr>
	<tr>
		<td id="header">
			<%header 4%>
		</td>
	</tr>
	<tr>
		<td id="content">
			<div id="member_img"><div id="pg_title">Program Profile Form</div></div>
			<table id="pg_container" cellspacing="0" cellpadding="0">
				<tr>
					<td id="menu_area">
						<!-- SIDE MENU //-->
						<div id="sidebar">
							<ul id="cust" class="nav">

								<li>
									<a id="three" href="mailto:join@connectwithaca.com">> Contact ACA</a>
								</li>
							</ul>
						</div>
					</td>
					<td valign="top">
						<!-- CONTENT AREA //-->
						<table id="content_table" cellspacing="0" cellpadding="0">
							<tr>
								<td id="content_main" style="background-image:url();background-repeat:no-repeat;background-position:right bottom;">

									<table>
										<tr>
											<td colspan="2" style="vertical-align:top;padding:0px 10px 10px 0px;">
											<p>
												<ul class="pg">
													<li>Complete the brief form below and you will be contacted within 1 business day or less by one of our ACA Memberhsip professionals.</li>
												</ul>
											</p>
											</td>
										</tr>
										<tr valign="top">
											<td style="width:50%;" align="right">Your Name&nbsp;</td>
											<td align="left"><%plTextbox "txtName_RQD", "", 25, 50, ""%></td>
										</tr>
										<tr valign="top">
											<td style="width:50%;" align="right">Phone&nbsp;</td>
											<td align="left"><%plTextbox "txtPhone_RQD", "", 25, 25, ""%></td>
										</tr>
										<tr valign="top">
											<td style="width:50%;" align="right">Email&nbsp;</td>
											<td align="left"><%plTextbox "txtEmail_EML", "", 25, 128, ""%></td>
										</tr>
										<tr valign="top">
											<td style="width:50%;" align="right">Number of Consultants Required&nbsp;</td>
											<td align="left"><%plTextbox "txtConsultants", "", 10, 50, ""%></td>
										</tr>
										<tr valign="top">
											<td style="width:50%;" align="right">Geographic Considerations&nbsp;</td>
											<td align="left"><%plTextbox "txtGeography", "", 25, 500, ""%></td>
										</tr>
										<tr valign="top">
											<td style="width:50%;" align="right">When do you need them to start?&nbsp;</td>
											<td align="left"><%=plsDate("thisForm", "txtStart_Date_DTE", 4, "", "Set_Begin()", true)%></td>
										</tr>
										<tr valign="top">
											<td style="width:50%;" align="right">What is the length of the program?&nbsp;</td>
											<td align="left">
												<%=plsDate("thisForm", "txtProgram_Begin_Date_DTE", 4, "", "", true)%>
												&nbsp;to&nbsp;
												<%=plsDate("thisForm", "txtProgram_End_Date_DTE", 4, "", "", true)%>
											</td>
										</tr>
										<tr valign="top">
											<td style="width:50%;" align="right">Skills Required&nbsp;</td>
											<td align="left">
<%
dim cmd, rs
set cmd = Server.CreateObject("ADODB.Command")
set rs = Server.CreateObject("ADODB.Recordset")

rs.CursorLocation = adUseClient

plCon_Open()

plCmd_Params_Clear cmd, 0
plCmd_Set cmd, plCon, "con451.Expertises_Get"

rs.open cmd,,adOpenForwardOnly,adLockReadOnly
if not (rs.eof and rs.bof) then
  do until rs.eof
	plCheckbox "chkExpertise_" & rs.Fields.Item("Expertise_Key").Value, 0, 1
	response.write "&nbsp;" & rs("Expertise").Value & "<BR>" & vbcrlf
    rs.movenext
  loop
end if
rs.close

plCon_Close
set rs = nothing
set cmd = nothing
%>

											</td>
										</tr>
										<tr>
											<td colspan="2">
												<div style="float:right;"><a href="javascript:SubmitForm();"><img src="images/button.jpg" border="0" alt="Submit" title="Submit" /></a></div>
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
</form>
</center>
</body>
</html>

