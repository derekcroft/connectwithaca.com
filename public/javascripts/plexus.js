/////////////////////////////////////////////////////////////////
// Assign global Javascript stuff

vVersion = new String(navigator.appVersion);
vLocation = new String(document.location);
vLocation = vLocation.toLowerCase();

if (vLocation.charAt(vLocation.length-1) == "/") vLocation += "default.asp";

//Find the base address so things will work in any working mode
vSlashTotal = 0;
vTemp = vLocation;

if (Is_Local_Web( vLocation ))
  vLoop = 4;
 else 
  vLoop = 3; //If not in local mode, only find the third slash

//Loop four times so we can find the fourth slash in the address
for (i=0;i<vLoop;i++) {
  vSlash = vTemp.indexOf("/",i);
  vTemp = vTemp.substr(vSlash);
  vSlashTotal += vSlash;
}

vBaseAddress = vLocation.substr(0,vSlashTotal);

// Set the base address of the main server for pages on the email server that link to main server
vBaseAddressPOL = vBaseAddress.replace("aspmail.","www.")
vBaseAddressPOL = vBaseAddressPOL.replace("devmail.","dev.")
vBaseAddressPOL = vBaseAddressPOL.replace("testmail.","www.")

vWidth = screen.availwidth - 10
vHeight = screen.availheight - 50

// This part checks if POL is attempting to be navigated in an illegal window,
// if it is, it immediately kills the session and send the user to the login screen.


/*
if (plIsMobileBrowser() == false) {
  if (
      (vBaseAddress.toLowerCase().substr(0,10) == "http://www" || vBaseAddress.toLowerCase().substr(0,11) == "https://www") &&
      vLocation.indexOf("index.asp") == -1 &&
      vLocation.indexOf("link.asp") == -1 &&
      vLocation.indexOf("password_questions_ask.asp") == -1 &&
      vLocation.indexOf("message/message_popup.asp") == -1 &&
      !((
         ((typeof(self.top.opener) != "undefined" || self.top.name.substr(0,15) == "POLPOLMAINKIOSK") &&
           typeof(window.dialogArguments) == "undefined") || // nonmodal popup or kiosk window
         typeof(window.dialogArguments) != "undefined"       // modal popup
        ) &&
        (
         self.top.name.substr(0,6) == "POLPOL" ||           // named window
         typeof(window.dialogArguments) != "undefined"      // modal
        )
       )  // not a nonmodal or modal popup
     )
   {
    if (vLocation.indexOf("http_error.asp") == -1) {
      alert("You may not use Plexus Online from this window. Click OK to log in again.");
    }
    LogOut(false);
  }
}
*/

var plClickX = 0, plClickY = 0  // the last coords clicked

// Done assigning global Javascript stuff
/////////////////////////////////////////////////////////////////

//START TSCH 6/24/05 Specific browser sniffing. Of course any of these may be defeated by disabling JavaScript, so this is a bunch of browser-specific "screen door latches"
// Generally this section assumes spoofing is occurring and boots out anyone using specific non-IE identifiable without using the User Agent string
//Not, this directs the user to Use_Policy.asp, because it does not have plexus.js (preventing looping) and servers as an official warning, logged by IP to our Web logs, that we do not find hacking attempts appropriate.
//Of course newer versions of some of these browsers may no longer be detected by these methods, but I recommend leaving them in place as safeguars against older versions.

//jsBrowserCheck();

function jsBrowserCheck() {
  try {
    if (window.opera) //If Opera's specific JavaScript object is discovered, boot them out, cf. webreference.com/programming/javascript/sniffing/3/index.html
    {
      alert("Only Internet Explorer is allowed for Plexus Online.");
      document.location = vBaseAddress + "/Use_Policy.asp?B=Opera";    
      return;
    }
  } catch(err) {
    // Ignore errors
  }
  try {
    if (navigator.vendor == 'KDE') //Konqueror is capable of agent-string spoofing. Konqueror allows users to input any userAgent string they want. But it has one honest quirk: it always displays the same vendor property: “KDE”. So, vendor property: “KDE” means Konqueror, or someone spoofing as Konqueror (webreference.com/programming/javascript/sniffing/index.html)
    {
      alert("Only Internet Explorer is allowed for Plexus Online.");
      document.location = vBaseAddress + "/Use_Policy.asp?B=Konqueror";    
      return;
    }
  } catch(err) {
    // Ignore errors
  }
  try {
    if (navigator.__ice_version) //ICEbrowser (www.howtocreate.co.uk/tutorials/jsexamples/sniffer.html)
    {
      alert("Only Internet Explorer is allowed for Plexus Online.");
      return;
      document.location = vBaseAddress + "/Use_Policy.asp?B=Ice";    
    }
  } catch(err) {
    // Ignore errors
  }
  try {
    if (!document.all)  //Konqueror, OmniWeb, Safari, etc. does not support the document.all property. Much POL requires this funcationality and we don't want these browsers, anyway (webreference.com/programming/javascript/sniffing/2.html)
    {
      alert("Only Internet Explorer is allowed for Plexus Online.");
      document.location = vBaseAddress + "/Use_Policy.asp?B=NoDocumentAll";    
      return;
    }
  } catch(err) {
    // Ignore errors
  }
  if (plIsMobileBrowser() == false) {
    try {
      if (navigator.appName != "Microsoft Internet Explorer") // not IE
      {
        alert("Only Internet Explorer is allowed for Plexus Online.");
        document.location = vBaseAddress + "/Use_Policy.asp?B=NotIE";
        return;
      }
    } catch(err) {
      // Ignore errors
    }
  }
    
}

var plivIsMobileBrowser;
function plIsMobileBrowser() {
  if (typeof plivIsMobileBrowser == 'undefined') {
    plivIsMobileBrowser = (/.?(Windows\ CE|PPC|IEMobile|Smartphone|AvantGo|DoCoMo|UP\.Browser|Vodafone|J\-PHONE|PalmOS|PalmSource|NetFront|Xiino|BlackBerry|Nokia|Blazer|ReqwirelessWeb|Ericsson|Samsung)/.test(navigator.userAgent));
  }
  return plivIsMobileBrowser;
}

