var Findex = 0;
var DREDD_FormAlreadySubmitted = false; // make sure it doesn't submit more than once. -- 1/23/2002 TGIL

function Validate_Form( vFormName )
{
  var i // make sure we use a local variable
  
  if (typeof vFormName != "undefined")
  {
    Findex = -1;
    for (i=0; i < document.forms.length; i++) 
      if (document.forms[i].name == vFormName)      
        Findex = i;     
      
    if (Findex == -1)
    {
      Notify(vFormName + " not found!");
      return false;
    }
  }
  
  var WillSubmit = true;

  for (i=0; i < document.forms[Findex].length; i++)
  {
    // 9/24/2001 TGIL
    // Check for Rich TextArea.
    Prepare_Rich_TextArea(i)
    
    if (Validate_Element(i) == false)
    {
      WillSubmit = false;
      break;
    }   
  }   


  if (WillSubmit && !DREDD_FormAlreadySubmitted) {
    document.forms[Findex].submit();
    DREDD_FormAlreadySubmitted = true  // make sure it doesn't submit again. -- 1/23/2002 TGIL
  } else if (!WillSubmit) {
    if (document.all.PL_Wait_Message)
      document.all.PL_Wait_Message.style.visibility = "hidden"
    if (document.all.SubmitLink) {
      document.all.SubmitLink.clicked = false
    }
  }
}

function Validate_Form_No_Submit()
{
  var ValidForm = true
  var i // make sure we use a local variable

  for (i=0; i < document.forms[Findex].length; i++)
  {
    // 9/24/2001 TGIL
    // Check for Rich TextArea.
    Prepare_Rich_TextArea(i)
    
    if (Validate_Element(i) == false)
    {
      ValidForm = false;
      break;
    }   
  }

  if (!ValidForm)
    if (document.all.SubmitLink)
      document.all.SubmitLink.clicked = false
  
  return ValidForm;
}

function Prepare_Rich_TextArea(i) {
  // 9/24/2001 TGIL
  // Check for Rich TextArea.
  var vElementName = document.forms[Findex].elements[i].name
    
  if (InputType(vElementName) == "RTA")
  {
    // If found, we must manually copy the contents of it into the accompanied hidden field.
    var filteredHTML;
    var svEditorText;
    
    // Make sure the current element is the hidden field and not one of the style combo boxes.
    if (eval("document.all." + vElementName + "Frame")) {
      // Filter any design time attributes the control may have added during editing.
      eval("filteredHTML = " + vElementName + "Frame.EditorGetHTML();")
      eval("svEditorText = " + vElementName + "Frame.EditorGetText();")
      
      // Put the value in the hidden field. Also make a style that make single spaced <P>
      // 12/3/2004 TGIL: If there is no text, then store blank, to get rid of unwanted HTML tags.
      if (removeWhiteSpace(svEditorText) == "")
        document.forms[Findex].elements[i].value = ""
      else
        document.forms[Findex].elements[i].value = filteredHTML
    }
  }
}

function Validate_Element(i)
  {
  vType = document.forms[Findex].elements[i].type
  var vName = document.forms[Findex].elements[i].name

// 5/30/2001 TGIL
// Added "select-one" type for select lists, which only validate _RQD.
// 11/21/2001 TGIL
// Added "radio" type for radio sets, which only validate _RQD.
  switch(vType.toLowerCase())
    {
    case "select-one":
      if (Required_Is_Blank(i))
        return false;
      else
        return true;
      break;              
    case "radio":
      if (vName.toLowerCase().indexOf("_rqd") == -1) // TGIL 6/14/2002. If radio isn't required, skip it.
        return true;

      if (Required_Radio_Not_Selected(document.forms[Findex].elements[i].name,i))
        return false;
      break;              
    case "textarea":
      if (Required_Is_Blank(i))
        return false;
      else
        InputType(document.forms[Findex].elements[i].name)
        return IsValid_TextArea(i,false);
      break;              
// 5/30/2001 TGIL
// If not a select list or a textarea, check for all other validation.
    default:
      if (Required_Is_Blank(i))
        return false;
      else
        switch(InputType(document.forms[Findex].elements[i].name))
          {
          case "FLT":
            return IsValid_Float(i)
          case "NME":
            return IsValid_Name(i)
          case "MNY":
            return IsValid_Money(i,false)
          case "CSH":
            return IsValid_Money(i,true)
          case "INT":
            return IsValid_INT(i,document.forms[Findex].elements[i].value)
          case "DEC":
            return IsValid_DEC(i,document.forms[Findex].elements[i].value)
          case "URL":
            return IsValid_URL(i)
          case "EML":
            return IsValid_EMail(i)
          case "DTE":
            return IsValid_Date(i)
          case "MIL":
            return IsValid_MilitaryTime(i,document.forms[Findex].elements[i].value)
          case "TME":
            return IsValid_Time(i,document.forms[Findex].elements[i].value)
          case "PER":
            return IsValid_Percent(i)
          case "FRC":
            return IsValid_Fraction( document.forms[Findex].elements[i].value, true, true, document.forms[Findex].elements[i].MaxDenominator ) // requires math.js
          case "RTA":
            return IsValid_TextArea(i,true)  // Rich TextArea uses the same validation as TextArea
          //more?
          default:
            return true;
          }
    break;
  }
}

function Required_Is_Blank(i)
{
  var vNameStr = new String(document.forms[Findex].elements[i].name);
  var vTemp = vNameStr.toLowerCase();
  if (vTemp.indexOf("_rqd") == -1) return false; // TSCH 5/20/02
  
  // 5/30/2001 TGIL
  // Added support for _RQD checking on select lists.
  if (document.forms[Findex].elements[i].type.indexOf("select") != -1)
  { 
    var vSel = document.forms[Findex].elements[i].selectedIndex

    if (vSel == -1) // TSCH 5/20/02, this indicates the Select is empty, as when an empty RecordSet built it in plSelectList. Note changes in Input_Alert
    {
      Input_Alert(i, "This field is required.");
      return true;
    }
    else
      if (document.forms[Findex].elements[i].options[vSel].text == "")
      {
        Input_Alert(i, "This field is required.");
        return true;
      }
      else
        return false;
  }
  else
  {
    if (removeWhiteSpace(document.forms[Findex].elements[i].value) == ""){ //TSCH as per BVIN 06/14/04 Just whitespace counts as invalid
      Input_Alert(i, "This field is required."); return true; }
    else
      return false;
  }
}

