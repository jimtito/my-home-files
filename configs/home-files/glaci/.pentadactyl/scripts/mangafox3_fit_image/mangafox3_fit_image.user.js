// ==UserScript==
// @name          Mangafox3 Fit Image
// @namespace     Knace
// @description   Thnx to Knace. A mangafox.com script: Loads several images (up to entire chapter) vertically for your reading pleasure. You only need to scroll down to continue reading which keeps the flow of the manga. Also makes saving the entire chapter simple and easy!
// @version       4.2
// @include       http://www.mangafox.com/*
// ==/UserScript==
///////////////////////////////////////////////////
if(!GM_setValue) {
	function GM_setValue(name,value) {}
	function GM_getValue(name,value) {return value;}
	function GM_registerMenuCommand( oText, oFunc ) { }
	function GM_addStyle(css) {
		var head = document.getElementsByTagName('head')[0];
		var style = document.createElement('style');
		//if (!head) {return}
			style.type = 'text/css';
			style.innerText = css;
		head.appendChild(style);
	}
}


var script = document.createElement("script");
script.type = "application/javascript";
document.body.appendChild(script);
//20 is the height of the nav bar
script.textContent =
"	function resizefit(i) {							"
+"		image = document.getElementById(i);				"
+"		y = window.innerHeight - 20;					"
+"		x = Math.floor(image.width * y / image.height);			"
+"		if (x > document.body.clientWidth) {				"
+"			x = document.body.clientWidth;				"
+"			y = Math.floor(image.height * x / image.width);		"
+"		}								"
+"		image.style.height = y + 'px';					"
+"		image.style.width = x + 'px';					"
+"	}									"
+"										"
+"	function resizeall() {							"
+"		i=1;								"
+"		while(document.getElementById(i) != null) {			"
+"			resizefit(i);						"
+"			i++;							"
+"		}								"
+"		document.getElementById(window.location.hash.split('#')[1]).scrollIntoView();		"
+"	}									"
+"	window.onresize=function(evt) {resizeall()};									"
+"	var imgerrors = 0;								"
+"	var mirrorlist = new Array ('64.237.46.132','66.55.139.36','66.55.139.42','67.213.212.176','67.213.220.252','67.228.169.10','67.228.177.201','174.36.18.193','174.36.42.76','174.36.44.88','174.36.75.37','174.36.75.38','174.37.18.82','174.37.45.155','174.37.45.156','174.37.61.10','174.37.63.43','206.217.202.5','206.217.202.21','208.43.46.113','208.43.48.209','208.43.49.33','208.167.237.36','216.155.133.249','216.155.139.181','216.155.144.229');"
+"	function imgloaderr(image) {						"
+"		imgerrors++;							"
+"		if (imgerrors < 20 && image.src.split('/')[3] != null) {		"
+"			h = Math.floor(Math.random()*26);			"
+"			var str = image.src;					"
+"			str = str.replace(/http:\\/\\/([a-zA-Z0-9_\\-.]*)(\\/.*)$/, 'http://' + mirrorlist[h] + '$2');		"
+"			image.src = str;					"
+"		}								"
+"	}";

document.body.appendChild(script);


//UserScript Commands
var pagelimit = GM_getValue('pagelimit', 9);
function setImageset() {
	pagelimit = prompt('Set Max # of Images: ', pagelimit);
	GM_setValue( 'pagelimit', parseInt(pagelimit) );
}
GM_registerMenuCommand( 'Set Max Images Per Page', setImageset );

var ploader = GM_getValue('piloader', 1000);   //progressiver image loader
function toggleProgressiveLoad() {
	if( ploader ) {
		ploader = 0;
		alert('Images will be loaded instantly.');
	} else {
		ploader = parseInt( prompt("Set Progressive delay maximum to: (in ms)", 1000) );
	}
	GM_setValue('piloader', ploader);
}
GM_registerMenuCommand( 'Toggle Progressive Image Loading', toggleProgressiveLoad );

var target_load = GM_getValue('target_load', true);
function toggleTarget_load() {
	target_load = !target_load; GM_setValue('target_load', target_load);
	if( target_load ) {
		alert('Images will start loading from [current page - 2]');
	} else {
		alert('Images will start load from the first image');
	}
}
GM_registerMenuCommand( 'Toggle Middle Image Loading', toggleTarget_load );

var img_width = GM_getValue('img_width', '100%');
var img_height = GM_getValue('img_height', 'auto');
function setImageSize() {
	GM_setValue('img_width',prompt('Set width (#,#px,#%,auto): ',img_width));
	GM_setValue('img_height',prompt('Set height (#,#px,#%,auto): ',img_height));
}
GM_registerMenuCommand( 'Set Image Size', setImageSize );

//Variables
var js = document.getElementsByTagName('script');
	for( var i=0;i<js.length;++i ) { js[i].src=''; }
var values = document.body.innerHTML.match(/="(.*?)";[^=]*=(.*?);[^=]*=(.*?);[^=]*='(.*?)'/);
var url_directory = 'http://www.mangafox.com/manga/'+values[1];

