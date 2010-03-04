//--------------------------------------------------------------------------------------------
//You must have script tags pointing to Plexus.js, Dates.js to use this file!!!!!!!!!!!!!!!!!!!!!!
//--------------------------------------------------------------------------------------------

//This is where the month range of 0-11 comes in handy...
now = new Date();
var aNumDays = [31,28,31,30,31,30,31,31,30,31,30,31]
vYear = now.getFullYear()
vNextYear = now.getFullYear()

//Set to the previous month by subtracting one
vMonth = now.getMonth() - 1

//Make if the previous month is December, then make month 11 and subtract one from the year
if (vMonth < 0) {
	vMonth = 11;
	vYear--;
}

//Determine if a leap year
if (vYear % 4 == 0) {
     if ( ( vYear % 100 == 0 ) && (vYear % 400 != 0) ) {
          //Not a leap year! Do nothing.
     }
     else
     {
          aNumDays[1]++  //Is a leap year! Add one to February's day count
     }
}

//We need to know the number of days in the previous month just in case somebody views the previous month
vMonthDays = aNumDays[vMonth]
//We need to know the number of days in the current month just in case somebody views the current month
vCurrMonthDays = aNumDays[vMonth + 1]

if( vMonth == 10 )
{
    vNextMonthDays = aNumDays[0]
}
else
{
    
    vNextYear++
    if (vNextYear % 4 == 0) 
    {
      if ( ( vNextYear % 100 == 0 ) && (vNextYear % 400 != 0) ) {
           //Not a leap year! Do nothing.
      }
      else
      {
           aNumDays[1]++  //Is a leap year! Add one to February's day count
      }
    }
    vNextMonthDays = aNumDays[vMonth + 2]
}

function plDateElemChange() { plSelectBytext( RangeListBox, '' ); }

//We have to find the list box that contains the ranges.
//It is the list box whose onChange calls plSetDateRange
var RangeListBox = null;
function plAssignRangeElem() {
for(var i=0; i<document.thisForm.length; i++)
  if( document.thisForm.elements[i].type.indexOf("select") > -1 )
    if(document.thisForm.elements[i].onchange) {
      var vOnChange = new String(document.thisForm.elements[i].onchange);
      if(vOnChange.indexOf("plSetDateRange") > -1 ) { RangeListBox = document.thisForm.elements[i]; return; } 
        }
}

