<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/library.asp" -->
<%

dim cItem, svBody
for each cItem in request.form
	svBody = svBody & cItem & "=" & request.form(cItem) & "<br>"
next

Send_Mail "join@connectwithaca.com", "join@connectwithaca.com", "New ACA Membership Form", svBody, "", "jhappell@comcast.net"

response.redirect "join.asp"

%>