var page = 1;
	if(target_load) { page = parseInt(values[2]); }
var total_images = parseInt(values[3]);
var url_chapter = values[4];

//Get data from page select tag
var selects = document.getElementsByTagName('select');
var select = selects[0];
var ch_selecter=select.innerHTML;
var pg_selecter=selects[1].innerHTML;
var si = select.selectedIndex;
var chapter_prev=url_directory;
	if( si > 0 ) { chapter_prev += '/'+select.options[si-1].value; }
var chapter_next=url_directory;
	if( si+1 < select.length ) { chapter_next += '/'+select.options[si+1].value; }

unsafeWindow.chapter_prev=chapter_prev;
unsafeWindow.chapter_next=chapter_next;

//Clear and Create Menu
var jump;
	try { jump = parseInt(window.location.href.split('#')[1].substring(1)); } catch(err) { jump = -1; }
function onchange(evt) {
	var value = evt.target.value;
	try {
		var element = document.getElementById(''+value);
		document.getElementById(''+value).style.display='';
		window.location.href = '#p'+evt.target.value;
	} catch(err) {
		jump = value;
		sendrequest(value);
	}
}
{
	document.body.parentNode.replaceChild( document.createElement('body'), document.body )
	//New CSS Styles
	GM_addStyle('\
		#mu { top:5px; position:fixed; background:#FFFFFF; border:solid #000000 medium; padding:3px; text-align:left; max-width:90%; } \n\
		#chapters { max-width:50%; } \n\
		#chapters option { max-width:600px; } \n\
		.bookmarks, .EOC { width:100%; width:100%; border-style:outset; border-width:thin 0px thin 0px; } \n\
		.bookmarks { font:xx-small; } \n\
		.EOC { text-align:center; font:x-small; background-color:#FF0000; color:#FFFFFF } \n\
		body { background: #DDDDDD; font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 12px; line-height: 150%; margin: 0; width: 100%; font-size-adjust: none; font-stretch: normal; font-style: normal; font-weight: normal; font-variant: normal; font-weight: normal; text-align: center; } \n\
	');
	var element = document.createElement('div');
		element.setAttribute('id','mu');
		element.innerHTML = '<a href="'+url_directory+'">Manga Info</a> : [ <a href="'+chapter_prev+'">&lt;&lt;</a> <select id="chapters" onchange="change_chapter(this)">'+ch_selecter+'</select> <a href="'+chapter_next+'">&gt;&gt;</a> ] ('+total_images+' Images) <select id="goto">'+pg_selecter+'</select>';
	document.body.appendChild(element);
	document.getElementById('chapters').selectedIndex = si;
	document.getElementById('goto').addEventListener('change',onchange,false);
}

var hide_menu = GM_getValue('hide_menu', false);
if( hide_menu ) { document.getElementById('mu').style.display='none'; }
function toggleMenu() {
	var menu = document.getElementById('mu');
	GM_setValue('hide_menu', !hide_menu);
	if( menu.style.display == 'none' ) {
		menu.style.display = '';
	} else {
		menu.style.display = 'none';
	}
}
GM_registerMenuCommand( '[~] Toggle Menu', toggleMenu );

function keycodes(evt) {
	if(evt.keyCode == 37) { evt.preventDefault(); evt.stopPropagation(); window.location=chapter_prev; }
	if(evt.keyCode == 39) { evt.preventDefault(); evt.stopPropagation(); window.location=chapter_next; }
	if(evt.keyCode == 38) { evt.preventDefault(); evt.stopPropagation(); i = parseInt(window.location.hash.split('p')[1]) - 1; x = document.getElementById('p' + i);  if (x != null && x.hasChildNodes() == true) { window.location.hash = 'p' + i; document.getElementById(window.location.hash.split('#')[1]).scrollIntoView(); } }
	if(evt.keyCode == 40) { evt.preventDefault(); evt.stopPropagation(); i = parseInt(window.location.hash.split('p')[1]) + 1; x = document.getElementById('p' + i);  if (x != null && x.hasChildNodes() == true) { window.location.hash = 'p' + i; document.getElementById(window.location.hash.split('#')[1]).scrollIntoView(); } }
}

function keycodes2(evt) {
	if(evt.keyCode == 192) { toggleMenu(); }
}
document.addEventListener('keypress', keycodes, true);
document.addEventListener('keydown', keycodes2, true);


function refill() {
	var end;
	if( confirm('Refill Missing Images to Last Image?') ) {
		end = 1;
	} else if( confirm('Refile to Entire Chapter?') ) {
		end = 2;
	}
	if( end ) {
		var images = document.images;
		if( end == 1 ) { end = parseInt(images[images.length-1].id); }
		else if( end == 2 ) { end = total_images; }
		var start = parseInt(document.images[0].id);
		for( i=start; i<=end; i++ ) {
			if( document.getElementById(''+i) == undefined ) { sendrequest(i); }
		}
	}
}
GM_registerMenuCommand( 'Refill Missing Images', refill );



document.body.style.overflow="hidden";




