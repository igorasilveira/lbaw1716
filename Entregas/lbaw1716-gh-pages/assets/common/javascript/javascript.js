/* Global Field */

this.pendingRow;


/*              */

function addModerator() {
	var createBtt = document.getElementById("createModBtt");
	createBtt.disabled = true;
	var table = document.getElementById("moderatorsList");
	var row = table.insertRow(table.rows.length);
	var cell1 = row.insertCell();
	var cell2 = row.insertCell();
	var cell3 = row.insertCell();
	var cell4 = row.insertCell();
	var photo = document.createElement('img');
	photo.setAttribute('class', 'photoModerator');
	photo.setAttribute('src', 'images/profile_pic.png');
	photo.setAttribute("width", "60");
	photo.setAttribute("height", "40");
	var confirm = document.createElement('img');
	confirm.setAttribute('src', 'images/confirm_edit.png');
	confirm.setAttribute("width", "20");
	confirm.setAttribute("height", "20");
	confirm.setAttribute("title", "Confirm Moderator");
	confirm.setAttribute("onclick", "confirmModerator()");
	var cancel = document.createElement('img');
	cancel.setAttribute('src', 'images/remove_logo.png');
	cancel.setAttribute("width", "20");
	cancel.setAttribute("height", "20");
	cancel.setAttribute("title", "Cancel");
	cancel.setAttribute("onclick", "cancelCreatModerator(this)");
	cancel.style.marginLeft = "15px";
	var name = document.createElement('input');
	name.setAttribute('type', 'text');
	name.setAttribute("class", 'form-control')
	name.setAttribute('required', 'required');
	cell1.appendChild(photo);
	cell2.appendChild(name);
	cell3.innerHTML = "0";
	cell4.appendChild(confirm);
	cell4.appendChild(cancel);
}


function confirmModerator() {


	var table = document.getElementById("moderatorsList");
	var nameCell = document.getElementById("moderatorsList").rows[table.rows.length - 1].cells[1];
	if (nameCell.children[0].value == null || nameCell.children[0].value == "") {
		alert("You need to give a name to the moderator");
	}
	else {
		nameCell.innerHTML = "[Mod]" + nameCell.children[0].value;
		var bttChildren = document.getElementById("moderatorsList").rows[table.rows.length - 1].cells[3];
		var remBtt = bttChildren.childNodes[1];
		var confBtt = bttChildren.childNodes[0];
		remBtt.style.marginLeft = "0px";
		remBtt.setAttribute("class", "removeBtt");
		remBtt.style.visibility = 'visible';
		remBtt.setAttribute("title", "Remove Moderator");
		remBtt.setAttribute("onclick", "delModerator(this)");
		bttChildren.removeChild(confBtt);
		var createBtt = document.getElementById("createModBtt");
		createBtt.disabled = false;
	}


}

function editModerators() {
	var createBtt = document.getElementById("createModBtt");

	var editBtt = document.getElementById("editModBtt");
	var removeBtts = document.querySelectorAll('#moderatorsList .removeBtt');
	var vis;

	for (i = 0; i < removeBtts.length; i++) {
		var bt = removeBtts[i];


		if (bt.style.visibility === 'hidden') {
			bt.style.visibility = 'visible';
			vis = true;
		}
		else {
			bt.style.visibility = 'hidden';
			vis = false;
		}

	}

	if (vis) {
		createBtt.style.visibility = "visible";

	}
	else {
		createBtt.style.visibility = "hidden";
	}
}


function delModerator(row) {
	var confBox = confirm("Do you really want to delete this user?");
	if (confBox == true) {
		var i = row.parentNode.parentNode.rowIndex;
		document.getElementById("moderatorsList").deleteRow(i);
	}

}

function cancelCreatModerator(row) {
	var createBtt = document.getElementById("createModBtt");
	createBtt.disabled = false;
	var i = row.parentNode.parentNode.rowIndex;
	document.getElementById("moderatorsList").deleteRow(i);

}

function addCategory() {
	var createBtt = document.getElementById("createCategoryBtt");
	createBtt.disabled = true;
	var table = document.getElementById("categoriesList");
	var row = table.insertRow(table.rows.length);
	var cell1 = row.insertCell();
	var cell2 = row.insertCell();
	var cell3 = row.insertCell();
	var cell4 = row.insertCell();


	var parent = document.createElement('select');
	var catrows = document.getElementById('categoriesList').rows;

var option = document.createElement("option");
option.text = "N/A";
parent.add(option);

for (i = 1; i < catrows.length-1; i++) {

var option = document.createElement("option");
option.text = catrows[i].cells[0].textContent;
parent.add(option);
	}



	parent.setAttribute('class', 'form-control');


	var confirm = document.createElement('img');
	confirm.setAttribute('src', 'images/confirm_edit.png');
	confirm.setAttribute("width", "20");
	confirm.setAttribute("height", "20");
	confirm.setAttribute("title", "Confirm Category");
	confirm.setAttribute("onclick", "confirmCategory()");
	var cancel = document.createElement('img');
	cancel.setAttribute('src', 'images/remove_logo.png');
	cancel.setAttribute("width", "20");
	cancel.setAttribute("height", "20");
	cancel.setAttribute("title", "Cancel");
	cancel.setAttribute("onclick", "cancelCreatCategory(this)");
	cancel.style.marginLeft = "15px";
	var name = document.createElement('input');
	name.setAttribute('type', 'text');
	name.setAttribute("class", 'form-control')
	name.setAttribute('required', 'required');
	cell1.appendChild(name);
	cell2.appendChild(parent);
	cell3.innerHTML = "0";
	cell4.appendChild(confirm);
	cell4.appendChild(cancel);
}


