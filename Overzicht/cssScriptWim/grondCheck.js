var windowObjectReference = null; // global variable
var relaties = []; // [mainOWobjectID, bronObject(vd link!), targetID];
var biDirRelaties = []; //[eenId, anderId]
var benen = [];
var losseRelaties = [];
var parentGlobalEl;
var recurseBlocker = 0;
var reeks = false;

//OW:

var OWobjecten = ["r:RegelVoorIedereen", "r:Instructieregel", "r:Omgevingswaarderegel", "l:Gebied", "l:Lijn", "l:Punt", "ga:Gebiedsaanwijzing", "rol:Activiteit", "l:Gebiedengroep", "l:Lijnengroep", "l:Puntengroep", "k:Kaart", "rol:Omgevingsnorm", "rol:Omgevingswaarde", "p:Pons", "rg:Regelingsgebied", "GML",  "basisgeo:id "];
//, "GIO", "Artikel", "Lid", "IntIoRef

var OWorde = [
["r:RegelVoorIedereen", 1000], 
["r:Instructieregel", 1000], 
["r:Omgevingswaarderegel", 1000], 
["l:Gebiedengroep", 910], 
["l:Lijnengroep", 910], 
["l:Puntengroep", 910], 
["l:Gebied", 900], 
["l:Lijn", 900], 
["l:Punt", 900], 
["ga:Gebiedsaanwijzing", 900], 
["rol:Activiteit", -100], 
["k:Kaart", -100], 
["rol:Omgevingsnorm", -100], 
["rol:Omgevingswaarde", -100], 
["p:Pons", -100], 
["rg:Regelingsgebied", -100], 
["GML",  200], 
["geo:Locatie",  200],
["basisgeo:id ", 0],
["Artikel", -1000],
["IntIoRef", -1100],
["ExtIoRef", -1200],
["GIO", -1300] ];

$(document ).ready(function() {
 clearAllOwObjects();
maakrelaties();
console.log('relaties');
console.log(relaties);

//maakrelaties: vindRelaties, maakBiRelaties
		});
		

function clearAllOwObjects(){
				$(".owObject, owObjectContent, .regel, .divLinks0, .owTable").each(function(index, el){
						//
						$(el).hide();
						})		
}

function ordeVanType(objType)//type
{
		var out;
		OWorde.forEach(function(type, index, array) {
			  if( type[0] == objType) //niet al bestaand?
				   {
							 out = type[1];
				   };
				});
  if(out != NaN){
		return out;}
	else{
		return -10000000;}
}

function ordeVanObject(obj)//elementObject
{
	var objType = obj.getAttribute("data-xml");
	var out;
	OWorde.forEach(function(type, index, array) {
	if( type[0] == objType) //niet al bestaand?
				   {
							out = type[1];
				   };
				});
  if(out != NaN){
		return out;}
	else{
		return -10000000;}
}

function maakBeen(obj){
		var biRelaties = getBiRelaties(obj);
		 
		//ancestor class="owObject"
		
		biDirRelaties.forEach(function(typeRec, index, array) {
    //naar boven t/m 2000
				
				
		//naar boven t/m 2000
		//naar beneden t/m 0				
		});
}

function elRect(element){
domRect = element.getBoundingClientRect();
return [domRect.x,  domRect.y, domRect.width, domRect.height];
}
function elRectMidRight(element){
domRect = element.getBoundingClientRect();
return [domRect.x + (domRect.width / 2), domRect.y + (domRect.height / 2)]
}	


// **********************PADEN ************


function toonRelaties(elObj){
	var parentDiv  =   elObj.closest("div.owObject");// OW object
	elId =parentDiv.id;
  var biLijst = getBiRelaties(document.getElementById(elId));
	//plaats de objecten
	var baseRect = elRect(parentDiv);// x, y, width, height
	var baseOrde = ordeVanObject(parentDiv);
	biLijst.forEach(function(biRelatieId, index, array) {
	var biRelEl =  document.getElementById(biRelatieId);
		var biRelOrde = ordeVanType(biRelEl.getAttribute('data-xml'));
    if (biRelOrde == -100)// rechts
		  {
		 var topEl = biRelEl.closest("div.owObject" );
		 topEl.insertAdjacentElement('afterend', biRelEl);
		 biRelEl.style.left = "550px";//baseRect[2];
		 biRelEl.style.top =  "0px"//baseRect[1];
  			biRelEl.style.position = "absolute"; //pas hierna gaan top en left werken!
		    $(biRelEl).show();
		  }
    else if (biRelOrde < baseOrde) //lager 
 		  {}
    else if (biRelOrde > baseOrde) //hoger
			{}
    else //gelijk
			{} 
		});
}

