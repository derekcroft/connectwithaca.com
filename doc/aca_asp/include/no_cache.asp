<%
Response.CacheControl = "Private"
Response.AddHeader "pragma", "no-cache"

Response.Expires = -1								  ' Force immediate expiration of this dynamically generated page.
Response.ExpiresAbsolute = Now() - 1	' This is a better forced expiration because it handles time differences between Server and Client
%>