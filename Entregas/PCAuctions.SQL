Authentica/*
ALTER TABLE Add_Credits DROP CONSTRAINT add_credits;
ALTER TABLE Auction DROP CONSTRAINT win;
ALTER TABLE Auction DROP CONSTRAINT "create";
ALTER TABLE Auction DROP CONSTRAINT accepts;
ALTER TABLE Auction DROP CONSTRAINT rejects;
ALTER TABLE Authenticated_User DROP CONSTRAINT "add";
ALTER TABLE Authenticated_User DROP CONSTRAINT remove;
ALTER TABLE Authenticated_User DROP CONSTRAINT FK_Authenticated_User_Authenticated_User;
ALTER TABLE Authenticated_User DROP CONSTRAINT blocks;
ALTER TABLE Authenticated_User DROP CONSTRAINT FK_Authenticated_User_City;
ALTER TABLE Bid DROP CONSTRAINT Auction;
ALTER TABLE Bid DROP CONSTRAINT Authenticated_User;
ALTER TABLE Category DROP CONSTRAINT has;
ALTER TABLE City DROP CONSTRAINT FK_City_Country;
ALTER TABLE Comment DROP CONSTRAINT "to";
ALTER TABLE Comment DROP CONSTRAINT removes;
ALTER TABLE Comment DROP CONSTRAINT adds;
ALTER TABLE Notification DROP CONSTRAINT pertains_to;
ALTER TABLE Notification DROP CONSTRAINT receives;
ALTER TABLE CategoryOfAuction DROP CONSTRAINT Category;
ALTER TABLE CategoryOfAuction DROP CONSTRAINT Auction;
ALTER TABLE Report DROP CONSTRAINT Auction;
ALTER TABLE Report DROP CONSTRAINT Authenticated_User;
ALTER TABLE Blocks DROP CONSTRAINT Authenticated_User;
ALTER TABLE Blocks DROP CONSTRAINT Authenticated_User;
ALTER TABLE Edit_Moderator DROP CONSTRAINT Authenticated_User;
ALTER TABLE Edit_Moderator DROP CONSTRAINT Authenticated_User;
ALTER TABLE Edit_Categories DROP CONSTRAINT Category;
ALTER TABLE Edit_Categories DROP CONSTRAINT Authenticated_User;
*/
DROP TABLE IF EXISTS Add_Credits CASCADE;
DROP TABLE IF EXISTS Auction CASCADE;
DROP TABLE IF EXISTS Authenticated_User CASCADE;
DROP TABLE IF EXISTS Bid CASCADE;
DROP TABLE IF EXISTS Category CASCADE;
DROP TABLE IF EXISTS City CASCADE;
DROP TABLE IF EXISTS Comment CASCADE;
DROP TABLE IF EXISTS Country CASCADE;
DROP TABLE IF EXISTS Authenticated_User CASCADE;
DROP TABLE IF EXISTS Notification CASCADE;
DROP TABLE IF EXISTS CategoryOfAuction CASCADE;
DROP TABLE IF EXISTS Report CASCADE;
DROP TABLE IF EXISTS Blocks CASCADE;
DROP TABLE IF EXISTS Edit_Moderator CASCADE;
DROP TABLE IF EXISTS Edit_Categories CASCADE;

DROP TYPE IF EXISTS AuctionSate;
DROP TYPE IF EXISTS BlockingState;
DROP TYPE IF EXISTS TypeOfUser;

CREATE TYPE AuctionSate AS ENUM ('Active', 'Rejected', 'Pending');

CREATE TYPE BlockingState AS ENUM ('Blocked', 'Allowed');

CREATE TYPE TypeOfUser	AS ENUM ('Moderator', 'Administrator', 'Normal');

CREATE TABLE Add_Credits
(
	id integer NOT NULL PRIMARY KEY,
	"value" integer NOT NULL,
	"date" TIMESTAMP WITH TIME zone NOT NULL,
	paypalID integer NOT NULL,
	"user" INT NOT NULL REFERENCES Authenticated_User (id)
);

