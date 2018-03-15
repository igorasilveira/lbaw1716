ALTER TABLE Active DROP CONSTRAINT FK_Active_Auction
;
ALTER TABLE Active DROP CONSTRAINT wins
;
ALTER TABLE Administrador DROP CONSTRAINT FK_Administrador_Moderator
;
ALTER TABLE Bidder DROP CONSTRAINT FK_Bidder_Normal User
;
ALTER TABLE Category DROP CONSTRAINT edits
;
ALTER TABLE City DROP CONSTRAINT FK_City_Country
;
ALTER TABLE Comment DROP CONSTRAINT Active
;
ALTER TABLE Comment DROP CONSTRAINT Normal User
;
ALTER TABLE Comment DROP CONSTRAINT Moderator
;
ALTER TABLE Location DROP CONSTRAINT FK_Location_City
;
ALTER TABLE Moderator DROP CONSTRAINT adds       
;
ALTER TABLE Moderator DROP CONSTRAINT removes
;
ALTER TABLE Moderator DROP CONSTRAINT FK_Moderator_Authenticated User
;
ALTER TABLE Normal User DROP CONSTRAINT FK_Normal User_Authenticated User
;
ALTER TABLE Normal User DROP CONSTRAINT FK_Normal User_Location
;
ALTER TABLE Normal User DROP CONSTRAINT blocks
;
ALTER TABLE Pending DROP CONSTRAINT FK_Pending_Auction
;
ALTER TABLE Pending DROP CONSTRAINT accepts
;
ALTER TABLE Pending DROP CONSTRAINT refuses
;
ALTER TABLE Pending DROP CONSTRAINT creates 
;
ALTER TABLE pertains to DROP CONSTRAINT Category
;
ALTER TABLE pertains to DROP CONSTRAINT Auction
;
ALTER TABLE places a bid on DROP CONSTRAINT Active
;
ALTER TABLE places a bid on DROP CONSTRAINT Bidder
;
ALTER TABLE Refused DROP CONSTRAINT FK_Refused_Auction
;
ALTER TABLE Seller DROP CONSTRAINT FK_Seller_Normal User
;
ALTER TABLE System Message DROP CONSTRAINT receives 
;

DROP TABLE IF EXISTS Active
;
DROP TABLE IF EXISTS Administrador
;
DROP TABLE IF EXISTS Auction
;
DROP TABLE IF EXISTS Authenticated User
;
DROP TABLE IF EXISTS Bid
;
DROP TABLE IF EXISTS Bidder
;
DROP TABLE IF EXISTS Category
;
DROP TABLE IF EXISTS City
;
DROP TABLE IF EXISTS Comment
;
DROP TABLE IF EXISTS Comment
;
DROP TABLE IF EXISTS Comment
;
DROP TABLE IF EXISTS Country
;
DROP TABLE IF EXISTS Location
;
DROP TABLE IF EXISTS Moderator
;
DROP TABLE IF EXISTS Normal User
;
DROP TABLE IF EXISTS Pending
;
DROP TABLE IF EXISTS pertains to
;
DROP TABLE IF EXISTS places a bid on
;
DROP TABLE IF EXISTS Refused
;
DROP TABLE IF EXISTS Seller
;
DROP TABLE IF EXISTS System Message
;
DROP TABLE IF EXISTS Won
;

CREATE TABLE Active ( 
	dateOfStart Date NULL,
	numberOfBids Int NULL,
	lastBid Bid NULL,
	activeID integer NOT NULL,
	bidderID integer NOT NULL
)
;

CREATE TABLE Administrador ( 
	administradorID integer NOT NULL
)
;

CREATE TABLE Auction ( 
	title varchar(50) NULL,
	description varchar(50) NULL,
	sellingReason varchar(50) NULL,
	pathToPhoto varchar(50) NULL,
	startingPrice Int NULL,
	minimumSellingPrice Int NULL,
	buyNow Int NULL,
	maxLifeTime Int NULL,
	auctionID integer NOT NULL
)
;

CREATE TABLE Authenticated User ( 
	username varchar(50) NULL,
	password varchar(50) NULL,
	pathToPhoto varchar(50) NULL,
	authenticated UserID integer NOT NULL
)
;

CREATE TABLE Bid ( 
	dateOfBid Date NULL,
	value Int NULL,
	bidID integer NOT NULL
)
;

CREATE TABLE Bidder ( 
	bidderID integer NOT NULL
)
;

