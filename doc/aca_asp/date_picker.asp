<%@Language="VBSCRIPT"%>
<%Option Explicit%>
<!-- #include file="include/header.asp" -->
<!-- #include file="include/library.asp" -->
<html>
<head>
<title>Calendar</title>
<link rel="stylesheet" href="css/aca_global.css" type="text/css">
<script type="text/javascript" src="js/aca_main.js"></script>
<script type="text/javascript" src="js/plexus.js"></script>
<script type="text/javascript" src="js/pickers.js"></script>
<script type="text/javascript" src="js/dredd.js"></script>

<%
dim day,month,year,prevmonth,nextmonth,prevyear,nextyear,today,vFormat
dim existday,existmonth,existyear,temp

if Request.Form("month") <> "" then
  month=Request.Form("month")
  year=Request.Form("year")
else
  month=Request.querystring("month")
  year=Request.querystring("year")
end if
existday = Request.QueryString("day")
existmonth = Request.QueryString("month")
existyear = Request.QueryString("year")

if month="" or month = -1 then
  temp = Date()
  today = Split(temp,"/")
  month = today(0) - 1
  year = today(2)
  if year < 100 then
    if year < 50 then
      year = year + 2000
    else
      year = year + 1900
    End if
  end if
end if

prevmonth=month-1
nextmonth=month+1
prevyear=year
nextyear=year

if prevmonth<0 then
  prevmonth=11
  prevyear=prevyear-1
end if

if nextmonth>11 then
  nextmonth=0
  nextyear=nextyear+1
end if
%>

<script language="Javascript">
if (window.opener.vDateFormat)
  vDateFormat = window.opener.vDateFormat
var weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
var monthname = [,"January","February","March","April","May","June","July","August","September","October","November","December"]
var numdays = [,31,28,31,30,31,30,31,31,30,31,30,31]
var existday = "<% =existday %>"
var existmonth = "<% =existmonth+1 %>"
var existyear = "<% =existyear %>"
var month = <% =month+1 %>
var year = <% =year %>
document.title="Calendar for " + monthname[month] + ", " + year

today = new Date()
calendar = new Date(month + "/1/" + year)
firstday=calendar.getDay()

if (IsLeapYear(year))
  numdays[2]++  //Is a leap year! Add one to February's day count

monthdays=numdays[month]

function DayClick(Day) {
  if (<%=Request("Digits")%> == 2)
    year = MakeTwoDigitYear(year)

  switch (vDateFormat) {
    case "usa":
      PickedDate = (month) + "/" + Day + "/" + year
      break
    case "euro": //European format
      PickedDate = Day + "/" + (month) + "/" + year
      break
    case "dd-mon-yy":
      PickedDate = Day + "-" + monthname[month].substr(0,3) + "-" + year
      break
    case "Www/yy":
      var vWeekOfYear = WeekOfYear(month + "/" + Day + "/" + year,1)
      if (vWeekOfYear == 0) {
        year = MakeFourDigitYear(year) - 1
        if (<%=Request("Digits")%> == 2)
          year = MakeTwoDigitYear(year)
        vWeekOfYear = WeekOfYear("12/31/" + year,1)
      }
      PickedDate = "W" + vWeekOfYear + "/" + year
      break
  }

  //alert(PickedDate)
  if (window.opener.<%=Request("Form")%>.<%=Request("Field")%>.type != "hidden" &&
      window.opener.<%=Request("Form")%>.<%=Request("Field")%>.disabled == false) {
    window.opener.<%=Request("Form")%>.<%=Request("Field")%>.focus()
  }
  window.opener.<%=Request("Form")%>.<%=Request("Field")%>.value = PickedDate
  //This checks for an onchange event, if it finds one it runs it.
  if (window.opener.<%=Request("Form")%>.<%=Request("Field")%>.onchange != null){
    window.opener.<%=Request("Form")%>.<%=Request("Field")%>.onchange()
  }
  window.close()
}

function MakeTwoDigitYear(vYear) {
  vYear = vYear + ""    // converts to string
  vYear = vYear.substr(2,2)
  return vYear
}
</script>

</head>
<body marginheight=0 marginwidth=0 topmargin=0 leftmargin=0>

