function tableXML(vTable,vRootNode,vRowNode,vTRKeys,vHiddenField,vOptions){

	//Verify the table exists else ignore
	if(document.all.tags("TABLE").item(vTable) != null){
		//Variables
		var i,j,r;
	
		//Options
		var oForm = "thisForm", oStartRow = 1, oEndRow = 0, vOption_Set;
		if(typeof(vOptions) != 'undefined'){ // Changed from "==" to "!=", TSCH 5/8/02
			var vOption_Array = vOptions.split("|");
			for(i=0;i<vOption_Array.length;i++){
				vOption_Set = vOption_Array[i].split("=");
	
			  switch(vOption_Set[0].toLowerCase()){
					case 'form':
						if(vOption_Set[1] != "") oForm = vOption_Set[1];
						break;
					case 'startrow':
						oStartRow = vOption_Set[1];
						break;
					case 'endrow':
						oEndRow = vOption_Set[1];
						break;
			  }
			}
		}
	
		var vTRKeys_Tags = vTRKeys.split(",");
		var vTRKey_Values;
		var xmlString = "<" + vRootNode + ">", xmlRowStr;
	
		//Get all the TR tags in the passed table.
		var trnode = document.all.tags("TABLE").item(vTable).all.tags("TR");

		if(trnode != null){
	
			var tdnode,inputnode,selectnode, vDate, inputRadioID;
			
			if(oEndRow == 0) oEndRow = trnode.length;
			if(oEndRow > trnode.length) oEndRow = trnode.length;
			
			for(i = oStartRow - 1;i < oEndRow; i++){	//Process all the rows.
				if(trnode[i].id != ""){	//Only process rows with id's
					xmlRowStr = "";
				
					//If Keys are set, create the required tags.
					vTRKey_Values = trnode[i].id.split(",");
					for(j=0;j<vTRKey_Values.length;j++){
						if(vTRKey_Values[j] != "")
							xmlRowStr += "<" + vTRKeys_Tags[j] + ">" + vTRKey_Values[j] + "</" + vTRKeys_Tags[j] + ">";
					}
				
					tdnode = trnode[i].all.tags("TD");	//Get all the TD tags on the row.
					for(j=0;j<tdnode.length;j++){	//Process each TD tag.
				
						if(tdnode[j].id != ""){	//Only process TD tags that have an ID
							xmlRowStr += "<" + tdnode[j].id + ">";	//Add a new tag
								
							inputnode = tdnode[j].all.tags("INPUT");	//Get any INPUT tags in the TD tag.
							if(inputnode.length > 0){	//If there is an INPUT tag process it to get the value to set.
							  if (inputnode.length == 2 && inputnode[0].type == 'text' && inputnode[1].type == 'hidden'){ //see if this is a picker if so use the hidden value
								  xmlRowStr += "<![CDATA[" + inputnode[1].value + "]]>";
							  }else{
								  switch(inputnode[0].type){
								  	case 'text':
								  		//If a date input then set timezone offset
								  		if (inputnode[0].id.toLowerCase().indexOf("_dte") > -1 && inputnode[0].value != "") //check to see if it is a date 
								  			xmlRowStr += "<![CDATA[" + makeSQLDate(inputnode[0].value) + "]]>";
								  	  else 
								  			xmlRowStr += "<![CDATA[" + inputnode[0].value + "]]>";
								  		break;
								  	case 'radio':  //Added code to insert the value of the checked radio into the XML -  JMID 05/25/05
								  	  if (inputnode.length == 1 ){
								  	    if (inputnode[0].checked) xmlRowStr += inputnode[0].value;
								  	  }
								  		else{   //Loop through the radios 
							  	      inputRadioID = inputnode[0].id;
								  	    for(r=0;r<inputnode.length;r++){  //only look at the inputs that are named the same as the first one and are also radios
								  	      if (inputnode[r].checked && inputnode[r].id ==inputRadioID  && inputnode[0].type == 'radio') xmlRowStr += inputnode[r].value;
								  	    }
								  	  }
								  	  break;
								  	case 'checkbox':
								  		if(inputnode[0].checked) xmlRowStr += inputnode[0].value;
								  		break;
								  	case 'hidden':
								  	  xmlRowStr += "<![CDATA[" + inputnode[0].value + "]]>";
								  	  break;
								  }
							  }
							}else {
								//Check for a SELECT list
								selectnode = tdnode[j].all.tags("SELECT");
								if(selectnode.length > 0 ){ 
									if(selectnode[0].selectedIndex > -1)
										xmlRowStr += "<![CDATA[" + selectnode[0].options[selectnode[0].selectedIndex].value + "]]>";
								} else {
									//Add the TD tag HTML.
									if(tdnode[j].innerHTML != "")
										xmlRowStr += "<![CDATA[" + tdnode[j].innerText + "]]>"; //Changed from innerHTML because some special characters were getting parsed out- JMID
								}
							}
									
							xmlRowStr += "</" + tdnode[j].id + ">";	//Close the tag.

						}	//if
					}	//for
				
					//Add XML for the row if we have some data.
					if(xmlRowStr != "") xmlString += "<" + vRowNode + ">" + xmlRowStr + "</" + vRowNode + ">";
				}	//if TR id
			}	//for	all TR
		}	//if TR not null

		xmlString += "</" + vRootNode + ">";	//Close the ROOT level.
	
		if(document.forms(oForm) == null)
			document.body.insertAdjacentHTML("beforeEnd","<form name='" + oForm + "' method='Post' onSubmit='return false'></form>");

		if(document.forms(oForm).item(vHiddenField) == null)
			document.forms(oForm).insertAdjacentHTML("afterBegin","<textarea id='" + vHiddenField + "' name='" + vHiddenField + "' style='display:none;visibility:hidden'>" + xmlString + "</textarea>");
		else
			document.forms(oForm).item(vHiddenField).value = xmlString;	//Write the XML to the hidden input field.
	}
}