function removeWhiteSpace(s) {
  s = s.replace(/\s+/g, " ");
  s = s.replace(/^\s(.*)/, "$1");
  s = s.replace(/(.*)\s$/, "$1");
  return s; }

function Required_Radio_Not_Selected(field,fieldIndex) {  
  if (field == "")
    return false  // - 2/19/02 TGIL. unnamed dummy radio inputs were causing problems
  
  // Added 11/21/2001 by TGIL
  // returns true if a radio option has been selected for the given radio set field name
  var picked = false
  var fieldLen = eval("document.forms[Findex]." + field + ".length")

  for (var i=0;i<fieldLen;i++) {
    if (eval("document.forms[Findex]." + field + "[i].checked"))
      picked = true
  }
  
  if (!picked)
  {
    // Check for existence of Dredd property. If so, use it for the field name in the alert box. (5/29/2002 TGIL)
    if (document.forms[Findex].elements[fieldIndex].Dredd)
      var StrName = new String(document.forms[Findex].elements[fieldIndex].Dredd);
    else
      StrName = MakeElemNameReadable( field );
    Dredd_Notify("Please select one of the radio buttons for " + StrName + ".");
    return true;
  }

  return false  // return the opposite, since the function returns true if NOT picked
}

function InputType(vName)
  {
  var vNameStr = new String(vName);
  var vTemp = vNameStr.toLowerCase();

  // 8/12/03 TGIL: improve parsing of Dredd tags, to prevent mistakes on fields named like "Something_Personnel" being "PER"
    
  if (HasTag(vTemp,"flt"))
    return "FLT"
  
  if (HasTag(vTemp,"nme"))
    return "NME";
    
  if (HasTag(vTemp,"mny"))
    return "MNY";
    
  if (HasTag(vTemp,"csh"))
    return "CSH"; 

  if (HasTag(vTemp,"url"))
    return "URL";
  
  if (HasTag(vTemp,"eml"))
    return "EML";
    
  if (HasTag(vTemp,"dte"))
    return "DTE";

  if (HasTag(vTemp,"mil"))
    return "MIL";

  if (HasTag(vTemp,"tme"))
    return "TME";
    
  if (HasTag(vTemp,"int"))
    return "INT";
    
  if (HasTag(vTemp,"dec"))
    return "DEC";
    
  if (HasTag(vTemp,"per"))
    return "PER";       

  if (HasTag(vTemp,"txa"))
    return "TXA";
    
  if (HasTag(vTemp,"frc"))
    return "FRC";
    
  if (HasTag(vTemp,"rta"))
    return "RTA";
}

function HasTag(vField,vTag) {
  var iLen = String(vField).length;
  if (vField.indexOf("_" + vTag + "_") != -1 || String(vField).substring(iLen, iLen - 4).toLowerCase() == "_" + vTag)
    return true
  else
    return false
}

function IsValid_Name(i)
  {
  //A field holding the name of a person should only have alpha characters, ".", ",", " " or "-"
  var vNameStr = new String(document.forms[Findex].elements[i].value);
  for (var idx = 0; idx < vNameStr.length; idx++)
    {
    var ch = vNameStr.substring(idx, idx + 1);
    if (((ch < "a" || "z" < ch) && (ch < "A" || "Z" < ch)) && ch != " " && ch != "." && ch != "," && ch != "-" && ch != "'") 
      {
      Input_Alert(i, "This field can only have alpha characters, periods, commas, hyphens or spaces");
      return false;
      }
    }
  return true;
  }

function IsValid_Money(i,vCash)
  {
  vStr = document.forms[Findex].elements[i].value
  
  if (vStr == "")   //Skip validation of entry is blank
    { 
    //Following line commented out by TSCH, 3-7-01
    //document.forms[Findex].elements[i].value = "0";
    return true;
    }
    
  if (vStr == "$") {
    Input_Alert(i,"Dollar signs are only allowed at the beginning of a numeric value. A dollar sign alone is invalid.")
    return false; }   
        
  vTemp = vStr.replace(/[$]/g,"");  //First test for illegal characters
  vTemp = vTemp.replace(/[,]/g,"");
  vTemp = vTemp.replace(/[.]/g,"");

  if ((vTemp == "") || (vTemp == "-")){    //Nothing but a set of the above characters was here! (TSCH, 1-3-01). Expanded to include only a hyphen as entry, TSCH 10/22/01
    Input_Alert(i,"This is not a numeric value.");
    return false;
  }
    
  // check for multiple minus signs -TGIL
  if (vTemp.indexOf("-") != vTemp.lastIndexOf("-")) {
    Input_Alert(i,"Only one minus sign is allowed.");
    return false;
  }
  
  if (vTemp.indexOf("-") == 0) vTemp = vTemp.replace(/[-]/,"");
  //The line below would have allowed such miskeys as "$5-.000" -TSCH
  //vTemp = vTemp.replace(/[-]/g,""); //We need to allow negative money values. -SSIG
  
  if (IsValid_INT(i,vTemp) == false) return false;
    
  vTemp = vStr.substring(vStr.indexOf("$")+1,vStr.length) //Check for more than one dollar sign
  if (vTemp.indexOf("$") != -1) {
    Input_Alert(i,"Dollar signs are only allowed at the beginning of the money value.");
    return false; }
    
/* The following was being allowed and now prevented: -3630$0.00    
   TSCH 01/03/2003
   There can be no digits to the left of the "$"       */
var pattern = /\d[$]/; //x36 = "$"
if(pattern.test(vStr)) {
    Input_Alert(i,"There can be no digits to the left of the dollar sign.");
    return false; }

//  This validation is used for fields that take commas and decimals but cannot have "$"
//  DO NOT uncomment the following lines - TSCH 
//if (vStr.indexOf("$") != 0)  //If there is no dollar sign, then add one to the beginning
//    { vStr = "$" + vStr }   
  
  if (vStr.indexOf(".") != -1) {  //If there is at least one decimal point...
    vTemp = vStr.substring(vStr.indexOf(".")+1,vStr.length) //...check for more than one decimal point
    if (vTemp.indexOf(".") != -1)
      {
      Input_Alert(i,"Only one decimal point is allowed in a money value.")
      return false
      }
// it now passes in a boolean indicating if it is in cash(x.2)or money(x.x) mode -TDEC
     if (vCash == true)
     {  
       if (vStr.length - vStr.indexOf(".") > 3)  //Check for more than 2 digits after decimal point (3 including the decimal)
        {
        Input_Alert(i,"Only 2 digits are allowed after the decimal point.")
        return false
        }
  // There can be more than two places past the decimal in a money field - TSCH
     }
      
    vTemp = vStr.substring(0,vStr.indexOf("."))  //Strip the decimal portion to analyze the commas
    }
    else
    { vTemp = vStr }

  if (vTemp.indexOf(",") != -1) {  //If there is at least one comma, check to see that commas as used properly
    while (vTemp.indexOf(",") != -1) {  //While there are still commas to test...
      if (vTemp.length - vTemp.lastIndexOf(",") != 4)  //...make sure there are 3 digits plus a comma before the next comma
        {
        Input_Alert(i,"Only 3 digits are allowed between each comma and the decimal point.")
        return false
        }
      vTemp = vTemp.substring(0,vTemp.lastIndexOf(","))  //Strip off the right-most comma and 3 digits
      
      if ( (vTemp.length >4) && (vTemp.indexOf(",") == -1) )  //If there are more than 3 digits plus a $ before the first comma
        {
        Input_Alert(i,"You have too many digits before the first comma.")
        return false
        }
    }
  }
  document.forms[Findex].elements[i].value = vStr
  return true
}

