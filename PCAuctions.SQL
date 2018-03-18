ALTER TABLE Add_Credits DROP CONSTRAINT add_credits;
ALTER TABLE Auction DROP CONSTRAINT win;
ALTER TABLE Auction DROP CONSTRAINT create;
ALTER TABLE Auction DROP CONSTRAINT accepts;
ALTER TABLE Auction DROP CONSTRAINT rejects;
ALTER TABLE Autheticated_User DROP CONSTRAINT add;
ALTER TABLE Autheticated_User DROP CONSTRAINT remove;
ALTER TABLE Bid DROP CONSTRAINT Auction;
ALTER TABLE Bid DROP CONSTRAINT Normal_User;
ALTER TABLE Category DROP CONSTRAINT has;
ALTER TABLE City DROP CONSTRAINT FK_City_Country;
ALTER TABLE Comment DROP CONSTRAINT to;
ALTER TABLE Comment DROP CONSTRAINT removes;
ALTER TABLE Comment DROP CONSTRAINT adds;
ALTER TABLE Normal_User DROP CONSTRAINT FK_Normal_User_Autheticated_User;
ALTER TABLE Normal_User DROP CONSTRAINT blocks;
ALTER TABLE Normal_User DROP CONSTRAINT FK_Normal_User_City;
ALTER TABLE Notification DROP CONSTRAINT pertains_to;
ALTER TABLE Notification DROP CONSTRAINT receives;
ALTER TABLE pertains_to DROP CONSTRAINT Category;
ALTER TABLE pertains_to DROP CONSTRAINT Auction;
ALTER TABLE Report DROP CONSTRAINT Auction;
ALTER TABLE Report DROP CONSTRAINT Normal_User;


DROP TABLE IF EXISTS Add_Credits;
DROP TABLE IF EXISTS Auction;
DROP TABLE IF EXISTS Autheticated_User;
DROP TABLE IF EXISTS Bid;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Country;
DROP TABLE IF EXISTS Normal_User;
DROP TABLE IF EXISTS Notification;
DROP TABLE IF EXISTS pertains_to;
DROP TABLE IF EXISTS Report;
DROP TABLE IF EXISTS Win;
DROP TABLE IF EXISTS Block;
DROP TABLE IF EXISTS Remove_Moderator;
DROP TABLE IF EXISTS Create_Moderator;


    CREATE TABLE Add_Credits (
	     value Int NOT NULL,
	     date Date NOT NULL,
	     add_CreditsID integer NOT NULL,
	     normalUserID integer NOT NULL
    );

    CREATE TABLE Auction (
	     state Enum NOT NULL,
	     title varchar(50) NOT NULL,
       description varchar(50) NULL,
	     sellingReason varchar(50) NULL,
	     pathToPhoto varchar(50) NULL,
	     startingPrice Int NOT NULL,
	     minimumSellingPrice Int NULL,
	     buyNow Int NULL,
	     startDate Date NULL,
	     limitDate Date NOT NULL,
	     refusalDate Date NULL,
	     /numberOfBids Int NULL,
	     reasonOfRefusal varchar(50) NULL,
	     auctionID integer NOT NULL,
	     normalUserID integer NOT NULL,
	     authenticatedUserID integer NOT NULL
    );

    CREATE TABLE Autheticated_User (
	    typeOfUser Enum NOT NULL,
	    username varchar(50) NOT NULL,
	    password varchar(50) NOT NULL,
	    pathToPhoto varchar(50) NULL,
	    authenticatedUserID integer NOT NULL
    );

    CREATE TABLE Bid (
	     date Date NOT NULL,
	     value Int NOT NULL,
	     bidID integer NOT NULL,
       auctionID integer NULL,
       normalUserID integer NULL
    );

    CREATE TABLE Category (
	     name varchar(50) NULL,
	     subcategories NULL,
	     categoryID integer NOT NULL
    );

    CREATE TABLE City (
	     name varchar(50) NOT NULL,
	     cityID integer NOT NULL,
	     countryID integer NOT NULL
    );

    CREATE TABLE Comment (
	     date Date NOT NULL,
	     description varchar(50) NOT NULL,
	     commentID integer NOT NULL,
	     auctionID integer NOT NULL,
	     authenticatedUserID integer NULL,
	     normalUserID integer NOT NULL
    );

    CREATE TABLE Country (
	     name varchar(50) NOT NULL,
	     countryID integer NOT NULL
    );

    CREATE TABLE Normal_User (
	     state Enum NULL,
	     completeName varchar(50) NOT NULL,
	     email Email NOT NULL,
	     birthDate Date NULL,
	     /rating Int NULL,
	     address varchar(50) NOT NULL,
	     postalCode varchar(50) NOT NULL,
	     balance Int NULL,
	     normalUserID integer NOT NULL,
	     authenticatedUserID integer NULL,
	     cityID integer NOT NULL
    );

    CREATE TABLE Notification (
	     date Date NOT NULL,
	     description varchar(50) NOT NULL,
	     type varchar(50) NOT NULL,
	     notificationID integer NOT NULL,
	     auctionID integer NULL,
	     authenticatedUserID integer NOT NULL
    );

    CREATE TABLE pertains_to (
	     categoryID integer NULL,
	     auctionID integer NULL
    );

    CREATE TABLE Report (
	     date Date NOT NULL,
	     reason varchar(50) NOT NULL,
	     reportID integer NOT NULL,
       	 auctionID integer NULL,
         NormalUserID integer NULL
    );

    CREATE TABLE Win (
	     date Date NOT NULL,
	     finalPrice Int NOT NULL,
	     rate Int NULL,
	     winID integer NOT NULL
    );

	CREATE TABLE Blocks (
		normalUserID integer NULL,
		authenticatedUserID integer NULL
    );

	CREATE TABLE Remove_Moderator (
	     authenticatedUserID integer NULL,
		 removeMod integer NULL
    );

	CREATE TABLE Create_Moderator (
		authenticatedUserID integer,
		addedMod integer NULL
    );