CREATE TABLE Category ( 
	name varchar(50) NULL,
	subcategories List NULL,
	categoryID integer NOT NULL,
	administradorID integer NOT NULL
)
;

CREATE TABLE City ( 
	name varchar(50) NULL,
	cityID integer NOT NULL,
	countryID integer NOT NULL
)
;

CREATE TABLE Comment ( 
	activeID integer NULL,
	normal UserID integer NULL,
	moderatorID integer NULL
)
;

CREATE TABLE Comment ( 
	date Date NULL,
	description varchar(50) NULL,
	commentID integer NOT NULL
)
;

CREATE TABLE Comment ( 
	commentID integer NOT NULL
)
;

CREATE TABLE Country ( 
	name varchar(50) NULL,
	countryID integer NOT NULL
)
;

CREATE TABLE Location ( 
	address varchar(50) NULL,
	postalCode varchar(50) NULL,
	locationID integer NOT NULL,
	cityID integer NOT NULL
)
;

CREATE TABLE Moderator ( 
	numberOfManagingAuctions Int NULL,
	moderatorID integer NOT NULL,
	administradorID integer NOT NULL
)
;

CREATE TABLE Normal User ( 
	completeName varchar(50) NULL,
	email Email NULL,
	birthDate Date NULL,
	normal UserID integer NOT NULL,
	locationID integer NOT NULL,
	moderatorID integer NULL
)
;

CREATE TABLE Pending ( 
	pendingID integer NOT NULL,
	moderatorID integer NOT NULL,
	sellerID integer NOT NULL
)
;

CREATE TABLE pertains to ( 
	categoryID integer NULL,
	auctionID integer NULL
)
;

CREATE TABLE places a bid on ( 
	activeID integer NULL,
	bidderID integer NULL
)
;

CREATE TABLE Refused ( 
	dateOfRefusal Date NULL,
	reason varchar(50) NULL,
	refusedID integer NOT NULL
)
;

CREATE TABLE Seller ( 
	rating Int NULL,
	sellerID integer NOT NULL
)
;

CREATE TABLE System Message ( 
	date Date NULL,
	description varchar(50) NULL,
	system MessageID integer NOT NULL,
	authenticated UserID integer NOT NULL
)
;

CREATE TABLE Won ( 
	date Date NULL,
	finalPrice Int NULL,
	wonID integer NOT NULL
)
;


ALTER TABLE Active ADD CONSTRAINT PK_Active 
	PRIMARY KEY (activeID)
;


ALTER TABLE Administrador ADD CONSTRAINT PK_Administrador 
	PRIMARY KEY (administradorID)
;


ALTER TABLE Auction ADD CONSTRAINT PK_Auction 
	PRIMARY KEY (auctionID)
;


ALTER TABLE Authenticated User ADD CONSTRAINT PK_Authenticated User 
	PRIMARY KEY (authenticated UserID)
;


ALTER TABLE Bid ADD CONSTRAINT PK_Bid 
	PRIMARY KEY (bidID)
;


ALTER TABLE Bidder ADD CONSTRAINT PK_Bidder 
	PRIMARY KEY (bidderID)
;


ALTER TABLE Category ADD CONSTRAINT PK_Category 
	PRIMARY KEY (categoryID)
;


ALTER TABLE City ADD CONSTRAINT PK_City 
	PRIMARY KEY (cityID)
;


ALTER TABLE Comment ADD CONSTRAINT PK_Comment 
	PRIMARY KEY (commentID)
;


ALTER TABLE Comment ADD CONSTRAINT PK_Comment 
	PRIMARY KEY (commentID)
;


ALTER TABLE Country ADD CONSTRAINT PK_Country 
	PRIMARY KEY (countryID)
;


ALTER TABLE Location ADD CONSTRAINT PK_Location 
	PRIMARY KEY (locationID)
;


ALTER TABLE Moderator ADD CONSTRAINT PK_Moderator 
	PRIMARY KEY (moderatorID)
;


ALTER TABLE Normal User ADD CONSTRAINT PK_Normal User 
	PRIMARY KEY (normal UserID)
;


ALTER TABLE Pending ADD CONSTRAINT PK_Pending 
	PRIMARY KEY (pendingID)
;


ALTER TABLE Refused ADD CONSTRAINT PK_Refused 
	PRIMARY KEY (refusedID)
;


ALTER TABLE Seller ADD CONSTRAINT PK_Seller 
	PRIMARY KEY (sellerID)
;


ALTER TABLE System Message ADD CONSTRAINT PK_System Message 
	PRIMARY KEY (system MessageID)
