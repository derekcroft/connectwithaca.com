function SupplierPicker(vForm, vFieldOne, vFieldTwo, vFieldThree, vFieldFour, vSubmit_On_Pick, vDistance_From_Top, vDistance_From_Right){
  //
  //Used when over 1000 Suppliers to avoid large select lists.
  //Opens the Supplier picker and passes in the element names that will be populated by the picker.
  //vForm = formName, vFieldOne=Supplier Code, vFieldTwo=Supplier Name
  //vFieldThree=Select List the picker is replacing,vSubmit_On_Pick=True/False submits vForm
  //
  
  if (document.thisForm.txtSupplier_Code)
    var vSupplierCode = document.thisForm.txtSupplier_Code.value
  else //Added by TSCH, 8/22/01 as a way to specify the field targeted for the Supplier Picker code
    var vSupplierCode = eval("document.thisForm." + vFieldOne + ".value");
    
  vTop = (screen.availheight - vDistance_From_Top)
  vLeft = (screen.availwidth - vDistance_From_Right)
  vURL = vBaseAddress + "/Pickers/Supplier_Picker2.asp?Form=" + vForm + "&FieldOne=" + vFieldOne + "&FieldTwo=" + vFieldTwo + "&FieldThree=" + vFieldThree + "&FieldFour=" + vFieldFour + "&Submit_On_Pick=" + vSubmit_On_Pick + "&Value=" + vSupplierCode
  OpenWin(vURL, "Supplier_Code","scrollbars=yes, top=" + vTop + ",left=" + vLeft + ",width=700,height=450");
}

function CustomerPicker1(vForm, vFieldOne, vFieldTwo, vFieldThree, vFieldFour, vSubmit_On_Pick, vDistance_From_Top, vDistance_From_Right){
  //
  //Used when over 1000 customers to avoid large select lists.
  //Opens the Customer picker and passes in the element names that will be populated by the picker.
  //vForm = formName, vFieldOne=Customer Code, vFieldTwo=Customer Name
  //vFieldThree=Select List the picker is replacing,vSubmit_On_Pick=True/False submits vForm
  //
  var vCustCode = document.thisForm.txtCustomer_Code.value
  vTop = (screen.availheight - vDistance_From_Top)
  vLeft = (screen.availwidth - vDistance_From_Right)
  vURL = vBaseAddress + "/Pickers/Customer_Picker.asp?Form=" + vForm + "&FieldOne=" + vFieldOne + "&FieldTwo=" + vFieldTwo + "&FieldThree=" + vFieldThree + "&FieldFour=" + vFieldFour + "&Submit_On_Pick=" + vSubmit_On_Pick + "&Value=" + vCustCode
  OpenWin(vURL, "Customer_Code","scrollbars=yes, top=" + vTop + ",left=" + vLeft + ",width=700,height=450");
}

function Pick_Color_Modal() {
  var vColor = showModalDialog(vBaseAddress + "/Pickers/Web_Colors_Modal.asp",
                               null,
                               "dialogWidth: 470px; dialogHeight: 445px; help:no; status:no; scroll: no")
  return vColor
}

// Color picker section added 8/23/2001 TGIL
function Pick_Color(vField) {
  // Show the color picker
  var vColor = Pick_Color_Modal()
  
  if (vColor == null)
    return
    
  Update_Picked_Color(vField,vColor)
}

function Update_Picked_Color(vField,vColor) {
  // Update the input field with the new color
  eval ("document.thisForm." + vField + ".value = '" + vColor + "'")
  
  // Update the colored box
  if (document.all.BoxColor.length) {
    // Find the colored box that matches the input field
    for (var i=0;i<document.thisForm.length;i++) {
      if (document.thisForm.elements[i].name == vField) {
        var colorIndex = document.thisForm.elements[i].colorIndex
        // Make the color box the color of the current value of the field. If empty, use black.
        try {
          document.all.BoxColor[colorIndex].style.backgroundColor = vColor
        }
        catch(er) {
          alert(vColor + " is an invalid color value.")
        }
        break // finished, so stop looking.
      }
    }
  } else {
    // There is only one color picker on this page, so there is no array.
    try {
      document.all.BoxColor.style.backgroundColor = vColor
    }
    catch(er) {
      alert(vColor + " is an invalid color value.")
    }
  }
}
// End color picker section


var vAskBGColor = ''; // TSCH 12/1/03 for setting the background of the Ask dialog.
var plsvAskType = 'Question';
function Ask() {
  if (arguments.length == 0) {
    alert("Ask() has no question supplied.");
    return;
  }
  
  // Adjust the height of the window based on the length of the question and answers.
  var vHeight = 170;
  
  for (var i=0;i<arguments.length;i++) {
    vHeight += arguments[i].length * .2;
  }
    
  if (vHeight < 200)
    vHeight = 200;
  
  var result = showModalDialog(vBaseAddress + "/Pickers/Answer_Picker.asp?bgcolor=" + encodeURIComponent(vAskBGColor) + '&type=' + encodeURIComponent(plsvAskType), arguments, "dialogWidth:440px;dialogHeight:" + vHeight + "px;scroll:no;help:no;status:no");
  return result;
}