function Is_Local_Web( svURL ) {
  // 11/2/2005 TGIL: Remove querystring, since a querystring value containing one of the tested values results in a false value when on local.
  // This is likely the cause of many "HM_Browserstring" errors on local.
  if (svURL.indexOf("?") > -1)
    svURL = svURL.substr(0,svURL.indexOf("?"));
  
  return ( 
    ( svURL.indexOf(".com")  == -1 ) && 
    ( svURL.indexOf("aspmail.") == -1 ) &&
    ( svURL.indexOf("www.") == -1 )
  ); //First case includes dev.plexus-online.com
} 

function jsSingleton_Field(vSQL,vField,vDB) {
  // 6/10/2002 TGIL
  // 10/21/2003 TGIL: wrap vSQL with escape
  var svPage = vLocation.substr(vBaseAddress.length)
  if (svPage.indexOf("?") > -1 ) svPage = svPage.slice(0,svPage.indexOf("?"));
  var result = showModalDialog(vBaseAddress + "/Pickers/Singleton_Field.asp?SQL=" + escape(vSQL) + "&DB=" + vDB + "&Field=" + vField + "&Picker_Called_By=" + svPage + "&Session_Key=" + Get_Session_Key(),null,"dialogWidth:0px;dialogHeight:0px;dialogLeft:9999px;dialogTop:9999px;help:no;center:no;")
  return result;
}

function Session_Set(vVariable_Name,vValue,vOnSet) {
  // 1/23/2003 TGIL
  if (typeof(document.thisForm.SV_Variable_Name) == "undefined")
    document.all.thisForm.insertAdjacentHTML("beforeEnd","<input type=hidden name=SV_Variable_Name value=\"" + vVariable_Name + "\">")
  else
    document.thisForm.SV_Variable_Name.value = vVariable_Name
   
  if (typeof(document.thisForm.SV_Variable_Value) == "undefined")
    document.all.thisForm.insertAdjacentHTML("beforeEnd","<textarea style='visibility:hidden;position:absolute' Revision='false' name=SV_Variable_Value>" + vValue + "</textarea>")
  else
    document.thisForm.SV_Variable_Value.value = vValue

  if (typeof(document.thisForm.SV_OnSet) == "undefined")
    document.all.thisForm.insertAdjacentHTML("beforeEnd","<input type=hidden name=SV_OnSet value=\"" + vOnSet + "\">")
  else
    document.thisForm.SV_OnSet.value = vOnSet

  if (typeof(document.all.SV_IFrame) == "undefined")
    document.body.insertAdjacentHTML("afterBegin","<iframe src='" + vBaseAddress + "/Plexus_Control/blank.html' style='position:absolute;visibility:hidden;width:1;height:1;' id=SV_IFrame></iframe>")

  document.all.SV_IFrame.src = vBaseAddress + "/Plexus_Control/Client_Side_Session_Var_Form.asp?Session_Key=" + vSession_Key
}

function Get_Session_Key() {
  if (typeof(vSession_Key) == "undefined") {
    if (window.top.frames[0])
      vSession_Key = Find_Session_Key(window.top.frames[0]) // recurse frames from the top
    else
      return ""
  }
  return vSession_Key
}


function Create_PDF_From_HTML(vID,vHeight) {
  // Created: 6/27/2003 TGIL
  // Called from any page via the popup menu
  
  // 6/8/2004 TGIL: Added vHeight argument (optional)
  if (typeof(vHeight) == "undefined") vHeight = ""
    
  // If the PDF_IFrame IFRAME doesn't exist yet, create it.
  if (typeof(document.all.PDF_IFrame) == "undefined")
//    document.body.insertAdjacentHTML("afterBegin","<iframe src='" + vBaseAddress + "/Plexus_Control/blank.html' style='width:600;height:600;' id=PDF_IFrame></iframe>")
    document.body.insertAdjacentHTML("afterBegin","<iframe src='" + vBaseAddress + "/Plexus_Control/blank.html' style='position:absolute;visibility:hidden;width:1;height:1;' id=PDF_IFrame></iframe>")

  document.all.PDF_IFrame.src = vBaseAddress + "/Plexus_Control/PDF_Download_HTML_Form.asp?ID=" + vID + "&Height=" + vHeight + "&Source=" + document.location.href
}


function plUpload_Progress(vProgress_ID) {
  OpenWinCentered(vBaseAddress + "/Plexus_Control/Upload_Progress.asp?Progress_ID=" + vProgress_ID,"ProgressWin","",400,30)
}

function Find_Session_Key(oFrame) {
  if (typeof(oFrame.vSession_Key) != "undefined")
    return oFrame.vSession_Key
  
  for (var i=0;i<oFrame.frames.length;i++) {   
    var vRet = Find_Session_Key(oFrame.frames[i]) // recurse frames
    if (vRet != "")
      return vRet
  }
  return ""
}

function Ask_Password(vURL, svSession_Key, svUser_ID) {
  var bvValid = Verify_Password(svUser_ID);
  if (typeof(bvValid) != "undefined") {
    if (bvValid == 1)
      Navigate_To(vURL);
    else
      Notify("Sorry, the password was not accepted.");
  }
}

function Verify_Password(svUser_ID) {
  var svURL = vBaseAddress + "/Pickers/Ask_Validate_UserID.asp?Session_Key=" + Get_Session_Key();
  if (typeof svUser_ID != "undefined" && svUser_ID != null) {
    svURL += "&User_ID=" + encodeURIComponent(svUser_ID)
  }
  var ivValid = showModalDialog(svURL, null,"dialogWidth:300px;dialogHeight:160px;scroll:no;help:no;status:no")
  return ivValid;
}

function Help(Help_No,CustNo,vForce) {
  if (typeof(vForce) == "undefined") vForce = false
  var vPath_Filename = location.href.substr(vBaseAddress.length)
  var vQuerystring = vPath_Filename.indexOf("?")
  if (vQuerystring > -1)  // remove the querystring
    vPath_Filename = vPath_Filename.substr(0,vQuerystring)
  if (vPath_Filename == "/")
    vPath_Filename = "/index.asp"
  if (arguments.length == 1)
    CustNo = arguments[0];
  if (!vForce)
    Help_No = ""
  vHelpURL = vBaseAddressPOL + "/help/help.asp?Path_Filename=" + vPath_Filename + "&Help_No=" + Help_No + "&Customer_No=" + CustNo
  vHelpURL += "&Session_Key=" + Get_Session_Key()  
  OpenWin(vHelpURL,"Help","left=50,top=50,screenX=50,screenY=50,height=400,width=725,status,scrollbars,resizable")
}