function IsValid_Percent(i)
  {
  
  vStr = document.forms[Findex].elements[i].value
  
  if (vStr == "")   //Skip validation of entry is blank
    { 
    document.forms[Findex].elements[i].value = "0";
    return true;
    }
    
  vTemp = vStr.replace(/[%]/g,"");  //Strip %
  document.forms[Findex].elements[i].value = vTemp;
  
  return IsValid_DEC(i,vTemp)
}

function IsValid_MilitaryTime( i, vValue ) //Added by TSCH, 3-23-01.
{
  if (vValue == "")   //Skip validation of entry is blank
    return true;
    
    var vRegExp = /(^[0-1]\d:[0-5]\d$)|(^2[0-3]:[0-5]\d$)/;
    var vResult =  vValue.match(vRegExp);
    if (vResult == null) {
      Input_Alert(i,"Must be entered as military time between 00:00 and 24:59")
      return false; }
    else
      return (vResult[0] == vValue);
}

function IsValid_Fraction( vValue, fraImproper, fraBase2, fraMaxDenom ) //Added by TSCH, 1-29-01. Pulling out the guts of IsValid_Fraction() allows it to be called directly.
{ // requires math.js
  //fraImproper, fraBase2 Added by TSCH, 7/26/01
  
  if (isInteger (vValue)) return true;
  
  var C;
  for (n = 0; n < vValue.length; n++) { //Check for any invalid characters
    C = vValue.charCodeAt(n);
    if (!( (C == 45) || (C == 47) || ((C >= 48) && (C <= 57)) )) {  // 45 = Hyphen, or "Dash", 47 = Forward-Slash. There rest are Digits
      Dredd_Notify("Fraction '" + vValue + "' cannot include a '" + vValue.substr(n,1) + "'<BR>(ASCII Code: " + C + ")");
      return false; }
    }
  
  
  if (typeof fraImproper == 'undefined') fraImproper = false; //fraImproper - send in true to validate against improper fractions, e.g. 73/4
  if (typeof fraBase2 == 'undefined') fraBase2 = false; //fraBase2 - send in true to validate base-2, e.g. would validate against 7-1/47 as not being base-2  
  // fraMaxDenom Added by TSCH, 3/25/02. Use to indicate a range of acceptable fractions.
  //For instance, IsValid_Fraction( "...", true, true, 16 ) would only allow /2, /4, /8, /16

      if ( vValue.lastIndexOf("-") > -1 )
        var fraFraction = vValue.substr( vValue.lastIndexOf("-") + 1, vValue.length - vValue.lastIndexOf("-") );
      else
        var fraFraction = vValue;

      fraArray = fraFraction.split("/");      

      if ( !isFinite(fraArray[0]/fraArray[1]) ) { //isNaN would not work here for cases such as "8-1/", TSCH 3/25/02
        Dredd_Notify("Fractions must have numeric numerators and denominators, " + vValue + " is non-numeric.");
        return false; }
        fraArray[0] = parseInt(fraArray[0]);
        fraArray[1] = parseInt(fraArray[1]);

    if ((vValue.lastIndexOf("/") > -1) && (fraImproper || fraBase2)) {    
      
      if ( fraImproper && (fraArray[0] > fraArray[1]) ) {
        Dredd_Notify("Fractions must be proper, " + vValue + " is improper.");
        return false; }

      if (!IsBase2( fraArray[1] )) {
        Dredd_Notify("Fractions must be base-2, " + vValue + " is not of the proper base.");
        return false; }
    }

      if (typeof fraMaxDenom == 'undefined') fraMaxDenom = fraArray[1];
      if (fraArray[1] * 1 > fraMaxDenom * 1) {
        Dredd_Notify("Denominator cannot exceed " + fraMaxDenom + ".");
        return false; }
    
    var vRegExp = /(^\d+$)|(^\d+-\d+\/\d+$)|(^\d+\/\d+$)/;
    var vResult =  vValue.match(vRegExp);
    if (vResult == null) 
      return false;
    else
      return (vResult[0] == vValue);
}