;


ALTER TABLE Won ADD CONSTRAINT PK_Won 
	PRIMARY KEY (wonID)
;




ALTER TABLE Active ADD CONSTRAINT FK_Active_Auction 
	FOREIGN KEY (activeID) REFERENCES Auction (auctionID)
;

ALTER TABLE Active ADD CONSTRAINT wins 
	FOREIGN KEY (bidderID) REFERENCES Bidder (bidderID)
;

ALTER TABLE Administrador ADD CONSTRAINT FK_Administrador_Moderator 
	FOREIGN KEY (administradorID) REFERENCES Moderator (moderatorID)
;

ALTER TABLE Bidder ADD CONSTRAINT FK_Bidder_Normal User 
	FOREIGN KEY (bidderID) REFERENCES Normal User (normal UserID)
;

ALTER TABLE Category ADD CONSTRAINT edits 
	FOREIGN KEY (administradorID) REFERENCES Administrador (administradorID)
;

ALTER TABLE City ADD CONSTRAINT FK_City_Country 
	FOREIGN KEY (countryID) REFERENCES Country (countryID)
;

ALTER TABLE Comment ADD CONSTRAINT Active 
	FOREIGN KEY (activeID) REFERENCES Active (activeID)
;

ALTER TABLE Comment ADD CONSTRAINT Normal User 
	FOREIGN KEY (normal UserID) REFERENCES Normal User (normal UserID)
;

ALTER TABLE Comment ADD CONSTRAINT Moderator 
	FOREIGN KEY (moderatorID) REFERENCES Moderator (moderatorID)
;

ALTER TABLE Location ADD CONSTRAINT FK_Location_City 
	FOREIGN KEY (cityID) REFERENCES City (cityID)
;

ALTER TABLE Moderator ADD CONSTRAINT adds        
	FOREIGN KEY (administradorID) REFERENCES Administrador (administradorID)
;

ALTER TABLE Moderator ADD CONSTRAINT removes 
	FOREIGN KEY (administradorID) REFERENCES Administrador (administradorID)
;

ALTER TABLE Moderator ADD CONSTRAINT FK_Moderator_Authenticated User 
	FOREIGN KEY (moderatorID) REFERENCES Authenticated User (authenticated UserID)
;

ALTER TABLE Normal User ADD CONSTRAINT FK_Normal User_Authenticated User 
	FOREIGN KEY (normal UserID) REFERENCES Authenticated User (authenticated UserID)
;

ALTER TABLE Normal User ADD CONSTRAINT FK_Normal User_Location 
	FOREIGN KEY (locationID) REFERENCES Location (locationID)
;

ALTER TABLE Normal User ADD CONSTRAINT blocks 
	FOREIGN KEY (moderatorID) REFERENCES Moderator (moderatorID)
;

ALTER TABLE Pending ADD CONSTRAINT FK_Pending_Auction 
	FOREIGN KEY (pendingID) REFERENCES Auction (auctionID)
;

ALTER TABLE Pending ADD CONSTRAINT accepts 
	FOREIGN KEY (moderatorID) REFERENCES Moderator (moderatorID)
;

ALTER TABLE Pending ADD CONSTRAINT refuses 
	FOREIGN KEY (moderatorID) REFERENCES Moderator (moderatorID)
;

ALTER TABLE Pending ADD CONSTRAINT creates  
	FOREIGN KEY (sellerID) REFERENCES Seller (sellerID)
;

ALTER TABLE pertains to ADD CONSTRAINT Category 
	FOREIGN KEY (categoryID) REFERENCES Category (categoryID)
;

ALTER TABLE pertains to ADD CONSTRAINT Auction 
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID)
;

ALTER TABLE places a bid on ADD CONSTRAINT Active 
	FOREIGN KEY (activeID) REFERENCES Active (activeID)
;

ALTER TABLE places a bid on ADD CONSTRAINT Bidder 
	FOREIGN KEY (bidderID) REFERENCES Bidder (bidderID)
;

ALTER TABLE Refused ADD CONSTRAINT FK_Refused_Auction 
	FOREIGN KEY (refusedID) REFERENCES Auction (auctionID)
;

ALTER TABLE Seller ADD CONSTRAINT FK_Seller_Normal User 
	FOREIGN KEY (sellerID) REFERENCES Normal User (normal UserID)
;

ALTER TABLE System Message ADD CONSTRAINT receives  
	FOREIGN KEY (authenticated UserID) REFERENCES Authenticated User (authenticated UserID)
;