function LoginHelp(Help_No,CustNo) {
  // Use this function for the Help button on all custom login screens, such as GenuinePlus and Matrix
  vHelpURL = vBaseAddressPOL + "/help/help.asp?Help_No=" + Help_No + "&Customer_No=" + CustNo
  OpenWin(vHelpURL,"Help","left=50,top=50,screenX=50,screenY=50,height=400,width=600,status,scrollbars")
}

function GetDate(vForm,vField,vDigits) {
  var i // make sure we use a local variable for looping
  
  // This first part searches for [] in vField,
  // which would indicate that is it part of an array of fields with the same name.
  var vArrayIndex
  var vTextBoxField
  if (vField.indexOf("[") > -1) {
    vTextBoxField = vField.substr(0,vField.indexOf("["))
    vArrayIndex = vField.substring(vField.indexOf("[")+1,vField.indexOf("]"))
  } else {
    vTextBoxField = vField
    vArrayIndex = -1
  }
  vArrayIndex*=1  // convert it to a numeric variable

  // 9/9/2003 TGIL: Find out which index number the form is, and use it instead of hard-coded form[0]
  Findex = -1;
  for (i=0; i < document.forms.length; i++)  
    if (document.forms[i].name == vForm)      
      Findex = i;      

  if (Findex == -1) {
    Notify(vFormName + " not found!");
    return false;
  }

  // At this point, vArrayIndex will be -1 if this field is not in an array,
  // but will be the value of the array index if it is part of an array.
  var vCurrentIndex = 0   // keeps track of the current index number of the matched field if there is an array of them
  for (i=0;i<document.forms[Findex].length;i++) {
    if (document.forms[Findex].elements[i].name == vTextBoxField) {
      if (vCurrentIndex == vArrayIndex || vArrayIndex == -1) {
        if (IsValid_Date(i) == false)
          vStartDate = null
        else {
          vStartDate = document.forms[Findex].elements[i].value
          break
        }
      } else {
        vCurrentIndex++   // if we found a matching field name, but the index numbers don't match, increase to try again
      }
    }
  }
  
  if (vDigits != 4) { vDigits = 2 }
  vURL = vBaseAddress + "/Date_Picker.asp?Form=" + vForm + "&Field=" + vField + "&Digits=" + vDigits + "&Session_Key=" + Get_Session_Key()
  if (vStartDate) {
    switch (vDateFormat)
    {
      case "usa":
        aDate = vStartDate.split("/")
        aDate[2] = MakeFourDigitYear(aDate[2])
        vURL += "&day=" + aDate[1] + "&month=" + (aDate[0]-1) + "&year=" + aDate[2]
        break
    
      case "euro":
        aDate = vStartDate.split("/")
        aDate[2] = MakeFourDigitYear(aDate[2])
        vURL += "&day=" + aDate[0] + "&month=" + (aDate[1]-1) + "&year=" + aDate[2]
        break
    
      case "dd-mon-yy":
        aMonthNames = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]
        // Figure out which month number it we have based on the name.
        aDate = vStartDate.split("-")
        aDate[2] = MakeFourDigitYear(aDate[2])
        for (i=0;i<12;i++) {
          if (aMonthNames[i] == aDate[1].toLowerCase().substr(0,3)) {
            break
          }
        }
        vURL += "&day=" + aDate[0] + "&month=" + i + "&year=" + aDate[2]
        break
        
      case "Www/yy":
        aDate = vStartDate.split("/")
        aDate[0] = aDate[0].substr(1) * 1
        aDate[1] = MakeFourDigitYear(aDate[1])
        var maxWeeks = WeekOfYear("12/31/" + aDate[1],1)
        // Since the date is returned as the friday of the chosen week, find the first Friday of the year and go from there.
        
        for (i=1;i<8;i++) {
          vCurDate = new Date("1/" + i + "/" + aDate[1])
          if (vCurDate.getDay() == 5)
            break
        }

        // Now that we found the first Friday, try each Friday date until we find the one currently picked.
        for (i=0;i<375;i+=7) {
          if (WeekOfYear((vCurDate.getMonth()+1) + "/" + vCurDate.getDate() + "/" + vCurDate.getYear(),1) == aDate[0]) {
            // Found the week, so use the current date (vCurDate)
            break
          }
          
          vCurDate = new Date(vCurDate*1 + 7 * 86400000)  // skip ahead to the next week
          
          vNewWeek = WeekOfYear((vCurDate.getMonth()+1) + "/" + vCurDate.getDate() + "/" + vCurDate.getYear(),1)
          if (vNewWeek == 0 && i > 14) {
            // This week spills into the next year
            aDate[0] = 0
          }
          
        }
        vURL += "&day=" + vCurDate.getDate() + "&month=" + vCurDate.getMonth() + "&year=" + MakeFourDigitYear(vCurDate.getYear())

        break
    }
  }

  OpenWinCentered(vURL,"Calender","",280,275)
}

function MakeFourDigitYear(vYear) {
  vYear*=1
  if (vYear < 100) {
    if (vYear > 50) {  //If a 2 digit year greater than 50, add 1900 to it.
      vYear+=1900
    } else {  //Otherwise, add 2000.
      vYear+=2000
    }
  }
  return vYear
}

function IsLeapYear(yearCheck) {
  //Check for leap year:
  if (yearCheck % 4 == 0) { 
    if (( yearCheck % 100 == 0 ) && (yearCheck % 400 != 0))
      return false
    else
      return true
  }
  else
    return false
}

function DayOfYear(vDate) {
  // vDate is expected to be a string in the format "mm/dd/yyyy"
  var numdays = [,31,28,31,30,31,30,31,31,30,31,30,31]

  var vTemp = vDate.split("/")
  var year = MakeFourDigitYear(vTemp[2])

  if (IsLeapYear(year))
    numdays[2]++  //Is a leap year! Add one to February's day count

  var vDayOfYear = 0

  // Add the number of days for each month up to the current month
  for (i=1;i<vTemp[0]*1;i++) {
    vDayOfYear += numdays[i] * 1
  }
  // Now add the number of days into the current month
  vDayOfYear += vTemp[1] * 1
  return vDayOfYear
}