function showLink(mainDiv, linkedID){//mainDiv is zelf-id óf windownr(2 = links onder, 1 = rechts onder, GML); linkedID is doelId
//Let op: nu komt elke target uit ónder de oorsprong
//bij het klikken vanuit zij-instromers of anderzins moet er mogelijk ergens IN de reeks gevlochten worden
		
    if (mainDiv == "2"){//links
		  document.getElementById(linkedID).style.visibility = "visible";
		  $(document.getElementById(linkedID)).show();
		  parentGlobalEl = document.getElementById(linkedID);
		}
	else if (mainDiv == "1"){//rechts

		  var superParentOW = document.getElementById(mainDiv);
			if (superParentOW.lastElementChild)//er zijn onderliggende objecten
			   {
  		    var topEl = superParentOW.lastElementChild;
       		var elIn = document.getElementById(linkedID);
          var prevOW = topEl.closest("table.owTable");
      		var elTable = elIn.closest("table.owTable");
  				if(elTable != null){// table
             		prevOW.insertAdjacentElement('afterend', elTable);
             		elTable.style.visibility = 'visible';
             		$(elTable).show();
             		elIn.style.visibility = 'visible';
             		$(elIn).show();
     				    }
  			  else{//gio heeft geen table
            		prevOW.insertAdjacentElement('afterend', elIn);
								elIn.style.visibility = 'visible';
           		  $(elIn).show();
     				    };
     			}
				else {// geen onderligende objecten

       		var elIn = document.getElementById(linkedID);
				  var topEl = superParentOW.lastElementChild;
  				if(elTable != null){// table
			      		var elTable = elIn.closest("table.owTable");
             		topEl.insertAdjacentElement('afterend', elTable);
             		elTable.style.visibility = 'visible';
             		$(elTable).show();
             		elIn.style.visibility = 'visible';
             		$(elIn).show();
     				    }
  			  else{//gio heeft geen table
            		topEl.append(elIn);
								elIn.style.visibility = 'visible';
           		  $(elIn).show();
     				    };
				}
		   }
		else if(ordeVanObject(document.getElementById(linkedID)) == -100){//zijwaards
					 var elIn = document.getElementById(linkedID);
					 var topEl = document.getElementById(mainDiv);
     		   var prevOW = topEl.closest('table.owTable');
		       var elTable = elIn.closest('table.owTable');
           prevOW.firstElementChild.lastElementChild.append(elTable);
					 elTable.style.visibility = 'visible';
 		       $(elTable).show();
					 elIn.style.visibility = 'visible';
		       $(elIn).show();
				}
				else if (document.getElementById(mainDiv) < ordeVanObject(document.getElementById(linkedID)) ){ //up
						
/*Nog niet van belang
 					var topEl = document.getElementById(mainDiv);
        		var elIn = document.getElementById(linkedID);

						var prevOW = topEl.closest("table.owTable");
		        var elTable = elIn.closest("table.owTable");
            // prevOW.append(el);
		        prevOW.insertAdjacentElement('afterend', elTable);
		        elTable.style.visibility = 'visible';
		        $(elTable).show();
		        elIn.style.visibility = 'visible';
		        $(elIn).show();
		        console.log(elTable);
*/						
				}
				else{ //down; deze als sjabloom voor anderen; zie mainDiv == "1" voor gevallen waar geen table wordt gebruikt 
      		var topEl = document.getElementById(mainDiv);
      		var elIn = document.getElementById(linkedID);
          var prevOW = topEl.closest("table.owTable");
      		var elTable = elIn.closest("table.owTable");
      		 prevOW.insertAdjacentElement('afterend', elTable);
           $(elTable).find(".owObject").css( "visibility", "visible"); // met name voor GML obeject met geneste id's
					 $(elTable).find(".owObject").show();
					 elTable.style.visibility = 'visible';
      		 $(elTable).show();
					 elIn.style.visibility = 'visible';
      		 $(elIn).show();
				}
}

