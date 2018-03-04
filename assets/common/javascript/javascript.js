

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
		console.log(remBtt);
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



function getModal(){
var modal = document.getElementById('myModal');

var clobtt = document.getElementsByClassName("close")[0];

clobtt.onclick = function() {
    modal.style.display = "none";
}
modal.style.display = "block";

}