function IsValid_DEC(i,vStr)
  {   
  if (vStr == "")   //Skip validation of entry is blank
    { 
    //Following line commented out by TSCH, 3-7-01
    //document.forms[Findex].elements[i].value = "0";
    return true;
    } 

  if (vStr.indexOf(".") != vStr.lastIndexOf("."))
    {
    Input_Alert(i,"You cannot have more than one decimal point.")
    return false
    }

  if (vStr == "-") //Added by TSCH, 3-26-01
    {
    Input_Alert(i,"You need more here than just a negative sign.");
    return false;
    }

  if (isNaN(parseFloat(vStr))) //Added by TSCH, 3-26-01
    {
    Input_Alert(i,"Invalid Decimal format: '" + vStr + "'.");
    return false;
    }

  vTemp = vStr.replace(/[.]/g,"");
  //vTemp = vTemp.replace(/[,]/g,""); //Allowing Commas, TSCH 2/13/02
  return IsValid_INT(i,vTemp);
   }

function IsValid_INT(i,vStrINT)
  {
  if (vStrINT == "")   //Skip validation of entry is blank
    { 
    //document.forms[Findex].elements[i].value = "0";
    // the above line commented by tgil on 3/6/2001. We want to keep a blank entry as blank.
    return true;
    } 

  // check for multiple minus signs -TGIL
  if (vStrINT.indexOf("-") != vStrINT.lastIndexOf("-"))
  {
    Input_Alert(i,"Only one minus sign is allowed.");
    return false;
  }

  if (vStrINT.indexOf("-") == 0)   //Allow for negatives but only in the first character. -SSIG
    {
    vStrINT = vStrINT.substring(1);
    }

  vStrINT = vStrINT.replace(/[,]/g,""); //Allowing Commas, TSCH 2/13/02 observed by BVIN

  for (n = 0; n < vStrINT.length; n++) {
  if ((vStrINT.charCodeAt(n) <48) || (vStrINT.charCodeAt(n) >57)) { //Removed comma-specific message for dynamic one. TSCH 2/13/02
    Input_Alert(i,"Please re-enter a valid numeric value. The value cannot include an '" + String.fromCharCode(vStrINT.charCodeAt(n)) + "'"); // Do not include commas.");
    return false; }
  }
  
  //TSCH 02/11/03 This solves problems as when commas are inserted in filter fields that are _INT or _DEC come back as an additional param into SQL
  document.forms[Findex].elements[i].value = document.forms[Findex].elements[i].value.replace(/[,]/g,"");

  if(document.forms[Findex].elements[i].greater_than || (document.forms[Findex].elements[i].greater_than==0))
    if(document.forms[Findex].elements[i].greater_than > '')
      if (document.forms[Findex].elements[i].value*1 <= document.forms[Findex].elements[i].greater_than*1) { // TSCH 2/13/03
       Input_Alert(i,"Please re-enter this value. The value cannot be less than or equal to " + document.forms[Findex].elements[i].greater_than);
       return false; }

  if(document.forms[Findex].elements[i].less_than || (document.forms[Findex].elements[i].less_than==0))
    if(document.forms[Findex].elements[i].less_than > '')
      if (document.forms[Findex].elements[i].value*1 >= document.forms[Findex].elements[i].less_than*1) { // TSCH 2/13/03
       Input_Alert(i,"Please re-enter this value. The value cannot be greater than or equal to " + document.forms[Findex].elements[i].less_than);
       return false; }

  if(document.forms[Findex].elements[i].minimum || (document.forms[Findex].elements[i].minimum==0))
    if(document.forms[Findex].elements[i].minimum > '')
      if (document.forms[Findex].elements[i].value*1 < document.forms[Findex].elements[i].minimum*1) { // TSCH 2/13/03
       Input_Alert(i,"Please re-enter this value. The value cannot be less than " + document.forms[Findex].elements[i].minimum);
       return false; }

  if(document.forms[Findex].elements[i].maximum || (document.forms[Findex].elements[i].maximum==0))
    if(document.forms[Findex].elements[i].maximum > '')
      if (document.forms[Findex].elements[i].value*1 > document.forms[Findex].elements[i].maximum*1) { // TSCH 2/13/03
       Input_Alert(i,"Please re-enter this value. The value cannot exceed " + document.forms[Findex].elements[i].maximum);
       return false; }

  return true;
}

function IsValid_EMail(i)
{
  var EMailAddress = document.forms[Findex].elements[i].value;

  var svErr = IsValid_Email_List( EMailAddress );

  if (svErr != "")
  {
    Input_Alert(i,svErr);
    return false;
  }

  return true;
}

function IsValid_Email_List( svEmail_List )
{
  if (svEmail_List == "")  //Skip validation if entry is blank
    return "";

  svEmail_List = svEmail_List.replace(/,/g,";");
  var svEmail_Array = svEmail_List.split(";");

  for (var ivEmail_Count = 0;ivEmail_Count < svEmail_Array.length;ivEmail_Count++)  
  {
    EMailAddress = svEmail_Array[ivEmail_Count];
    if (svEmail_Array[ivEmail_Count] == "")
      continue;
    
    if (EMailAddress.lastIndexOf("@") > EMailAddress.lastIndexOf("."))
      return "E-Mail address(es) must be entered in the format \"name@domain.com\"";

    for (var n=0; n<EMailAddress.length; n++) //Check for any invalid characters
    {
      C = EMailAddress.charCodeAt(n)
      if ( ((C >= 48) && (C <= 57)) || ((C >=65) && (C <= 90)) || ((C >= 97) && (C <= 122)) || (C == 64) || (C == 45) || (C == 43) || (C == 46) || (C == 95) || (C == 39) )
      {
        //Valid character
      } else {
        //Invalid character found
        return "E-Mail address(es) cannot include a '" + EMailAddress.substr(n,1) + "'";
      }
    }
  
    if (EMailAddress.indexOf("@") == -1)
      return "E-Mail address(es) must be entered in the format \"name@domain.com\"";

    EmailName = EMailAddress.substring(0,EMailAddress.lastIndexOf("@"));
  
    if (EmailName.indexOf("@") != -1)
      return "Only one '@' in an e-mail address!";
        
    vHost = EMailAddress.substring(EMailAddress.lastIndexOf("@"),EMailAddress.length);
                
    if (EMailAddress.indexOf("@") + 1 == EMailAddress.lastIndexOf("."))
      return "There must be a domain name between the '@' and the '.'";
      
    F = EMailAddress.lastIndexOf(".")+1
    
    if ( (EMailAddress.substr(F,EMailAddress.length-F).length > 4) || (EMailAddress.substr(F,EMailAddress.length-F).length < 2) )
      return "The extension such as \".com\" or \".net\" must be 2-4 letters.";
    
    if (EMailAddress.indexOf("@") == 0)
      return "'@' cannot be the first character in an e-mail address!";
  }
  return "";
}

