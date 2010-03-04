// Created: 2/25/2002 by TGIL
// Functions for image viewer menus only
// DCS_v2/DCS_Document_Viewer.asp and UAS_Doc_Viewer_Menu.asp
//
var vOriginal_Width
var vOriginal_Height
var vPercent

function Zoom(vEnlarge) {
	
	if (vEnlarge)
		vPercent += 10
	else
		vPercent -= 10

	Resize()
}

function Set_Size() {
	var per = Ask("Enter the zoom percent:",vPercent)
	if (per) {
		if (!isNaN(per)) {
			vPercent = per * 1	// make sure it is numeric
			Resize()
		}
	}
}

function Resize() {
  if (window.top.DocumentFrame.document.readyState != "complete")
    return  // not done loading the image yet
    
	if (vPercent < 1) vPercent = 1
	vWidth = vOriginal_Width * vPercent / 100
	vHeight = vOriginal_Height * vPercent / 100
	window.top.DocumentFrame.document.all.Photo.style.width = vWidth + "px"
	window.top.DocumentFrame.document.all.Photo.style.height = vHeight + "px"
	document.all.ZoomPercent.innerHTML = vPercent
}
//
///////////////////////////////////////////////////
