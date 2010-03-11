              <ul id="cust" class="nav">
                <li>
                  <%if request.querystring("login") = "invalid" then%>
                    <div style="margin:10px 0px 0px 20px;padding:0px 0px 0px 0px;" style="color: #c60a27;">Invalid Login!</div>
                  <%end if%>
                  <%if Session("Membership_Key") <> "" then%>
                    <a id="four" href="javascript:toggle('four','foursub');">> Logged in as... <%=Session("First_Name")%>&nbsp;<%=Session("Last_Name")%></a>
                    <ul id="foursub" class="sub">
                      <li><a href="change_password.asp">Change Password</a></li>
                      <li><a href="logout.asp">Logout</a></li>
                    </ul>
                  <%else%>
                  <div style="margin:10px 0px 0px 20px;padding:0px 0px 0px 0px;">Email Address<br /><input style="margin: 0px 0px 0px 0px;width:153px;" type="text" name="Email_Address_EML_RQD" value="<%=plNullCheck(Request.Cookies("ACA_EMail"),"")%>"></div>
                  <div style="margin:5px 0px 0px 20px;padding:0px 0px 0px 0px;">Password</div>
                    <table  style="margin:0px 0px 10px 20px;padding:0px 0px 0px 0px;" cellspacing="0" cellpadding="0" border="0">
                      <tr>
                        <td><input style="margin: 0px 0px 0px 0px;width:130px;" type="password" name="Password_RQD"></td>
                        <td id="member_btn"><a href="javascript:SubmitForm()"><img src="images/button.jpg" alt="Login" title="Login" border="0" /></a></td>
                      </tr>
                      <tr>
                      	<td colspan="2"><%plCheckbox "chkRemember", 0, 1%>Remember my email address</td>
                      </tr>
                    </table>
                  <script>
                  <%if plNullCheck(Request.Cookies("ACA_EMail"),"") = "" then%>
                  	document.thisForm.Email_Address_EML_RQD.select();
                  	document.thisForm.Email_Address_EML_RQD.focus();
                  <%else%>
                  	document.thisForm.Password_RQD.select();
                  	document.thisForm.Password_RQD.focus();
                  <%end if%>
                  </script>
                  <%end if%>
                </li>
                <%if Session("Membership_Key") <> "" then%>
                <li>
                  <a id="two" href="javascript:toggle('two','twosub');">> Member Profile</a>
                  <ul id="twosub" class="sub">
                    <li><a href="profile.asp">Edit My Profile</a></li>
                    <li><a href="http://www.connectwithaca.com/shopsite_sc/page1.html">Annual Membership (PayPal)</a></li>
                  </ul>
                </li>
                <li>
                  <a id="three" href="javascript:toggle('three','threesub');">> Member Directory</a>
                  <ul id="threesub" class="sub">
                    <li><a href="member_list.asp">All Members</a></li>
                  </ul>
                </li>
                <%end if%>

<%
		dim cmdSample, rsSample, ivSample
		set cmdSample = Server.CreateObject("ADODB.Command")
		set rsSample = Server.CreateObject("ADODB.Recordset")

		ivSample = 1

		plCon_Open()

		plcmd_Set cmdSample, plCon, "con451.Profile_Samples_Get"

		rsSample.open cmdSample,,adOpenForwardOnly,adLockReadOnly
		if not (rsSample.eof and rsSample.bof) then
%>
                <li>
                  <a id="seven" href="javascript:toggle('seven','sevensub');">> Sample Profiles</a>
                  <ul id="sevensub" class="sub">
<%
			do until rsSample.eof
%>
				<li><a href="member_find_profile.asp?ACA_ID_RQD=<%=rsSample.Fields.Item("ACA_ID").Value%>"><%=rsSample.Fields.Item("First_Name").Value%>&nbsp;<%=rsSample.Fields.Item("Last_Name").Value%></a></li>
<%
				ivSample = ivSample + 1
				rsSample.movenext
			loop
%>
                  </ul>
                </li>
<%
		end if
		rsSample.close

		set rsSample = nothing
		set cmdSample = nothing
%>
              </ul>