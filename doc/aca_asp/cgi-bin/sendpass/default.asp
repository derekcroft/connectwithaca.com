<%@ LANGUAGE="VBSCRIPT" %>
<%
	dim strUserID 
	' Get UserID or DOMAIN\UserID from LOGON_USER or AUTH_USER
	strUserID = Request.ServerVariables("LOGON_USER")
	if strUserID = "" then strUserID = Request.ServerVariables("AUTH_USER")

	' Last chance at trying to get the user's ID... check APPL_PHYSICAL_PATH
	if strUserID = "" then strUserID = LCase(Split(Request.ServerVariables("APPL_PHYSICAL_PATH"),"\")(2))

	dim objLanguage
	dim strServerIP
	dim strLangTag
	
	set objLanguage = Server.CreateObject("LanguageTags.CLanguage")
	objLanguage.UserID = strUserID
	strServerIP = objLanguage.ServerIP

	strLangTag =objLanguage.LangTag("sendpass1")
	set objLanguage = Nothing

	strLangTag=replace(strLangTag,"action=""sendpass""","action=""http://" & strServerIP & "/cgi-bin/sendpass""")
	strLangTag=replace(strLangTag,"action='sendpass'","action='http://" & strServerIP & "/cgi-bin/sendpass'")
	strLangTag=replace(strLangTag,"action=sendpass","action=http://" & strServerIP & "/cgi-bin/sendpass")
	strLangTag=replace(strLangTag,"$httpHost", strDomain)
	strLangTag=replace(strLangTag,"$hidden", "<input type='hidden' name='action' value='Submit Send Request'><input type='hidden' name='view' value='Pass Sent'>")
	response.write strLangTag
%>