function WeekOfYear(vDate,vFirstDayOfWeek) {
  // vDate is expected to be a string in the format "mm/dd/yyyy"
  // vFirstDay is an integer representing a day of the week 0-6
  // Returns the week number from 0-53, where 0 is the final week of the previous year.
  var vTemp = vDate.split("/")
  var year = MakeFourDigitYear(vTemp[2])

  // Find out which day of the week the first day of the year is on
  vFirstDate = new Date("1/1/" + year)
  vFirstDayAdjust = vFirstDayOfWeek - vFirstDate.getDay()
  var vDayOfYear = DayOfYear(vDate) - vFirstDayAdjust - 1
  
  var vWeekOfYear = Math.floor((vDayOfYear) / 7)
  
  if (vFirstDayOfWeek >= vFirstDate.getDay())
    vWeekOfYear++

  return vWeekOfYear
}

function OpenWinCentered( svURL, svName, svOptions, ivWidth, ivHeight ) {
  var ivTop = (screen.availheight - ivHeight) / 2;
  var ivLeft = (screen.availwidth - ivWidth) / 2;
  if (svOptions.length > 0) svOptions += ", ";
  svOptions += "top=" + ivTop + ",left=" + ivLeft + ",width=" + ivWidth + ",height=" + ivHeight;
  OpenWin(svURL,svName,svOptions);  // don't return the window object here, since it breaks pages that call this directly with HREF.
}

function OpenWin(svURL,svName,svOptions) {
  var oWin = window.open(svURL,"POLPOL" + svName,svOptions);
  if (oWin) // may be null if external url
    oWin.focus();
  return oWin;
}

function DateKeypress(vField,vDigits) {
  // This only works for US-style dates
  
  // Now using a string that hold the date format, instead of a boolean,
  // because there are more than 2 date formats to choose from. TGIL 6/18/2001
  if (typeof vDateFormat == 'undefined') //Added by TSCH, 5/14/01 because not all pages have this var defined
    vDateFormat = "usa"
  
  Press = window.event.keyCode
  
  if (vDateFormat == "dd-mon-yy" && Press == 45) // 11/4/2003 TGIL: return true for this format so dashes are enterable.
    return true
  else if (vDateFormat != "usa")
    return false;
  
  // This first part searches for [] in vField,
  // which would indicate that is it part of an array of fields with the same name.
  var vArrayIndex
  var vTextBoxField
  if (vField.indexOf("[") > -1) {
    vTextBoxField = vField.substr(0,vField.indexOf("["))
    vArrayIndex = vField.substring(vField.indexOf("[")+1,vField.indexOf("]"))
  } else {
    vTextBoxField = vField
    vArrayIndex = -1
  }
  vArrayIndex*=1  // convert it to a numeric variable

  // At this point, vArrayIndex will be -1 if this field is not in an array,
  // but will be the value of the array index if it is part of an array.
  var vCurrentIndex = 0   // keeps track of the current index number of the matched field if there is an array of them
  var vFieldIndex = -1
  for (i=0;i<document.forms[0].length;i++) {
    if (document.forms[0].elements[i].name == vTextBoxField) {
      if (vCurrentIndex == vArrayIndex || vArrayIndex == -1) {
        vFieldIndex = i
        break
      } else {
        vCurrentIndex++   // if we found a matching field name, but the index numbers don't match, increase to try again
      }
    }
  }
  
  // 9/9/2003 TGIL: Since this function relies on the first form, make sure the field is in the first form
  if (vFieldIndex == -1)
    return false
  
  vForm = document.forms[0].elements[i].value
  vTemp = new Date(new Date(vForm))
  if (vTemp == "NaN")
    return false
  
  //Here's the 2-digit to 4-digit year conversion kludge...
  aForm = vForm.split("/")
  if (aForm[2] < 50) {
    aForm[2] = aForm[2]*1 + 2000
  }
  if (aForm[2] >= 50 && aForm[2] < 100) {
    aForm[2] = aForm[2]*1 + 1900
  }

  //Re-assemble the date with the 4-digit year.
  vTemp = aForm[0] + "/" + aForm[1] + "/" + aForm[2]
  if (Press == 43) {
    vDate = new Date(new Date(vTemp)*1+86400000)
  } else {  // Press==45
    vDate = new Date(new Date(vTemp)-86400000)
  }
  
  if (vDigits == 4)
    document.forms[0].elements[i].value = (vDate.getMonth()+1) + "/" + vDate.getDate() + "/" + vDate.getFullYear() // Return 4-digit year
  else
    document.forms[0].elements[i].value = (vDate.getMonth()+1) + "/" + vDate.getDate() + "/" + vDate.getFullYear().toString().substr(2,2) // Return 2-digit year
    
  if (document.forms[0].elements[i].onchange) document.forms[0].elements[i].onchange(); //TSCH 09/29/03 Before this, any onchange function was not being called although the field was being changed
  return false; //Return fales so that the chars that forced this function to be called do not get typed into form element.
}

function GetTime(vForm,vField,vTime) {
  for (i=0;i<document.forms[0].length;i++) {
    if (document.forms[0].elements[i].name == vField) {
      if (IsValid_Time(i,document.forms[0].elements[i].value) == false)
        vTime = ""
    }
  }

  vURL = vBaseAddress + "/Pickers/Time_Picker.asp?Form=" + vForm + "&Field=" + vField + "&Time=" + vTime + "&Session_Key=" + Get_Session_Key()
  OpenWinCentered(vURL,"Clock","",160,240)
}

function MenuKeypress() {
  Press = window.event
  vKey = Press.keyCode - 48
  if (vKey == 0) { vKey+=10 } // the zero key
  vKey--  // make sure the lowest value matches the first index of 0
  if (vKey < 0 || vKey > MenuOption.length - 1) { return }
  MenuOption[vKey].click()
}

function Keypress(vButton) {
  for (i=0;i<document.images.length;i++) {
    vFilename = document.images[i].src
    if (vFilename.indexOf("Plexus_Online") > -1 || vFilename.indexOf("Contact") > -1) {
      break
    }
  }
  Press = window.event
  if (vButton == 0) {
    vKey = Press.keyCode - 48
  } else {
    vKey = vButton
  }
  if (vKey == 0) { vKey+=10 }
  vKey = vKey + i //Find the first button link by skipping the amount of buttons up to the "Contact" button
  vLocation = new String(document.location)
  vLocation = vLocation.toLowerCase()
  if ((vKey < 3) || (vKey > document.links.length) || (vLocation.indexOf("menu.asp") == -1)) { return }
  document.links[vKey].click()
}

