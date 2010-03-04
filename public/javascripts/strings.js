//From: http://www.4guysfromrolla.com/webtech/vb2java.shtml
//More similar functions at: http://guille.costasol.net/html_ejemplos/vb2js.htm and http://www.planet-source-code.com/xq/ASP/txtCodeId.382/lngWId.7/qx/vb/scripts/ShowCode.htm
      
//Left(string, length): Returns a specified number of characters from the left side of a string.
function Left(str, n){
  if (n <= 0)     // Invalid bound, return blank string
          return "";
  else if (n > String(str).length)   // Invalid bound, return
          return str;                // entire string
  else // Valid bound, return appropriate substring
          return String(str).substring(0,n);
}

//Right(string, length): Returns a specified number of characters from the right side of a string.
function Right(str, n) {
  if (n <= 0)     // Invalid bound, return blank string
     return "";
  else if (n > String(str).length)   // Invalid bound, return
     return str;                     // entire string
  else { // Valid bound, return appropriate substring
     var iLen = String(str).length;
     return String(str).substring(iLen, iLen - n);
  }
}

//Mid(string, start, length): Returns a specified number of characters from a string.
function Mid(str, start, len) {
        // Make sure start and len are within proper bounds
        if (start < 0 || len < 0) return "";

        var iEnd, iLen = String(str).length;
        if (start + len > iLen)
                iEnd = iLen;
        else
                iEnd = start + len;

        return String(str).substring(start,iEnd);
}
// Keep in mind that strings in JavaScript are zero-based, so if you ask
// for Mid("Hello",1,1), you will get "e", not "H".  To get "H", you would
// simply type in Mid("Hello",0,1)

// You can alter the above function so that the string is one-based.  Just
// check to make sure start is not <= 0, alter the iEnd = start + len to
// iEnd = (start - 1) + len, and in your final return statement, just
// return ...substring(start-1,iEnd)


//Len(String) : Returns the number of characters in a string
function Len(str){ 
  return String(str).length;
}

function InStr(str, SearchForStr){ 

	if ( Len(SearchForStr) == 0 )
		return 0
	else
		return str.indexOf(SearchForStr) + 1; } //Implemented by TSCH 8/25/01 as a replaced for commented out code below. This implementation searches for substrings, not chars and returns at least 1 for a find, thus it is closer to the VBscript InStr()

/*
// InStr(str, SearchForStr) : Returns the location a character (charSearchFor)was found
// in the string str.  If not found then -1 returned.
function InStr(strSearch, charSearchFor){
	for (i=0; i < Len(strSearch); i++)	{
	  if (charSearchFor == Mid(strSearch, i, 1)) {
	  return i;
	  }
	}
	return -1;
}
*/

//Trim(string) : Returns a copy of a string without leading or trailing spaces.
function Trim(str) {
  return RTrim(LTrim(str));
}


//LTrim(string) : Returns a copy of a string without leading spaces.
function LTrim(str) {
  var whitespace = new String(" \t\n\r");

  var s = new String(str);

  if (whitespace.indexOf(s.charAt(0)) != -1) {
    // We have a string with leading blank(s)...

    var j=0, i = s.length;

    // Iterate from the far left of string until we
    // don't have any more whitespace...
    while (j < i && whitespace.indexOf(s.charAt(j)) != -1)
        j++;

    // Get the substring from the first non-whitespace
    // character to the end of the string...
    s = s.substring(j, i);
  }

  return s;
}


//RTrim(string) : Returns a copy of a string without trailing spaces.
// We don't want to trip JUST spaces, but also tabs,
// line feeds, etc.  Add anything else you want to
// "trim" here in Whitespace
function RTrim(str) {
  var whitespace = new String(" \t\n\r");
  var s = new String(str);

  if (whitespace.indexOf(s.charAt(s.length-1)) != -1) {
      // We have a string with trailing blank(s)...

    var i = s.length - 1;       // Get length of string

    // Iterate from the far right of string until we
    // don't have any more whitespace...
    while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1)
        i--;

    // Get the substring from the front of the string to
    // where the last non-whitespace character is...
    s = s.substring(0, i+1);
  }

  return s;
}

