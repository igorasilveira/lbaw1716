
### Refering to Classes

* auction(state NN,  title,  description, sellingReason, pathToPhoto, startingPrice <b>CK</b> startingPrice > 0, minimumSellingPrice, buyNow, startDate, limitDate, refusalDate, numberofbids, reasonOfRefusal, <u>auctionID</u> <b>NN</b>,  normal_UserID -> Normal_User <b>NN</b>,  autheticated_UserID -> Autheticated_User <b>NN</b>)

* authenticated_User(typeOfUser, username, password, pathToPhoto, <u>autheticated_UserID</u> <b>NN</b>)

* add_Credits(value,  date, <u>add_CreditsID</u> <b>NN</b>, normal_UserID -> Normal_User <b>NN</b>)

* bid(date,  value,  <u>bidID</u> <b>NN</b>)

* category(name, subcategories, <u>categoryID</u> <b>NN</b>)

* city(name, <u>cityID</u> <b>NN</b>, <u>countryID</u> <b>NN</b>)

* comment(date,
	description,
	<u>commentID</u> <b>NN</b>,
	auctionID -> Auction <b>NN</b>,
	autheticated_UserID -> Autheticated_User ,
	normal_UserID -> Normal_User <b>NN</b>)

* country(name, <u>countryID</u> <b>NN</b>)

* normal_User(state,  completeName, email,  birthDate, /rating, address, postalCode, balance, <u>normal_UserID</u> <b>NN</b>, autheticated_UserID -> Autheticated_User, cityID -> City <b>NN</b>)

* notification(date, description, type, <u>notificationID</u> <b>NN</b>, auctionID -> Auction,  autheticated_UserID -> Autheticated_User <b>NN</b>)

* report(date, reason, <u>reportID</u> <b>NN</b>)

* win(date, finalPrice, rate, <u>winID</u> <b>NN</b>)

### Refering to Associations

* reports_an(<u>auctionID</u> -> Auction, <u>normal_UserID</u> -> Normal_User)

* pertains_to (<u>categoryID</u> -> Category, <u>auctionID</u> -> Auction)

* bid (<u>auctionID</u> -> Auction, <u>normal_UserID</u> -> Normal_User)