//Load images past image limit on scroll end
var hide=0;
function loop() {
	var timer=1;
//	var scrollsize = window.scrollMaxY > document.body.clientHeight ? window.scrollMaxY : (document.body.clientHeight-630);
	var scrollsize = window.scrollMaxY;
	var scrollpos = window.pageYOffset;
//	if( scrollpos > (scrollsize*.97) ) {
	if( scrollpos == scrollsize ) {
		var images_all = document.images;
		var img_end = parseInt(images_all[images_all.length-1].id);
		if( img_end < total_images ) {
			var img_increment = Math.round(pagelimit*.9);
			var img_left=total_images-img_end;
			if( img_increment > img_left ) img_increment = img_left;

			for(i=1;i<=img_increment;i++) {
				scrollpos -= images_all[i-1+hide].offsetHeight;
				//images_all[i-1+hide].style.display='none';
				if( ploader ) {
					if( i > ploader/250 ) { timer += ploader; } else { timer+=250*(i-1); }
					window.setTimeout( sendrequest, timer, img_end+i );
				}
				else { sendrequest(img_end+i); }
			}
			hide+=img_increment;
			timer+=2500;
			
			//window.scrollTo(0,scrollpos);
		}
	}
	window.setTimeout( loop, 200+timer );
}


//Image loading code
function state_change( xmlhttp, i ) {
	if (xmlhttp.readyState==4) {
		if (xmlhttp.status!=200) {
			window.setTimeout( sendrequest, 5000, i );
		} else {
			var data_src = xmlhttp.responseText.match(/<img.*?src="(.*?)".*?id="image".*?>/);
			var data_bookmark = xmlhttp.responseText.match(/'series_id':'(.*?)','chapter_id':'(.*?)','page':'(.*?)'/);

			var element = document.getElementById('p'+i);

			var bookmark = "new Request({url:'http://www.mangafox.com/ajax/bookmark.php',method:'post',evalScripts:true}).send('action=add&series_id="+data_bookmark[1]+"&chapter_id="+data_bookmark[2]+"&page="+data_bookmark[3]+"')";
			var html ='<div class="bookmarks"><table width="100%"><tr onMouseover="this.style.cursor=\'e-resize\'"><td onClick="element=document.getElementById(\'\'+'+i+');element.src=element.src.split(\'?\')[0]+\'?\'+Math.random();" align="left">[R]</td>&nbsp;&nbsp;&nbsp;&nbsp;<td onClick="resizeall();">[RS]</td><td align="center" width="100%" onClick="element=document.getElementById(\'\'+'+i+').style;if(element.display==\'none\'){element.display=\'\';}else{;}">-'+i+'-</td><td oncontextmenu="event.stopPropagation(); window.location=chapter_prev;" onClick="window.location.hash = \'p'+(i-1)+'\';"><==Prev</a></td>&nbsp;&nbsp;&nbsp;&nbsp;<td oncontextmenu="event.stopPropagation(); window.location=chapter_next;" onClick="window.location.hash = \'p'+(i+1)+'\';">Next==>&nbsp;&nbsp;&nbsp;&nbsp;</td><td onClick="'+bookmark+'">Bookmark</td></tr></table></div>';
				if( i == total_images ) { html+='<a href="'+chapter_next+'">'; }
				html +='<img id="'+i+'" src="'+data_src[1]+'" width="'+img_width+'" height="'+img_height+'" onLoad="resizefit('+i+');" onError="imgloaderr(this);">';
				if( i == total_images ) { html+='</a><div class="EOC" onMouseover="this.style.cursor=\'e-resize\'" onClick="window.location=\''+chapter_next+'\'"><br><br>***End of '+url_chapter+'***<br><br><br></div>'; }
			element.innerHTML = html;

			if(jump == i) {
				jump = -1;
				document.getElementById(''+i).addEventListener('load', function() {window.location.href = '#p'+i;}, false);
				document.getElementById(window.location.hash.split('#')[1]).scrollIntoView()
			}
		}
	}
}
window.sendrequest = function(i) {
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.open("GET", url_directory+'/'+url_chapter+'/'+i+'.html');
	function f_state_change() { return state_change( xmlhttp, i ); }
	xmlhttp.onreadystatechange = f_state_change;
	xmlhttp.send(null);
}

//Start loading images
var element = document.createElement('div');
	var html='';
	for( var i = 1; i<=  total_images; ++i ) { html += '<div id="p'+i+'"></div>'; }
	element.innerHTML = html;
document.body.appendChild(element);
var timer = 1;
if( jump < 0 ) { jump = page; }
var limit = jump+pagelimit-1; if( limit > total_images ) { limit = total_images; }
var i_start = jump - 2;
	if( i_start < 1 ) { i_start=1; }
for( var i=i_start; i<=limit; i++ ) {
	if( ploader ) {
		if( i > ploader/250 ) { timer += ploader; } else { timer+=250*(i-1); }
		window.setTimeout( sendrequest, timer, i );
	}
	else { sendrequest(i); }
}

window.setTimeout( loop, timer+2500 );
