var ivFormIndex = 0;

function Get_New_Form_Elements()
  {var i, vName, vVarName;
  for (i=0; i < document.forms[ivFormIndex].length; i++)
    {vName = document.forms[ivFormIndex].elements[i].name;	 
		vVarName = "v" + vName;
		eval("if (typeof(" + vVarName + ")=='undefined')Element_Value(" + i + ")")}  
  }

function Get_Form_Elements()
  {var i;
   for (i=0; i < document.forms[ivFormIndex].length; i++)
     {Element_Value(i)}
  }

function Element_Value(i)
  {var vType, vName, vVarName, sel;
  vType = document.forms[ivFormIndex].elements[i].type;
  vName = document.forms[ivFormIndex].elements[i].name;
  vVarName = "v" + vName;

  if (document.forms[ivFormIndex].elements[i].Revision != "false")  // don't do fields if specifically told not to.
    {
    switch(vType.toLowerCase())
      {
      case "text":
        eval("if (document.forms[ivFormIndex]." + vName + "){" + vVarName + "=document.forms[ivFormIndex]." + vName + ".value}")
	    	break;
	    case "select-one":
        eval("if (document.forms[ivFormIndex]." + vName + "){sel = document.forms[ivFormIndex]." + vName + ".selectedIndex; if (sel > -1) " + vVarName + " = document.forms[ivFormIndex]." + vName + ".options[sel].text; else " + vVarName + " = ''}")
	    	break;							
	    case "radio":
        eval("if (document.forms[ivFormIndex].elements[i].RevisionValue && document.forms[ivFormIndex].elements[i].checked){" + vVarName + "=document.forms[ivFormIndex].elements[i].RevisionValue;}")        
	    	break;
	    case "textarea":
        eval("if (document.forms[ivFormIndex]." + vName + "){" + vVarName + "=document.forms[ivFormIndex]." + vName + ".value}")
	    	break;
      case "checkbox":
        eval("if (document.forms[ivFormIndex]." + vName + "){" + vVarName + "=document.forms[ivFormIndex]." + vName + ".checked}")
        break;
	    case "hidden":
	      // only do hidden fields if specifically told to
	      if (document.forms[ivFormIndex].elements[i].Revision == "true")
          eval("if (document.forms[ivFormIndex]." + vName + "){" + vVarName + "=document.forms[ivFormIndex]." + vName + ".value}")
	    	break;
	    }
	  }
  }

function Verify_Form_Elements()
  {var i;
  vRevisions = '';
  vOriginalValues = '';

  for (i=0; i < document.forms[ivFormIndex].length; i++)
    {Element_Change(i)}

  if (vOriginalValues > "")
    {vOriginalValues = vOriginalValues.slice(0,(vOriginalValues.length - 2));
    document.forms[ivFormIndex].hdn_OriginalValues.value = vOriginalValues}

  if (vRevisions > "")
    {vRevisions = vRevisions.slice(0,(vRevisions.length - 2));
    document.forms[ivFormIndex].hdn_Revisions.value = vRevisions;
    return true;}
  else
	{return false;}
  }
  
function Element_Change(i) {
  var vStr, newval, sel;
  var vType = document.forms[ivFormIndex].elements[i].type;
  var vName = document.forms[ivFormIndex].elements[i].name;
  var vLabel = document.forms[ivFormIndex].elements[i].RevisionLabel;
  var svDataType = InputType(vName);
  var vVarName = "v" + vName;
 
 
  if ((vLabel=="")||(typeof(vLabel)=="undefined"))
    vLabel = "No Label Value";

  if (svDataType != "" && typeof(svDataType) != "undefined")
    vLabel+= "|" + svDataType;

  vLabel = vLabel.replace(/'/gi,"\'");

  if (document.forms[ivFormIndex].elements[i].Revision != "false") { // don't do fields if specifically told not to.
	  switch(vType.toLowerCase()) {
	    case "text":
	  	  eval("if(document.forms[ivFormIndex]." + vName + "){if(" + vVarName + "!= document.forms[ivFormIndex]." + vName + ".value){vOriginalValues+= '" + vLabel + "' + ': ' + " + vVarName + " + '||'; vRevisions+= '" + vLabel + "' + ': ' + document.forms[ivFormIndex]." + vName + ".value + '||';}}")
	  	  break;
	    case "select-one":
	  	 	eval("if(document.forms[ivFormIndex]." + vName + "){sel = document.forms[ivFormIndex]." + vName + ".selectedIndex; if (sel>-1) {newval = document.forms[ivFormIndex]." + vName + ".options[sel].text} else {newval = ''} if(" + vVarName + "!= newval) {vOriginalValues+= '" + vLabel + "' + ': ' + " + vVarName + " + '||'; vRevisions+= '" + vLabel + "' + ': ' + newval + '||';}}") 
	  	 	break;							
	    case "radio":
        eval("if(document.forms[ivFormIndex].elements[i].RevisionValue && document.forms[ivFormIndex].elements[i].checked && " + vVarName + " != document.forms[ivFormIndex].elements[i].RevisionValue){vOriginalValues+= '" + vLabel + "' + ': ' + " + vVarName + " + '||'; vRevisions+= '" + vLabel + "' + ': ' + document.forms[ivFormIndex].elements[i].RevisionValue + '||';}")
	  	 	break;
	    case "textarea":
	  	 	eval("if(document.forms[ivFormIndex]." + vName + "){if(" + vVarName + "!= document.forms[ivFormIndex]." + vName + ".value){vOriginalValues+= '" + vLabel + "' + ': ' + " + vVarName + " + '||'; vRevisions+= '" + vLabel + "' + ': ' + document.forms[ivFormIndex]." + vName + ".value + '||';}}")
	  	 	break;
	    case "checkbox":
        eval("if(document.forms[ivFormIndex]." + vName + "){if(" + vVarName + "!= document.forms[ivFormIndex]." + vName + ".checked){vOriginalValues+= '" + vLabel + "' + ': ' + " + vVarName + " + '||'; vRevisions+= '" + vLabel + "' + ': ' + document.forms[ivFormIndex]." + vName + ".checked + '||';}}")
        break;
	    case "hidden":
	      // only do hidden fields if specifically told to
	      if (document.forms[ivFormIndex].elements[i].Revision == "true")
	  	 	  eval("if(document.forms[ivFormIndex]." + vName + "){if(" + vVarName + "!= document.forms[ivFormIndex]." + vName + ".value){vOriginalValues+= '" + vLabel + "' + ': ' + " + vVarName + " + '||'; vRevisions+= '" + vLabel + "' + ': ' + document.forms[ivFormIndex]." + vName + ".value + '||';}}")
	  	 	break;
    }
  }
}
  
function ViewRevisions(vURL,vNotifyChanges) {
  Get_New_Form_Elements();
  if (vNotifyChanges.toLowerCase()=='true' && Verify_Form_Elements()) {
    if (Ask("Changes have occurred, would you like a chance to save them before viewing the revision history?","Yes","No")=="Yes") {
      return;
    } else {
      Navigate_To(vURL,"");
    }
  } else {
    Navigate_To(vURL,"");
  }
}
