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
			<%header 3%>
		</td>
	</tr>
	<tr>
		<td id="content">
			<div id="member_img"><div id="pg_title">Dealer Direct</div></div>
			<table id="pg_container" cellspacing="0" cellpadding="0">
				<tr>
					<td id="menu_area">
						<!-- SIDE MENU //-->
						<div id="sidebar">
							<ul id="cust" class="nav">
								<li>
									<a id="one" href="javascript:toggle('one','onesub');">> Search Opportunities</a>
									<ul id="onesub" class="sub">
										<li><a href="#">All</a></li>
										<li><a href="#">Products Only</a></li>
										<li><a href="#">Services Only</a></li>
									</ul>
								</li>
								<!--<li>
									<a id="two" href="javascript:toggle('two','twosub');">> Submit A New Opportunity</a>
								</li>-->
								<li>
									<a id="three" href="javascript:toggle('three','threesub');">> Recent Additions</a>
									<ul id="threesub" class="sub">
										<!--<li><a href="#">Teletracker</a></li>
										<li><a href="#">StreaMail</a></li>-->
									</ul>
								</li>
								<li>
									<a id="four" href="javascript:toggle('four','foursub');">> Submit Opportunity</a>
									<ul id="foursub" class="sub">
									</ul>
								</li>
								<li>
									<a id="five" href="javascript:toggle('five','fivesub');">> Content Library</a>
									<ul id="fivesub" class="sub">
									</ul>
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
								<td id="content_main" style="background-image:url(images/dealer_img.jpg);background-repeat:no-repeat;background-position:right bottom;">
									<h1>Your resource for unlimited possibilities</h1>
									<p style="width:100%;">Whether your looking for some additional opportunities or looking to tell others about your own product or service, Dealer Direct on the ACA website is the way to go!  Where else can you have access to multiple types of products that you can market immediately in just a few clicks.</p>
									<p style="width:290px;">In just a few clicks you can search for a new opportunity, review all of the related materials, review and sign the associated NDA and reseller’s agreement, and gain access to all of the sales support material required to begin selling and supporting dealership direct opportunities.</p>
									<p style="width:290px;">Dealer Direct was actually the concept described to us by multiple consultants that have developed and delivered successful content of their own and were looking for an efficient way to distribute it.  The ACA is all too happy to oblige!</p>
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