function makeSQLDate(vInputDate) {
	var aMonths = ["","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
	var aDateParts, vSQLDate, i
	
	switch (vDateFormat){
		case "usa":
			var aDateParts = vInputDate.split("/");
			vSQLDate = new Date(aDateParts[0] + "/" + aDateParts[1] + "/" + MakeFourDigitYear(aDateParts[2]));
			//return vNewDate;
			break;
		case "euro":
			var aDateParts = vInputDate.split("/");
			vSQLDate = new Date( aDateParts[1] + "/" + aDateParts[0] + "/" + MakeFourDigitYear(aDateParts[2]));
			//return vDate;
			break;
		case "Www/yy":
			aDateParts = vInputDate.split("/");
			aDateParts[0] = aDateParts[0].substr(1) * 1;
			aDateParts[1] = MakeFourDigitYear(aDateParts[1]);
			var maxWeeks = WeekOfYear("12/31/" + aDateParts[1],1);
			// Since the date is returned as the friday of the chosen week, find the first Friday of the year and go from there.
			
			var vCurDate				    
			for (i=1;i<8;i++) {
				vCurDate = new Date("1/" + i + "/" + aDateParts[1]);
				if (vCurDate.getDay() == 5)	break;
			}

			// Now that we found the first Friday, try each Friday date until we find the one currently picked.
			for (i=0;i<375;i+=7) {
				if (WeekOfYear((vCurDate.getMonth()+1) + "/" + vCurDate.getDate() + "/" + vCurDate.getYear(),1) == aDateParts[0]) {
					// Found the week, so use the current date (vCurDate)
					break;
				}
									      
				vCurDate = new Date(vCurDate*1 + 7 * 86400000);  // skip ahead to the next week
								    
				vNewWeek = WeekOfYear((vCurDate.getMonth()+1) + "/" + vCurDate.getDate() + "/" + vCurDate.getYear(),1);
				if (vNewWeek == 0 && i > 14) {
					// This week spills into the next year
					aDateParts[0] = 0;
				}
									      
			}
			vSQLDate = new Date((vCurDate.getMonth()+1) + "/" + vCurDate.getDate() + "/" + MakeFourDigitYear(vCurDate.getYear()));
			//return vDate;
			break ;
		case "dd-mon-yy":
			var aDateParts = vInputDate.split("-")
			// Find the month number
			for (var vMonth=1;vMonth<13;vMonth++){
				if (aMonths[vMonth] == aDateParts[1]) break;
			}
			vSQLDate = new Date(vMonth + "/" + aDateParts[0] + "/" + MakeFourDigitYear(aDateParts[2]));
			//return vDate;
			break;
	}
	vSQLDate = new Date(vSQLDate);
	return vSQLDate.getFullYear() + "-" + (vSQLDate.getMonth() + 1) + "-" + vSQLDate.getDate() + " " + vSQLDate.getHours() + ":" + vSQLDate.getMinutes() + ":" + vSQLDate.getSeconds();
}