function Ask_Checkboxes() {
  if (arguments.length == 0) {
    alert("Ask_Checkboxes() has no question supplied.")
    return
  }
  
  if (arguments.length < 3) {
    alert("Ask_Checkboxes() must have at least two answer choices.")
    return
  }
  
  // Adjust the height of the window based on the number of answers
  var vHeight = 200 + arguments.length * 12
  
  var result = showModalDialog(vBaseAddress + "/Pickers/Answer_Picker.asp?Checkboxes=true",arguments,"dialogWidth:440px;dialogHeight:" + vHeight + "px;scroll:no;help:no;status:no")
  return result
}

function Notify(vMessage,vOptions) {
  if (typeof(vMessage) == "undefined") {
    Notify("Notify() has no explanation supplied.")
    return
  }
  
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

function Message(vCustomer,vMessageKey,vModuleKey,vWidth,vHeight) {
  var result = showModalDialog(vBaseAddress + "/Dialogs/Message_Dialog.asp?Module_Key=" + vModuleKey + "&PCN=" + vCustomer + "&Message_Key=" + vMessageKey,arguments,"dialogWidth:" + vWidth + "px;dialogHeight:" + vHeight + "px;scroll:yes;help:no;status:no")
  return result
}

function Pick_Document(vName,vRoot,vDoc_Type) {
  var vURL = vRoot + "DCS_v2/DCS_Heirarchy.asp?Doc_Picker=true&Doc_Picker_Field=" + vName + "&Doc_Type=" + vDoc_Type
  OpenWinCentered(vURL,"DocPicker","scrollbars,resizable,status",screen.availWidth-100,screen.availHeight-100)
}

function Pick_Month(vMonth,vYear) {
  if (typeof(vMonth) == "undefined")
    vMonth = 1
  if (typeof(vYear) == "undefined")
    vYear = 2002
  var vOptions = "dialogWidth:250px;dialogHeight:150px;scroll:no;help:no;status:no"
  var ans = showModalDialog(vBaseAddress + "/Pickers/Month_Picker.asp?Month=" + vMonth + "&Year=" + vYear,null,vOptions)
  if (typeof(ans) == "undefined") {
    ans = new Array()
    ans[0] = ans[1] = ""
  }
  return ans
}

function Pick_Customer(vLabel,vButton,vCustomer_No,vSame_PCN_Select) {
  if (typeof(vLabel) == "undefined")
    vLabel = "Customer"
  if (typeof(vButton) == "undefined")
    vButton = "apply"
  if (typeof(vCustomer_No) == "undefined")
    vCustomer_No = "1"
  if (typeof(vSame_PCN_Select) == "undefined")
    vSame_PCN_Select = "0"
  return showModalDialog(vBaseAddress + "/Pickers/Customer_Picker_Modal.asp?Button=" + vButton + "&Label=" + vLabel + "&Customer=" + vCustomer_No + "&Allow_Same_PCN_Selection=" + vSame_PCN_Select,null,"dialogWidth:350px;dialogHeight:160px;scroll:no;help:no;status:no")
}

function Pick_Customer_Source_Dest(vSource_Label,vDest_Label,vButton,vCustomer_No,vSame_PCN_Select) {
  if (typeof(vSource_Label) == "undefined")
    vSource_Label = "Source"
  if (typeof(vDest_Label) == "undefined")
    vDest_Label = "Destination"
  if (typeof(vButton) == "undefined")
    vButton = "apply"
  if (typeof(vCustomer_No) == "undefined")
    vCustomer_No = "1"
  if (typeof(vSame_PCN_Select) == "undefined")
    vSame_PCN_Select = "0"    
  return showModalDialog(vBaseAddress + "/Pickers/Customer_Picker_Modal.asp?Button=" + vButton + "&Source_Label=" + vSource_Label + "&Dest_Label=" + vDest_Label + "&Customer=" + vCustomer_No + "&Allow_Same_PCN_Selection=" + vSame_PCN_Select,null,"dialogWidth:350px;dialogHeight:160px;scroll:no;help:no;status:no")
}

function Confirm_Delete(vHref, vItemName, vFormName) { 
  if (vItemName == null || vItemName == '') {
    vItemName = 'record';
  }
  else {
    vItemName = escape(vItemName);
  }
    
  if(Ask('Are you sure you want to delete this ' + vItemName + ' ?', 'Yes', 'No') == 'Yes') {
                 
    var oForm;
    if (vFormName == null) {
      if(document.thisForm == null)
        oForm = document.forms[0];
      else
        oForm = document.thisForm;
    }
    else {
      oForm = eval('document.' + vFormName);
    }
    
    if (vHref == null) {
      vHref = window.location.href;
    }
    
    Navigate_To(vHref);
    
  }
}

