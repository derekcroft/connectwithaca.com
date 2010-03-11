<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<%

Session("Membership_Key") = ""
Session("First_Name") = ""
Session("Last_Name") = ""
Session("Admin") = ""
Session("Profile_Key") = ""

response.redirect "member.asp"

%>