function ContactPlexus() {
  vContactURL = vBaseAddressPOL + "/Plexus_Control/Contact_Plexus_Form.asp?Page=" + vLocation.substr(0,(vLocation.indexOf(".asp")+4)) + "&OpenerServer=" + vBaseAddress

  OpenWin(vContactURL ,"Contact","left=20,top=20,screenX=20,screenY=20,height=550,width=600,status,scrollbars,resizable");
}

function Submit_To(vURL) {
  document.thisForm.action = vURL;
  document.thisForm.submit();
}

function Navigate_To(vURL,vTarget) {
  // Navigate to a page without posting.
  // By using the click() method instead of document.location,
  // the HTTP_REFERER is not blank on the next page.

  if (!vTarget) vTarget = "_top"

  var vOld_href = document.links[0].href      // save these so we can put them back when we're done clicking
  var vOld_target = document.links[0].target
  
  // Temporarily assign the first link on the page to the URL we want to navigate to, then click it.
  document.links[0].href = vURL
  document.links[0].target = vTarget
  document.links[0].click()
  
  // Restore the original link
  document.links[0].href = vOld_href
  document.links[0].target = vOld_target
}

function Post_Querystring(svURL) {
  // Intended to get PCN, PUN, or other sensitive keys to another page without using a querystring.
  // Not intended for string values, since quotes or backslashes will probably break it.
  
  var svAddress = svURL;
  var svQS = "";
  var svHTML = "";
  var ivQuestion = svURL.indexOf("?");
    
  var oForm = document.createElement("<form name='Posted_Get_Form' method='post'>")
  document.body.insertBefore(oForm);
  
  if (ivQuestion > -1) {
    svAddress = svURL.substr(0,ivQuestion);
    svQS = svURL.substr(ivQuestion + 1);
    var aQS = svQS.split("&");
    for (var i = 0;i < aQS.length;i++) {
      var aQS_Val = aQS[i].split("=");
      var oInput = document.createElement("<input type='hidden' name='" + aQS_Val[0] + "' value='" + aQS_Val[1] + "'>");
      oForm.insertBefore(oInput);
    }
  }
    
  oForm.action = svAddress;
  oForm.submit();
}

function Main_Menu(vMainMenuNode)
{
  if (window.opener && window.name.substr(0,10) != "POLPOLMAIN")
  {
    // Start a chain reaction until we are actually on the main window again.
    window.opener.top.Main_Menu(vMainMenuNode)
    window.close();
  }
  else
  {
    vURL = vBaseAddressPOL + "/menu.asp?Node=" + vMainMenuNode;
    Navigate_To(vURL)
  }
}

function ComposeMail(vAddress,vAttachments,svSubject) {
  // 10/11/2004 TGIL: Add svSubject
  
  // The "new Date()*1" is there to add the current millisecond value to the window name so it won't be duplicated
  vContactURL = "../Redirect_Compose_Email.asp?Address=" + vAddress + "&Force_Comm_Log=1"
  if (vAttachments)
    vContactURL += "&Attachments=" + vAttachments
  if (svSubject)
    vContactURL += "&Subject=" + escape(svSubject)
  OpenWinCentered(vContactURL ,"Compose" + (new Date()*1),"scrollbars,status",770,514)
}

function Scale_Image(i,x,y) {
  w = document.images[i].width
  h = document.images[i].height
  if (x/w > y/h)
    document.images[i].width = document.images[i].width * (x/w)
  else
    document.images[i].height = document.images[i].height * (y/h)
}


function Submit_on_Enter(SubmitString) {
  if (window.event.keyCode == 13) FormSubmit(SubmitString);
  //NS 4 wants the following instead    
  //if (window.event.which == 13) FormSubmit(SubmitString);    
}

//The following lines go with the MoveMenu function
vMenuY = 0
var vTimeoutID = setTimeout("MoveMenu()",50)
var CancelMoveMenu = false;

function MoveMenu() {
  if (CancelMoveMenu) return;
  setTimeout("MoveMenu()",50)
  
  if (!document.all.Menu) return;

  document.body.topMargin = 45
  //If scrolling up, put the menu at the very top so it doesn't hover above the actual screen.
  if (vMenuY - document.body.scrollTop > 0) { vMenuY = 0 }
  vDif = vMenuY - document.body.scrollTop
  if (vDif < -1) {
    vMenuY = Math.round(vMenuY - vDif * .25)  //the .25 is a throttle for how fast the menu moves back into place. 1 is full speed
  } else {
    vMenuY = document.body.scrollTop
  }
  document.all.Menu.style.top = vMenuY

  if (vMenuY != document.body.scrollTop) {
    document.all.Menu.style.visibility = "hidden"
  } else {
    document.all.Menu.style.visibility = "visible"
  }

}

function SubmitOnReturn() {
  e = window.event
  if (e.keyCode == 13) {
    if (document.all.SubmitLink) {
      if (!document.all.SubmitLink.clicked) {
        document.all.SubmitLink.click()
        document.all.SubmitLink.clicked = true // make sure it doesn't get clicked again
      }
    }
  }
}

//Begin "BackOnESC" section
  //Set the entire page to go back if pressing ESC
if(document) {
  var ivKeyCount = 0;
  var ivMaxDupeKeysAllowed = 10; //Set this number to the allowable number of duplicate characters. TSCH 8/17/05 Raised to 10
  //When this number was set as high as 6, it would still get: "HTTP 403.9 - Access Forbidden: Too many users are connected" on local
  var aKeyArray = new Array(ivMaxDupeKeysAllowed);
  for (var i = 0; i < ivMaxDupeKeysAllowed; i++ ) {
    aKeyArray[i] = new Object();
    aKeyArray[i].pressTime = (new Date()) * 1;
  }
  document.onkeypress = BackOnESC;
}

