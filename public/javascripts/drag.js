//Javascript function for draggin layers around

var isNav = (navigator.appName.indexOf("Netscape") != -1)
var isIE = (navigator.appName.indexOf("Microsoft") != -1)
var zOrder = 1

function SetZIndex(obj,z) {
	obj.zIndex = z
	zOrder++
}

function ShiftTo(obj,x,y) {
	if (isNav) {
		obj.moveTo(x,y)
	} else {
		obj.pixelLeft = x
		obj.pixelTop = y
	}
}

//Holds reference to selected element
var SelectedObj
//Holds locations of click relative to element
var OffsetX, OffsetY

//Find out which element has been clicked on
function SetSelectedElem(evt) {
	if (isNav) {
		var ClickX = evt.pageX
		var ClickY = evt.pageY
		var TestObj
		for (i=document.layers.length - 1;i >= 0; i--) {
			TestObj = document.layers[i]
			if ((ClickX > TestObj.left) &&
				(ClickX < TestObj.left + TestObj.clip.width) &&
				(ClickY > TestObj.top) &&
				(ClickY < TestObj.top + TestObj.clip.height)) {
				SelectedObj = TestObj
				if (SelectedObj) {
					SetZIndex(SelectedObj,zOrder)
					return
				}
			}
		}
	} else {
		var ImgObj = window.event.srcElement
	  if (ImgObj.parentElement.locked)
	    return

		SelectedObj = ImgObj.parentElement.style
		if (SelectedObj) {
			SetZIndex(SelectedObj,zOrder) // zOrder
			return
		}
	}
	SelectedObj = null
	return
}

//Drag an element
function DragIt(evt) {
	if (SelectedObj) {
		if (isNav) {
			ShiftTo(SelectedObj,(evt.pageX - OffsetX),(evt.pageY - OffsetY))
		} else {
			ShiftTo(SelectedObj,(window.event.clientX + document.body.scrollLeft - OffsetX),(window.event.clientY + document.body.scrollTop - OffsetY))
			//Prevent further system response to dragging
			return false
		}
	}
}

//Turn selected element on
function Engage(evt) {
	SetSelectedElem(evt)
	if (SelectedObj) {
		if (isNav) {
			OffsetX = evt.pageX - SelectedObj.left
			OffsetY = evt.pageY - SelectedObj.top
		} else {
			OffsetX = window.event.offsetX
			OffsetY = window.event.offsetY
		}
		//prevent further processing of mouseDown event
		return false
	}
}

//Turn selected element off
function Release(evt) {
	if (SelectedObj) {
//		SetZIndex(SelectedObj,0)
//		alert(SelectedObj.left + "," + SelectedObj.top)
		SelectedObj = null
	}
}

//Set event capture for Navigator
function SetNSEventCapture() {
	if (isNav) {
		document.captureEvents(Event.MOUSEDOWN | Event.MOUSEMOVE | Event.MOUSEUP)
	}
}

function DragInit() {
	if (isNav) {
		SetNSEventCapture()
	}
	document.onmousedown = Engage
	document.onmousemove = DragIt
	document.onmouseup = Release
}
