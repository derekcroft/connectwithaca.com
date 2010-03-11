<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/header.asp" -->
<!-- #include file="include/library.asp" -->
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
</script>
</head>
<body>
<center>
<form name="thisForm" method="POST" action="application_email.asp" onSubmit="return false;">
<table id="container" cellspacing="0" cellpadding="0">
	<tr>
		<td id="top"></td>
	</tr>
	<tr>
		<td id="header">
			<%header 5%>
		</td>
	</tr>
	<tr>
		<td id="content">
			<div id="member_img"><div id="pg_title">Membership Form</div></div>
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
												<ul class="pg"><!--I'm interested in the ACA as a <input type="checkbox" name="Membership_Type" value="Basic"> -OR- <input type="checkbox" name="Membership_Type" value="Founding"> Founding Member-->
													<li>Complete the brief form below and you will be contacted within 1 business day or less by one of our ACA Memberhsip professionals.</li>
												</ul>
												<ul class="pg">
													<li>Tell us about yourself;</li>
												</ul>
											</p>
											</td>
										</tr>
										<tr valign="top">
											<td style="width:50%;vertical-align:top;padding:0px 10px 10px 0px;">
											<p>
												<ul class="pg">Your Name
													<li><input type="text" name="Contact_Name_RQD" value="" size="25"></li>
												</ul>
											</p>
											<p>
												<ul class="pg">Your Contact Information
													<li>Email - <input type="text" name="Contact_Email_EML" value="" size="25"></li>
													<li>Phone - <input type="text" name="Contact_Phone" value="" size="25"></li>
												</ul>
											</p>
											</td>
											<td>
											<p>
												<ul class="pg">Referring ACA Member
													<li><input type="text" name="Referring_Member" value="" size="25"></li>
												</ul>
											</p>
											<p>
												<ul class="pg">Best time to contact you?
													<li><input type="text" name="Contact_Time" value="" size="25"></li>
												</ul>
											</p>
											<div style="float:right;"><a href="javascript:SubmitForm();"><img src="images/join_btn.jpg" border="0" alt="Join" title="Join" /></a></div>
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