CREATE TABLE Auction
(
	id integer NOT NULL PRIMARY KEY,
	state AuctionSate NOT NULL,
	title varchar(50) NOT NULL,
	description varchar(50) NULL,
	sellingReason varchar(50) NULL,
	pathToPhoto varchar(50) NULL,
	startingPrice integer NOT NULL CHECK (startingPrice > 0),
	minimumSellingPrice integer NULL CHECK (minimumSellingPrice > 0),
	buyNow integer NULL CHECK (buyNow > 0),
	startDate TIMESTAMP WITH TIME zone NOT NULL,
	limitDate TIMESTAMP WITH TIME zone NOT NULL,
	refusalDate TIMESTAMP WITH TIME zone NULL,
	"/numberOfBids" integer NULL,
	reasonOfRefusal varchar(50) NULL,
  	finalDate TIMESTAMP WITH TIME zone NULL,
  	finalPrice integer NULL,
	rate integer NULL CHECK (rate >= 0 AND rate <=5),
	auctionCreator integer NOT NULL REFERENCES Authenticated_User (id),
  	auctionWinner integer NULL REFERENCES Authenticated_User (id),
	responsibleModerator integer NULL REFERENCES Authenticated_User (id),
	CHECK ((minimumSellingPrice > startingPrice OR minimumSellingPrice = NULL)
				 AND
				 (buyNow > startingPrice OR buyNow = NULL)
	)
);

CREATE TABLE Authenticated_User
(
	id integer NOT NULL PRIMARY KEY,
	typeOfUser TypeOfUser NOT NULL,
	username varchar(50) NOT NULL UNIQUE,
	"password" varchar(50) NOT NULL,
	pathToPhoto varchar(50) NULL,
	completeName varchar(50) NOT NULL,
	email varchar(50) NULL UNIQUE,
	birthDate TIMESTAMP WITH TIME zone NULL,
	"/rating" integer NULL CHECK ("/rating" >= 0 AND "/rating" <=5),
	address varchar(50) NULL,
	postalCode varchar(50) NULL,
	balance integer NULL CHECK (balance >= 0),
	city integer NULL REFERENCES City (id)
);

CREATE TABLE Bid
(
	"date" TIMESTAMP WITH TIME zone NOT NULL,
	"value" integer NOT NULL,
	auctionBidded integer NOT NULL REFERENCES Auction (id),
  	bidder integer NOT NULL REFERENCES Authenticated_User (id),
	PRIMARY KEY (auctionBidded,bidder)
);

CREATE TABLE Category
(
	categoryID integer NOT NULL PRIMARY KEY,
	"name" varchar(50) NOT NULL UNIQUE,
	parent integer NULL REFERENCES Category (categoryID)
);

CREATE TABLE City
(
	id integer NOT NULL PRIMARY KEY,
	"name" varchar(50) NOT NULL UNIQUE,
	country integer NOT NULL REFERENCES Country (id)
);

CREATE TABLE Comment
(
	id integer NOT NULL PRIMARY KEY,
	"date" TIMESTAMP WITH TIME zone NOT NULL,
	description varchar (50) NOT NULL,
	auctionCommented integer NOT NULL REFERENCES Auction (id),
	moderatorThatErased integer NULL REFERENCES Authenticated_User (id),
	userCommenter integer NOT NULL REFERENCES Authenticated_User (id)
);

CREATE TABLE Country
(
	id integer NOT NULL PRIMARY KEY,
	"name" varchar(50) NOT NULL UNIQUE
);

CREATE TABLE Notification
(
	id integer NOT NULL PRIMARY KEY,
	"date" TIMESTAMP WITH TIME zone NOT NULL,
	description varchar(50) NOT NULL,
  	"type" varchar(50) NOT NULL,
	auctionAssociated integer NULL REFERENCES Auction (id),
	authenticated_UserID integer NOT NULL REFERENCES Authenticated_User (id)
);

CREATE TABLE Report
(
	"date" TIMESTAMP WITH TIME zone NOT NULL,
	reason varchar(50) NOT NULL,
  	auctionID integer NOT NULL REFERENCES Auction (id),
  	normalUserID integer NOT NULL REFERENCES Authenticated_User (id)
);

CREATE TABLE CategoryOfAuction
(
	category integer NOT NULL  REFERENCES Category (categoryID),
	auction integer NOT NULL REFERENCES Auction (id)
);

CREATE TABLE Blocks
(
	state BlockingState NOT NULL,
	description varchar(50) NULL,
	"date" TIMESTAMP WITH TIME zone NOT NULL,
	blocked integer NULL  REFERENCES Authenticated_User (id),
	blocker integer NULL  REFERENCES Authenticated_User (id)
);

CREATE TABLE Edit_Moderator
(
	removedMod integer NULL REFERENCES Authenticated_User (id),
	removerAdmin integer NULL REFERENCES Authenticated_User (id)
);

CREATE TABLE Edit_Categories
(
	category integer NOT NULL REFERENCES Category (categoryID),
	"admin" integer NOT NULL REFERENCES Authenticated_User (id)
);
