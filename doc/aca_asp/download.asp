<% @CodePage=65001 %>
<%
' This file must not contain any HTML tags

  'Set Upload = Server.CreateObject("Persits.Upload")
  'Upload.SendBinary "upload_data/" & Request("File"), True, "application/octet-stream", True
%>
<img src="upload_data/<%=Request("File")%>">