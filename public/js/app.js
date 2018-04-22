function encodeForAjax(data) {
	if (data == null) return null;
	return Object.keys(data)
		.map(function (k) {
			return encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
		})
		.join('&');
}

function sendAjaxRequest(method, url, data, handler) {
	let request = new XMLHttpRequest();

	request.open(method, url, true);
	request.setRequestHeader('X-CSRF-TOKEN', document.querySelector('meta[name="csrf-token"]')
		.content);
	request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	request.addEventListener('load', handler);
	request.send(encodeForAjax(data));
}

/*function addEventListeners() {
	let itemCheckers = document.querySelectorAll('article.card li.item input[type=checkbox]');
  [].forEach.call(itemCheckers, function (checker) {
		checker.addEventListener('change', sendItemUpdateRequest);
	});

	let itemCreators = document.querySelectorAll('article.card form.new_item');
  [].forEach.call(itemCreators, function (creator) {
		creator.addEventListener('submit', sendCreateItemRequest);
	});

	let itemDeleters = document.querySelectorAll('article.card li a.delete');
  [].forEach.call(itemDeleters, function (deleter) {
		deleter.addEventListener('click', sendDeleteItemRequest);
	});

	let cardDeleters = document.querySelectorAll('article.card header a.delete');
  [].forEach.call(cardDeleters, function (deleter) {
		deleter.addEventListener('click', sendDeleteCardRequest);
	});

	let cardCreator = document.querySelector('article.card form.new_card');
	if (cardCreator != null)
		cardCreator.addEventListener('submit', sendCreateCardRequest);
}

function sendItemUpdateRequest() {
	let item = this.closest('li.item');
	let id = item.getAttribute('data-id');
	let checked = item.querySelector('input[type=checkbox]')
		.checked;

	sendAjaxRequest('post', '/api/item/' + id, {
		done: checked
	}, itemUpdatedHandler);
}

function sendDeleteItemRequest() {
	let id = this.closest('li.item')
		.getAttribute('data-id');

	sendAjaxRequest('delete', '/api/item/' + id, null, itemDeletedHandler);
}

function sendCreateItemRequest(event) {
	let id = this.closest('article')
		.getAttribute('data-id');
	let description = this.querySelector('input[name=description]')
		.value;

	if (description != '')
		sendAjaxRequest('put', '/api/cards/' + id, {
			description: description
		}, itemAddedHandler);

	event.preventDefault();
}

function sendDeleteCardRequest(event) {
	let id = this.closest('article')
		.getAttribute('data-id');

	sendAjaxRequest('delete', '/api/cards/' + id, null, cardDeletedHandler);
}

function sendCreateCardRequest(event) {
	let name = this.querySelector('input[name=name]')
		.value;

	if (name != '')
		sendAjaxRequest('put', '/api/cards/', {
			name: name
		}, cardAddedHandler);

	event.preventDefault();
}

function itemUpdatedHandler() {
	let item = JSON.parse(this.responseText);
	let element = document.querySelector('li.item[data-id="' + item.id + '"]');
	let input = element.querySelector('input[type=checkbox]');
	element.checked = item.done == "true";
}

function itemAddedHandler() {
	if (this.status != 200) window.location = '/';
	let item = JSON.parse(this.responseText);

	// Create the new item
	let new_item = createItem(item);

	// Insert the new item
	let card = document.querySelector('article.card[data-id="' + item.card_id + '"]');
	let form = card.querySelector('form.new_item');
	form.previousElementSibling.append(new_item);

	// Reset the new item form
	form.querySelector('[type=text]')
		.value = "";
}

function itemDeletedHandler() {
	if (this.status != 200) window.location = '/';
	let item = JSON.parse(this.responseText);
	let element = document.querySelector('li.item[data-id="' + item.id + '"]');
	element.remove();
}

function cardDeletedHandler() {
	if (this.status != 200) window.location = '/';
	let card = JSON.parse(this.responseText);
	let article = document.querySelector('article.card[data-id="' + card.id + '"]');
	article.remove();
}

function cardAddedHandler() {
	if (this.status != 200) window.location = '/';
	let card = JSON.parse(this.responseText);

	// Create the new card
	let new_card = createCard(card);

	// Reset the new card input
	let form = document.querySelector('article.card form.new_card');
	form.querySelector('[type=text]')
		.value = "";

	// Insert the new card
	let article = form.parentElement;
	let section = article.parentElement;
	section.insertBefore(new_card, article);

	// Focus on adding an item to the new card
	new_card.querySelector('[type=text]')
		.focus();
}

function createCard(card) {
	let new_card = document.createElement('article');
	new_card.classList.add('card');
	new_card.setAttribute('data-id', card.id);
	new_card.innerHTML = `

  <header>
    <h2><a href="cards/${card.id}">${card.name}</a></h2>
    <a href="#" class="delete">&#10761;</a>
  </header>
  <ul></ul>
  <form class="new_item">
    <input name="description" type="text">
  </form>`;

	let creator = new_card.querySelector('form.new_item');
	creator.addEventListener('submit', sendCreateItemRequest);

	let deleter = new_card.querySelector('header a.delete');
	deleter.addEventListener('click', sendDeleteCardRequest);

	return new_card;
}

function createItem(item) {
	let new_item = document.createElement('li');
	new_item.classList.add('item');
	new_item.setAttribute('data-id', item.id);
	new_item.innerHTML = `
  <label>
    <input type="checkbox"> <span>${item.description}</span><a href="#" class="delete">&#10761;</a>
  </label>
  `;

	new_item.querySelector('input')
		.addEventListener('change', sendItemUpdateRequest);
	new_item.querySelector('a.delete')
		.addEventListener('click', sendDeleteItemRequest);

	return new_item;
}

addEventListeners();
*/

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
	var nameCell = document.getElementById("moderatorsList")
		.rows[table.rows.length - 1].cells[1];
	if (nameCell.children[0].value == null || nameCell.children[0].value == "") {
		alert("You need to give a name to the moderator");
	} else {
		nameCell.innerHTML = "[Mod]" + nameCell.children[0].value;
		var bttChildren = document.getElementById("moderatorsList")
			.rows[table.rows.length - 1].cells[3];
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
		} else {
			bt.style.visibility = 'hidden';
			vis = false;
		}

	}

	if (vis) {
		createBtt.style.visibility = "visible";

	} else {
		createBtt.style.visibility = "hidden";
	}
}


