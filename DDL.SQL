ALTER TABLE Add_Credits DROP CONSTRAINT add credits;
ALTER TABLE Auction DROP CONSTRAINT win;
ALTER TABLE Auction DROP CONSTRAINT create;
ALTER TABLE Auction DROP CONSTRAINT accepts;
ALTER TABLE Auction DROP CONSTRAINT rejects;
ALTER TABLE Autheticated_User DROP CONSTRAINT add;
ALTER TABLE Autheticated_User DROP CONSTRAINT remove;
ALTER TABLE bid DROP CONSTRAINT Auction;
ALTER TABLE bid DROP CONSTRAINT Normal_User;
ALTER TABLE Category DROP CONSTRAINT has;
ALTER TABLE City DROP CONSTRAINT FK_City_Country;
ALTER TABLE Comment DROP CONSTRAINT to;
ALTER TABLE Comment DROP CONSTRAINT removes;
ALTER TABLE Comment DROP CONSTRAINT adds;
ALTER TABLE Normal_User DROP CONSTRAINT FK_Normal_User_Autheticated_User;
ALTER TABLE Normal_User DROP CONSTRAINT blocks;
ALTER TABLE Normal_User DROP CONSTRAINT FK_Normal_User_City;
ALTER TABLE Notification DROP CONSTRAINT pertains to;
ALTER TABLE Notification DROP CONSTRAINT receives;
ALTER TABLE pertains to DROP CONSTRAINT Category;
ALTER TABLE pertains to DROP CONSTRAINT Auction;
ALTER TABLE report DROP CONSTRAINT Auction;
ALTER TABLE report DROP CONSTRAINT Normal_User;

DROP TABLE IF EXISTS Add_Credits;
DROP TABLE IF EXISTS Auction;
DROP TABLE IF EXISTS Autheticated_User;
DROP TABLE IF EXISTS bid;
DROP TABLE IF EXISTS Bid;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Country;
DROP TABLE IF EXISTS Normal_User;
DROP TABLE IF EXISTS Notification;
DROP TABLE IF EXISTS pertains to;
DROP TABLE IF EXISTS report;
DROP TABLE IF EXISTS Report;
DROP TABLE IF EXISTS Win;

CREATE TABLE Add_Credits (
	valued Int NULL,
	date Date NULL,
	add_CreditsID integer NOT NULL,
	normal_UserID integer NOT NULL
);

CREATE TABLE Auction (
	state Enum NULL,
	title varchar(50) NULL,
	description varchar(50) NULL,
	sellingReason varchar(50) NULL,
	pathToPhoto varchar(50) NULL,
	startingPrice Int NULL,
	minimumSellingPrice Int NULL,
	buyNow Int NULL,
	startDate Date NULL,
	limitDate Date NULL,
	refusalDate Date NULL,
	/numberOfBids Int NULL,
	reasonOfRefusal varchar(50) NULL,
	auctionID integer NOT NULL,
	normal_UserID integer NOT NULL,
	autheticated_UserID integer NOT NULL
);

CREATE TABLE Autheticated_User (
	typeOfUser Enum NULL,
	username varchar(50) NULL,
	password varchar(50) NULL,
	pathToPhoto varchar(50) NULL,
	autheticated_UserID integer NOT NULL
);

CREATE TABLE bid (
	auctionID integer NULL,
	normal_UserID integer NULL
);

CREATE TABLE Bid (
	date Date NULL,
	value Int NULL,
	bidID integer NOT NULL
);

CREATE TABLE Category (
	name varchar(50) NULL,
	subcategories Array<id_Category> NULL,
	categoryID integer NOT NULL
);

CREATE TABLE City (
	name varchar(50) NULL,
	cityID integer NOT NULL,
	countryID integer NOT NULL
);

CREATE TABLE Comment (
	date Date NULL,
	description varchar(50) NULL,
	commentID integer NOT NULL,
	auctionID integer NOT NULL,
	autheticated_UserID integer NULL,
	normal_UserID integer NOT NULL
);

CREATE TABLE Country (
	name varchar(50) NULL,
	countryID integer NOT NULL
);

CREATE TABLE Normal_User (
	state Enum NULL,
	completeName varchar(50) NULL,
	email Email NULL,
	birthDate Date NULL,
	/rating Int NULL,
	address varchar(50) NULL,
	postalCode varchar(50) NULL,
	balance Int NULL,
	normal_UserID integer NOT NULL,
	autheticated_UserID integer NULL,
	cityID integer NOT NULL
);

CREATE TABLE Notification (
	date Date NULL,
	description varchar(50) NULL,
	type varchar(50) NULL,
	notificationID integer NOT NULL,
	auctionID integer NULL,
	autheticated_UserID integer NOT NULL
);

CREATE TABLE pertains to (
	categoryID integer NULL,
	auctionID integer NULL
);

CREATE TABLE report (
	auctionID integer NULL,
	normal_UserID integer NULL
);