function plSetDateRange( vStartFormElemName, vEndFormElemName, Range ) // This should be called for initialization onLoad of the page
{

//This code applies an Onchange event to the Date Elements, this is necessary so that the listbox of logical date ranges does not conflict
//with the manually set date ranges, TSCH 11/14/02
  if(RangeListBox == null) plAssignRangeElem();
  document.thisForm.item(vStartFormElemName).onchange = plDateElemChange;
  document.thisForm.item(vEndFormElemName).onchange = plDateElemChange;

  var vStartElem = document.thisForm.item(vStartFormElemName);
  var vEndElem = document.thisForm.item(vEndFormElemName);
	var vTodaysDate = (now.getMonth() + 1) + "/" + now.getDate() + "/" + now.getFullYear();
	//You can find another date by adding or subtracting the number of milliseconds from the original date.
	//There are 86400000 milliseconds in a day. In order for Javascript to calculate properly,
	//you must multiply the current date by 1 to convert it to a number first. I don't know why, but you just do.
	
  switch(Range) 
  {
    case 'Today':
      vStartElem.value = vTodaysDate;
      vEndElem.value = vTodaysDate;
      break
    case 'Yesterday':    
			vYesterday = new Date(now * 1 - 86400000)
      vStartElem.value = (vYesterday.getMonth() + 1) + "/" + vYesterday.getDate() + "/" + vYesterday.getFullYear();
      vEndElem.value = (vYesterday.getMonth() + 1) + "/" + vYesterday.getDate() + "/" + vYesterday.getFullYear();      
			break;
    case 'CurrentWeek':
			vWeekStart = new Date(now * 1 - 86400000*now.getDay())
			vWeekEnd = plDayAdd(vWeekStart, 6); //Set vWeekEnd to 6 days later, i.e. Sunday
      vStartElem.value = (vWeekStart.getMonth() + 1) + "/" + vWeekStart.getDate() + "/" + vWeekStart.getFullYear();
      vEndElem.value = (vWeekEnd.getMonth() + 1) + "/" + vWeekEnd.getDate() + "/" + vWeekEnd.getFullYear();
      break;
    case 'PreviousWeekMonday':
      now = new Date();
      vWeekStart = plDayAdd(now, -1*(7+(now.getDay()-1))); //Set vWeekStart to previous Monday
      vWeekEnd = plDayAdd(vWeekStart, 6); //Set vWeekEnd to 6 days later, i.e. Sunday
      vStartElem.value = (vWeekStart.getMonth() + 1) + "/" + vWeekStart.getDate() + "/" + vWeekStart.getFullYear();
      vEndElem.value = (vWeekEnd.getMonth() + 1) + "/" + vWeekEnd.getDate() + "/" + vWeekEnd.getFullYear();
      break;
    case 'PreviousWeek':
			vWeekStart = new Date(now * 1 - 86400000 * now.getDay() - 7 * 86400000)	//Subtract another 7 days worth for previous week
			vWeekEnd = new Date(now * 1 + 86400000 * (-1 - now.getDay()))	//-1 comes from 6 (Saturday) - 7 days for previous week
      vStartElem.value = (vWeekStart.getMonth() + 1) + "/" + vWeekStart.getDate() + "/" + vWeekStart.getFullYear();
      vEndElem.value = (vWeekEnd.getMonth() + 1) + "/" + vWeekEnd.getDate() + "/" + vWeekEnd.getFullYear();
      break;
    case 'CurrentMonth':
      vStartElem.value = (now.getMonth() + 1) + "/1/" + now.getFullYear();
      vEndElem.value = (now.getMonth() + 1) + "/" + aNumDays[now.getMonth()] + "/" + now.getFullYear();
      break;
    case 'PreviousMonth':
			vStartElem.value = (vMonth + 1) + "/1/" + vYear
			vEndElem.value = (vMonth + 1) + "/" + vMonthDays + "/" + vYear
      break;
    case 'YearToDate':
      vStartElem.value = "1/1/" + now.getFullYear();
      vEndElem.value = vTodaysDate;
      break;
    case 'Previous30Days':
      vWeekStart = new Date(now * 1 - 30 * 86400000)	//Subtract another 30 days worth for start
      vStartElem.value = (vWeekStart.getMonth() + 1) + "/" + vWeekStart.getDate() + "/" + vWeekStart.getFullYear();
      vEndElem.value = vTodaysDate;
      break;
    case 'Previous60Days':
      vWeekStart = new Date(now * 1 - 60 * 86400000)	//Subtract another 60 days worth for start
      vStartElem.value = (vWeekStart.getMonth() + 1) + "/" + vWeekStart.getDate() + "/" + vWeekStart.getFullYear();
      vEndElem.value = vTodaysDate;
      break;
    case 'Previous90Days':
      vWeekStart = new Date(now * 1 - 90 * 86400000)	//Subtract another 90 days worth for start
      vStartElem.value = (vWeekStart.getMonth() + 1) + "/" + vWeekStart.getDate() + "/" + vWeekStart.getFullYear();
      vEndElem.value = vTodaysDate;
      break;
    case 'PreviousYear':
      vStartElem.value = "1/1/" + (now.getFullYear() - 1);
      vEndElem.value = "12/31/" + (now.getFullYear() - 1);
      break;
    case 'BackOneYear':
      vStartElem.value = (now.getMonth()+1) + "/" + now.getDate() + "/" + (now.getFullYear() - 1);
      vEndElem.value = vTodaysDate;
      break;
    case 'MonthBeginToMonthEnd':
      vStartElem.value = (now.getMonth() + 1) + "/1/" + now.getFullYear();
      vEndElem.value = (now.getMonth() + 1) + "/" + vCurrMonthDays + "/" + now.getFullYear();
      break;
    case 'YearBeginToYearEnd':
      vStartElem.value = "1/1/" + (now.getFullYear() - 1);
      vEndElem.value = "12/31/" + (now.getFullYear() - 1);    
      break;   
    case 'Next30Days':
        vWeekStart = new Date(now * 1 + 30 * 86400000)	//add 30 days //actually Week End
        vStartElem.value = vTodaysDate;
        vEndElem.value = (vWeekStart.getMonth() + 1) + "/" + vWeekStart.getDate() + "/" + vWeekStart.getFullYear();
        break;        
    case 'NextMonth':
        vStartElem.value = (now.getMonth() + 2) + "/1/" + vNextYear
        vEndElem.value = (now.getMonth() + 2) + "/" + vNextMonthDays + "/" + vNextYear
        break;        
    case 'NextYear':
      vStartElem.value = "1/1/" + (now.getFullYear() + 1);
      vEndElem.value = "12/31/" + (now.getFullYear() + 1);    
      break;
  }
  if (Range > '') {
      vStartElem.value = Customer_Date(new Date(vStartElem.value));
      vEndElem.value = Customer_Date(new Date(vEndElem.value)); }
      
}