function delModerator(row) {
	var confBox = confirm("Do you really want to delete this user?");
	if (confBox == true) {
		var i = row.parentNode.parentNode.rowIndex;
		document.getElementById("moderatorsList")
			.deleteRow(i);
	}

}

function cancelCreatModerator(row) {
	var createBtt = document.getElementById("createModBtt");
	createBtt.disabled = false;
	var i = row.parentNode.parentNode.rowIndex;
	document.getElementById("moderatorsList")
		.deleteRow(i);

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
	var catrows = document.getElementById('categoriesList')
		.rows;

	var option = document.createElement("option");
	option.text = "N/A";
	parent.add(option);

	for (i = 1; i < catrows.length - 1; i++) {

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
	var nameCell = document.getElementById("categoriesList")
		.rows[table.rows.length - 1].cells[0];
	if (nameCell.children[0].value == null || nameCell.children[0].value == "") {
		alert("You need to give a name to the Category");
	} else {
		nameCell.setAttribute('scope', 'row');
		nameCell.innerHTML = nameCell.children[0].value;
		var parentCell = document.getElementById("categoriesList")
			.rows[table.rows.length - 1].cells[1];
		parentCell.innerHTML = parentCell.children[0].value;
		var bttChildren = document.getElementById("categoriesList")
			.rows[table.rows.length - 1].cells[3];
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
		} else {
			bt.style.visibility = 'hidden';
			vis = false;
		}

	}

	if (vis) {
		createBtt.style.visibility = "visible";

	} else {
		createBtt.style.visibility = "hidden";
	}
}


function delCategory(row) {
	var confBox = confirm("Do you really want to delete this category?");
	if (confBox == true) {
		var i = row.parentNode.parentNode.rowIndex;
		document.getElementById("categoriesList")
			.deleteRow(i);
	}

}

function cancelCreatCategory(row) {
	var createBtt = document.getElementById("createCategoryBtt");
	createBtt.disabled = false;
	var i = row.parentNode.parentNode.rowIndex;
	document.getElementById("categoriesList")
		.deleteRow(i);

}

function disapproveAuction(row) {

	var i = row.parentNode.parentNode.rowIndex;
	document.getElementById("pendingListViewMoreTable")
		.deleteRow(i);

}


function approveAuction(row) {

	var i = row.parentNode.parentNode.rowIndex;
	var wantedRow = document.getElementById("pendingListViewMoreTable")
		.rows[i];

	wantedRow.deleteCell(-1);
	var lastBid = wantedRow.insertCell(wantedRow.cells.length - 1);
	lastBid.innerHTML = "None";

	document.getElementById("pendingListViewMoreTable")
		.deleteRow(i);

	var addedRow = document.getElementById("SellsListViewMoreTable")
		.insertRow(1);
	addedRow.innerHTML = wantedRow.innerHTML;

}

function initMap() {
	var uluru = {
		lat: 41.178126,
		lng: -8.597441
	};
	var map = new google.maps.Map(document.getElementById('map'), {
		zoom: 17,
		center: uluru
	});
	var marker = new google.maps.Marker({
		position: uluru,
		map: map
	});
}



function getModal(row) {

	var modal = document.getElementById('myModal');

	var clobtt = document.getElementsByClassName("close")[0];

	this.pendingRow = row;
	clobtt.onclick = function () {
		modal.style.display = "none";
	}
	modal.style.display = "block";

}


function checkRating() {

	var rating;
	if (document.getElementById('star1')
		.checked) {
		document.getElementById('complain')
			.style.display = "block";
	} else
	if (document.getElementById('star2')
		.checked) {
		document.getElementById('complain')
			.style.display = "block";
	} else {
		document.getElementById('complain')
			.style.display = "none";
		eliminatePending();
	}

}

function eliminatePending() {

	if (document.getElementById('complainID')
		.value != null || document.getElementById('complainID')
		.value != " ")
		document.getElementById('complainID')
		.value; //next, we shall do something with this complain

	var pendTable = document.querySelector('#pending table');

	var i = (this.pendingRow)
		.parentNode.parentNode.rowIndex;
	var wantedRow = pendTable.rows[i];

	wantedRow.deleteCell(-1);

	pendTable.deleteRow(i);

	var addedRow = document.querySelector('#bought table')
		.insertRow(1);
	addedRow.innerHTML = wantedRow.innerHTML;
	addedRow.setAttribute("class", "table");

	document.getElementById('warningPendingTop')
		.style.display = "none";
	var modal = document.getElementById('myModal');
	modal.style.display = "none";
}

function timecounter(time) {
	document.getElementById('demo')
		.innerHTML = date('Y W o', time);
}

/*function bid() {
	let auction_bid = document.getElementById('auctionBid')
		.innerHTML;
	console.log(auction_bid);
	sendAjaxRequest('post', '/api/cards/' + id, {
			description: description
		}
	}*/