function IsValid_URL(i)
  {
  // 5/6/2005 TGIL: Added support for https:
  var vURL = document.forms[Findex].elements[i].value
  if (vURL == "") return true; //If field is blank, skip validation

  if (vURL.substr(0,5).toLowerCase() == "http:" || vURL.substr(0,6).toLowerCase() == "https:") {
    var S = vURL.indexOf(":/");
    if (S == -1)  vURL = vURL.substring(5,vURL.length); //If no slashes after the colon
    if (vURL.substr(S+2,1) == "/") S++; //Check for the second slash      
    if (vURL.substr(S+2,1) == "/") { //Check for more than two slashes
      Input_Alert(i,"You have too many slashes in your web address (URL).");
      return false; }
  } else
    vURL = "http://" + vURL;

  var ivProtocolLen;
  if (vURL.substr(0,5).toLowerCase() == "http:")
    ivProtocolLen = 7;
  else if (vURL.substr(0,6).toLowerCase() == "https:")
    ivProtocolLen = 8;
  
  document.forms[Findex].elements[i].value = vURL;

  for (n=ivProtocolLen; n<vURL.length; n++) //Check for any invalid characters
    {
    C = vURL.charCodeAt(n)
    if ( (C == 95) ||                     // Underscore
         (C == 35) ||                     // Hashmark
         (C == 126) ||                    // Tilde
         (C == 61) ||                     // Equal Sign
         (C == 63) ||                     // Question Mark
         (C == 37) ||                     // Percent
         (C == 38) ||                     // Ampersand
         ((C >= 48) && (C <= 57)) ||      // Digits
         ((C >=65) && (C <= 90)) ||       // Upper-case letters
         ((C >= 97) && (C <= 122)) ||     // Lower-case letters
         ((C >= 43) && (C <= 47) ) )      // Plus, Comma, Hyphen, Period, Forward-Slash
      {
        // Valid character.
      } else {
        //Invalid character found
        Input_Alert(i,"A web address (URL) cannot include a '" + vURL.substr(n,1) + "'\n(ASCII Code: " + C + ")");
        return false;
      }
    }

  if (vURL.lastIndexOf(".") == -1)  //Does not contain a period
    { 
    Input_Alert(i,"A web address (URL) must contain a 2-4 letter extension such as \".com\", \".net\" or \".info\"")
    return false
    } else
    {
    D = vURL.indexOf("/",ivProtocolLen)
    
    if ( (vURL.indexOf(".") > D) && (D > ivProtocolLen) )  //Period is not located in the base URL
      {
      Input_Alert(i,"The 2-4 letter extension such as \".com\" or \".net\" must be located in the base URL.")
      return false
      }
    }
    
    if (D == -1) {
      D = vURL.length
    }
    
    vTemp = vURL.substr(0,D)
    P = vTemp.lastIndexOf(".")

    // 9/16/2002 TGIL expand valid extension size to 4.
    if ( (vTemp.length - P > 5) || (vTemp.length - P < 3) )  //Check for length of extension such as .com
      {
      Input_Alert(i,"The extension such as \".com\" or \".net\" must be 2-4 letters.")
      return false
      }
      
  //Certain symbols must not precede the final period. That is, Query String symbols must be after the final period. TSCH, 9/5/01. Corrected (only hash mark was working), TSCH 02/09/04
    if ( ((vURL.indexOf("#") > -1) && (vURL.indexOf("#") < vTemp.length)) ||
         ((vURL.indexOf("=") > -1) && (vURL.indexOf("=") < vTemp.length)) ||
         ((vURL.indexOf("?") > -1) && (vURL.indexOf("?") < vTemp.length)) ||
         ((vURL.indexOf("&") > -1) && (vURL.indexOf("&") < vTemp.length)) ||
         ((vURL.indexOf("+") > -1) && (vURL.indexOf("+") < vTemp.length)) ||
         ((vURL.indexOf(",") > -1) && (vURL.indexOf(",") < vTemp.length)) ) {
      Input_Alert(i,"In a valid URL, hash marks (#), equal signs, question marks, ampersands (&), plus signs and commas must follow the domain extension, usually '.com' or '.net.'");
      return false; }
      
  return true
}

function FormIndexGet(vName){ //Added by TSCH, 9/7/01

  var i = "";
  for(var j = 0; j < document.forms[Findex].length; j++)
    if (document.forms[Findex].elements[j].name)
      if (document.forms[Findex].elements[j].name == vName) {
        i = j;
        break; }
  
  return i;

}