<table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0" bgcolor="Gray" bordercolor="Teal" cols="7" class=TinyText>
  <tr>
    <td height="40" colspan="7" bgcolor="#B9E9FF" align="center">
      <table cellpadding=0 cellspacing="0" border="0" width="100%">
        <tr>
          <td>
            <form name="previous" method="post">
            <input type="hidden" name="month" value="<% =prevmonth %>">
            <input type="hidden" name="year" value="<% =prevyear %>">
            <input type="image" src="images/arrow_left.gif" width="23" height="23" border="0" align="left">
            </form>
          </td>
          <td align="center" valign=middle>
            <form name="date" method="post">
              <IMG SRC="images/spacer14.gif" height=5><BR>
              <select name="month" onChange="submit()">
              <option value="0"><%=plGlossary("January", "", "")%>
              <option value="1"><%=plGlossary("February", "", "")%>
              <option value="2"><%=plGlossary("March", "", "")%>
              <option value="3"><%=plGlossary("April", "", "")%>
              <option value="4"><%=plGlossary("May", "", "")%>
              <option value="5"><%=plGlossary("June", "", "")%>
              <option value="6"><%=plGlossary("July", "", "")%>
              <option value="7"><%=plGlossary("August", "", "")%>
              <option value="8"><%=plGlossary("September", "", "")%>
              <option value="9"><%=plGlossary("October", "", "")%>
              <option value="10"><%=plGlossary("November", "", "")%>
              <option value="11"><%=plGlossary("December", "", "")%>
              </select>

              <select name="year" onChange="submit()">
                <script language="javascript">
                  for (i = year-100; i < year + 101; i++) {
                    document.write("<option value=" + i + ">" + i)
                  }
                  document.date.month.value = month-1
                  document.date.year.value = year
                </script>
              </select>

            </form>
          </td>
          <td align="right">
            <form name="next" method="post">
            <input type="hidden" name="month" value="<% =nextmonth %>">
            <input type="hidden" name="year" value="<% =nextyear %>">
            <input type="image" src="images/arrow_right.gif" width="23" height="23" border="0" align="right">
            </form>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <TR bgcolor="#eeeeee" height="10">
    <TD align="center" width="15%"><%=plGlossary("Sun", "", "")%></TD>
    <TD align="center" width="14%"><%=plGlossary("Mon", "", "")%></TD>
    <TD align="center" width="14%"><%=plGlossary("Tue", "", "")%></TD>
    <TD align="center" width="14%"><%=plGlossary("Wed", "", "")%></TD>
    <TD align="center" width="14%"><%=plGlossary("Thu", "", "")%></TD>
    <TD align="center" width="14%"><%=plGlossary("Fri", "", "")%></TD>
    <TD align="center" width="15%"><%=plGlossary("Sat", "", "")%></TD>
  </TR>
  <tr>
    <script language="Javascript">

    var svHoverColor = '';

    if (firstday > 0) {
      document.write("<td bgcolor=Gray colspan=" + firstday + ">&nbsp;</TD>")
    }
    d = firstday
    weeks = 1
    for (i=1; i < monthdays+1; i++) {
      if ( (today.getMonth() == month-1) && (today.getDate() == i) && (today.getYear() == year) ) {
        vColor = "#FFFF99";
        svHoverColor = "#FFFF00";
      } else {
        if ( (existmonth == month) && (existday == i) && (existyear == year) ) {
          vColor = "#CCFFCC";
          svHoverColor = "#99FF99";
        } else {
          vColor = "#FFFFFF";
          svHoverColor = "#EEEEEE";
        }
      }
      document.write('<td bgcolor="' + vColor + '" onmouseover="this.bgColor=\'' + svHoverColor + '\'" onmouseout="this.bgColor=\'' + vColor + '\'" valign="top" align="right" onclick="DayClick(' + i + ')"><span class="FakeLink">' + i + '</span></td>');
      d++
      if ( (d == 7) && (i < monthdays) ) {
        d = 0
        weeks++
        document.write("</TR><TR>")
      }
    }
    if (d < 7) {
      document.write("<TD colspan=" + (7-d) + " bgcolor=gray>&nbsp;</TD>")
    }
    </script>
  </tr>
</table>
</body>
</html>
