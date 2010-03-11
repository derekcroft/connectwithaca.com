<%
if Session("Membership_Key") = "" then
	response.redirect "default.asp"
end if

dim bvAdmin
bvAdmin = Session("Admin")

dim ivMember, ivProfile
ivMember = plNullCheck(Session("Membership_Key"),0)
ivProfile = plNullCheck(Session("Profile_Key"),0)

if ivMember = 0 then
	response.redirect "member.asp"
end if

dim ivMembership_Key, ivProfile_Key
ivMembership_Key = plNullCheck(Request.QueryString("Membership_Key"),ivMember)
ivProfile_Key = plNullCheck(Request.QueryString("Profile_Key"),ivProfile)

dim bvUpdate
bvUpdate = (Request.QueryString("Do") = "Update")

%>