function confirmCategory() {


	var table = document.getElementById("categoriesList");
	var nameCell = document.getElementById("categoriesList").rows[table.rows.length - 1].cells[0];
	if (nameCell.children[0].value == null || nameCell.children[0].value == "") {
		alert("You need to give a name to the Category");
	}
	else {
		nameCell.setAttribute('scope','row');
		nameCell.innerHTML = nameCell.children[0].value;
		var parentCell = document.getElementById("categoriesList").rows[table.rows.length - 1].cells[1];
		parentCell.innerHTML = parentCell.children[0].value;
		var bttChildren = document.getElementById("categoriesList").rows[table.rows.length - 1].cells[3];
		var remBtt = bttChildren.childNodes[1];
		var confBtt = bttChildren.childNodes[0];
		remBtt.style.marginLeft = "0px";
		remBtt.setAttribute("class", "removeBtt");
		remBtt.style.visibility = 'visible';
		remBtt.setAttribute("title", "Remove Category");
		remBtt.setAttribute("onclick", "delCategory(this)");
		bttChildren.removeChild(confBtt);
		var createBtt = document.getElementById("createCategoryBtt");
		createBtt.disabled = false;
	}


}

function editCategories() {
	var createBtt = document.getElementById("createCategoryBtt");

	var editBtt = document.getElementById("editCatBtt");
	var removeBtts = document.querySelectorAll('#categoriesList .removeBtt');
	var vis;

	for (i = 0; i < removeBtts.length; i++) {
		var bt = removeBtts[i];


		if (bt.style.visibility === 'hidden') {
			bt.style.visibility = 'visible';
			vis = true;
		}
		else {
			bt.style.visibility = 'hidden';
			vis = false;
		}

	}

	if (vis) {
		createBtt.style.visibility = "visible";

	}
	else {
		createBtt.style.visibility = "hidden";
	}
}


function delCategory(row) {
	var confBox = confirm("Do you really want to delete this category?");
	if (confBox == true) {
		var i = row.parentNode.parentNode.rowIndex;
		document.getElementById("categoriesList").deleteRow(i);
	}

}

function cancelCreatCategory(row) {
	var createBtt = document.getElementById("createCategoryBtt");
	createBtt.disabled = false;
	var i = row.parentNode.parentNode.rowIndex;
	document.getElementById("categoriesList").deleteRow(i);

}

function disapproveAuction(row) {

	var i = row.parentNode.parentNode.rowIndex;
	document.getElementById("pendingListViewMoreTable").deleteRow(i);

}


function approveAuction(row) {

	var i = row.parentNode.parentNode.rowIndex;
	var wantedRow=document.getElementById("pendingListViewMoreTable").rows[i];

	wantedRow.deleteCell(-1);
	var lastBid = wantedRow.insertCell(wantedRow.cells.length-1);
	lastBid.innerHTML = "None";

	document.getElementById("pendingListViewMoreTable").deleteRow(i);

	var addedRow= document.getElementById("SellsListViewMoreTable").insertRow(1);
	addedRow.innerHTML=wantedRow.innerHTML;

}

function initMap() {
	var uluru = {lat: 41.178126, lng: -8.597441};
	var map = new google.maps.Map(document.getElementById('map'), {
		zoom: 17,
		center: uluru
	});
	var marker = new google.maps.Marker({
		position: uluru,
		map: map
	});
}



function getModal(row){

	var modal = document.getElementById('myModal');

	var clobtt = document.getElementsByClassName("close")[0];

	this.pendingRow=row;
	clobtt.onclick = function() {
		modal.style.display = "none";
	}
	modal.style.display = "block";

}


function checkRating(){

	var rating;
	if (document.getElementById('star1').checked) {
		document.getElementById('complain').style.display="block";
	}else
	if (document.getElementById('star2').checked) {
		document.getElementById('complain').style.display="block";
	}else{
		document.getElementById('complain').style.display="none";
		eliminatePending();
	}

}

function eliminatePending(){

	if(document.getElementById('complainID').value!=null || document.getElementById('complainID').value!=" ")
	document.getElementById('complainID').value; //next, we shall do something with this complain

	var pendTable=document.querySelector('#pending table');
	
	var i = (this.pendingRow).parentNode.parentNode.rowIndex;
	var wantedRow=pendTable.rows[i];

	wantedRow.deleteCell(-1);

	pendTable.deleteRow(i);

	var addedRow= document.querySelector('#bought table').insertRow(1);
	addedRow.innerHTML=wantedRow.innerHTML;
	addedRow.setAttribute("class","table");

	document.getElementById('warningPendingTop').style.display="none";
	var modal = document.getElementById('myModal');
	modal.style.display = "none";
}