function zoekPadenNaarType(startId, type, up){
	var temp = [];
	if(ordeVanType(type) > ordeVanObject(document.getElementById(startId)) ){
		up = true;	// zIndex = 0, false: zIndex = 1000
   }
 else {up =false;};
  var lijst = getBiRelaties(document.getElementById(startId));
 if(lijst != [])
 {
		 // push startId nog ff aan de lijsten !!!!!!
	var temp = zoekPadenNaarLijst(type, lijst, startId, up, [], 0);
	return temp;
}
 else{
		 return [];
 }
}

function zoekPadenNaarLijst(type, lijst, startId, up, result, zIndex){ //type, Lijst, original startid (loop check), richting, ZIndexMaxOfmin
		var foundList = [];
		recurseBlocker++;
		if(recurseBlocker > 100)
		{ return ;};
	if (lijst.length > 1){
		var car = lijst[0];
		lijst.shift();
//			!!!!!!!!!!!orde meegeven!
	  return (zoekPadNaarEenType( car, type, lijst, startId, up, result, zIndex) + [result.concat(zoekPadenNaarLijst(type, lijst, startId, up, result, zIndex))]);
   }
 else if (lijst.length == 1){
		var car = lijst[0];
		lijst.shift();
		return (zoekPadNaarEenType(car, type, startId, up, result, zIndex));
   }
  else {
		  return;
  }
};

function zoekPadNaarEenType(car, type, startId, up, result, zIndex){//id vh eerste element uit de lijst; type; original startid (loop check); result is de array vd reeds opgebouwde reeks; zIndex: bij up=true is dit het minimum dus meer dan voorganger (van car) in de opgebouwde reeksreeks
		recurseBlocker++;
		if(recurseBlocker > 100)
		  { return;};
 		var lijst = getBiRelaties(document.getElementById(car));
		var car = lijst[0];
			
		if( !(  ((up == true) && (zIndex < ordeVanObject(document.getElementById(car))) ) || 
					( (up = false) && (ordeVanObject(document.getElementById(car)) > ordeVanType(type)   ) ) ) )//verkeerde richting
			 {
				  console.log(" verkeerde richting")
		    	return;
   	   }
   	else if (document.getElementById(car).getAttribute('data-xml') == type)	//!!!!!!!!!!!!!!!!type gevonden; 
		 {
				return foundList;
   	 }
    else if (car == startId || document.getElementById(car).getAttribute('data-xml') == document.getElementById(startId).getAttribute('data-xml') )//komt zichzelf tegen; komt object van hetzelfde type tegen > !!!!!!!!!!!!!!!!! verwijder deze reeks
      {
		  return;
      }
	  else{// plus nwe lijst met historie
		 result.push(car);
		 console.log("zoekPadNaarEenType result: " + result);
		 lijst.shift();
		 //+ 	zoekPadenNaarLijst(firstID, type, lijst, endId, up)  );		
		 return (zoekPadNaarEenType(car, type, startId, up, result, zIndex) + [result.concat(zoekPadenNaarLijst(type, lijst, startId, up, result, zIndex))]) ;
	  }
}

function getBiRelaties(obj){//return lijst met id's
		var biRelaties = [];
		biDirRelaties.forEach(function(typeRec, index, array) {
		var objTypeId = obj.id;
//		console.log("getBiRelaties :>" + objTypeId)
    if(typeRec[0] ==  obj.id)
		  {
					biRelaties.push(typeRec[1]);
		  };
    if(typeRec[1] ==  obj.id)
		  {
					biRelaties.push(typeRec[0]);
		  };		
		});
		return biRelaties; 
}


/*OP:
IntIoRef
ExtIoRef
Artikel?
Lid?
*/





