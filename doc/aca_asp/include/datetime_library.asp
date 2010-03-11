<%

function plDateTime(ByVal vDateTime, vType )
  'database to client
  
  'This function converts SQL representation of a datetime to Plexus' standard
  'For instance: "6/17/2000 2:34:00 PM" converts to "6/17/00 2:34 PM"
  
  ' Valid vType values are "long" for including time, "longer" for including time with seconds, anything
  ' else for only returning the date.  Add a 4 to the vType to return the year in 4-digit format if available.
  '    Example: "short4" returns only the date, with a 4-digit year.
  
  if isdate( vDateTime ) then
  
    ' First see if the incoming date is in d(d)-Mon-yy(yy) format. If so, just use it as-is.
    ' Dredd now supports that format. Added 18-Jun-2001 by TGIL
    dim vDateExp
    set vDateExp = new RegExp
    vDateExp.IgnoreCase = true
    vDateExp.Pattern = "^\d{1,2}[-][a-zA-Z]{3}[-](\d{2}|\d{4})$"
    if vDateExp.Test(vDateTime) then
      plDateTime = vDateTime
      exit function
    end if

    vType = lcase(vType)  ' do it once for easier comparisons
    
    ' 2/14/2002 TGIL: If vType contains the "filter", then it is used in a filter
    ' so do not apply the timezone offset. This was causing the
    ' date to default to the previous day for negative timezone offsets adjusted from date().
  

  
    if instr(1,vType,"filter") > 0 then
      ' no offset. remove it from the string now.
      vType = replace(vType,"filter","")
    else
      'Convert Date for timezone
      '----- DST Code -----
      vDateTime = plAdjustDate(vDateTime, true)
      '--------------------

    end if
      
    'Added by TSCH 11-2-00
    dim vDateArray,vDateTimeArray, vDate, vTimeArray
  
    vDateTimeArray = split(vDateTime," ")
    'vDateTimeArray(0) is Date
    'vDateTimeArray(1) is Time
    'vDateTimeArray(2) is AM or PM
  
    'represent possible YYYY as YY
    vDateArray = split(vDateTimeArray(0),"/")

    'This should return something like "10","12","00" from 10/12/00
    'If it does not, we have a serious garbage datum and should leave (TSCH, 10/19/00)
    if UBound(vDateArray) <> 2 Then
      plDateTime = "<font color=red>Bad Date Data! '" & vDateTime & "' not in format mm/dd/yy [hh:mm AM]</font>"
      Exit Function
    end if

    if instr(1,vType,"4") = 0 then 
      ' convert the year to 2-digit format if 4 isn't specified in vType
      if len(vDateArray(2)) = 4 then vDateArray(2) = right(vDateArray(2),2)
    end if
    
    vType = replace(vType,"4","") ' remove the 4 if it exists, before comparing below

    if UBound(vDateTimeArray) > 0 then vTimeArray = split(vDateTimeArray(1),":",2)

    select case vplDateFormat
    
      case "usa"
        'We know we have at least this much of a date.
        vDate = vDateArray(0) & "/" & vDateArray(1) & "/" & vDateArray(2)
            
      case "euro"      
        'We know we have at least this much of a date.
        vDate = vDateArray(1) & "/" & vDateArray(0) & "/" & vDateArray(2)
              
      case "dd-mon-yy"
        dim aMonthNames
        aMonthNames = split(",Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec",",")
        
        'We know we have at least this much of a date.
        vDate = vDateArray(1) & "-" & aMonthNames(vDateArray(0)) & "-" & vDateArray(2)
    
      case "Www/yy"
        Dim varDate, vWeekOfYear, vYear
        varDate = vDateArray(0) & "/" & vDateArray(1) & "/" & vDateArray(2)
        vYear = vDateArray(2)
        vWeekOfYear = plWeekOfYear(varDate,vbMonday)
        if vWeekOfYear = 0 then
          vYear = plMakeFourDigitYear(cint(vYear)) - 1
          vWeekOfYear = plWeekOfYear("12/31/" & vYear,vbMonday)
          if len(vDateArray(2)) = 2 then
            ' Convert back to two-digit year
            vYear = mid(cstr(vYear),3)
          end if
        end if
        
        vDate = "W" & mathAddLeadingZeros(vWeekOfYear,2) & "/" & plNullCheck(vYear,"&nbsp;") 
    end select

    'added vSeconds 6/17/03 jfos
    dim vSeconds
    if vType = "longer" then
      vType = "long"
      vSeconds = true
    else
      vSeconds = false
    end if
    
    ' Add the time if requested
    if vType = "long" then
       if UBound(vDateTimeArray) = 1 Then
         vDate = vDate & " " & vDateTimeArray(0)
       elseif UBound(vDateTimeArray) = 2 Then
         ' Only do this part if the time still includes AM or PM
         vDate = vDate & " " & plFormatTime_No_Offset(vDateTimeArray(1) & " " & vDateTimeArray(2),vSeconds)
      end if
      
      ' 1/4/2006 TGIL: If the time was midnight, then CDate and DateAdd remove the time altogether, but we still want it for the return value.
      ' 1/5/2006 MSCH: Moved from plAdjustDate
      if instr(1,vDate,":") = 0 then
        vDate = vDate & " " & plFormatTime_No_Offset("12:00 AM",vSeconds)
      end if
    end if

    plDateTime = vDate

  else
  
    plDateTime = ""
    
  end if
  
end function

%>