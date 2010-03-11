var defaultEmptyOK = false;
var decimalPointDelimiter = ".";

function mathRound( vValue, vTrailingZeroes, vScale ) {

// rounds vValue to vScale decimal places, defaults to 2 places with trailing zeroes. TSCH, 5/29/01
//In IE 5.5+ We can do this: vValue.toFixed(vScale)

vScale = (isNaN(vScale) ? 2 : vScale);  // changed "!vScale" to "isNaN(vScale)" so a value of 0 works properly. 6/27/2001 TGIL

var vStr = new String(vValue);
if (vStr.indexOf(".") > -1) { // TSCH Memorial Day, 2003. Only call Math.round if we need it.
	var vArray = vStr.split(".");
	if (vArray[1].length > vScale)
    vValue = Math.round(vValue*Math.pow(10,vScale))/Math.pow(10,vScale); //We now have the rounded value, minus any trailing zeroes
}

vStr = new String(vValue); // TSCH 10/02/03

if (vStr.indexOf(".") > -1) { // TSCH Memorial Day, 2003. If necessary trim the result of the Math.round output back to the number of required decimal places
	var vArray = vStr.split(".");
	vStr = vArray[0];
	vStr += ".";
	if (vArray[1].length < vScale)
	  vStr += vArray[1]
	else
	  vStr += vArray[1].substr(0,vScale); }

if (vTrailingZeroes) {
	if (vStr.indexOf(".") > -1) {
		var vInt = vStr.substr(0,vStr.indexOf("."));
		var vDec = vStr.substr(vStr.indexOf(".") + 1,vStr.length - vStr.indexOf("."));
		for (var i = vDec.length; i < vScale; i++)
			vDec += "0";
		vStr = vInt + "." + vDec;
	}
	else { //No zeroes padded on end
		if (vScale > 0) { //If vScale = 0, this is just an Integer w/no decimals
		vStr = vStr + ".";
		for (var i = 0; i < vScale; i++)
			vStr += "0"; }
	}
					
	vValue = vStr
}

return vValue;
}

function IsBase2( vValue ) { return (Math.floor(mathRound( log2( vValue ), false, 4 )) == Math.ceil(mathRound( log2( vValue ), false, 4 ))) } //Verifies vValue is a power of 2, TSCH 7/26/01

function log2( vValue ) { return Math.LOG2E * Math.log(vValue); } //Returns base-2 logarithm, TSCH 7/26/01

// TSCH will finish, 7/29/01
function GCF( vNum1, vNum2, vNum3 ){
if (typeof vNum3 == "undefined") vNum3 = vNum2; //Third param is optional

var max1=Math.max(vNum1,vNum2);
var max2=Math.max(max1,vNum3);
for (i=-max2;i<=max2;i=i+1){
var a=vNum1/i
var b=Math.floor(a)
var c=a-b
if (c==0)
  var first=1
else
  var first=0;

var a=vNum2/i;
var b=Math.floor(a);
var c=a-b;
if (c==0)
  var second=1
else
  var second=0;

var a=vNum3/i;
var b=Math.floor(a);
var c=a-b;

if (c==0)
  var third=1
else
  var third=0;

if ((first==1)&&(second==1)&&(third==1)) return i;

}
}

function isInteger (s) // One of many useful validation functions found at: developer.netscape.com/docs/examples/javascript/formval/overview.html

{   var i;

    // Search through string's characters one by one
    // until we find a non-numeric character.
    // When we do, return false; if we don't, return true.

    for (i = 0; i < s.length; i++)
    {   
        // Check that current character is number.
        var c = s.charAt(i);

        if (!isDigit(c)) return false;
    }

    // All characters are numbers.
    return true;
}


function isDigit (c){ return ((c >= "0") && (c <= "9")) }

function isDelimitedIntegers (s,vDelimiter)

