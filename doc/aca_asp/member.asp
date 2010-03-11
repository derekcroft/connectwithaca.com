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
		document.thisForm.submit();
	}
}
</script>
</head>
<body>
<form name="thisForm" method="POST" action="login.asp">
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
								<td id="content_top">What can the ACA do for you today?</td>
							</tr>
							<tr>
								<td id="content_main" style="background-image:url(images/mc_image.jpg);background-repeat:no-repeat;background-position:right bottom;">
									<h1>Welcome to the ACA</h1>
									<p>Finally!  Our “loose network of consultants” have now been brought together to produce a powerful resource for connecting.</p>
									<p>
										<ul class="pg">The ACA has been created so we can:
											<li><b>></b> Connect consultants with consultants Connect marketing companies with consultants, and Connect opportunities to consultants. As we grow in numbers, so will the Association’s ability to add additional features and resources that only you as members will have access to.</li>
										</ul>
									</p>
									<p>
										<ul class="pg" style="width:385px;height:190px;">Resources such as:
											<li><b>></b> Professional website presence to market yourself.</li>
											<li><b>></b> Unrivaled networking -- Its always been tough to keep up with each other.  With ACA you can keep in close contact with those in the know.</li>
											<li><b>></b> Dedicated resources focused on helping to connect you with that next industry project suited to your skill set.</li>
											<li><b>></b> Dealer Direct opportunities will allow you to both access and share products and services that will help make you successful.</li>
											<li><b>></b> An unrivaled, searchable online training content library.</li>
										</ul>
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
</form>
</center>
</body>
</html>

