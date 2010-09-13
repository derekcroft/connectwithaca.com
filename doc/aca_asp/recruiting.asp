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
</head>
<body>
<center>
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
			<div id="member_img"><div id="pg_title">Recruiting</div></div>
			<table id="pg_container" cellspacing="0" cellpadding="0">
				<tr>
					<td id="menu_area">
						<!-- SIDE MENU //-->
						<div id="sidebar">
							<ul id="cust" class="nav">
								<li>
									<a id="two" href="javascript:toggle('two','twosub');">> Complete Program Profile</a>
									<ul id="twosub" class="sub">
										<li><a href="recruiting_form.asp">Program Profile Form</a></li>
									</ul>
								</li>
								<li>
									<a id="three" href="#">> Referral Requests</a>
								</li>
								<li>
									<a id="four" href="#">> My Program Profiles</a>
								</li>
							</ul>
						</div>
					</td>
					<td valign="top">
						<!-- CONTENT AREA //-->
						<table id="content_table" cellspacing="0" cellpadding="0">
							<!--
							<tr>
								<td id="content_top">&nbsp;</td>
							</tr>
							//-->
							<tr>
								<td id="content_main" style="background-image:url(images/recruiting.jpg);background-repeat:no-repeat;background-position:right bottom;">
									<h1>Access the best consultants in the industry here</h1>
									<p style="width:350px;">So your looking for the best resources available to make your program a success.  Look no further.  In-dealership consultants, facilitators, stand-up presenters, Ride & Drive specialists, instructional designers�the ACA represents all the best.</p>
									<p style="width:350px;">By completing the Program Profile, located on the upper left navigation bar, you will alert an ACA Recruiting Specialist that will be personally assigned to finding you the right personnel to meet the specific needs of your program with our database of members.</p>
									<p style="width:350px;">Within 48 hours you will have your own access to all of your Program Profiles available to you through the ACA.  No running expensive �help wanted� ads, scouring through tons of irrelevant resumes or thumbing through an outdated rolodex.  Choose the best candidates from their profiles, click 'Contact Me' and receive a response back immediately.</p>
									<p style="width:320px;">You�ll never recruit automotive consultants the same way again!</p>
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
</body>
</html>