CREATE TABLE Report (
	date Date NULL,
	reason varchar(50) NULL,
	reportID integer NOT NULL
);

CREATE TABLE Win (
	date Date NULL,
	finalPrice Int NULL,
	rate Int NULL,
	winID integer NOT NULL
);


ALTER TABLE Add_Credits ADD CONSTRAINT PK_Add_Credits
	PRIMARY KEY (add_CreditsID);


ALTER TABLE Auction ADD CONSTRAINT PK_Auction
	PRIMARY KEY (auctionID);


ALTER TABLE Autheticated_User ADD CONSTRAINT PK_Autheticated_User
	PRIMARY KEY (autheticated_UserID);


ALTER TABLE Bid ADD CONSTRAINT PK_Bid
	PRIMARY KEY (bidID);


ALTER TABLE Category ADD CONSTRAINT PK_Category
	PRIMARY KEY (categoryID);


ALTER TABLE City ADD CONSTRAINT PK_City
	PRIMARY KEY (cityID);


ALTER TABLE Comment ADD CONSTRAINT PK_Comment
	PRIMARY KEY (commentID);


ALTER TABLE Country ADD CONSTRAINT PK_Country
	PRIMARY KEY (countryID);


ALTER TABLE Normal_User ADD CONSTRAINT PK_Normal_User
	PRIMARY KEY (normal_UserID);


ALTER TABLE Notification ADD CONSTRAINT PK_Notification
	PRIMARY KEY (notificationID);


ALTER TABLE Report ADD CONSTRAINT PK_Report
	PRIMARY KEY (reportID);


ALTER TABLE Win ADD CONSTRAINT PK_Win
	PRIMARY KEY (winID);




ALTER TABLE Add_Credits ADD CONSTRAINT add credits
	FOREIGN KEY (normal_UserID) REFERENCES Normal_User (normal_UserID);

ALTER TABLE Auction ADD CONSTRAINT win
	FOREIGN KEY (normal_UserID) REFERENCES Normal_User (normal_UserID);

ALTER TABLE Auction ADD CONSTRAINT create
	FOREIGN KEY (normal_UserID) REFERENCES Normal_User (normal_UserID);

ALTER TABLE Auction ADD CONSTRAINT accepts
	FOREIGN KEY (autheticated_UserID) REFERENCES Autheticated_User (autheticated_UserID);

ALTER TABLE Auction ADD CONSTRAINT rejects
	FOREIGN KEY (autheticated_UserID) REFERENCES Autheticated_User (autheticated_UserID);

ALTER TABLE Autheticated_User ADD CONSTRAINT add
	FOREIGN KEY (autheticated_UserID) REFERENCES Autheticated_User (autheticated_UserID);

ALTER TABLE Autheticated_User ADD CONSTRAINT remove
	FOREIGN KEY (autheticated_UserID) REFERENCES Autheticated_User (autheticated_UserID);

ALTER TABLE bid ADD CONSTRAINT Auction
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE bid ADD CONSTRAINT Normal_User
	FOREIGN KEY (normal_UserID) REFERENCES Normal_User (normal_UserID);

ALTER TABLE Category ADD CONSTRAINT has
	FOREIGN KEY (categoryID) REFERENCES Category (categoryID);

ALTER TABLE City ADD CONSTRAINT FK_City_Country
	FOREIGN KEY (countryID) REFERENCES Country (countryID);

ALTER TABLE Comment ADD CONSTRAINT to
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE Comment ADD CONSTRAINT removes
	FOREIGN KEY (autheticated_UserID) REFERENCES Autheticated_User (autheticated_UserID);

ALTER TABLE Comment ADD CONSTRAINT adds
	FOREIGN KEY (normal_UserID) REFERENCES Normal_User (normal_UserID);

ALTER TABLE Normal_User ADD CONSTRAINT FK_Normal_User_Autheticated_User
	FOREIGN KEY (normal_UserID) REFERENCES Autheticated_User (autheticated_UserID);

ALTER TABLE Normal_User ADD CONSTRAINT blocks
	FOREIGN KEY (autheticated_UserID) REFERENCES Autheticated_User (autheticated_UserID);

ALTER TABLE Normal_User ADD CONSTRAINT FK_Normal_User_City
	FOREIGN KEY (cityID) REFERENCES City (cityID);

ALTER TABLE Notification ADD CONSTRAINT pertains to
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE Notification ADD CONSTRAINT receives
	FOREIGN KEY (autheticated_UserID) REFERENCES Autheticated_User (autheticated_UserID);

ALTER TABLE pertains to ADD CONSTRAINT Category
	FOREIGN KEY (categoryID) REFERENCES Category (categoryID);

ALTER TABLE pertains to ADD CONSTRAINT Auction
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE report ADD CONSTRAINT Auction
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE report ADD CONSTRAINT Normal_User
	FOREIGN KEY (normal_UserID) REFERENCES Normal_User (normal_UserID);
