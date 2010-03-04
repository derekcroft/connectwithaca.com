// This function takes a date string and returns a date object,
// useful for comparing to another date object.
// It needs to be finished to handle all POL date formats,
// based on vDateFormat assigned in plEuroDate()
function Standard_Date(vInput) {
  var aMonths = ["","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  var svDate = vInput;
  var svTime;
	var oDate;
	var i;
	
	if (vInput.indexOf(" ") > -1) {
	  var svDate = vInput.substr(0,vInput.indexOf(" "));
	  var svTime = vInput.substr(vInput.indexOf(" ") + 1);
  }
  
	switch (vDateFormat)
	{
	  case "usa":
	    svDate = Date_Slashify(svDate);
	    var aNewDate = svDate.split("/")
      oDate = new Date(aNewDate[0] + "/" + aNewDate[1] + "/" + MakeFourDigitYear(aNewDate[2]))
		  break
	  case "euro":
	    svDate = Date_Slashify(svDate);
		  var aParts = svDate.split("/")
			oDate = new Date( aParts[1] + "/" + aParts[0] + "/" + MakeFourDigitYear(aParts[2]))
	    break
	  case "Www/yy":
		  aDate = svDate.split("/")
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
			oDate = new Date((vCurDate.getMonth()+1) + "/" + vCurDate.getDate() + "/" + MakeFourDigitYear(vCurDate.getYear()) )
	    break  
	  case "dd-mon-yy":
      var aParts = svDate.split("-")
	    // Find the month number
			for (var vMonth=1;vMonth<13;vMonth++) 
			{
				if (aMonths[vMonth] == aParts[1])
			  break
			}
			oDate = new Date(vMonth + "/" + aParts[0] + "/" + MakeFourDigitYear(aParts[2]))
				
	    break
	}
	
	// 10/20/2004 TGIL: Check for included time.
	// svTime must be in format HH:MM or HH:MM AM
	if (vInput.indexOf(" ") > -1) {
	  var svTime = vInput.substr(vInput.indexOf(" ") + 1);
    var aTime = svTime.split(":");
    var svAMPM = "";
    // check the input for AM/PM
    if (aTime[1].indexOf(" ") > -1) {
      svAMPM = aTime[1].substr(aTime[1].indexOf(" ") + 1).toLowerCase();
      aTime[1] = aTime[1].substr(0,aTime[1].indexOf(" "));
      if (svAMPM == "pm")
        aTime[0] = (aTime[0] * 1) + 12;
    }
    // Add the hours and minutes
    oDate = new Date(oDate * 1 + aTime[0] * 3600000 + aTime[1] * 60000);
  }
  return oDate;
}

function Date_Slashify(svDate) {
	if ( ( (svDate.length == 8) || (svDate.length == 6) ) && (svDate.indexOf("/") == -1))
		svDate = svDate.substring(0,2) + "/" + svDate.substring(2,4) + "/" + svDate.substring(4,svDate.length);
  return svDate;
}


// This function takes a date object and returns a customer date string,
// It needs to be finished to handle all POL date formats,
// based on vDateFormat assigned in plEuroDate()
function Customer_Date(vInput) {
  var aMonths = ["","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
	var vDate
  var vYear
	
	vYear = new String(vInput.getFullYear())
	vYear = vYear.substr(2,2)
	    
	switch (vDateFormat)
	{
	  case "usa":
			vDate = (vInput.getMonth() + 1) + "/" + (vInput.getDate()) + "/" + (vYear)
		  return vDate
		  break
	  case "euro":
			vDate =  (vInput.getDate()) + "/" + (vInput.getMonth() + 1) + "/" + (vYear)
			return vDate
	    break
	  case "Www/yy":
		  var vWeek
		  vWeek = WeekOfYear((vInput.getMonth()+1) + "/" + vInput.getDate() + "/" + vInput.getYear(),1)
			vDate = "W" + vWeek + "/" + vYear
			return vDate
	    break  
	  case "dd-mon-yy":
	    var vStrDate
	    
	    vDate = (vInput.getDate()) + "-" + aMonths[(vInput.getMonth() + 1)] + "-" + (vYear)
			return vDate
	    break
	}
	
}

// Created 2/21/02 MHAT
// This function will return the last day of the month, for the month of the date which is supplied.
function getLastDOM(inputDate) 
{
  var vMonth = inputDate.getMonth() + 2
  var vYear = inputDate.getFullYear()

  if (vMonth > 12) {
  	vYear++
  	vMonth-=12
  }

  var lastDOM = new Date(vMonth + "/1/" + vYear)
  lastDOM.setTime(lastDOM - 86400000)
  
/*
  // old code before 11/13/2003
	var lastDOM = new Date(inputDate)
	lastDOM.setTime(lastDOM.getTime() + ((32 - lastDOM.getDate()) * 86400000) );
	lastDOM.setTime(lastDOM.getTime() - (lastDOM.getDate() * 86400000) );
*/
	return lastDOM;
}


// Created 5/1/2002 TGIL
// Return the number of days between two dates
function DayDiff(vDate1,vDate2) { //Now accomodating Date objects and date strings, TSCH 7/30/02

  if( typeof vDate1 == "object" )
    var vDiff = (vDate2 - vDate1)
  else
    var vDiff = (Standard_Date(vDate2) - Standard_Date(vDate1)); 
    
  return Math.round(vDiff/86400000)}
  
function plMonthDiff(vDate1,vDate2) { //TSCH 01/24/03

  if( typeof vDate1 != "object" ) vDate1 = Standard_Date(vDate1);
  if( typeof vDate2 != "object" ) vDate2 = Standard_Date(vDate2);
  
  var vDiff = vDate2.getMonth() - vDate1.getMonth();
  var vDiff = vDiff*1 + 12*(vDate2.getFullYear() - vDate1.getFullYear());
  return vDiff;
}

function plDateAdd(startDate, numDays, numMonths, numYears) {

	var returnDate = new Date(startDate.getTime());
	var yearsToAdd = numYears;
	
	var month = returnDate.getMonth()	+ numMonths;
	if (month > 11) {
		yearsToAdd = Math.floor((month+1)/12);
		month -= 12*yearsToAdd;
		yearsToAdd += numYears; }
	returnDate.setMonth(month);
	returnDate.setFullYear(returnDate.getFullYear()	+ yearsToAdd);
	
	returnDate.setTime(returnDate.getTime()+60000*60*24*numDays);
	
	return returnDate; }

function plYearAdd(startDate, numYears) {
  return plDateAdd(startDate,0,0,numYears); }

function plMonthAdd(startDate, numMonths) {
  return plDateAdd(startDate,0,numMonths,0); }

function plDayAdd(startDate, numDays) {
  return plDateAdd(startDate,numDays,0,0); }