function IsValid_Date(i)
{
  var vTemp=document.forms[Findex].elements[i].value;
  var intime = ""
  var indate = ""
  //The leading comma is to ensure that January is index 1 in the next two arrays
  var jsNumDays=[,31,28,31,30,31,30,31,31,30,31,30,31]
  var jsMonthNames=[,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
  
  // 3/20/2002 TGIL added vYearDigits validation
  var vYearDigits
  if (document.forms[Findex].elements[i].YearDigits)
    vYearDigits = document.forms[Findex].elements[i].YearDigits * 1
  else
    vYearDigits = 2
    
  if (typeof vDateFormat == "undefined") {
    vDateFormat = "usa"
  }

  //If date is blank, then ignore it
  if (vTemp == "")
  {
    return true;
  }
  
  // Regular Expression used for matching format dd-Mon-yy, or d-Mon-yyyy, etc.
  // If it matches, validate the month spelling and number of days in month only.
  // Added 6/18/2001 by TGIL for GKN per MHAT.
  
  dateExp = /^\d{1,2}[-][a-zA-Z]{3}[-](\d{2}|\d{4})$/
  if (vTemp.search(dateExp) > -1) {
    sdate = vTemp.split("-")
    var year = sdate[2]*1 // Convert to a numeric value
    var day = sdate[0]*1  // Convert to a numeric value
    
    // First, figure out what month it is so we can validate the number of days in it
    for (n=1;n<13;n++) {
      if (sdate[1].toLowerCase() == jsMonthNames[n].toLowerCase())
        break   // found the month, so get out of the loop
    }

    if (n == 13) {
      // Went through the entire loop and didn't find a matching month name
      Input_Alert(i,"\"" + sdate[1] + "\" is an invalid month. Please use the first three letters only.")
      return false;
    }
    
    // added 3/20/2002 TGIL
    if (vYearDigits == 4 && year < 100) {
      Input_Alert(i,"You must supply a 4-digit year for the date " + vTemp + ".")
      return false;
    }

    year = MakeFourDigitYear(year)  // requires Plexus.js

    //Check for leap year:
    if (IsLeapYear(year))
      jsNumDays[2]++    // Is a leap year! Add 1 to February's day count

    //Make sure the day entered is valid for the given month
    if (day < 1) {
      Input_Alert(i,day+" is not a valid value for a date.")
      return false;
    }
  
    if (day > jsNumDays[n])
    {
      Input_Alert(i,day+" is not a valid day for that month.")
      return false;
    }
    
    return true
  } // End of dd-Mon-yyyy format
  
  // This must be checked before manipulating the date string below.
  if (vDateFormat == "Www/yy") {
    dateExp = /^[W]\d{1,2}[/](\d{2}|\d{4})$/
    if (vTemp.search(dateExp) > -1) {
      sdate = vTemp.split("/")
      // Find out how many weeks are in the current year.
      var maxWeeks = WeekOfYear("12/31/" + sdate[1],1)

      month = sdate[0].substr(1) * 1
      if (month < 1 || month > maxWeeks*1) {
        Input_Alert(i,month + " is an invalid week number. Please use 1 through " + maxWeeks + " for the year " + MakeFourDigitYear(sdate[1]) + ".")
        return false
      }
    } else {
      Input_Alert(i,"Please use the format Www/yyyy or Www/yy, where ww is the week number and yyyy or yy is the year.")
      return false
    }
    return true
  }

  // This must be checked before manipulating the date string below.
  if (vDateFormat == "dd-mon-yy") {
    Input_Alert(i,"Please use the format DD-Mon-YY or DD-Mon-YYYY, where Mon is the first 3 letters of the month.")
    return false
  }
  
  //Replace any dashes or periods with slashes
  vTemp=vTemp.replace(/[.]/g, "/")
  vTemp=vTemp.replace(/[-]/g, "/")
  
  //Insert delimiter if one does not exist
  //Added by TSCH 9/18/00
  if ( ( (vTemp.length == 8) || (vTemp.length == 6) ) && (vTemp.indexOf("/") == -1))
    vTemp = vTemp.substring(0,2) + "/" + vTemp.substring(2,4) + "/" + vTemp.substring(4,vTemp.length);
    
  if (vTemp.indexOf(" ") > -1) {
    indate = vTemp.substring(0,vTemp.indexOf(" "))
    intime = vTemp.substring(vTemp.indexOf(" ")+1,vTemp.length)
    for (n=0;n<intime.length;n++) { //Scan the time string looking for spaces
      if (intime.charAt(n) != " ") {  //If we find a character other than a space, then verify the time
        if (IsValid_Time(i,intime)) { //If the time is valid, then break out of the loop
          break
        } else {                      //If the time is invalid, then return false for the time field
          return false
        }
      }
    }
  } else {
    indate = vTemp
  }
  
  //Check for invalid characters in the date
  for (n = 0; n < indate.length; n++) {
  if ((indate.charCodeAt(n) < 47) || (indate.charCodeAt(n) > 57))
    {
    Input_Alert(i,"\"" + indate.substr(n,1) + "\" is an invalid character for a date. Please use the format MM/DD/YY or MM/DD/YYYY, where January is 1 and December is 12.")
    return false;
    }
  }
  
  //Check for valid separator in the date
  if (indate.indexOf("/")!=-1)
  {
    var sdate = indate.split("/");
  } else {
    Input_Alert(i,"Please use the format MM/DD/YY, where January is 1 and December is 12.")
    return false;
  }

  // Multiply all the numeric date parts by 1 to convert them to numeric values instead of strings
  var year = sdate[2]*1
  
  switch (vDateFormat)
  {
    case "usa":
      var month = sdate[0]*1
      var day = sdate[1]*1
      var errMsg = "Please use the format MM/DD/YY or MM/DD/YYYY, where January is 1 and December is 12."
      break
    case "euro":
      var month = sdate[1]*1
      var day = sdate[0]*1
      var errMsg = "Please use the format DD/MM/YY or DD/MM/YYYY, where January is 1 and December is 12."
      break
    case "dd-mon-yy":
      // This case is handled separately before checking for invalid characters above.
      break
    case "Www/yy":
      // This case is handled separately before checking for invalid characters above.
      break
  }

  //Make sure the month is in the valid range
  if (month < 1 || month > 12) {
    Input_Alert(i,errMsg)
    return false;
  }

  //If no year has been entered
  if ( sdate.length != 3 || sdate[2] == "") {
    Input_Alert(i,errMsg)
    return false
  }


  //Verify that the year has either 2 or 4 digits, but nothing else. ( year.length !=2 && year.length !=4 ) Added by TSCH 1-29-01 to prevent single-digit years.
  if ( ( year < 0 ) || ( ( year > 99 ) && ( year < 1582 ) ) || ( year > 9999 ) ) {
    Input_Alert(i,"You MUST use a 2-digit or 4-digit year.")
    return false
  }
  
 // added 3/20/2002 TGIL
  if (vYearDigits == 4 && year < 100) {
    Input_Alert(i,"You must supply a 4-digit year for the date " + vTemp + ".")
    return false;
  }

  year = MakeFourDigitYear(year)  // requires Plexus.js

  //Check for leap year:
  if (IsLeapYear(year))
    jsNumDays[2]++    // Is a leap year! Add 1 to February's day count

  //Make sure the day entered is valid for the given month
  if (day < 1) {
    Input_Alert(i,day+" is not a valid value for a date.")
    return false;
  }
  
  if (day > jsNumDays[month] && month <= 12)
  {
    Input_Alert(i,day+" is not a valid day for that month.")
    return false;
  }

  if (intime.length > 0) {
    document.forms[Findex].elements[i].value=indate + " " + intime
  } else {
    document.forms[Findex].elements[i].value=indate
  }
  return true;
}

function IsValid_Time(i,vStr)
{
  //If time is blank, then ignore it
  if (vStr == "")
  {
    return true;
  }

  //Check for AM or PM, and make sure it's the last thing in the entry
/*  Europeans apparently use 24-hour clock, no AM/PM
  vLen = vStr.length
  if (vStr.indexOf(" AM") != vLen-3 && vStr.indexOf(" am") != vLen-3 && vStr.indexOf(" PM") != vLen-3 && vStr.indexOf(" pm") != vLen-3)
  {
    Input_Alert(i,"AM or PM must be the last thing in the time entry.\nMake sure there is a space between the time and AM or PM, and that there is no space afterwards.\n\nPlease use the format HH:MM AM or HH:MM PM.")
    return false;
  }
*/
  
  //Check for invalid characters in the time
  for (n = 0; n < vStr.length; n++) {
    var ch = vStr.substring(n, n + 1);
    if ((ch < "0" || ":" < ch) && ch != "a" && ch != "A" && ch != "p" && ch != "P" && ch != "m" && ch != "M" && ch != " ")
    {
    Input_Alert(i,"\"" + vStr.substr(n,1) + "\" is an invalid character for a time. Please use the format HH:MM AM or HH:MM PM.")
    return false;
    }
  }
  
  //Check for valid separator in the time
  if (vStr.indexOf(":")!=-1)
  {
    var aTime = vStr.split(":");
  } else {
    Input_Alert(i,"Please use the time format HH:MM AM or HH:MM PM.")
    return false;
  }
  
  if (aTime.length > 3) {
    Input_Alert(i,"Please use the time format HH:MM AM or HH:MM PM.")
    return false;
  }
  
  if (aTime[2]) {       //If seconds are included, then assign minutes and seconds to different variables
    vMidVal = aTime[1]
    vLastVal = aTime[2]
  } else {              //If seconds aren't included, then assign the minutes to both variables
    vMidVal = aTime[1]
    vLastVal = aTime[1]
  }

  // Use a regular expression to remove any spaces and am or pm from the values for case-insensitivity for am/pm. 4/1/2002 TGIL 
  vMidVal = vMidVal.replace(/[ ]*(am|pm)/gi,"");
  vLastVal = vMidVal.replace(/[ ]*(am|pm)/gi,"");
    
  //Test for invalid values for hours, minutes and seconds
  if (aTime[0] < 0 || aTime[0] > 23 || vLastVal < 0 || vLastVal > 59 ||
      vMidVal < 0 || vMidVal > 59 || vLastVal.length != 2 || vMidVal.length != 2) {
    Input_Alert(i,"One or more values are out of range.")
    return false;
  }

  return true
}

function IsValid_TextArea(i,bvRTA)
{
  var T = document.forms[Findex].elements[i].value
  var L = T.length
  vTemp = document.forms[Findex].elements[i].name
  var U = vTemp.lastIndexOf("_")
  var M = vTemp.substr(U+1,vTemp.length-U) * 1
  var svMessage;
  
  if (isNaN(parseInt(M)))
    return true // No character length was specified, so do not restrict the length. 9/25/2001 TGIL
    
  if (L > M)
    {
    var Cut = L - M
    svMessage = "The text entry cannot exceed " + M + " characters! Please remove at least " + Cut + " characters."
    if (bvRTA)
      svMessage += "<br><br>If you copied text from Microsoft Word, then there will be thousands of hidden characters that are included in this count."
    Input_Alert(i,svMessage)
    return false
    }
  return true
}

//TSCH 3-16-01 Made this a function, extracted from code in Input_Alert() so it can be called from elsewhere
function MakeElemNameReadable( StrName ) {

  var StrName_Buffer = StrName;

  //Convert to lowercase to for case-insensitive search for Dredd tags
    StrName = StrName.toLowerCase() 
  
  //Initialize the starting point of the search at the end of the string and work backwards
    var vStart = StrName.length
  
  //I know this line layout is unusual, but it is much easier to read with repeating lines:
    if ((StrName.indexOf("_frc") < vStart) && (StrName.indexOf("_frc") > -1)) { vStart = StrName.indexOf("_frc") }
    if ((StrName.indexOf("_nme") < vStart) && (StrName.indexOf("_nme") > -1)) { vStart = StrName.indexOf("_nme") }
    if ((StrName.indexOf("_mny") < vStart) && (StrName.indexOf("_mny") > -1)) { vStart = StrName.indexOf("_mny") }
    if ((StrName.indexOf("_csh") < vStart) && (StrName.indexOf("_csh") > -1)) { vStart = StrName.indexOf("_csh") }
    if ((StrName.indexOf("_url") < vStart) && (StrName.indexOf("_url") > -1)) { vStart = StrName.indexOf("_url") }
    if ((StrName.indexOf("_eml") < vStart) && (StrName.indexOf("_eml") > -1)) { vStart = StrName.indexOf("_eml") }
    if ((StrName.indexOf("_dte") < vStart) && (StrName.indexOf("_dte") > -1)) { vStart = StrName.indexOf("_dte") }
    if ((StrName.indexOf("_tme") < vStart) && (StrName.indexOf("_tme") > -1)) { vStart = StrName.indexOf("_tme") }
    if ((StrName.indexOf("_mil") < vStart) && (StrName.indexOf("_mil") > -1)) { vStart = StrName.indexOf("_mil") }
    if ((StrName.indexOf("_int") < vStart) && (StrName.indexOf("_int") > -1)) { vStart = StrName.indexOf("_int") }
    if ((StrName.indexOf("_dec") < vStart) && (StrName.indexOf("_dec") > -1)) { vStart = StrName.indexOf("_dec") }
    if ((StrName.indexOf("_txa") < vStart) && (StrName.indexOf("_txa") > -1)) { vStart = StrName.indexOf("_txa") }
    if ((StrName.indexOf("_rta") < vStart) && (StrName.indexOf("_rta") > -1)) { vStart = StrName.indexOf("_rta") }
    if ((StrName.indexOf("_rqd") < vStart) && (StrName.indexOf("_rqd") > -1)) { vStart = StrName.indexOf("_rqd") }
  
  //Re-assign the string to restore capitalization
    StrName = StrName_Buffer; //document.forms[Findex].elements[i].name
    var vName = StrName.substring(0, vStart);
  
  //Check for a 3-letter lower-case prefix and strip it off if found.
    if ( (vName.charCodeAt(0) > 90)
      && (vName.charCodeAt(1) > 90)
      && (vName.charCodeAt(2) > 90)
      && (vName.charCodeAt(3) < 91) ) {
        vName = vName.substr(3) // fixed 10/19/2001 TGIL
      }

  //Replace all underscores with spaces
    vName = vName.replace(/_/g," ")

  return vName;
}

function IsValid_Float(i) { // DSHU & TSCH, 7/18/02

  vStr = document.forms[Findex].elements[i].value;

    if( IsValid_DEC( i, vStr ) )
    { 
        vStr = parseFloat( vStr )
        // Next 3 lines modeled after Textarea validation
      vTemp = document.forms[Findex].elements[i].name;
      var U = vTemp.lastIndexOf("_");
      var intNumPlacesAfterDec = vTemp.substr(U+1,vTemp.length-U) * 1;  
        
      if( String(vStr).length - String(vStr).indexOf(".") > intNumPlacesAfterDec + 1 ) {      
        Input_Alert(i,"Only " +  intNumPlacesAfterDec + " digits are allowed after the decimal point.")
        return false; }
      else
        return true;
    } 
}

function Input_Alert(i, vExtraLine)
{
  // Check for existence of Dredd property. If so, use it for the field name in the alert box. (6/12/01 TGIL)
  if (document.forms[Findex].elements[i].Dredd)
    var StrName = new String(document.forms[Findex].elements[i].Dredd);
  else
  {
    var StrName = new String(document.forms[Findex].elements[i].name);
    StrName = MakeElemNameReadable( StrName );
  }
  
  // For Select Lists that are required, show the "text" instead of the "value" property in the alert box.
  if (document.forms[Findex].elements[i].type == "select-one")
    vElementValue = ""  // a select list can only be invalid if it is required and the selection is blank
  else
    vElementValue = document.forms[Findex].elements[i].value
  
  // 6/2/2003 TGIL: Use Dredd_Notify() instead of intrinsic alert() function.
  
  vElementValue = (vElementValue == "" ? "Blank" : vElementValue) // instead of empty quotes, use the word "Blank" if no value.
  
  var svMessage = ""
  if (vElementValue.length > 50)
    svMessage += "The entered value"
  else
    svMessage += "\"<font color=firebrick>" + vElementValue + "</font>\""
  
  svMessage += " is invalid for the field named \"" + StrName + "\".<BR><BR>" + vExtraLine
  
  var vTempLength = (svMessage.length > 500 ? 500 : svMessage.length)
  
  // Determine the size of the dialog box based on the length of the message.
  var vWidth = vTempLength * 1
  var vHeight = 100 + vTempLength * .6
  
  if (vWidth < 400) vWidth = 400
  if (vHeight < 200) vHeight = 200  
  
  //strLeft() Added by TSCH, 3-16-01 to prevent alert boxes that are so large the user can not see the OK button.   
  Dredd_Notify(svMessage,"Width=" + vWidth + "|Height=" + vHeight);

  // 3/24/2005 TGIL: Changed focus code to "try/catch", since some fields were causing errors, even with TSCH's previous code.
  try {
    document.forms[Findex].elements[i].select();
    document.forms[Findex].elements[i].focus();
  } catch(e) {
    // failed to give focus, just ignore
  }
}


function Dredd_Notify(vMessage,vOptions) {
  // added 6/2/2003 TGIL
  
  // default option values
  var vHeight = 160
  var vWidth = 330
  
  
  if (typeof(vOptions) != "undefined") {
  
    // Now loop through all the options and do whatever necessary for each option
    var vOptionValue
    var aOptions = vOptions.split("|")

    for (var i = 0;i<aOptions.length;i++) {
  
      var aOptionPair = aOptions[i].split("=")
      if (aOptionPair.length == 2) {
        vOptionValue = aOptionPair[1]
              
        // Each case is a possible option
        switch (aOptionPair[0].toLowerCase()) {
          case "height":
            vHeight = vOptionValue
            break
          case "width":
            vWidth = vOptionValue
            break
        }
      }
    }
    
  }
  
  var result = showModalDialog(vBaseAddress + "/Notification_Dialog.asp",vMessage,"dialogWidth:" + vWidth + "px;dialogHeight:" + vHeight + "px;scroll:no;help:no;status:no")
  
  return result
}


function strLeft(str, n, vEllipsis )
        /***    Added by TSCH, 3-16-01
                IN: str - the string we are LEFTing
                    n - the number of characters we want to return
                    vEllipsis - An optional continuation mark for missing data, i.e. "..."

                RETVAL: n characters from the left side of the string concatenated with vEllipsis if data is missing
        ***/
        {
                if (n <= 0)     // Invalid bound, return blank string
                        return "";
                else if (n > String(str).length)   // Invalid bound, return
                        return str;                // entire string
                else // Valid bound, return appropriate substring
                        return String(str).substring(0,n) + vEllipsis;
        }
        
        
function Excessive_Integer(vNum) 
/*When passing a user-entered value into SQL, INT values > 999999999
  come back with this error:

Microsoft OLE DB Provider for SQL Server (0x80040E07)
Error converting data type numeric to int. 

TSCH 02/27/03*/
{
if( isNaN(parseInt(vNum)) ) return false;
var vNumber = new Number(vNum);
if (vNumber > 999999999) {
  Dredd_Notify(vNum + ' is too large of an integer');
  return true; }
else
  return false; }