window.addEventListener("message", (event) => {
		console.log("event.data = " + event.data);
		console.log("event.origin = " + event.origin);
		showLink("2", event.data);
}, false);


		
		
		
function test(){
	console.log("test OK");	
}

		
//experimenteel menus
		
// Holds the current open menu item.
var Item;
// Holds the timeout value.
var Timer;
// Hide the menu after clicking outside it.
document.onclick = CloseMenu;

function OpenMenu(Menu)
{
  // If there is an item that is open, close it.
  if (Item)
  {
   Item.style.visibility = "hidden";
  }
  // Obtain an item reference for the new menu.
  Item = document.getElementById(Menu);
  // Make it visible.
  Item.style.visibility = "visible";
}
function CloseMenu()
{
  // Set a timer for closing the menu.
  Timer = window.setTimeout(PerformClose, 500);
}
function PerformClose()
{
  // If the item is still open.
  if (Item)
  {
   // Close it.
   Item.style.visibility = "hidden";
  }
}
function KeepSubmenu()
{
  // Reset the timer.
  window.clearTimeout(Timer);
}

		
// /experimenteel





function popObject(id, targetId){
		  var elTo = document.getElementById(targetId); 
		  var elFrom = document.getElementById(id);
			var domRectFrom = elFrom.getBoundingClientRect();
			var domRectTo = elTo.getBoundingClientRect();
			//elTo.style.position = "absolute";
			//elTo.style.top = Math.round(domRectFrom.y);// + domRectFrom.height;
			elTo.style.display = "block";
			//alert("to x=" + domRectTo.x + "   from x=" + Math.round(domRectFrom.x));
}

			
			// *****************Rijgen *************

		
		
function maakrelaties(){// gericht en bi
 for (const elementType of OWobjecten) {
	vindRelaties(elementType);
    } 
  maakBiRelaties();

}

function vindRelaties(OWobjectType){//bv van alle r:RegelVoorIedereen, alle uitgaande relaties; 
		var startObjectSelector = "[data-xml='" + OWobjectType + "']"; //"[data-xml='r:RegelVoorIedereen']";
		$(startObjectSelector).each(function(index, el){// bv vanuit alle r:RegelVoorIedereen objecten de uitgaande relaties
				var startObject = el;
				var startObjectID = el.id;
//				var mainDataTarget =  $(el).attr("data-target");
			$(el).find("[data-target]").each(function(index, el1){ //doel kan in een kind zitten
			    relaties.push([startObjectID, el1, $(el1).attr("data-target")]);// van objectType output> [mainOWobjectID, bronObject(vd link!), targetID];
	})
		})
}

var tempList;
function geefInkomendeRelaties(object) {// 'returnd' id's 
		tempList = [];
		var topEl = object.closest('.owObject');
		descendants(topEl);
		//doe zelf ook mee!
		relaties.forEach(function(relatie){//[mainOWobjectID, bronObject(vd link!), targetID];
		      if (relatie[2] == topEl.id){
					tempList.push(relatie[0]);
		                 };
           });
    var alertText = "inkomende relaties:\n";
		tempList.forEach(function(id){//[mainOWobjectID, bronObject(vd link!), targetID];
				alertText = alertText + id + "\n"
           });
		if(tempList.length == 0)
		{alertText = "Geen inkomende realties.";}
		alert(alertText);
		return tempList;
}

function descendants(object){
     for (let i = 0; i < object.children.length; i++) {
			var id = object.children[i].id;
      if(object.children[i].id != ""){//er is een id
			  relaties.forEach(function(relatie){//[mainOWobjectID, bronObject(vd link!), targetID];
		      if (relatie[2] == id){
					tempList.push(relatie[0]);
		                 };
           });
			  descendants(object.children[i]);
		   };
		 };
}



function maakBiRelaties(){
		relaties.forEach(function(relatie, index, relaties) {
			  if( biRalatieBestaatNiet(relatie[0], relatie[2])) //niet al bestaand?
				   {

            biDirRelaties.push([relatie[0], relatie[2]]);
				   };
				})
}