function BackOnESC() {
  var e = window.event;
        
  if (e.keyCode == 27) {
//    if (e.keyCode == 115) {   // F4 key
    // In order to make sure we are always using the upper-left most button,
    // we must go to the top frame, then back to frame 0,
    // but the links[0] object is accessible accross frames,
    // so we call a secondary function "BackClick()" from frame 0 that actually clicks it's first link.
      
    if (window.top.location.href != window.location.href) {
      // The page isn't in the topmost frame, so look deeper in the frames
      // until we find a page that contains the BackClick() function.
      if (window.top.frames[0].BackClick) {
        window.top.frames[0].BackClick()
      } else if (window.top.frames[0].frames[0]) {
        if (window.top.frames[0].frames[0].BackClick) {
          window.top.frames[0].frames[0].BackClick()
        }
      }
    } else 
      BackClick();
  }
  
  try {
    var svSticky_Key = new String("security_alert.asp");
    if (vLocation.indexOf(svSticky_Key) == -1 ){//Dont run this code from sticky_key.asp **Infinate Loop**
      var ivIndex = ivKeyCount % ivMaxDupeKeysAllowed;
      ivKeyCount++; // TSCH 7/18/05 US #47916  Prevent continuous submits when key is held down 
      var ivKeyCode = window.event.keyCode;
      var ivNow = (new Date()) * 1;
      aKeyArray[ivIndex].keyCode = ivKeyCode;   // always remember the key pressed, regardless of focus, to prevent false positives
      aKeyArray[ivIndex].pressTime = ivNow;
      var ivTest = aKeyArray[0].keyCode;

      if ( ( ivKeyCode !=9 ) && ( ivKeyCode !=32) && (window.document.activeElement.type == '' || typeof(window.document.activeElement.type) == "undefined" ) ) { // Skip tabs, spaces and any element
        var bvRepetitionDetected = true;
        for (var i = 0; i < ivMaxDupeKeysAllowed; i++ )
          bvRepetitionDetected = (bvRepetitionDetected && (ivTest == aKeyArray[i].keyCode) && (ivNow - aKeyArray[i].pressTime < 5000));
        if( bvRepetitionDetected ) {
          document.onkeypress = ReturnFalse;  // prevent multiple positives
          Security_Alert("Excessive repeated keystrokes have been detected.<br>Please check for a sticky key on your keyboard.","Sticky Key Detected:" + ivKeyCode,8);
          e.cancelBubble = false;
          e.returnValue = false;
          document.onkeypress = BackOnESC;  // reset to normal after showing message
          return false;
        }
      }
    }
  } catch(err) {
    // Do nothing
  }
}
  
function ReturnFalse() { return false; }

var PL_Disable_After_ESC = true // added 3/15/02 TGIL to provide the option to keep the ESC key enabled after pressing it once.
  
function BackClick() {
  if (document.links[0]) {
    if (PL_Disable_After_ESC)
      document.onkeypress = null
    document.links[0].click()
  }
}
//End "BackOnESC" section

function Security_Alert(svDisplayMessage,svEmailMessage,ivLog_Type) {
  var asMessage = [svDisplayMessage,svEmailMessage,ivLog_Type];
  showModalDialog( vBaseAddressPOL + "/Plexus_Control/Security_Alert.asp?Session_Key=" + Get_Session_Key(),asMessage,"dialogWidth:500px;dialogHeight:400px;scroll:no;help:no;status:no");
}

function Enumerate(vObject) { //Storing this useful code. TSCH
//  enumerates all available properties of the given object then displays them
  vProperties = "";
  var j = 0;
  for (i in vObject) {
    vProperties += i + "\n";
    j++;
    if ( j % 25 == 0) {
    alert(vProperties);      
    vProperties = "";
    }
  }
  alert(vProperties);
}

function placeFocus( vSelect, vIndex ) {  //Added by TSCH, 3-14-01
                                  //Extended to pass over disabled elements. TSCH, 3-29-01
                                  //Extend111111111ed to Radio Sets. TSCH, 5-30-01
                                  //try statements for follow-up attempt. This catches case where elements in a hidden span, etc.
                                  //Added type="password" to focus and select if-statements.  TMCG, 6-20-06
  if (typeof(vSelect) == 'undefined') vSelect = false;
  if (typeof(vIndex) == 'undefined') vIndex = 0;

  if (document.forms.length > 0) {
    var field = document.forms[0];
    for (i = vIndex; i < field.length; i++) {
      if (!field.elements[i].disabled && field.elements[i].style.visibility != "hidden") {
        if ( (field.elements[i].type == "radio") && (field.elements[i].defaultChecked) ) {
          try {field.elements[i].focus()} catch(e) {placeFocus( vSelect, ++i );}
          break;
        }
        if ( (field.elements[i].type == "checkbox") || (field.elements[i].type == "text") || (field.elements[i].type == "textarea") || ((field.elements[i].type.toString().charAt(0) == "s") && (field.elements[i].length)) || (field.elements[i].type == "password") ) {
          try {field.elements[i].focus()} catch(e) {placeFocus( vSelect, ++i );}
          if ( ((field.elements[i].type == "text") || (field.elements[i].type == "textarea") || (field.elements[i].type == "password")) && vSelect )
            field.elements[i].select();
          break;
        }
      } // if not disabled and not hidden
    }
  }
}

function Advance_Focus(svForm) {
  if (svForm == null)
    svForm = "thisForm";
  
  var oForm = eval("document." + svForm);
  
  if (typeof(window.document.activeElement) == "undefined") {
    // nothing active, so put focus on first field
    placeFocus();
    return;
  }
  
  for (var i=0;i<oForm.length;i++) {
    if (oForm.elements[i] == window.document.activeElement) {
      // Found the active field, so put focus on the next field that accepts it.
      placeFocus(true,i + 1);
      return
    }
  }
}

function Show_Popup_Layer(vMessage) {
  if (document.all.PL_Wait_Message) {
    // Layer is already made, so do nothing yet
  } else {
    // build the layer
    var vHTML
    vHTML  = "<div ID=PL_Wait_Message style='Position:absolute; left:150; top:0; z-index: 5000; visibility:hidden;'>"
    vHTML += "<table border=2 bordercolor=#4a81aa bgcolor=white cellpadding=6 cellspacing=0 width=250 height=50>"
    vHTML += "<tr><td class=GridHeader>"
    vHTML += vMessage
    vHTML += "</td></tr></table></div>"
    document.body.insertAdjacentHTML("AfterBegin",vHTML)
  }
  // 6/28/2004 TGIL: position the popup layer where the user clicked
  document.all.PL_Wait_Message.style.left = plClickX + document.body.scrollLeft - 125
  document.all.PL_Wait_Message.style.top = plClickY + document.body.scrollTop - 25
  document.all.PL_Wait_Message.style.visibility = "visible"
//  document.all.PL_Wait_Message.style.left = (screen.availWidth - 250) / 2 // make sure the Wait_Message covers the middle button
}