//Replace( string, target, replacement ) : Returns a string after the VBScript-style replace conducted on all instances of 'target' found in a case insensitive search of 'string.'
//TSCH, 6/19/01
function Replace( string, target, replacement ) {

	var s = new String(string);
	var r = new RegExp(target,"gi");
	s = s.replace( r, replacement );
	
	return s;
}

function LCase( string ) {
	var s = new String(string);
	return s.toLowerCase();
}

function UCase( string ) {
	var s = new String(string);
	return s.toUpperCase();
}


// Created: 10/19/2001 by TGIL for RHAR
// Purpose: Create a querystring value of name-value pairs of filter values,
//          to be used on a report page to display the filter values used to generate the report.
function Filter_Name_Value_Pairs() {
  var fltStr = new String()
  // Search all form elements for filter elements
  for (var i=0;i<document.thisForm.elements.length;i++) {
    var elName = new String(document.thisForm.elements[i].name.toLowerCase())
    if (elName.indexOf("flt") != -1 && document.thisForm.elements[i].type != "hidden") {
      // Found a filter element
      // Check for existence of Dredd property. If so, use it for the field name.
      if (document.thisForm.elements[i].Dredd)
	      var strName = new String(document.thisForm.elements[i].Dredd);
	    else
	    {
	      var strName = new String(document.thisForm.elements[i].name);
	      strName = MakeElemNameReadable( strName );
	    }
      var strVal
      if (document.thisForm.elements[i].type == "radio" || document.thisForm.elements[i].type == "checkbox") {
        // Radio or checkboxes get their value based on the "checked" property
        if (document.thisForm.elements[i].checked)
          strVal = "Yes"
        else
          strVal = "No"
      }
      else if (document.thisForm.elements[i].type.indexOf("select") > -1) {
        // for select lists, use the text property instead of the value property
        var sel = document.thisForm.elements[i].selectedIndex
        strVal = document.thisForm.elements[i].options[sel].text
      }
      else
        strVal = document.thisForm.elements[i].value
      
      // If the value is blank, make it a single space, otherwise request.querystring will not pick it up.
      strVal = (strVal == "" ? " " : strVal)
      
      // If there is already a value in the string, add a pipe first to separate the new pair being added
      if (fltStr.length > 0)
        fltStr += "|"
        
      fltStr += strName + "=" + strVal
    }
  }
  
  // Replace ampersands with our own encoded value that will need to be replaced on the receiving page.
  fltStr = fltStr.replace(/[&]/gi,"*amp*")
  
  if (fltStr.length > 0)
    fltStr = "Filter=" + fltStr
    
  return fltStr
}

function FormatCurrency(valuein) { //TSCH 5/7/02 form a JavaScript list posting
  valuein = valuein.toString(); //TSCH 5/7/02. This is necessary for when numeric values are passed in, but harmless on Strings
  var formatStr = "";
  var dollarSign = "$"; // Note this could be dynamic based on PCN's Currency_Key
  var decipos = valuein.indexOf(".");
  if (decipos==-1) decipos = valuein.length;
  var dollars = valuein.substring(0,decipos);
  var Outdollars = "";
  var dollen = dollars.length;
  if (dollen > 3) {
      while (dollen>0) {
            tDollars=dollars.substring(dollen-3, dollen)
                    if (tDollars.length==3) {
                            Outdollars=","+tDollars+Outdollars
                            dollen=dollen-3;
                    } else {
                            Outdollars=tDollars+Outdollars
                            dollen=0
                    }
      }
           if (Outdollars.substring(0, 1)==",")
                    dollars=Outdollars.substring(1, Outdollars.length)
            else
                    dollars=Outdollars
  }

  var cents = valuein.substring(decipos+1, decipos+3);
  if (cents == "") cents = "00";
  if (cents.length == 1) cents = cents + "0"; // TSCH 5/7/02
  var formatStr = dollarSign + dollars + "." + cents;
  return formatStr;
}