ALTER TABLE Add_Credits ADD CONSTRAINT PK_Add_Credits
	PRIMARY KEY (add_CreditsID);


ALTER TABLE Auction ADD CONSTRAINT PK_Auction
	PRIMARY KEY (auctionID);


ALTER TABLE Autheticated_User ADD CONSTRAINT PK_Autheticated_User
	PRIMARY KEY (authenticatedUserID);


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
	PRIMARY KEY (normalUserID);


ALTER TABLE Notification ADD CONSTRAINT PK_Notification
	PRIMARY KEY (notificationID);


ALTER TABLE Report ADD CONSTRAINT PK_Report
	PRIMARY KEY (reportID);


ALTER TABLE Win ADD CONSTRAINT PK_Win
	PRIMARY KEY (winID);


ALTER TABLE Add_Credits ADD CONSTRAINT add_credits
	FOREIGN KEY (normalUserID) REFERENCES Normal_User (normalUserID);

ALTER TABLE Auction ADD CONSTRAINT win
	FOREIGN KEY (normalUserID) REFERENCES Normal_User (normalUserID);

ALTER TABLE Auction ADD CONSTRAINT create
	FOREIGN KEY (normalUserID) REFERENCES Normal_User (normalUserID);

ALTER TABLE Auction ADD CONSTRAINT accepts
	FOREIGN KEY (authenticatedUserID) REFERENCES Autheticated_User (authenticatedUserID);

ALTER TABLE Auction ADD CONSTRAINT rejects
	FOREIGN KEY (authenticatedUserID) REFERENCES Autheticated_User (authenticatedUserID);

ALTER TABLE Autheticated_User ADD CONSTRAINT add
	FOREIGN KEY (authenticatedUserID) REFERENCES Autheticated_User (authenticatedUserID);

ALTER TABLE Autheticated_User ADD CONSTRAINT remove
	FOREIGN KEY (authenticatedUserID) REFERENCES Autheticated_User (authenticatedUserID);

ALTER TABLE Bid ADD CONSTRAINT Auction
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE Bid ADD CONSTRAINT Normal_User
	FOREIGN KEY (normalUserID) REFERENCES Normal_User (normalUserID);

ALTER TABLE Category ADD CONSTRAINT has
	FOREIGN KEY (categoryID) REFERENCES Category (categoryID);

ALTER TABLE City ADD CONSTRAINT FK_City_Country
	FOREIGN KEY (countryID) REFERENCES Country (countryID);

ALTER TABLE Comment ADD CONSTRAINT to
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE Comment ADD CONSTRAINT removes
	FOREIGN KEY (authenticatedUserID) REFERENCES Autheticated_User (authenticatedUserID);

ALTER TABLE Comment ADD CONSTRAINT adds
	FOREIGN KEY (normalUserID) REFERENCES Normal_User (normalUserID);

ALTER TABLE Normal_User ADD CONSTRAINT FK_Normal_User_Autheticated_User
	FOREIGN KEY (normalUserID) REFERENCES Autheticated_User (authenticatedUserID);

ALTER TABLE Normal_User ADD CONSTRAINT blocks
	FOREIGN KEY (authenticatedUserID) REFERENCES Autheticated_User (authenticatedUserID);

ALTER TABLE Normal_User ADD CONSTRAINT FK_Normal_User_City
	FOREIGN KEY (cityID) REFERENCES City (cityID);

ALTER TABLE Notification ADD CONSTRAINT pertains_to
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE Notification ADD CONSTRAINT receives
	FOREIGN KEY (authenticatedUserID) REFERENCES Autheticated_User (authenticatedUserID);

ALTER TABLE pertains_to ADD CONSTRAINT Category
	FOREIGN KEY (categoryID) REFERENCES Category (categoryID);

ALTER TABLE pertains_to ADD CONSTRAINT Auction
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE Report ADD CONSTRAINT Auction
	FOREIGN KEY (auctionID) REFERENCES Auction (auctionID);

ALTER TABLE Report ADD CONSTRAINT Normal_User
	FOREIGN KEY (normalUserID) REFERENCES Normal_User (normalUserID);

ALTER TABLE Report ADD CONSTRAINT Normal_User
	FOREIGN KEY (normalUserID) REFERENCES Normal_User (normalUserID);