function Hide_Popup_Layer() {
  if (document.all.PL_Wait_Message)
    document.all.PL_Wait_Message.style.visibility = "hidden"
}

/////////////////////////////////////////////////////////////////////////////////
// Begin security lockdown section

//Define event triggers
document.onkeydown = CloseBackDoors

if (vBaseAddress.indexOf("www.") != -1 || vBaseAddress.indexOf("aspmail.") != -1) {
  document.oncontextmenu = DoNothing  // Prevent right=click menus.
}
document.onhelp = HelpKey         // Prevent system Help window from popping up
document.onmousedown = CloseBackDoors

function LogOut(vAsk, vSystem_Name) {
  if (vAsk) {
    if (!vSystem_Name)
      vSystem_Name = "Plexus Online"
    if (!confirm("Are you sure you want to log out of " + vSystem_Name + "?")) {
      return
    }
  }
  
  if (window.name.substr(0,6) == "POLPOLMAIN") {
    // 7/2/2004 TGIL: To erase the history, open the index in a brand new window, then close the current window.
    var vWidth = screen.availwidth - 10;
    var vHeight = screen.availheight - 50;
    OpenWin(vBaseAddressPOL + "/index.asp",(new Date()*1),"Left=0,Top=0,Width=" + vWidth + ",Height=" + vHeight + ",scrollbars,resizable,status");
  
    // Navigate to "Session_Kill.asp", which kills the session then closes the window to prevent using the browser history from a previous session.
    window.top.location = vBaseAddressPOL + "/Session_Kill.asp";
  } else {
    // not on the main window, so we must be in a popup. Cascade down to the main window.
    OpenWin(vBaseAddressPOL + "/Session_Kill.asp","KillPOL","height=10,width=10,left=4000,top=4000");
    window.top.location = vBaseAddress + "/index.asp";
  }
}

function DoNothing() {
  event.keyCode = 0
  event.cancelBubble = true
  event.returnValue = false
}

function HelpKey() {
  Function_Keypress(1)
  DoNothing()
}

function ClickHelp() {
  // find the first link to Help() and click it
  for (var i = 0;i<document.links.length;i++) {
    if (document.links[i].href.indexOf("Help(") > -1) {
      document.links[i].click()
      return
    }
  }
}

function KillPOL() {
  alert("Pressing the F3 or F11 while in Plexus Online will force the current window to close.\n" +
    "Click OK to close this window.")
  window.close()
}

var vChkBoxToggle = true;
function ChkBoxToggle( vFormIndex ) {
  
  if (typeof vFormIndex == "undefined") vFormIndex = 0; //param is optional, TSCH 09/11/2002

  for(var i = 0;i<document.forms[vFormIndex].length; i++)
    if(document.forms[vFormIndex].elements[i].type == "checkbox")
      if(!document.forms[vFormIndex].elements[i].disabled)
        document.forms[vFormIndex].elements[i].checked = vChkBoxToggle;      
      
  vChkBoxToggle = !vChkBoxToggle;  
  
}

function CloseBackDoors() {

  plClickX = event.clientX
  plClickY = event.clientY
    
  vKey = event.keyCode
  vCtrl = event.ctrlKey
  vAlt = event.altKey
  vShift = event.shiftKey
  vMouse = event.button

  //alert(vKey)
  
  // Allow control and alt together, which is the equivalent to the German Alt-GR key.
  if (vCtrl && vAlt) {
    return
  }
  
  if (vCtrl && vKey == 83) {
    if (document.all.SubmitLink) {
      if (document.all.SubmitLink.Control_S) {
        document.all.SubmitLink.click()
        return
      }
    }
  }
    
  // Prevent shift-clicking links, which opens them in a new window.
  if (vShift && vMouse == 1) {
    alert("This feature has been disabled.")
    event.returnValue=false
    return
  }

  // Allow Ctrl-left click for multi-selecting in list boxes
  if (vCtrl && vMouse == 1) {
    return
  }
  
                          // Allowed Control-key combos:
  if (vCtrl && vKey != 16 // Control and Shift only
            && vKey != 17 // Control key only
            && vKey != 35 // End key
            && vKey != 36 // Home key
            && vKey != 37 // Arrow key
            && vKey != 38 // Arrow key
            && vKey != 39 // Arrow key
            && vKey != 40 // Arrow key
            && vKey != 65 // Select All
            && vKey != 67 // Copy
            && vKey != 70 // Find
            && vKey != 80 // Print
            && vKey != 86 // Paste
            //&& vKey != 87 - Close Window - REMOVED 4/20/02 by MWOH w/ TSCH, TDEC and TGIL approval.
            && vKey != 88 // Cut
            && vKey != 90 // Undo
            && vKey != 83 // S (for saving)
            && vKey != 192 // ~ (for tabbing to the next section of a form) 3/14/2002 TGIL & MWOH
            ) {
    // All other keys with Ctrl will do nothing.
    DoNothing()
    return
  }

  // Check for other system keys. F1 (vKey=112), is captured with the onhelp event above.
  switch (vKey) {
    case 8:       // backspace (prevent "browser back" functionality)
      if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
        DoNothing()
      break
    case 113:     // F2
      Function_Keypress(2)
      DoNothing()
      break
    case 114:     // F3
      Function_Keypress(3)
      DoNothing()
      break
    case 115:     // F4
      Function_Keypress(4)
      DoNothing()
      return
      break
    case 116:     // F5
      if (!(vBaseAddress.indexOf("www.") == -1 && vBaseAddress.indexOf("aspmail.") == -1))
        DoNothing()
      break
    case 117:     // F6
      Function_Keypress(6)
      DoNothing()
      return
      break
    case 118:     // F7
      Function_Keypress(7)
      DoNothing()
      return
      break
    case 119:     // F8
      Function_Keypress(8)
      DoNothing()
      return
      break
    case 120:     // F9
      Function_Keypress(9)
      DoNothing()
      return
      break
    case 121:     // F10
      Function_Keypress(10)
      DoNothing()
      return
      break
    case 122:     // F11
      Function_Keypress(11)
      DoNothing()
      break
    case 123:     // F12 displays current address only on non-production
      if (vBaseAddress.indexOf("www.") == -1 && vBaseAddress.indexOf("aspmail.") == -1) {
        alert(document.location)
      } else {
        Function_Keypress(12)
        DoNothing()
      }
      break
  }
}


