<%
sub header(ivDiv)
%>
		<div id="logo">&nbsp;</div>
        <div id="globalnav">
          <ul style="border:none;" class="gnav">
            <li class="tablit"><a href="default.asp" id="one" name="navigation" style="<%=plIIF(ivDiv=1, "color:#c60a27;", "")%>">Home</a></li>
          </ul>
          <ul class="gnav">
            <li class="tab"><a href="member.asp" id="two" name="navigation" style="<%=plIIF(ivDiv=2, "color:#c60a27;", "")%>">Member Center</a></li>
          </ul>
          <ul class="gnav">
            <li class="tab"><a href="dealer.asp" id="three" name="navigation" style="<%=plIIF(ivDiv=3, "color:#c60a27;", "")%>">Dealer Direct</a></li>
          </ul>
          <ul class="gnav">
            <li class="tab"><a href="recruiting.asp" id="four" name="navigation" style="<%=plIIF(ivDiv=4, "color:#c60a27;", "")%>">Recruiting</a></li>
          </ul>
          <ul class="gnav">
            <li class="tab"><a href="join.asp" id="five" name="navigation" style="<%=plIIF(ivDiv=5, "color:#c60a27;", "")%>">Join ACA</a></li>
          </ul>
        </div>
<%
end sub

sub footer
%>
	Copyright 2006 Automotive Consultant Association. All rights reserved.
<%
end sub
%>