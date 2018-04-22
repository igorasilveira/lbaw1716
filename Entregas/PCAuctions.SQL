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

CREATE TABLE Country
(
	id integer SERIAL NOT NULL PRIMARY KEY,
	"name" varchar(50) NOT NULL UNIQUE
);

CREATE TABLE City
(
	id integer SERIAL NOT NULL PRIMARY KEY,
	"name" varchar(50) NOT NULL UNIQUE,
	country integer NOT NULL REFERENCES Country (id)
);

CREATE TABLE Authenticated_User
(
	id integer SERIAL NOT NULL PRIMARY KEY,
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

CREATE TABLE Auction
(
	id integer SERIAL NOT NULL PRIMARY KEY,
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
	numberofbids integer NULL,
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

CREATE TABLE Add_Credits
(
	id integer SERIAL NOT NULL PRIMARY KEY,
	"value" integer NOT NULL,
	"date" TIMESTAMP WITH TIME zone NOT NULL,
	paypalID integer NOT NULL,
	"user" INT NOT NULL REFERENCES Authenticated_User (id)
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
	categoryID SERIAL integer NOT NULL PRIMARY KEY,
	"name" varchar(50) NOT NULL UNIQUE,
	parent integer NULL REFERENCES Category (categoryID)
);

CREATE TABLE Comment
(
	id integer SERIAL NOT NULL PRIMARY KEY,
	"date" TIMESTAMP WITH TIME zone NOT NULL,
	description varchar (50) NOT NULL,
	auctionCommented integer NOT NULL REFERENCES Auction (id),
	moderatorThatErased integer NULL REFERENCES Authenticated_User (id),
	userCommenter integer NOT NULL REFERENCES Authenticated_User (id)
);

CREATE TABLE Notification
(
	id integer SERIAL NOT NULL PRIMARY KEY,
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

CREATE FUNCTION check_Block_Users(blocked integer,blocker integer)
RETURNS BOOLEAN AS $$
DECLARE passed BOOLEAN;
DECLARE blokedUser TypeOfUser;
DECLARE blokerUser TypeOfUser;
BEGIN
		SELECT typeOfUser INTO blokedUser FROM Authenticated_User where id = blocked ;
		SELECT typeOfUser INTO blokerUser FROM Authenticated_User where id = blocker ;
		IF blokedUser = 'Normal'::TypeOfUser AND (blokerUser = 'Administrator'::TypeOfUser OR blokerUser = 'Moderator'::TypeOfUser)
		THEN passed := true;
		ELSE passed := false;
		END IF;
		RETURN passed;
END; $$
LANGUAGE plpgsql;

CREATE FUNCTION check_Edit_Moderators(removedMod integer,removerAdmin integer)
RETURNS BOOLEAN AS $$
DECLARE passed BOOLEAN;
DECLARE removerModUser TypeOfUser;
DECLARE removerAdminUser TypeOfUser;
BEGIN
		SELECT typeOfUser INTO removerModUser FROM Authenticated_User where id = removedMod ;
		SELECT typeOfUser INTO removerAdminUser FROM Authenticated_User where id = removerAdmin ;
		IF removerModUser = 'Moderator'::TypeOfUser AND removerAdminUser = 'Administrator'::TypeOfUser
		THEN passed := true;
		ELSE passed := false;
		END IF;
		RETURN passed;
END; $$
LANGUAGE plpgsql;