function biRalatieBestaatNiet(links, rechts){
		if (biDirRelaties.length == 0)
		  {return true;};
		for (const biRelatie of biDirRelaties) {//rechts
				if ( !( (biRelatie[0] == links) && (biRelatie[1] == rechts) || (biRelatie[0] == rechts) && (biRelatie[1] == links) ))
				{
				 return true;
				}
		  }
 return false;		
}


function vindMijnOwBenen(me){
		// zoek tot r:RegelVoorIedereen
		var reeks = [];

	for (const id of relaties) {
     el = document.getElementById(id);
		if(el.getAttribute("data-xml") == "r:RegelVoorIedereen") 
		  {}
		else
		{}
		
		//zoek tot GML
		if(el.getAttribute("data-xml") == "r:RegelVoorIedereen") 
		  {}
		else
		{}
		
		}
}
			
function padNaarRegelVoorIedereen(me){
}
function padNaarRegelGML(mi){
}

function mijnBiRelaties(id){
	gevondenRelaties = [];
	biDirRelaties.forEach(function(pair) {
			
				if (pair[0] == id){gevondenRelaties.push(pair[0]) };
				if (pair[1] == id){gevondenRelaties.push(pair[1]) };
			  	console.log("id:" + id + "; " + pair[0] + ", " + pair[1]);
		});
		return gevondenRelaties;
}

function mijnUitRelaties(id){
  reeks = true;
	gevondenRelaties = [];
	relaties.forEach(function(pair) {
				if (pair[0] == id){
			  	console.log(pair[0] + ":>" + pair[1]);
					gevondenRelaties.push([pair[1]]);
				};
		});
	  pushBelow(id ,gevondenRelaties);
}

function pushBelow(parentId, childIds){//id, ids[]
		//insert grid onder idElement
		var query = "#" + parentId;
		var gridID = parentId + "grid"
		var query2 = "#" + gridID;
		
		$(query).after( "<div class='gridRelaties' id='" + gridID  + "'></div>" );
		 document.getElementById(gridID).style.gridTemplateColumns = "repeat(" + childIds.length  + ", 1fr)";

		getElsfromIds(childIds).forEach(function(id){
		  if (id != null){
   		  $(id).appendTo(query2);
				$(id).show();
		}
		  else {
					console.log("error");
					$("<div >ERROR</div>").appendTo(query2);
        		};
		
			});
}


function showOpLink(dummy, linkedID){//id, ids[]
//!!!! dummy verwijderen?
		var el = document.getElementById(linkedID);
		var dataxml = el.getAttribute("data-xml");
		openSet([dataxml]);
		showMe(el.firstElementChild);
}

function openCloseOWobj(obj) {
		 var nextDiv  =   obj.closest('.owHead').nextElementSibling;
 		 var old = nextDiv.style.display;
			nextDiv.style.display = (old == "block" ? "none": "block");
		}

function showMe(obj) {
		  var nextP = obj.nextElementSibling.nextElementSibling;
			var old = nextP.style.display;
			nextP.style.display = "block";
		}

function	openSet(dataxml) // zonder de anderen te sluiten; data-xml="r:RegelVoorIedereen"
{ // uitwerken!!!!!!!!!!!!!!!!!!!!!!!!!!
		dataxml.forEach(function(type) {

		var selector = "div[data-xml='" +  type.replace('.', '\\.') +  "']";
	$(selector).each(function(index, el){
			$(el).show();
	})
				
		});
}




function getElsfromIds(childIds){
				var childEls = [];
				childIds.forEach(function(id){
						childEls.push(document.getElementById(id));
				});
		return childEls;
}



function	fetch(dataxml) // //data-xml="r:RegelVoorIedereen"
{ // uitwerken!!!!!!!!!!!!!!!!!!!!!!!!!!
		clearAllOwObjects();
		dataxml.forEach(function(type) {

		var selector = "div[data-xml='" +  type.replace('.', '\\.') +  "']";
	$(selector).each(function(index, el){
			var prevOW = el.closest("table.owTable");
			$(el).show();
			$(prevOW).show();
	})
				
		});
}




/* ok!
function vindRelaties(){
		var realties = []; 
	$("[data-xml='r:RegelVoorIedereen']").each(function(index, el){
				var rvi = this;
				var dt = "error";
				console.log(this.id);
				$("span", rvi).each(function(index, el){
						console.log(this);
				})
		})
}
 */