function jsReplace_Querystring(vURL,vQueryString,vValue) {
  // Created: 8/18/2002 TGIL
  // This is a direct javascript translation of the VBscript function strReplace_Querystring in SSI/Strings.asp
  
  var vReplace_QueryString
  
	if (vQueryString + vValue == "") 
		vReplace_QueryString = vURL
	else if (vURL != "") {    // prevent type mismatch errors if the incoming URL is blank
		var i, aURL
		aURL = vURL.split("?")  // separate the querystring into its own string
		if (aURL.length == 1)
		  aURL[1] = ""    // No querystring, so manually set the variable for it
  
		if (aURL[1] == "") {
			if (vValue == "!") {
				return aURL[0]
			} else {
				vReplace_QueryString = aURL[0] + "?" + vQueryString + "=" + vValue
			}
		} else {
			var aURL2, aURL2Idx, vFound
			vFound = false
			aURL2 = aURL[1].split("&")
			for (aURL2Idx = 0;aURL2Idx < aURL2.length;aURL2Idx++) {
				if (aURL2[aURL2Idx].toLowerCase().indexOf(vQueryString.toLowerCase() + "=") == 0) {
					vFound = true
					if (vValue == "!")
						aURL2[aURL2Idx] = ""
					else		
						aURL2[aURL2Idx] = vQueryString + "=" + vValue
				}
			}
			vReplace_QueryString = aURL[0]         // Start with Filename
			var vFound2
			vFound2 = false
			for (aURL2Idx = 0;aURL2Idx < aURL2.length;aURL2Idx++) {
			  if (aURL2[aURL2Idx] != "") {  // We have a value
				  if (!vFound2) vReplace_QueryString += "?"                 // Add "?" before first undeleted QueryString name-value pair
				  if (vFound2)  vReplace_QueryString += "&"                 // Add "&" before non-first undeleted QueryString name-value pair
				  vFound2 = true
				  vReplace_QueryString += aURL2[aURL2Idx]                   // Add undeleted QueryString name-value pair
			  }
			}
		  if (!vFound && vValue != "!")
		    vReplace_QueryString += "&" + vQueryString + "=" + vValue   // Add unadded name-value pair, if necessary
		}
  }
    
	vReplace_QueryString = vReplace_QueryString.replace(/\?&/g,"?") // We do not want this condition and believe it prevented, but this is a safety net.
  return vReplace_QueryString
}

function plIsInList(list,find,delimiter) {

  var strList = new String(list);
  var strFind = new String(find);
  var aListArray = new Array();

  if ( typeof(delimiter) == 'undefined' ) delimiter = ',';
  aListArray = strList.split(delimiter);
  
  for(i=0;i<aListArray.length;i++)
    if (aListArray[i] == strFind) return true;
	
	return false; }

function isnull( vParam1, vParam2 ) { //TSCH 10/03/2002

  if( !vParam2 ) 
    return (vParam1 == null)
  else
    return (vParam1 == null) ? vParam2 : vParam1;
}

function Make_Form_Chunks(oField,oForm) {
  // 1/10/2005 TGIL
  // Divides a single field into multiple fields, to allow lengths of more than 102399 to be posted in a single field.
  // Use plJoin_Form_Chunks() instead of Request.Form() to get the values on the posted page.
  if (oForm == null) oForm = document.forms[0]
  var vFormLimit = 102399
  var vTemp = new String(oField.value)
  
  if (vTemp > vFormLimit) {
    oField.value = vTemp.substr(0,vFormLimit)
    vTemp = vTemp.substr(vFormLimit)  // Store the remaining string in the vTemp variable
    
    while (vTemp.length > 0) {
      var objTEXTAREA = document.createElement("TEXTAREA")
      objTEXTAREA.name = oField.name
      objTEXTAREA.value = vTemp.substr(0,vFormLimit)
      oForm.appendChild(objTEXTAREA)
      
      vTemp = vTemp.substr(vFormLimit)  // Store the remaining string in the vTemp variable
    }
  }
}