{   var i;

    // Search through string's characters one by one
    // until we find a non-numeric character that is not the delimiter.
    // When we do, return false; if we don't, return true.

    for (i = 0; i < s.length; i++)
    {   
        // Check that current character is number.
        var c = s.charAt(i);
        
        if( c != " ")
          if( c != vDelimiter)
            if (!isDigit(c)) return false;
    }

    // All characters are numbers or the delimiter.
    return true;
}

function isFloat (s) {
    var seenDecimalPoint = false;

    if (s == "") return defaultEmptyOK;
    if (s == decimalPointDelimiter) return false;

    // Search through string's characters one by one
    // until we find a non-numeric character.
    // When we do, return false; if we don't, return true.
 
    var i = 0;
    if (s.charAt(0) == "-") i = 1; //If lead characted is negative sign, start at next char TSCH 11/22/03
 
    for (i; i < s.length; i++) { // Check that current character is number.
        var c = s.charAt(i);
        if ((c == decimalPointDelimiter) && !seenDecimalPoint) 
          seenDecimalPoint = true;
        else 
          if (!isDigit(c)) return false; }
    
    return true; // All characters are numbers.
}

var vInValidValue;
function isDelimitedFloats (s,vDelimiter,vMaxScale) {
//alert(1)
  if ( s == "" ) return true;
//alert(2)
  if ( s.indexOf(vDelimiter) == -1 ) 
    return ( 
              ( isFloat(s) ) 
            && 
              ( vMaxScale >= floatScale(s) )
            );
//alert(3)
  var a = s.split(vDelimiter);
//alert(( (isFloat(a[0])) && (vMaxScale >= floatScale(a[0])) ))
  for (var i = 0; i < a.length; i++)
    if(!
          ( (isFloat(a[i])) && (vMaxScale >= floatScale(a[i])) )
    ) {
      vInValidValue = a[i]; 
      return false; }
//alert(4)
  return true;
}

function floatScale( f ) {

  if (isInteger(f)) return 0;

  if (!isFloat(f)) return null;
  
  var a = f.split(decimalPointDelimiter);
  
  var s = new String( a[1] )
  return s.length

}

function cFormat(vValue,vDecimal) { 
//
// Format a number with user-specified number of decimals and commas
//
  vValue = Math.round(vValue*100)/100;
  
	var str = vValue.toString();
	var decimal = str.indexOf(".");
	var i;
	
	if (decimal > -1) 
	{
		dif = str.length - decimal;
		while (dif < vDecimal + 1) 
		{
			str = str + "0";
			dif = str.length - decimal;
		}
		if ((str.length - decimal) > vDecimal + 1) 
		{
			str = str.substring(0, decimal + vDecimal + 1);
		}
	}
	else 
	{
		if (vDecimal > 0)
		{
			str = str + ".";
			i = 1;
			while (i < vDecimal + 1)
			{
				str = str + "0";
				++i
			}
		}
	}
	
	var whole = str.substr(0,str.length - 3)
  var pos = whole.length - 1

	str = str.substr(str.length - 3, 3)
  i = 0
  while (pos >= 0) {
    str = whole.substr(pos,1) + str
    --pos
    
    // 12/07/01 MSTO Added '=' to pos >= 0 to add comma for millions.
    if ( (pos >= 0) && (whole.substr(pos,1) != "-") && str.indexOf(".")>0 ) { // Only add comma if there are more numbers (and not a negative sign)
      ++i
      if (i == 3) {
        i = 0
        str = ',' + str
      }
    }
  }	
	return str;
}

function cNum(vValue) {
//
// Convert any string to a true number/decimal.
//
  vValue = vValue.replace(/[$]/g,"");
  vValue = vValue.replace(/[,]/g,"");
  vValue*=1
	return vValue;
}

function Scale_Get( svValue ) { //Finds scale of already validated decimal value
  var ivDecimalPlace = svValue.indexOf('.');
  if (ivDecimalPlace > -1)
    return svValue.length - (ivDecimalPlace+1)
  else
    return 0; }