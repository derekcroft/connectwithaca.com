<%@ Language=VBScript %>
<!-- #include file="include/No_Cache.asp" -->
<HTML>
<HEAD>
<title>Notification</title>

<script language=Javascript>
var vMessage = window.dialogArguments
function KeyPress() {
  if (window.event.keyCode == 27 || window.event.keyCode == 13)
    window.close()
}
</script>

</HEAD>

<form name=thisForm onsubmit="return false">

<BODY leftMargin='0' topMargin='0' onKeyPress="Javascript:KeyPress()">

<table border=0 cellpadding=8 cellspacing=0 height=100%>
  <tr valign=top height=50%>
    <td align=center width=10%>
      <img src="images/icons/warning.gif" align=absmiddle></td>
    <td class=GridText width=90%>
      <B>
      <script language=Javascript>
      document.write(vMessage)
      </script>
    </td>
  </tr>
  <tr valign=bottom>
    <td align=center colspan=2>
      <table border=0 cellpadding=0 cellspacing=20>
        <tr>
          <td width=60 height=20 background='images/buttons/Blue_whitematte.gif'
            onclick="Javascript:window.close()" style='font-family: Arial; font-weight: bold; font-size: 9pt; color:#EEEEEE; text-align: center; cursor:hand'>Ok</td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</BODY>
</form>

</HTML>
