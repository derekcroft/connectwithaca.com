var isIE,isNN,frameWidth,frameHeight,userType;

function toggle(tab,which) {
	if (document.getElementById) {
		var a = document.getElementById(which);
		var b = document.getElementById(tab);
		if (a.style.display != "block") {
			a.style.display = "block";
		}
		else {
			a.style.display = "none";
		}
	}
}

function reloaded() {
	if (document.getElementById) {
		var x = window.frames["contentIframe"];
		var y = x.document.location;
		x.document.location = y;
	}
}