// End security lockdown section
/////////////////////////////////////////////////////////////////////////////////

var vFunction_Keypress_Done = false

function Function_Keypress(vKeyNo) {
  if (vFunction_Keypress_Done)
    return // only allow it to be used once
    
  // Search the page for a functionKey property that matches the given key no (favorites menu options)
  if (typeof(HM_Function_Keys) == "undefined")
    return
    
  for (var i=0;i<HM_Function_Keys.length;i++) {
    if (HM_Function_Keys[i].keyNo == vKeyNo) {
      vFunction_Keypress_Done = true
      if (HM_Function_Keys[i].linkText == "Help") {
        ClickHelp()
        return
      }
      
      Show_Popup_Layer("Please wait... navigating to<BR>" + HM_Function_Keys[i].dispText)
      
      if (HM_Function_Keys[i].linkText.toLowerCase().indexOf("javascript:")!=-1)
        eval(HM_Function_Keys[i].linkText)
      else
        Navigate_To(HM_Function_Keys[i].linkText)
    }
  }
}


// Load the required Javascript files for popup menus
//document.write("<SCR" + "IPT LANGUAGE='JavaScript1.2' SRC='" + vBaseAddress + "/Popup_Menus/Global_Menu_Properties.js' TYPE='text/javascript'><\/SCR" + "IPT>");
//document.write("<SCR" + "IPT LANGUAGE='JavaScript1.2' SRC='" + vBaseAddress + "/Popup_Menus/HM_Loader.js' TYPE='text/javascript'><\/SCR" + "IPT>");


function SelectReset( vSelectObj ) { //Resets a Select Object to the Default Select, TSCH 8/27/01

  if(!vSelectObj) return; // TSCH 11/04/02

  for(var i = 0; i < vSelectObj.length; i ++)
    vSelectObj.options[i].selected = vSelectObj.options[i].defaultSelected;
}

function plSelectBytext( vSelectObj, vText ) { //Reset a specified Select object to the value(s) bearing the specified text. TSCH 12/12/01

  if(!vSelectObj) return; // TSCH 11/04/02
  
  for( var i = 0; i < vSelectObj.length; i++ )
    vSelectObj.options[i].selected = (vSelectObj.options[i].text == vText);
}

function Launch_Kiosk(vURL,vWidth,vHeight) {
  if (screen.width != vWidth || screen.height != vHeight) {
    alert("Please set your screen resolution to " + vWidth + "x" + vHeight + " before launching this module in kiosk mode.");
    Hide_Popup_Layer();
    return;
  }
  Open_In_New_Session(vURL,true);
}

function Open_In_New_Session(vURL,vKiosk) {
  // Launch any POL page in directly in a new session window.
  var vLoginURL = vBaseAddress + "/Index.asp?Session_Copy=" + Get_Session_Key()
  if (vKiosk) {
    // if requesting kiosk mode, add a querystring flag to the URL so Index.asp knows how to handle it.
    if (vURL.indexOf("?") == -1)
      vURL += "?"
    else
      vURL += "&"
    vURL += "Kiosk=true"
  }
  // Save the page info in a session variable to be retrieved in Login.asp
  Session_Set("New_Session_Page",vURL,"Launch_New_Session('" + vLoginURL + "'," + vKiosk + ")")
}

function Launch_New_Session(vURL,vKiosk) {
  try {
    var vLaunch = "iexplore.exe "
    if (vKiosk) vLaunch += " -k"
    vLaunch += vURL
    var Wsh=new ActiveXObject('WScript.Shell');
    Wsh.Run(vLaunch,3);
    Wsh=null;
  } catch (e) {
    var vTrusted = vBaseAddress.replace(/http?(s):\/\/www/i,"*")
    vTrusted = vTrusted.replace(/http?(s):\/\/dev/i,"*")
    if (confirm("In order to automatically launch a new session, you must add " + vTrusted + " to the Trusted Sites Zone in your browser's Internet Options/Security section.\n\nClick OK now to see more details in the COOKIES section of PC Setup Help."))
      Help(350,vCustomer,true)
  }
}

//TSCH 01/29/03 to enhance listboxes with client-like reaction to typed text
var timerid     = null;
var matchString = "";
var mseconds    = 1000;  // Length of time before search string is reset

function plListselect(keyCode,targ)
  {
    if (navigator.appVersion.indexOf('Windows NT 5.1') == -1) return true; //Approach could not be found to work on OSes other than XP when combininb keyboarding and mouse usage. Note. NT 5.0 is Win2k, but it does not work there for the special mouse-tab combo. It must be XP, i.e. NT 5.1
    if (keyCode*1 < 33) return true; //We do not want to treat TABs, ENTERs, etc. as characters
    
    keyVal       = String.fromCharCode(keyCode); // Convert ASCII Code to a string
    matchString += keyVal; // Add to previously typed characters
    elementCnt   = targ.length - 1;  // Calculate length of array -1
    
    for (i = elementCnt; i > 0; i--) {
      selectText = targ.options[i].text.toLowerCase(); // convert text in SELECT to lower case
      if (selectText.substr(0,matchString.length) ==   matchString.toLowerCase())
        targ.options[i].selected = true; } // Make the relevant OPTION selected
    
    clearTimeout(timerid); // Clear the timeout
    timerid = setTimeout('matchString = ""',mseconds); // Set a new timeout to reset the key press string
    
    return false; // to prevent IE from doing its own highlight switching
  }

//TSCH 3/8/04 to display user name in Title Bar
function plNameInTitle( plTitle, plPassedInPlexusUserName ){

  if ( typeof plTitle != "undefined" ) document.title = plTitle;
  if ( typeof plPassedInPlexusUserName != "undefined" ) plPlexusUserName = plPassedInPlexusUserName;
  
  if (document.readyState == "complete") {   //Is the document loaded?
    if (typeof plSessionCustomerCode != "undefined") {
      document.title = "[" + plSessionCustomerCode.replace(/[']/g,"\'") + "] " + document.title;
    }
    if (typeof plPlexusUserName != "undefined") {
      document.title += " - " + plPlexusUserName.replace(/[']/g,"\'");
    }
  }
  else {
    setTimeout("plNameInTitle()",400);
  }

}
plNameInTitle();