/*function popObjects(id, targetIds){
		var tel = 0;
		for (let i in obj){
		 popObject(originId, i, i)
		 tel++;
		}
		return 0;
}*/
/*			if(Math.abs(domRectTo.x - domRectFrom.x) < 10 && (domRectFrom.x > 10))
			 {
				elTo.style.top = Math.round(domRectFrom.y)
				elTo.style.left = "-600px";
		   } else if (domRectFrom.x < 10) {
				elTo.style.top = Math.round(domRectFrom.y) + Math.round(domRectFrom.height)
				elTo.style.left = "-600px";
				   
			 } else if ((Math.abs(domRectTo.x - domRectFrom.x) > 10) && (Math.abs(domRectTo.y - domRectFrom.y) > 10)) {
					 //nog niks
			 } else {//gelijk
					 //nog niks
		   }
			//(Math.abs(domRectTo.x - domRectFrom.x) < 10) && (Math.abs(domRectTo.y - domRectFrom.y) > 10)
			//alert("top=" + elFrom.style.top + "   y:" + Math.round(domRectFrom.y));
//alert(Math.round(domRect.x) + " " + Math.round(domRect.y) + " " + Math.round(domRect.width) + " " + Math.round(domRect.height))
}*/
		
		
$( "a" ).click(function( event ) {
    event.preventDefault();
    $( this ).hide( "slow" );
 
});

/* uit originele script: */
function ShowHide(obj) {
		  var nextP = obj.nextElementSibling.nextElementSibling;
			var old = nextP.style.display;
			nextP.style.display = (old == "block" ? "none": "block");
		}
		
		
		
function ShowHideNext(id) {
		$("#art > div.divLinks0").each(function(index, el){
						var old = el.style.display;
						el.style.display = (old == "block" ? "none": "block");
						//el.style.visibility = "visible";
						})		
		
/*		  var nextP = obj.nextElementSibling;
			var old = nextP.style.display;
			console.log("nextP:" + nextP);
			console.log(nextP);
			el.style.display = (old == "block" ? "none": "block");
			nextP.style.visibility = "visible";
			console.log(nextP);
	*/	
}
function ShowHideMe(obj) {
			var old = obj.style.display;
			obj.style.display = (old == "block" ? "none": "block");

		
}		
		
   
function ShowHideOW(obj) {
	if (reeks == false){
  	clearAllObjectsExcept(obj.closest('table.owTable'));
		if(obj.parentNode.getAttribute("data-xml") == "GIO"){
				clearAllOpObjectsExcept(obj.parentNode);
		}
   };
}

function clearAllObjectsExcept(except){
				$("table.owTable").each(function(index, el){
						if(except != el)
						{$(el).hide();};
						})		
}

function clearAllOpObjectsExcept(except){
				$(".divLinks0").each(function(index, el){
						if(except != el)
						{$(el).hide();};
						})		
}




function dsvg() {
// targeting the svg itself
const svg = document.querySelector("");

// variable for the namespace 
const svgns = "http://www.w3.org/2000/svg";

// make a simple rectangle
let newRect = document.createElementNS(svgns, "rect");

newRect.setAttribute("x", "150");
newRect.setAttribute("y", "150");
newRect.setAttribute("width", "100");
newRect.setAttribute("height", "100");
newRect.setAttribute("fill", "#5cceee");

// append the new rectangle to the svg
svg.appendChild(newRect);
}




function test(){
//select
var gmls = $("div[data-geo_basisgeo='D28AF779-7EDD-4A88-8B11-809798F53636']");
alert(gmls[0])
//var val =  gmls[0].attr("data-basisgeo");

$(gmls).each(function( index, value )
{
    alert(gmls[0] + " ZZ " + gmls.length);
});
}

function popup(mylink, windowname) { 
    if (! window.focus)return true;
    var href;
    if (typeof(mylink) == 'string') href=mylink;
    else href=mylink.href; 
    window.open(href, windowname, 'width=400,height=200,scrollbars=yes'); 
    return false; 
  }



function openRequestedPopup(url) {
  if(windowObjectReference == null || windowObjectReference.closed) {
    windowObjectReference = window.open(url);
  } else {
    windowObjectReference.focus();
  };
}
/*
Alle identfiers zijn globaal en uniek 

Wie verwijst naar deze Id-value als identifier (noemt deze identifier als verwijzing)?
referredToMe(identifier)
result: list of objectID-socketname pairs

Deze identifier verwijst naar welke bestaande Id-values?
iReferTo(identifier) 
result:  list of objectID-socketname pairs

In: hash(identfier)
Out: hash(identifier)

*/

/* OK
$("div[data-basisgeo='D28AF779-7EDD-4A88-8B11-809798F53636']").each(function( index, value )
{
    alert(gmls[0] + " ZZ");
});
*/ 

//alert(gmls[1])//leeg
//var gmls = $("div")[0];
//alert(gmls.tagName)

/*experimental
browser.contextMenus.create({
  id: "log-selection",
  title: "Log '%s' to the console",
  contexts: ["selection"]
});

browser.contextMenus.onClicked.addListener(function(info, tab) {
  if (info.menuItemId == "log-selection") {
    console.log(info.selectionText);
  }
});
function onCreated() {
  if (browser.runtime.lastError) {
    console.log("error creating item:" + browser.runtime.lastError);
  } else {
    console.log("item created successfully");
  }
}

browser.contextMenus.create({
  id: "radio-green",
  type: "radio",
  title: "Make it green",
  contexts: ["all"],
  checked: false
}, onCreated);

browser.contextMenus.create({
  id: "radio-blue",
  type: "radio",
  title: "Make it blue",
  contexts: ["all"],
  checked: false
}, onCreated);

var makeItBlue = 'document.body.style.border = "5px solid blue"';
var makeItGreen = 'document.body.style.border = "5px solid green"';

browser.contextMenus.onClicked.addListener(function(info, tab) {
  if (info.menuItemId == "radio-blue") {
    browser.tabs.executeScript(tab.id, {
      code: makeItBlue
    });
  } else if (info.menuItemId == "radio-green") {
    browser.tabs.executeScript(tab.id, {
      code: makeItGreen
    });
  }
});

/experimental */


function escapeJqueryChars(inString){
		var outString = inString;
		//String.raw``
  	var re = /\#/;
		outString = outString.replace(re , '\\\#');
		re = /\;/g;			
    outString = outString.replace(re , '\\\;');
		re = /\&/g;			
		outString = outString.replace(re , '\\\&');
		re = /\@/g;			
    outString = outString.replace(re , '\\\\@');	
		re = /,/g;			
    outString = outString.replace(re , '\\\,');		
    re = /\//g;			
    outString = outString.replace(re , '\\\/');
		re = /\./g;			
    outString = outString.replace(re , '\\\.');
		re = /\+/g;			
    outString = outString.replace(re , '\\\\');
		re = /\*/g;			
    outString = outString.replace(re , '\\\*');
		re = /\~/g;			
    outString = outString.replace(re , '\\\~');
		re = /'/g;			
    outString = outString.replace(re , "\\\'");
		re = /\:/g;			
    outString = outString.replace(re , '\\\:');
		re = /"/g;			
    outString = outString.replace(re , '\\\"');
		re = /\!/g;			
    outString = outString.replace(re , '\\\!');		
		re = /\^/g;			
    outString = outString.replace(re , '\\\^');
		re = /\$/g;			
    outString = outString.replace(re , '\\\$');
		re = /\[/g;			
    outString = outString.replace(re , '\\\[');
		re = /\]/g;			
    outString = outString.replace(re , '\\\]');
		re = /\(/g;			
    outString = outString.replace(re , '\\\(');
		re = /\)/g;			
    outString = outString.replace(re , '\\\)');
		re = /\=/g;			
    outString = outString.replace(re , '\\\=');
		re = /\>/g;			
    outString = outString.replace(re , '\\\>');		
		re = /\|/g;
    outString = outString.replace(re , '\\\|');		
		/*
		re = //g;			
    outString = outString.replace(re , '\\');
*/
    return outString;
}


