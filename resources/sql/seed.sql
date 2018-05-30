
DROP SCHEMA IF EXISTS public cascade;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: lbaw1716
--

CREATE SCHEMA public;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: lbaw1716
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET search_path = public, pg_catalog;

--
-- Name: auctionstate; Type: TYPE; Schema: public; Owner: lbaw1716
--

CREATE TYPE auctionstate AS ENUM (
    'Active',
    'Rejected',
    'Pending',
    'Over'
);

--
-- Name: blockingstate; Type: TYPE; Schema: public; Owner: lbaw1716
--

CREATE TYPE blockingstate AS ENUM (
    'Blocked',
    'Allowed'
);


--
-- Name: typeofuser; Type: TYPE; Schema: public; Owner: lbaw1716
--

CREATE TYPE typeofuser AS ENUM (
    'Moderator',
    'Administrator',
    'Normal'
);


--
-- Name: check_admin_modify_category(integer); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_admin_modify_category(admin integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE passed BOOLEAN;
DECLARE adminUser TypeOfUser;
BEGIN
SELECT typeOfUser INTO adminUser FROM "user" where id = admin ;
IF
adminUser = 'Administrator'::TypeOfUser THEN passed := true; ELSE passed := false;
END IF;
RETURN passed;
END;
$$;


--
-- Name: check_auction_users(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_auction_users(auctioncreator integer, auctionwinner integer, responsiblemoderator integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE passed BOOLEAN;
DECLARE createrUser TypeOfUser;
DECLARE winnerUser TypeOfUser;
DECLARE responsibleUser TypeOfUser;
BEGIN
	  SELECT typeOfUser INTO createrUser FROM "user" where id = auctioncreator ;
    IF(auctionwinner IS NULL)
	   THEN winnerUser := NULL ;
     ELSE SELECT typeOfUser INTO winnerUser FROM "user" where id = auctionwinner ;
    END IF;
    IF(responsiblemoderator IS NULL)
      THEN responsibleUser := NULL ;
      ELSE SELECT typeOfUser INTO responsibleUser FROM "user" where id = responsiblemoderator ;
    END IF;
	  IF createrUser = 'Normal'::TypeOfUser AND (winnerUser = 'Normal'::TypeOfUser OR winnerUser IS NULL) AND (responsibleUser = 'Moderator'::TypeOfUser OR responsibleUser = 'Administrator'::TypeOfUser OR responsibleUser IS NULL
    ) THEN passed := true;
		ELSE passed := false;
		END IF;
		RETURN passed;
END;$$;


--


--
-- Name: check_auction_win(auctionstate, timestamp with time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_auction_win(state auctionstate, finaldate timestamp with time zone, finalprice integer, auctionwinner integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE pass boolean;
BEGIN
  IF state = 'Over'::auctionstate
      THEN IF finaldate IS NOT NULL AND finalprice IS NOT NULL AND auctionwinner IS NOT NULL
           THEN pass := true;
           ELSE pass := false;
           END IF;
  ELSE pass := true;
  END IF;
  RETURN pass;
END;$$;


--



--
-- Name: check_block_users(integer, integer); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_block_users(_blocked integer, blocker integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE passed BOOLEAN;
DECLARE blokedUser TypeOfUser;
DECLARE blokerUser TypeOfUser;
BEGIN
		SELECT typeOfUser INTO blokedUser FROM "user" where id = _blocked ;
		SELECT typeOfUser INTO blokerUser FROM "user" where id = blocker ;
		IF blokedUser = 'Normal'::TypeOfUser AND (blokerUser = 'Administrator'::TypeOfUser OR blokerUser = 'Moderator'::TypeOfUser)
		THEN passed := true;
		ELSE passed := false;
		END IF;
RETURN passed;
END;$$;


--


--
-- Name: check_edit_moderators(integer, integer); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_edit_moderators(removedmod integer, removeradmin integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE passed boolean;
DECLARE removerModUser TypeOfUser;
DECLARE removerAdminUser TypeOfUser;
BEGIN
	SELECT typeOfUser INTO removerModUser FROM "user" where id = removedMod ;
	SELECT typeOfUser INTO removerAdminUser FROM "user" where id = removerAdmin ;
	IF removerModUser = 'Moderator'::TypeOfUser AND removerAdminUser = 'Administrator'::TypeOfUser
	THEN passed := true;
	ELSE passed := false;
	END IF;
RETURN passed;
END;$$;


--

--
-- Name: check_rejected_auction(auctionstate, timestamp with time zone, character varying); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_rejected_auction(state auctionstate, dateofrefusal timestamp with time zone, reasonofrefusal character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE pass boolean;
BEGIN
  IF state = 'Rejected'::auctionstate
      THEN IF dateOfRefusal IS NOT NULL AND reasonOfRefusal IS NOT NULL
           THEN pass := true;
           ELSE pass := false;
           END IF;
  ELSE pass := true;
  END IF;
  RETURN pass;
END;$$;







--
-- Name: get_current_user(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION get_current_user() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
    cur_user varchar;
BEGIN
    BEGIN
        cur_user := (SELECT "username" FROM curr_user);
    EXCEPTION WHEN undefined_table THEN
        cur_user := 'unknown_user';
    END;
    RETURN cur_user;
END;
$$;




--
-- Name: auto_increment_credits; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_credits
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auto_increment_country; Type: SEQUENCE; Schema: public; Owner: lbaw1716

CREATE SEQUENCE auto_increment_country
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
--
-- Name: add_credits; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE add_credits (
    id integer DEFAULT nextval('auto_increment_credits'::regclass) NOT NULL,
    value integer NOT NULL,
    date timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    paypalid character varying NOT NULL,
    "user" integer NOT NULL,
    "trasactionID" character varying NOT NULL
);


--
-- Name: auto_increment_auction; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_auction
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE password_resets (
  email VARCHAR(255) unique,
  token VARCHAR(255) not null,
  created_at timestamp
);

--
-- Name: auction; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE auction (
    id integer DEFAULT nextval('auto_increment_auction'::regclass) NOT NULL,
    state auctionstate NOT NULL,
    title character varying NOT NULL,
    description character varying,
    sellingreason character varying,
    pathtophoto character varying,
    startingprice integer NOT NULL,
    minimumsellingprice integer,
    buynow integer,
    startdate timestamp DEFAULT transaction_timestamp() NOT NULL,
    limitdate timestamp NOT NULL,
    refusaldate timestamp with time zone,
    numberofbids integer DEFAULT 0,
    reasonofrefusal character varying,
    finaldate timestamp with time zone,
    finalprice integer,
    rate integer,
    auctioncreator integer NOT NULL,
    auctionwinner integer,
    responsiblemoderator integer,
    CONSTRAINT auction_buynow_check CHECK ((buynow >= 0)),
    CONSTRAINT auction_check CHECK ((((minimumsellingprice > startingprice) OR (minimumsellingprice = NULL::integer)) AND ((buynow > startingprice) OR (buynow = NULL::integer)))),
    CONSTRAINT auction_minimumsellingprice_check CHECK ((minimumsellingprice > 0)),
    CONSTRAINT auction_rate_check CHECK (((rate >= 0) AND (rate <= 5))),
    CONSTRAINT auction_startingprice_check CHECK ((startingprice > 0)),
    CONSTRAINT check_auction_win CHECK (check_auction_win(state, finaldate, finalprice, auctionwinner)),
    CONSTRAINT check_dates CHECK ((age(limitdate, startdate) <= '7 days'::interval)),
    CONSTRAINT check_rejected CHECK (check_rejected_auction(state, refusaldate, reasonofrefusal)),
    CONSTRAINT check_users CHECK (check_auction_users(auctioncreator, auctionwinner, responsiblemoderator))
);


--
-- Name: auto_increment_category; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_category
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auto_increment_city; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_city
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auto_increment_comment; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_comment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auto_increment_notification; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_notification
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auto_increment_user; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_user
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bid; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE bid (
    id SERIAL NOT NULL,
    date timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    value integer NOT NULL,
    auction_id integer NOT NULL,
    user_id integer NOT NULL,
    "isBuyNow" boolean
);


--
-- Name: blocks; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE blocks (
    state blockingstate NOT NULL,
    description character varying,
    date timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    blocked integer NOT NULL,
    blocker integer NOT NULL,
    CONSTRAINT check_users CHECK (check_block_users(blocked, blocker))
);


--
-- Name: category; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE category (
    id integer DEFAULT nextval('auto_increment_category'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    parent integer,
    CONSTRAINT check_parent_not_equal CHECK ((parent <> id))
);

--
-- Name: categoryofauction; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE categoryofauction (
    category_id integer NOT NULL,
    auction_id integer NOT NULL
);


--
-- Name: city; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE city (
    id integer DEFAULT nextval('auto_increment_city'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    country integer NOT NULL
);

--
-- Name: comment; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE comment (
    id integer DEFAULT nextval('auto_increment_comment'::regclass) NOT NULL,
    date timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    description character varying NOT NULL,
    auctioncommented integer NOT NULL,
    usercommenter integer NOT NULL
);

--
-- Name: country; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE country (
    id integer DEFAULT nextval('auto_increment_country'::regclass) NOT NULL,
    name character varying(50) NOT NULL
);

--
-- Name: edit_categories; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE edit_categories (
    category integer NOT NULL,
    admin integer NOT NULL,
    CONSTRAINT check_admin_modify_category CHECK (check_admin_modify_category(admin))
);

--
-- Name: edit_moderator; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE edit_moderator (
    removedmod integer NOT NULL,
    removeradmin integer NOT NULL,
    CONSTRAINT check_users CHECK (check_edit_moderators(removedmod, removeradmin))
);

--
-- Name: notification; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE notification (
    id integer DEFAULT nextval('auto_increment_notification'::regclass) NOT NULL,
    date timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    description character varying NOT NULL,
    type character varying(50) NOT NULL,
    auctionassociated integer,
    authenticated_userid integer NOT NULL,
    _read boolean DEFAULT false
);

--
-- Name: report; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE report (
    date timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    reason character varying NOT NULL,
    auctionid integer NOT NULL,
    normaluserid integer NOT NULL
);

--
-- Name: user; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE "user" (
    id integer DEFAULT nextval('auto_increment_user'::regclass) NOT NULL,
    typeofuser typeofuser NOT NULL,
    username character varying(50) NOT NULL,
    password character varying NOT NULL,
    pathtophoto character varying,
    completename character varying,
    email character varying,
    birthdate date,
    "/rating" integer,
    address character varying,
    postalcode character varying(50),
    balance integer,
    city integer,
    phonenumber numeric,
    blocked boolean DEFAULT false NOT NULL,
    CONSTRAINT "authenticated_user_/rating_check" CHECK ((("/rating" >= 0) AND ("/rating" <= 5))),
    CONSTRAINT authenticated_user_balance_check CHECK ((balance >= 0))
);

--
-- Name: add_credits_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY add_credits
    ADD CONSTRAINT add_credits_pkey PRIMARY KEY (id);


--
-- Name: auction_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY auction
    ADD CONSTRAINT auction_pkey PRIMARY KEY (id);


--
-- Name: authenticated_user_email_key; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY "user"
    ADD CONSTRAINT authenticated_user_email_key UNIQUE (email);


--
-- Name: authenticated_user_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY "user"
    ADD CONSTRAINT authenticated_user_pkey PRIMARY KEY (id);


--
-- Name: authenticated_user_username_key; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY "user"
    ADD CONSTRAINT authenticated_user_username_key UNIQUE (username);


--
-- Name: bid_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY bid
    ADD CONSTRAINT bid_pkey PRIMARY KEY (id);


--
-- Name: blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (blocked, blocker);


--
-- Name: category_name_key; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY category
    ADD CONSTRAINT category_name_key UNIQUE (name);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: categoryofauction_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY categoryofauction
    ADD CONSTRAINT categoryofauction_pkey PRIMARY KEY (category_id, auction_id);


--
-- Name: city_name_key; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY city
    ADD CONSTRAINT city_name_key UNIQUE (name);


--
-- Name: city_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id);


--
-- Name: comment_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: country_name_key; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY country
    ADD CONSTRAINT country_name_key UNIQUE (name);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: edit_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY edit_categories
    ADD CONSTRAINT edit_categories_pkey PRIMARY KEY (category, admin);


--
-- Name: edit_moderator_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY edit_moderator
    ADD CONSTRAINT edit_moderator_pkey PRIMARY KEY (removedmod, removeradmin);

--
-- Name: report_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY report
    ADD CONSTRAINT report_pkey PRIMARY KEY (auctionid, normaluserid);

ALTER TABLE IF EXISTS ONLY "user" ADD COLUMN textsearchable_user_col tsvector;
ALTER TABLE IF EXISTS ONLY auction ADD COLUMN textsearchable_auction_col tsvector;

--
-- Name: add_credits_trigger(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION add_credits_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
UPDATE "user" SET balance = ((SELECT balance FROM "user" WHERE id = NEW.user) +  NEW.value) WHERE id = NEW.user;
RETURN NEW;
END;$$;





--
-- Name: auction_creator(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION auction_creator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF EXISTS (SELECT * FROM auction
    INNER JOIN "user" ON "user".id = auction.auctioncreator
    WHERE NEW.auction_id = auction.id AND NEW.user_id = "user".id) THEN
    RAISE EXCEPTION 'The creator of an auction cannot make a bid on it!';
  END IF;
  RETURN NEW;
END;$$;




--
-- Name: auction_reported(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION auction_reported() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your auction was reported!', 'Auction Reported', NEW.auctionid, (SELECT "auctioncreator" FROM "auction" WHERE id = NEW.auctionid));
RETURN NEW;
END;$$;




--
-- Name: bid_greater_than_last(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION bid_greater_than_last() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF EXISTS (SELECT * FROM bid WHERE NEW.auction_id = auction_id AND NEW.value <= value) THEN
		RAISE EXCEPTION 'A bid on this auction has to have a greater value than a previous one on this auction.';
        ELSE IF EXISTS(SELECT * FROM bid WHERE NEW.auction_id = auction_id)
        THEN
         UPDATE "user" SET balance = ((SELECT value FROM "bid" WHERE "bid".auction_id=NEW.auction_id ORDER BY value DESC LIMIT 1) + (SELECT balance FROM "user" WHERE id = (SELECT user_id FROM "bid" WHERE auction_id = NEW.auction_id ORDER BY value DESC LIMIT 1))) WHERE id = (SELECT user_id FROM "bid" WHERE auction_id = NEW.auction_id ORDER BY value DESC LIMIT 1);
        INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your bid on this auction was surpassed. Try again!', 'Bid Exceeded', NEW.auction_id, (SELECT user_id FROM "bid" WHERE auction_id = NEW.auction_id ORDER BY value DESC LIMIT 1));
        END IF;
      END IF;
	RETURN NEW;
END$$;


--
-- Name: user_id_has_money(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION user_id_has_money() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF EXISTS (SELECT * FROM "user" WHERE NEW.user_id = id AND NEW.value > balance)
  THEN
		RAISE EXCEPTION 'To make a bid on this auction the user_id must have a balance greater than bid value';
  ELSE IF EXISTS (SELECT * FROM "user" WHERE NEW.user_id = id AND NEW.value <= balance)
  THEN
      UPDATE "user" SET balance = (SELECT balance FROM "user" WHERE NEW.user_id = id) - NEW.value WHERE id = NEW.user_id;
  END IF;
	END IF;
	RETURN NEW;
END$$;


--
-- Name: buy_now(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION buy_now() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
IF EXISTS (SELECT * FROM "auction" WHERE NEW.auction_id = id AND NEW.value = buyNow AND NEW."isBuyNow" = true)
THEN
UPDATE auction SET state = 'Over'::auctionstate, finaldate = NEW.date, finalprice = NEW.value, auctionwinner = NEW.user_id WHERE id = NEW.auction_id;
INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'You win this auction!', 'Won Auction', NEW.auction_id, NEW.user_id);
END IF;
RETURN NEW;
END;$$;

--

--
-- Name: block_user(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION block_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
IF NEW.state = 'Allowed'::blockingstate
THEN UPDATE "user" SET "blocked" = true;
ELSE IF NEW.state = 'Blocked'::blockingstate
THEN UPDATE "user" SET "blocked" = false;
END IF;
END IF;
RETURN NEW;
END;$$;




--
-- Name: check_bid_value(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_bid_value() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
IF EXISTS (SELECT * FROM "auction" WHERE NEW.auction_id = id AND NEW.value < startingprice)
THEN
RAISE EXCEPTION 'A Bid has to have a greater value than starting price of auction.';
END IF;
RETURN NEW;
END;$$;





--
-- Name: delete_comment(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION delete_comment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your Comment on this auction was removed!', 'Comment Removed', OLD.auctioncommented, OLD.usercommenter);
RETURN OLD;
END;$$;




--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);

    CREATE FUNCTION notification_auction() RETURNS trigger
        LANGUAGE plpgsql
        AS $$BEGIN
    IF NEW.state = 'Pending'::auctionstate
    THEN
    INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your Auction was created!', 'Auction Created', NEW.id, NEW.auctioncreator);
    ELSE IF NEW.state = 'Active'::auctionstate
    THEN
    INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your Auction was accepted!', 'Auction Accepted', NEW.id, NEW.auctioncreator);
    ELSE IF NEW.state = 'Rejected'::auctionstate
    THEN
    INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your Auction was rejected!', 'Auction Rejected', NEW.id, NEW.auctioncreator);
    ELSE IF NEW.state = 'Over'::auctionstate
    THEN
    INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your Auction terminated!', 'Auction Over', NEW.id, NEW.auctioncreator);
    END IF;
    END IF;
    END IF;
    END IF;
    RETURN NEW;
    END;$$;




--
-- Name: update_ratings(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--


CREATE FUNCTION update_ratings() RETURNS trigger
LANGUAGE plpgsql
AS $$DECLARE sumOfExistRates integer;
DECLARE countOfExistRates integer;
BEGIN
IF NEW.rate IS NOT NULL
THEN
sumOfExistRates := (SELECT SUM(rate) FROM "auction" where auctioncreator = NEW.auctioncreator AND rate IS NOT NULL) ;
countOfExistRates := (SELECT COUNT(rate) FROM "auction" where auctioncreator = NEW.auctioncreator AND rate IS NOT NULL) ;
IF countOfExistRates IS NOT NULL
THEN UPDATE "user" SET "/rating" = ((sumOfExistRates + NEW.rate) / (countOfExistRates + 1)) WHERE NEW.auctioncreator = id;
ELSE UPDATE "user" SET "/rating" = NEW.rate;
END IF;
END IF;
RETURN NEW;
END;$$;


--
-- Name: update_bid_number(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION update_bid_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
UPDATE "auction" SET numberofbids = numberofbids + 1 WHERE "auction".id = NEW.auction_id;
RETURN NEW;
END;$$;
--

--
-- Name: win_auction(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION win_auction() RETURNS trigger
LANGUAGE plpgsql
AS $$BEGIN
IF (transaction_timestamp() >= NEW.limitdate AND NEW.state = 'Active'::auctionstate)
THEN
UPDATE "auction" SET state = 'Over'::auctionstate, finaldate = (  SELECT date
  FROM "bid"
  WHERE "bid".auction_id= NEW.id
  ORDER BY value DESC  ), finalprice = (  SELECT value
    FROM "bid"
    WHERE "bid".auction_id= NEW.id
    ORDER BY value DESC  ), auctionwinner = (  SELECT user_id
      FROM "bid"
      WHERE "bid".auction_id=NEW.id
      ORDER BY value DESC LIMIT 1) WHERE id = NEW.id;
      INSERT INTO Notification (date, description, type, auctionassociated, authenticated_userid) VALUES (transaction_timestamp(), 'You win this auction!', 'Won Auction', NEW.id, (SELECT user_id FROM "bid" WHERE auction_id = NEW.id ORDER BY value DESC LIMIT 1));
      END IF;
      RETURN NEW;
      END;$$;

--
-- Name: winner_rate_auction(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION winner_rate_auction() RETURNS trigger
LANGUAGE plpgsql
AS $$DECLARE curr_user text;
BEGIN
curr_user := get_current_user();
IF (NEW.auctionwinner != (SELECT id FROM "user" WHERE "user".username = curr_user))
THEN RAISE EXCEPTION 'A rate can only be attributed to the auction by its winner.';
END IF;
RETURN NEW;
END;$$;

--
-- Name: full_text_search_user(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--
CREATE FUNCTION full_text_search_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    NEW.textsearchable_user_col = to_tsvector('english', NEW.username);
RETURN NEW;
END;$$;

--
-- Name: full_text_search_auction(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--
CREATE FUNCTION full_text_search_auction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    NEW.textsearchable_auction_col = to_tsvector('english', coalesce(NEW.title,'') || ' ' || coalesce(NEW.description,''));
    RETURN NEW;
    END;$$;
--
-- Name: add_credits_trigger; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER add_credits_trigger BEFORE INSERT ON add_credits FOR EACH ROW EXECUTE PROCEDURE add_credits_trigger();


--
-- Name: auction_creator; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER auction_creator BEFORE INSERT ON bid FOR EACH ROW EXECUTE PROCEDURE auction_creator();


--
-- Name: auction_reported; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER auction_reported BEFORE INSERT ON report FOR EACH ROW EXECUTE PROCEDURE auction_reported();


--
-- Name: bid_greater_than_last; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

 CREATE TRIGGER bid_greater_than_last BEFORE INSERT ON bid FOR EACH ROW EXECUTE PROCEDURE bid_greater_than_last();

--
-- Name: user_id_has_money; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER user_id_has_money BEFORE INSERT ON bid FOR EACH ROW EXECUTE PROCEDURE user_id_has_money();


--
-- Name: block_user; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER block_user BEFORE INSERT OR UPDATE ON blocks FOR EACH ROW EXECUTE PROCEDURE block_user();


--
-- Name: buy_now; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER buy_now BEFORE INSERT ON bid FOR EACH ROW EXECUTE PROCEDURE buy_now();

--
-- Name: check_bid_value; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER check_bid_value BEFORE INSERT ON bid FOR EACH ROW EXECUTE PROCEDURE check_bid_value();


--
-- Name: delete_comment; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER delete_comment BEFORE DELETE ON comment FOR EACH ROW EXECUTE PROCEDURE delete_comment();


--
-- Name: notification_auction; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER notification_auction AFTER INSERT OR UPDATE OF state ON auction FOR EACH ROW EXECUTE PROCEDURE notification_auction();

--
-- Name: update_bid_number; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER update_bid_number AFTER INSERT ON bid FOR EACH ROW EXECUTE PROCEDURE update_bid_number();
--
-- Name: update_rating; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER update_rating BEFORE INSERT OR UPDATE ON auction FOR EACH ROW EXECUTE PROCEDURE update_ratings();

--
-- Name: full_text_search_auction; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER full_text_search_auction BEFORE INSERT OR UPDATE ON auction FOR EACH ROW EXECUTE PROCEDURE full_text_search_auction();

--
-- Name: full_text_search_user; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER full_text_search_user BEFORE INSERT OR UPDATE ON "user" FOR EACH ROW EXECUTE PROCEDURE full_text_search_user();
--
-- Name: win_auction; Type: TRIGGER; Schema: public; Owner: lbaw1716
--
/*
CREATE TRIGGER win_auction BEFORE UPDATE ON auction FOR EACH ROW EXECUTE PROCEDURE win_auction();
*/

--
-- Name: winner_rate_auction; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER winner_rate_auction BEFORE UPDATE OF rate ON auction FOR EACH ROW EXECUTE PROCEDURE winner_rate_auction();


--
-- Name: add_credits_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY add_credits
    ADD CONSTRAINT add_credits_user_fkey FOREIGN KEY ("user") REFERENCES "user"(id);


--
-- Name: auction_auctioncreator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY auction
    ADD CONSTRAINT auction_auctioncreator_fkey FOREIGN KEY (auctioncreator) REFERENCES "user"(id);


--
-- Name: auction_auctionwinner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY auction
    ADD CONSTRAINT auction_auctionwinner_fkey FOREIGN KEY (auctionwinner) REFERENCES "user"(id);


--
-- Name: auction_responsiblemoderator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY auction
    ADD CONSTRAINT auction_responsiblemoderator_fkey FOREIGN KEY (responsiblemoderator) REFERENCES "user"(id);


--
-- Name: authenticated_user_city_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY "user"
    ADD CONSTRAINT authenticated_user_city_fkey FOREIGN KEY (city) REFERENCES city(id);


--
-- Name: bid_auction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY bid
    ADD CONSTRAINT bid_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES auction(id);


--
-- Name: bid_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY bid
    ADD CONSTRAINT bid_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: blocks_blocked_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY blocks
    ADD CONSTRAINT blocks_blocked_fkey FOREIGN KEY (blocked) REFERENCES "user"(id);


--
-- Name: blocks_blocker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY blocks
    ADD CONSTRAINT blocks_blocker_fkey FOREIGN KEY (blocker) REFERENCES "user"(id);


--
-- Name: category_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY category
    ADD CONSTRAINT category_parent_fkey FOREIGN KEY (parent) REFERENCES category(id);


--
-- Name: categoryofauction_auction_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY categoryofauction
    ADD CONSTRAINT categoryofauction_auction_fkey FOREIGN KEY (auction_id) REFERENCES auction(id);


--
-- Name: categoryofauction_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY categoryofauction
    ADD CONSTRAINT categoryofauction_category_fkey FOREIGN KEY (category_id) REFERENCES category(id);


--
-- Name: city_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY city
    ADD CONSTRAINT city_country_fkey FOREIGN KEY (country) REFERENCES country(id);


--
-- Name: comment_auctioncommented_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY comment
    ADD CONSTRAINT comment_auctioncommented_fkey FOREIGN KEY (auctioncommented) REFERENCES auction(id);


--
-- Name: comment_usercommenter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY comment
    ADD CONSTRAINT comment_usercommenter_fkey FOREIGN KEY (usercommenter) REFERENCES "user"(id);


--
-- Name: edit_categories_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY edit_categories
    ADD CONSTRAINT edit_categories_admin_fkey FOREIGN KEY (admin) REFERENCES "user"(id);


--
-- Name: edit_categories_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY edit_categories
    ADD CONSTRAINT edit_categories_category_fkey FOREIGN KEY (category) REFERENCES category(id);


--
-- Name: edit_moderator_removedmod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY edit_moderator
    ADD CONSTRAINT edit_moderator_removedmod_fkey FOREIGN KEY (removedmod) REFERENCES "user"(id);


--
-- Name: edit_moderator_removeradmin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY edit_moderator
    ADD CONSTRAINT edit_moderator_removeradmin_fkey FOREIGN KEY (removeradmin) REFERENCES "user"(id);


--
-- Name: notification_auctionassociated_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY notification
    ADD CONSTRAINT notification_auctionassociated_fkey FOREIGN KEY (auctionassociated) REFERENCES auction(id);


--
-- Name: notification_authenticated_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY notification
    ADD CONSTRAINT notification_authenticated_userid_fkey FOREIGN KEY (authenticated_userid) REFERENCES "user"(id);


--
-- Name: report_auctionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY report
    ADD CONSTRAINT report_auctionid_fkey FOREIGN KEY (auctionid) REFERENCES auction(id);

--
-- Name: report_normaluserid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY report
    ADD CONSTRAINT report_normaluserid_fkey FOREIGN KEY (normaluserid) REFERENCES "user"(id);

CREATE INDEX bid_ind ON bid USING hash (auction_id);
CREATE INDEX pending_ind ON auction USING hash (state);
--
CREATE INDEX search_name_idx ON "user" USING GIST (textsearchable_user_col);
CREATE INDEX search_title_idx ON auction USING GIST (textsearchable_auction_col);

-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--
ALTER SEQUENCE auto_increment_user restart;
ALTER SEQUENCE auto_increment_city restart;
ALTER SEQUENCE auto_increment_credits restart;
ALTER SEQUENCE auto_increment_comment restart;
ALTER SEQUENCE auto_increment_auction restart;
ALTER SEQUENCE auto_increment_category restart;
ALTER SEQUENCE auto_increment_country restart;

INSERT INTO country (name) VALUES ('Afghanistan');
INSERT INTO country (name) VALUES ('Albania');
INSERT INTO country (name) VALUES ('Algeria');
INSERT INTO country (name) VALUES ('American Samoa');
INSERT INTO country (name) VALUES ('Andorra');
INSERT INTO country (name) VALUES ('Angola');
INSERT INTO country (name) VALUES ('Anguilla');
INSERT INTO country (name) VALUES ('Antarctica');
INSERT INTO country (name) VALUES ('Antigua and Barbuda');
INSERT INTO country (name) VALUES ('Argentina');
INSERT INTO country (name) VALUES ('Armenia');
INSERT INTO country (name) VALUES ('Aruba');
INSERT INTO country (name) VALUES ('Australia');
INSERT INTO country (name) VALUES ('Austria');
INSERT INTO country (name) VALUES ('Azerbaijan');
INSERT INTO country (name) VALUES ('Bahamas');
INSERT INTO country (name) VALUES ('Bahrain');
INSERT INTO country (name) VALUES ('Bangladesh');
INSERT INTO country (name) VALUES ('Barbados');
INSERT INTO country (name) VALUES ('Belarus');
INSERT INTO country (name) VALUES ('Belgium');
INSERT INTO country (name) VALUES ('Belize');
INSERT INTO country (name) VALUES ('Benin');
INSERT INTO country (name) VALUES ('Bermuda');
INSERT INTO country (name) VALUES ('Bhutan');
INSERT INTO country (name) VALUES ('Bolivia');
INSERT INTO country (name) VALUES ('Bosnia and Herzegovina');
INSERT INTO country (name) VALUES ('Botswana');
INSERT INTO country (name) VALUES ('Bouvet Island');
INSERT INTO country (name) VALUES ('Brazil');
INSERT INTO country (name) VALUES ('British Indian Ocean Territory');
INSERT INTO country (name) VALUES ('Brunei Darussalam');
INSERT INTO country (name) VALUES ('Bulgaria');
INSERT INTO country (name) VALUES ('Burkina Faso');
INSERT INTO country (name) VALUES ('Burundi');
INSERT INTO country (name) VALUES ('Cambodia');
INSERT INTO country (name) VALUES ('Cameroon');
INSERT INTO country (name) VALUES ('Canada');
INSERT INTO country (name) VALUES ('Cape Verde');
INSERT INTO country (name) VALUES ('Cayman Islands');
INSERT INTO country (name) VALUES ('Central African Republic');
INSERT INTO country (name) VALUES ('Chad');
INSERT INTO country (name) VALUES ('Chile');
INSERT INTO country (name) VALUES ('China');
INSERT INTO country (name) VALUES ('Christmas Island');
INSERT INTO country (name) VALUES ('Cocos (Keeling) Islands');
INSERT INTO country (name) VALUES ('Colombia');
INSERT INTO country (name) VALUES ('Comoros');
INSERT INTO country (name) VALUES ('Congo');
INSERT INTO country (name) VALUES ('Cook Islands');
INSERT INTO country (name) VALUES ('Costa Rica');
INSERT INTO country (name) VALUES ('Croatia (Hrvatska)');
INSERT INTO country (name) VALUES ('Cuba');
INSERT INTO country (name) VALUES ('Cyprus');
INSERT INTO country (name) VALUES ('Czech Republic');
INSERT INTO country (name) VALUES ('Denmark');
INSERT INTO country (name) VALUES ('Djibouti');
INSERT INTO country (name) VALUES ('Dominica');
INSERT INTO country (name) VALUES ('Dominican Republic');
INSERT INTO country (name) VALUES ('East Timor');
INSERT INTO country (name) VALUES ('Ecuador');
INSERT INTO country (name) VALUES ('Egypt');
INSERT INTO country (name) VALUES ('El Salvador');
INSERT INTO country (name) VALUES ('Equatorial Guinea');
INSERT INTO country (name) VALUES ('Eritrea');
INSERT INTO country (name) VALUES ('Estonia');
INSERT INTO country (name) VALUES ('Ethiopia');
INSERT INTO country (name) VALUES ('Falkland Islands (Malvinas)');
INSERT INTO country (name) VALUES ('Faroe Islands');
INSERT INTO country (name) VALUES ('Fiji');
INSERT INTO country (name) VALUES ('Finland');
INSERT INTO country (name) VALUES ('France');
INSERT INTO country (name) VALUES ('France, Metropolitan');
INSERT INTO country (name) VALUES ('French Guiana');
INSERT INTO country (name) VALUES ('French Polynesia');
INSERT INTO country (name) VALUES ('French Southern Territories');
INSERT INTO country (name) VALUES ('Gabon');
INSERT INTO country (name) VALUES ('Gambia');
INSERT INTO country (name) VALUES ('Georgia');
INSERT INTO country (name) VALUES ('Germany');
INSERT INTO country (name) VALUES ('Ghana');
INSERT INTO country (name) VALUES ('Gibraltar');
INSERT INTO country (name) VALUES ('Guernsey');
INSERT INTO country (name) VALUES ('Greece');
INSERT INTO country (name) VALUES ('Greenland');
INSERT INTO country (name) VALUES ('Grenada');
INSERT INTO country (name) VALUES ('Guadeloupe');
INSERT INTO country (name) VALUES ('Guam');
INSERT INTO country (name) VALUES ('Guatemala');
INSERT INTO country (name) VALUES ('Guinea');
INSERT INTO country (name) VALUES ('Guinea-Bissau');
INSERT INTO country (name) VALUES ('Guyana');
INSERT INTO country (name) VALUES ('Haiti');
INSERT INTO country (name) VALUES ('Heard and Mc Donald Islands');
INSERT INTO country (name) VALUES ('Honduras');
INSERT INTO country (name) VALUES ('Hong Kong');
INSERT INTO country (name) VALUES ('Hungary');
INSERT INTO country (name) VALUES ('Iceland');
INSERT INTO country (name) VALUES ('India');
INSERT INTO country (name) VALUES ('Isle of Man');
INSERT INTO country (name) VALUES ('Indonesia');
INSERT INTO country (name) VALUES ('Iran (Islamic Republic of)');
INSERT INTO country (name) VALUES ('Iraq');
INSERT INTO country (name) VALUES ('Ireland');
INSERT INTO country (name) VALUES ('Israel');
INSERT INTO country (name) VALUES ('Italy');
INSERT INTO country (name) VALUES ('Ivory Coast');
INSERT INTO country (name) VALUES ('Jersey');
INSERT INTO country (name) VALUES ('Jamaica');
INSERT INTO country (name) VALUES ('Japan');
INSERT INTO country (name) VALUES ('Jordan');
INSERT INTO country (name) VALUES ('Kazakhstan');
INSERT INTO country (name) VALUES ('Kenya');
INSERT INTO country (name) VALUES ('Kiribati');
INSERT INTO country (name) VALUES ('Kosovo');
INSERT INTO country (name) VALUES ('Kuwait');
INSERT INTO country (name) VALUES ('Kyrgyzstan');
INSERT INTO country (name) VALUES ('Lao People''''s Democratic Republic');
INSERT INTO country (name) VALUES ('Latvia');
INSERT INTO country (name) VALUES ('Lebanon');
INSERT INTO country (name) VALUES ('Lesotho');
INSERT INTO country (name) VALUES ('Liberia');
INSERT INTO country (name) VALUES ('Libyan Arab Jamahiriya');
INSERT INTO country (name) VALUES ('Liechtenstein');
INSERT INTO country (name) VALUES ('Lithuania');
INSERT INTO country (name) VALUES ('Luxembourg');
INSERT INTO country (name) VALUES ('Macau');
INSERT INTO country (name) VALUES ('Macedonia');
INSERT INTO country (name) VALUES ('Madagascar');
INSERT INTO country (name) VALUES ('Malawi');
INSERT INTO country (name) VALUES ('Malaysia');
INSERT INTO country (name) VALUES ('Maldives');
INSERT INTO country (name) VALUES ('Mali');
INSERT INTO country (name) VALUES ('Malta');
INSERT INTO country (name) VALUES ('Marshall Islands');
INSERT INTO country (name) VALUES ('Martinique');
INSERT INTO country (name) VALUES ('Mauritania');
INSERT INTO country (name) VALUES ('Mauritius');
INSERT INTO country (name) VALUES ('Mayotte');
INSERT INTO country (name) VALUES ('Mexico');
INSERT INTO country (name) VALUES ('Micronesia, Federated States of');
INSERT INTO country (name) VALUES ('Moldova, Republic of');
INSERT INTO country (name) VALUES ('Monaco');
INSERT INTO country (name) VALUES ('Mongolia');
INSERT INTO country (name) VALUES ('Montenegro');
INSERT INTO country (name) VALUES ('Montserrat');
INSERT INTO country (name) VALUES ('Morocco');
INSERT INTO country (name) VALUES ('Mozambique');
INSERT INTO country (name) VALUES ('Myanmar');
INSERT INTO country (name) VALUES ('Namibia');
INSERT INTO country (name) VALUES ('Nauru');
INSERT INTO country (name) VALUES ('Nepal');
INSERT INTO country (name) VALUES ('Netherlands');
INSERT INTO country (name) VALUES ('Netherlands Antilles');
INSERT INTO country (name) VALUES ('New Caledonia');
INSERT INTO country (name) VALUES ('New Zealand');
INSERT INTO country (name) VALUES ('Nicaragua');
INSERT INTO country (name) VALUES ('Niger');
INSERT INTO country (name) VALUES ('Nigeria');
INSERT INTO country (name) VALUES ('Niue');
INSERT INTO country (name) VALUES ('Norfolk Island');
INSERT INTO country (name) VALUES ('Northern Mariana Islands');
INSERT INTO country (name) VALUES ('Norway');
INSERT INTO country (name) VALUES ('Oman');
INSERT INTO country (name) VALUES ('Pakistan');
INSERT INTO country (name) VALUES ('Palau');
INSERT INTO country (name) VALUES ('Palestine');
INSERT INTO country (name) VALUES ('Panama');
INSERT INTO country (name) VALUES ('Papua New Guinea');
INSERT INTO country (name) VALUES ('Paraguay');
INSERT INTO country (name) VALUES ('Peru');
INSERT INTO country (name) VALUES ('Philippines');
INSERT INTO country (name) VALUES ('South Korea');
INSERT INTO country (name) VALUES ('Pitcairn');
INSERT INTO country (name) VALUES ('Poland');
INSERT INTO country (name) VALUES ('Portugal');
INSERT INTO country (name) VALUES ('Puerto Rico');
INSERT INTO country (name) VALUES ('Qatar');
INSERT INTO country (name) VALUES ('Reunion');
INSERT INTO country (name) VALUES ('Romania');
INSERT INTO country (name) VALUES ('Russian Federation');
INSERT INTO country (name) VALUES ('Rwanda');
INSERT INTO country (name) VALUES ('Saint Kitts and Nevis');
INSERT INTO country (name) VALUES ('Saint Lucia');
INSERT INTO country (name) VALUES ('Saint Vincent and the Grenadines');
INSERT INTO country (name) VALUES ('Samoa');
INSERT INTO country (name) VALUES ('San Marino');
INSERT INTO country (name) VALUES ('Sao Tome and Principe');
INSERT INTO country (name) VALUES ('Saudi Arabia');
INSERT INTO country (name) VALUES ('Senegal');
INSERT INTO country (name) VALUES ('Serbia');
INSERT INTO country (name) VALUES ('Seychelles');
INSERT INTO country (name) VALUES ('Sierra Leone');
INSERT INTO country (name) VALUES ('Singapore');
INSERT INTO country (name) VALUES ('Slovakia');
INSERT INTO country (name) VALUES ('Slovenia');
INSERT INTO country (name) VALUES ('Solomon Islands');
INSERT INTO country (name) VALUES ('Somalia');
INSERT INTO country (name) VALUES ('South Africa');
INSERT INTO country (name) VALUES ('South Georgia South Sandwich Islands');
INSERT INTO country (name) VALUES ('Spain');
INSERT INTO country (name) VALUES ('Sri Lanka');
INSERT INTO country (name) VALUES ('St. Helena');
INSERT INTO country (name) VALUES ('St. Pierre and Miquelon');
INSERT INTO country (name) VALUES ('Sudan');
INSERT INTO country (name) VALUES ('Suriname');
INSERT INTO country (name) VALUES ('Svalbard and Jan Mayen Islands');
INSERT INTO country (name) VALUES ('Swaziland');
INSERT INTO country (name) VALUES ('Sweden');
INSERT INTO country (name) VALUES ('Switzerland');
INSERT INTO country (name) VALUES ('Syrian Arab Republic');
INSERT INTO country (name) VALUES ('Taiwan');
INSERT INTO country (name) VALUES ('Tajikistan');
INSERT INTO country (name) VALUES ('Tanzania, United Republic of');
INSERT INTO country (name) VALUES ('Thailand');
INSERT INTO country (name) VALUES ('Togo');
INSERT INTO country (name) VALUES ('Tokelau');
INSERT INTO country (name) VALUES ('Tonga');
INSERT INTO country (name) VALUES ('Trinidad and Tobago');
INSERT INTO country (name) VALUES ('Tunisia');
INSERT INTO country (name) VALUES ('Turkey');
INSERT INTO country (name) VALUES ('Turkmenistan');
INSERT INTO country (name) VALUES ('Turks and Caicos Islands');
INSERT INTO country (name) VALUES ('Tuvalu');
INSERT INTO country (name) VALUES ('Uganda');
INSERT INTO country (name) VALUES ('Ukraine');
INSERT INTO country (name) VALUES ('United Arab Emirates');
INSERT INTO country (name) VALUES ('United Kingdom');
INSERT INTO country (name) VALUES ('United States');
INSERT INTO country (name) VALUES ('United States minor outlying islands');
INSERT INTO country (name) VALUES ('Uruguay');
INSERT INTO country (name) VALUES ('Uzbekistan');
INSERT INTO country (name) VALUES ('Vanuatu');
INSERT INTO country (name) VALUES ('Vatican City State');
INSERT INTO country (name) VALUES ('Venezuela');
INSERT INTO country (name) VALUES ('Vietnam');
INSERT INTO country (name) VALUES ('Virgin Islands (British)');
INSERT INTO country (name) VALUES ('Virgin Islands (U.S.)');
INSERT INTO country (name) VALUES ('Wallis and Futuna Islands');
INSERT INTO country (name) VALUES ('Western Sahara');
INSERT INTO country (name) VALUES ('Yemen');
INSERT INTO country (name) VALUES ('Zaire');
INSERT INTO country (name) VALUES ('Zambia');
INSERT INTO country (name) VALUES ('Zimbabwe');
INSERT INTO country (name) VALUES ('North Korea');


--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO city (name, country) VALUES ('Dongguan', 44);
INSERT INTO city (name, country) VALUES ('Hanoi', 237);
INSERT INTO city (name, country) VALUES ('Ankara', 222);
INSERT INTO city (name, country) VALUES ('Suzhou', 44);
INSERT INTO city (name, country) VALUES ('Yokohama', 110);
INSERT INTO city (name, country) VALUES ('Moscow', 182);
INSERT INTO city (name, country) VALUES ('New York City', 230);
INSERT INTO city (name, country) VALUES ('Cairo', 62);
INSERT INTO city (name, country) VALUES ('Beijing', 44);
INSERT INTO city (name, country) VALUES ('Berlin', 80);
INSERT INTO city (name, country) VALUES ('Lima', 173);
INSERT INTO city (name, country) VALUES ('Johannesburg', 200);
INSERT INTO city (name, country) VALUES ('Saint Petersburg', 182);
INSERT INTO city (name, country) VALUES ('Los Angeles', 230);
INSERT INTO city (name, country) VALUES ('Singapore', 195);
INSERT INTO city (name, country) VALUES ('Istanbul', 222);
INSERT INTO city (name, country) VALUES ('Madrid', 202);
INSERT INTO city (name, country) VALUES ('London', 229);
INSERT INTO city (name, country) VALUES ('Lagos', 161);
INSERT INTO city (name, country) VALUES ('Kolkata', 99);
INSERT INTO city (name, country) VALUES ('Jaipur', 99);
INSERT INTO city (name, country) VALUES ('Mumbai', 99);
INSERT INTO city (name, country) VALUES ('Busan', 116);
INSERT INTO city (name, country) VALUES ('Pyongyang', 115);
INSERT INTO city (name, country) VALUES ('Seoul', 116);
INSERT INTO city (name, country) VALUES ('Sao Paulo', 30);
INSERT INTO city (name, country) VALUES ('Rio de Janeiro', 30);
INSERT INTO city (name, country) VALUES ('Salvador', 30);
INSERT INTO city (name, country) VALUES ('Porto Alegre', 30);
INSERT INTO city (name, country) VALUES ('Natal', 30);
INSERT INTO city (name, country) VALUES ('Joinville', 30);
INSERT INTO city (name, country) VALUES ('Lisbon', 177);
INSERT INTO city (name, country) VALUES ('Porto', 177);
INSERT INTO city (name, country) VALUES ('Casablanca', 149);
INSERT INTO city (name, country) VALUES ('Cape Town', 200);
INSERT INTO city (name, country) VALUES ('Hyderabad', 99);
INSERT INTO city (name, country) VALUES ('Jakarta', 101);
INSERT INTO city (name, country) VALUES ('Delhi', 99);
INSERT INTO city (name, country) VALUES ('Frankfurt', 80);
INSERT INTO city (name, country) VALUES ('Bucharest', 181);
INSERT INTO city (name, country) VALUES ('Kiev', 227);
INSERT INTO city (name, country) VALUES ('Rome', 106);
INSERT INTO city (name, country) VALUES ('Paris', 72);
INSERT INTO city (name, country) VALUES ('Minsk', 20);
INSERT INTO city (name, country) VALUES ('Vienna', 14);
INSERT INTO city (name, country) VALUES ('Budapest', 97);
INSERT INTO city (name, country) VALUES ('Hamburg', 80);
INSERT INTO city (name, country) VALUES ('Warsaw', 176);
INSERT INTO city (name, country) VALUES ('Munich', 80);
INSERT INTO city (name, country) VALUES ('Kharkiv', 227);
INSERT INTO city (name, country) VALUES ('Prague', 55);
INSERT INTO city (name, country) VALUES ('Sofia', 33);
INSERT INTO city (name, country) VALUES ('Nizhny Novgorod', 182);
INSERT INTO city (name, country) VALUES ('Kazan', 182);
INSERT INTO city (name, country) VALUES ('Brussels', 21);
INSERT INTO city (name, country) VALUES ('Columbus ', 230);
INSERT INTO city (name, country) VALUES ('Boston ', 230);
INSERT INTO city (name, country) VALUES ('Bakersfield ', 230);
INSERT INTO city (name, country) VALUES ('Tucson ', 230);
INSERT INTO city (name, country) VALUES ('Fort Worth ', 230);
INSERT INTO city (name, country) VALUES ('Lexington-Fayette ', 230);
INSERT INTO city (name, country) VALUES ('Arlington ', 230);
INSERT INTO city (name, country) VALUES ('Montgomery ', 230);
INSERT INTO city (name, country) VALUES ('Greensboro ', 230);
INSERT INTO city (name, country) VALUES ('Minneapolis ', 230);
INSERT INTO city (name, country) VALUES ('Virginia Beach ', 230);
INSERT INTO city (name, country) VALUES ('Sacramento ', 230);
INSERT INTO city (name, country) VALUES ('Honolulu ', 230);
INSERT INTO city (name, country) VALUES ('Norfolk ', 230);
INSERT INTO city (name, country) VALUES ('Cleveland ', 230);
INSERT INTO city (name, country) VALUES ('Washington D.C', 230);
INSERT INTO city (name, country) VALUES ('Chicago ', 230);
INSERT INTO city (name, country) VALUES ('Birmingham', 229);
INSERT INTO city (name, country) VALUES ('Bath', 229);
INSERT INTO city (name, country) VALUES ('Belfast', 229);
INSERT INTO city (name, country) VALUES ('Bristol', 229);
INSERT INTO city (name, country) VALUES ('Cambridge', 229);
INSERT INTO city (name, country) VALUES ('Canterbury', 229);
INSERT INTO city (name, country) VALUES ('Chester', 229);
INSERT INTO city (name, country) VALUES ('Derby', 229);
INSERT INTO city (name, country) VALUES ('Edinburgh', 229);
INSERT INTO city (name, country) VALUES ('Glasgow', 229);
INSERT INTO city (name, country) VALUES ('Hereford', 229);
INSERT INTO city (name, country) VALUES ('Lancaster', 229);
INSERT INTO city (name, country) VALUES ('Leicester', 229);
INSERT INTO city (name, country) VALUES ('Liverpool', 229);
INSERT INTO city (name, country) VALUES ('Manchester', 229);
INSERT INTO city (name, country) VALUES ('Oxford', 229);
INSERT INTO city (name, country) VALUES ('Nottingham', 229);
INSERT INTO city (name, country) VALUES ('Peterborough', 229);
INSERT INTO city (name, country) VALUES ('Plymouth', 229);
INSERT INTO city (name, country) VALUES ('Portsmouth', 229);
INSERT INTO city (name, country) VALUES ('Winchester', 229);
INSERT INTO city (name, country) VALUES ('Westminster', 229);
INSERT INTO city (name, country) VALUES ('York', 229);
INSERT INTO city (name, country) VALUES ('Stockholm', 210);
INSERT INTO city (name, country) VALUES ('Gothenburg', 210);
INSERT INTO city (name, country) VALUES ('Malmö', 210);
INSERT INTO city (name, country) VALUES ('Uppsala', 210);
INSERT INTO city (name, country) VALUES ('Västerås 	', 210);
INSERT INTO city (name, country) VALUES ('Örebro', 210);
INSERT INTO city (name, country) VALUES ('Lund', 210);
INSERT INTO city (name, country) VALUES ('Helsingborg', 210);
INSERT INTO city (name, country) VALUES ('Umeå', 210);
INSERT INTO city (name, country) VALUES ('Milan', 106);
INSERT INTO city (name, country) VALUES ('Turin', 106);
INSERT INTO city (name, country) VALUES ('Palermo', 106);
INSERT INTO city (name, country) VALUES ('Bologna', 106);
INSERT INTO city (name, country) VALUES ('Venice', 106);
INSERT INTO city (name, country) VALUES ('Cagliari', 106);
INSERT INTO city (name, country) VALUES ('Oslo', 165);
INSERT INTO city (name, country) VALUES ('Bergen', 165);
INSERT INTO city (name, country) VALUES ('Trondheim', 165);
INSERT INTO city (name, country) VALUES ('Stavanger', 165);
INSERT INTO city (name, country) VALUES ('Sandnes', 165);
INSERT INTO city (name, country) VALUES ('Fredrikstad', 165);
INSERT INTO city (name, country) VALUES ('Ålesund', 165);
INSERT INTO city (name, country) VALUES ('Maastricht', 155);
INSERT INTO city (name, country) VALUES ('Kerkrade', 155);
INSERT INTO city (name, country) VALUES ('Nieuwstadt', 155);
INSERT INTO city (name, country) VALUES ('Helmond', 155);
INSERT INTO city (name, country) VALUES ('Roosendaal', 155);
INSERT INTO city (name, country) VALUES ('Monnickendam', 155);
INSERT INTO city (name, country) VALUES ('Amsterdam', 155);
INSERT INTO city (name, country) VALUES ('Edam', 155);
INSERT INTO city (name, country) VALUES ('Enschede', 155);
INSERT INTO city (name, country) VALUES ('Utrecht', 155);
INSERT INTO city (name, country) VALUES ('Sluis', 155);
INSERT INTO city (name, country) VALUES ('Rotterdam', 155);
INSERT INTO city (name, country) VALUES ('The Hague', 155);
INSERT INTO city (name, country) VALUES ('Copenhagen', 56);
INSERT INTO city (name, country) VALUES ('Bangkok', 216);
INSERT INTO city (name, country) VALUES ('Abidjan', 107);
INSERT INTO city (name, country) VALUES ('Durban', 200);
INSERT INTO city (name, country) VALUES ('Alexandria', 62);
INSERT INTO city (name, country) VALUES ('Santiago', 43);
INSERT INTO city (name, country) VALUES ('Riyadh', 190);
INSERT INTO city (name, country) VALUES ('Tianjin', 44);
INSERT INTO city (name, country) VALUES ('Shenzhen', 44);
INSERT INTO city (name, country) VALUES ('Shanghai', 44);
INSERT INTO city (name, country) VALUES ('Pune', 99);
INSERT INTO city (name, country) VALUES ('Kinshasa', 49);
INSERT INTO city (name, country) VALUES ('Karachi', 167);
INSERT INTO city (name, country) VALUES ('Dhaka', 18);
INSERT INTO city (name, country) VALUES ('Addis Ababa', 67);
INSERT INTO city (name, country) VALUES ('Malanje', 6);
INSERT INTO city (name, country) VALUES ('Luanda ', 6);
INSERT INTO city (name, country) VALUES ('Lubango', 6);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'erika_wilk1978', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Mia S Burke', 'purus.Maecenas@ipsumdolorsit.net', '1996-11-03', NULL, '73 York Road', 'OX1 4PP', 9440, 89, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Administrator', 'NadiaCarvalho', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Nádia Carvalho', NULL, NULL, NULL, NULL, NULL, 9800, NULL, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'DavisonNaomi', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Naomi L Davison', 'non.lobortis@ultricesposuere.org', '1975-05-17', NULL, '90 Cunnery Rd', 'M2 1HE', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'langeles', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Adam M Shah', 'quis.accumsan.convallis@pellentesquetellus.org', '1976-03-16', NULL, '62 Cunnery Rd', 'M60 9DW', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'fearfultruck', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Naomi L Davison', '0manan.bhalla.mbz@myfaceb00k.ml', '1975-05-17', NULL, '90 Cunnery Rd', 'M2 1HE', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'frillymammoth', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Mia S Burke', 'dictum@ridiculusmus.co.uk', '1996-11-03', NULL, '73 York Road', 'OX1 4PP', 9800, 89, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'assetsopengl', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', 'http://4.bp.blogspot.com/-SoLmj_KD-oE/VCbiHfUzMjI/AAAAAAAAD-A/mlZ-3j-TAvk/s1600/Ian%2BH%2B(7).jpg', 'Max H Harding', 'Enswearry45@dayrep.com', '1981-05-28', NULL, '82 Guild Street', 'NW6 3LF', 9800, 19, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'switchsparkling', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Mia S Burke', 'a.tortor@estNunc.co.uk', '1996-11-03', NULL, '73 York Road', 'OX1 4PP', 9800, 89, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'nippykrypton', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Adam M Shah', 'Integer.aliquam.adipiscing@non.org', '1976-03-16', NULL, '62 Cunnery Rd', 'M60 9DW', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'informdunghill', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Mia S Burke', 'lorem.sit@Namnulla.org', '1996-11-03', NULL, '73 York Road', 'OX1 4PP', 9800, 89, 224056703, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'grossboars', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Naomi L Davison', 'sociis.natoque@iaculisaliquetdiam.co.uk', '1975-05-17', NULL, '90 Cunnery Rd', 'M2 1HE', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'rubberspinner', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Adam M Shah', 'velit@orci.co.uk', '1976-03-16', NULL, '62 Cunnery Rd', 'M60 9DW', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'branchgreat', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Mia S Burke', 'leo.in.lobortis@litoratorquentper.net', '1996-11-03', NULL, '73 York Road', 'OX1 4PP', 9800, 89, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'evilpublic', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Naomi L Davison', 'nisl.arcu@velnislQuisque.ca', '1975-05-17', NULL, '90 Cunnery Rd', 'M2 1HE', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'mizunaspider', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Adam M Shah', 'Nulla@aliquetdiam.com', '1976-03-16', NULL, '62 Cunnery Rd', 'M60 9DW', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'dilationwaals', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Naomi L Davison', 'ultrices@malesuadavelvenenatis.co.uk', '1975-05-17', NULL, '90 Cunnery Rd', 'M2 1HE', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'watchinggemini', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Adam M Shah', 'et.eros.Proin@vitaemaurissit.edu', '1976-03-16', NULL, '62 Cunnery Rd', 'M60 9DW', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'cambrianend', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Mia S Burke', 'volutpat.ornare@Suspendisse.edu', '1996-11-03', NULL, '73 York Road', 'OX1 4PP', 9800, 89, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'pastiedash', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Naomi L Davison', 'nec.urna@ascelerisquesed.com', '1975-05-17', NULL, '90 Cunnery Rd', 'M2 1HE', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'jockeypruning', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Adam M Shah', 'ut.ipsum.ac@quismassaMauris.net', '1976-03-16', NULL, '62 Cunnery Rd', 'M60 9DW', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Moderator', 'starkshell', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Nádia Carvalho', NULL, NULL, NULL, NULL, NULL, 9800, NULL, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Moderator', 'bolidesorrowful', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Nádia Carvalho', NULL, NULL, NULL, NULL, NULL, 9800, NULL, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Moderator', 'valuemonitoring', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Nádia Carvalho', NULL, NULL, NULL, NULL, NULL, 9800, NULL, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Moderator', 'abovedoubtful', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Nádia Carvalho', NULL, NULL, NULL, NULL, NULL, 9800, NULL, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Moderator', 'expectantridge', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Nádia Carvalho', NULL, NULL, NULL, NULL, NULL, 9800, NULL, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'Ritmock', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', 'http://4.bp.blogspot.com/-SoLmj_KD-oE/VCbiHfUzMjI/AAAAAAAAD-A/mlZ-3j-TAvk/s1600/Ian%2BH%2B(7).jpg', 'Max H Harding', 'lectus.sit@ligula.co.uk', '1981-05-28', NULL, '82 Guild Street', 'NW6 3LF', 9800, 19, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'unbecominglabour', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Mia S Burke', 'Nullam@ullamcorpervelit.net', '1996-11-03', NULL, '73 York Road', 'OX1 4PP', 500, 89, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'helicopteruk', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Adam M Shah', 'panama@smellypotato.tk', '1976-03-16', 1, '62 Cunnery Rd', 'M60 9DW', 9800, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'laggedcolony', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/default.png', 'Naomi L Davison', 'Vivamus@Etiam.ca', '1975-05-17', NULL, '90 Cunnery Rd', 'M2 1HE', 8995, 88, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'rabbitsfootortolan', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', 'http://4.bp.blogspot.com/-SoLmj_KD-oE/VCbiHfUzMjI/AAAAAAAAD-A/mlZ-3j-TAvk/s1600/Ian%2BH%2B(7).jpg', 'Max H Harding', 'Curabitur.sed.tortor@quisdiamPellentesque.net', '1981-05-28', 3, '82 Guild Street', 'NW6 3LF', 9800, 19, NULL, false);
INSERT INTO "user" (typeofuser,username,password,pathtophoto,completename,email,birthdate,"/rating",address,postalcode,balance,city,phonenumber,blocked) VALUES ('Normal', 'Ritmock520', '$2y$10$ZCNsTeh/TpPG5Js4YYpfCujhXIYMyqTFDy6/i5nWw82EKz9InTrdK', '/images/catalog/users/41.png', 'Naomi L Davison', 'nisl.aLLrcu@velnislQuisque.ca', '1975-05-17', NULL, '90 Cunnery Rd', 'M2 1HE', 9800, 88, NULL, false);


--
-- Data for Name: add_credits; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO add_credits (value, date, paypalid, "user", "trasactionID") VALUES (300, '2018-03-26 16:10:10+01', 'quis.accumsan.convallis@pellentesquetellus.org', 7, '8BL15100CF123456E');
INSERT INTO add_credits  (value, date, paypalid,"user", "trasactionID") VALUES (300, '2018-03-27 16:10:10+01', 'lectus.sit@ligula.co.uk', 2, '8BL15100CF123456E');
INSERT INTO add_credits  (value, date, paypalid,"user", "trasactionID") VALUES (130, '2018-03-26 16:10:10+01', 'non.lobortis@ultricesposuere.org', 3, '8BL15100CF123453D');
INSERT INTO add_credits (value, date, paypalid,"user", "trasactionID") VALUES (150, '2018-03-26 16:10:10+01', 'lectus.sit@ligula.co.uk', 2, '8BL15100CF123356D');
INSERT INTO add_credits (value, date, paypalid,"user", "trasactionID") VALUES (300, '2018-04-07 23:23:27.956682+01', 'purus.Maecenas@ipsumdolorsit.net', 5, '8BL15100CF023356D');

--
-- Data for Name: auction; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--







INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 500, 600, '2018-05-29 16:19:10+01', '2018-06-03 03:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Lenovo US', 'Legion Y520 | Intel Core i7 Gaming Laptop | Lenovo US', 'Brand new!', 'https://www3.lenovo.com/medias/lenovo-laptop-legion-y520-15-front.png?context=bWFzdGVyfGltYWdlc3wyNzI1M3xpbWFnZS9wbmd8aW1hZ2VzL2g4OC9oYTAvOTM1OTcwMTYwNjQzMC5wbmd8MjNhNjMwZjhhNWJmOGYzNzhjYjgwMDViMTQxOWM1ZjJiNjdjZGQ0OWUzOWEzMThkNzg3ZWE0MTc1NTdjNTY2Yw&w=1180', 650, 1100, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'GETWORTH T25 Computer Tower', 'GETWORTH T25 Computer Tower', 'not used at the moment', 'https://gloimg.gbtcdn.com/gb/pdm-product-pic/Maiyang/2017/09/17/source-img/20170917180055_49745.jpg', 1500, 3500, 5000, '2018-05-30 16:10:10+01', '2018-06-04 11:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'HP Laptop', 'HP Laptop - 15z with E2 touch optional', 'Two years old!', 'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05474585.png', 550, 850, 1030, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 22);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Notebook 7 Spin', 'Notebook 7 Spin', 'New!!!!', 'https://cdn.mos.cms.futurecdn.net/cndBsdKvcSFbnh7srJhRzS-320-80.jpg', 820, 1340, 1700, '2018-05-29 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' GETWORTH R12 Computer Tower - WHITE', ' GETWORTH R12 Computer Tower - WHITE', 'Brand new and I did not like the color', 'https://gloimg.gbtcdn.com/gb/pdm-product-pic/Electronic/2017/03/24/source-img/20170324174956_87899.jpg', 100, 450, 800, '2018-05-29 11:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 22);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Delll laptop', 'Dell laptop', 'New!!!!', 'https://cdn.shopify.com/s/files/1/1245/6617/products/dell-laptops-200-220-without-code-ten-dell-latitude-e6400-14-1-lcd-core-2-duo-80gb-hdd-2gb-ram-win-10-pro-64-bit-wifi-dvd-use-code-ten-18559622407.png?v=1524971910', 300, 450, 540, '2018-02-26 16:10:10+01', '2018-02-28 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 21);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Lenovo V110-15ISK 15.6"', 'Lenovo V110-15ISK 15.6" Cheap Intel Core i3 Laptop, 4GB RAM, 500GB', 'New!!!!', 'https://www.laptopoutlet.co.uk/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/5/4/5454_114.jpg', 600, 900, 1150, '2018-05-29 16:59:10+01', '2018-06-03 15:11:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 23);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'HP Laptop - 15"', 'HP Laptop - 15" Touch Screen Optional', 'kind of old', 'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05665420.png', 390, 600, 800, '2018-11-26 16:10:10+01', '2018-12-01 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Diypc SECC ATX Gaming Computer Case Full Tower USB3.0 w/ 7 x 120mm', 'Diypc SECC ATX Gaming Computer Case Full Tower USB3.0 w/ 7 x 120mm', 'Bought another one', 'https://images.prod.meredith.com/product/cd4e9ae697733aceb2666934d8000202/1500542931548/l/diypc-secc-atx-gaming-computer-case-full-tower-usb3-0-with-7-x-120mm-blue-fans-black-skyline-07-b-new-open-box', 300, 965, 1500, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'not used at the moment', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 150, 500, 600, '2018-05-29 01:10:10+01', '2018-06-03 06:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'RAIDMAX Cobra Z ATX Mid Tower Computer Case', 'RAIDMAX Cobra Z ATX Mid Tower Computer Case / Steel/Plastic / USB 3.0 x 1 + USB 2.0 x 1 / Patented Wide Body Design / Supports 120mm Liquid Cooling System', 'not used at the moment', 'https://www.evetech.co.za/repository/ProductImages/raidmax-cobra-z-computer-case-0003.jpg', 500, 1100, 2000, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'HP Omen Core i7 Desktop Tower', 'HP Omen Core i7 Desktop Tower', 'not used at the moment', 'https://images.officeworks.com.au/api/2/img/https://s3-ap-southeast-2.amazonaws.com/wc-prod-pim/JPEG_1000x1000/HPOMENCI7_C_hp_omen_core_i7_desktop_tower.jpg/resize?size=706&auth=MjA5OTcwODkwMg__', 320, 700, 1250, '2018-05-29 16:10:10+01', '2018-05-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 1, 8, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'HP Compaq 6000 Pro MicroTower HP Desktop Computer Tower PC Intel Core 2 Duo Windows 10 Pro', 'HP Compaq 6000 Pro MicroTower HP Desktop Computer Tower PC Intel Core 2 Duo Windows 10 Pro', 'too slow for me', 'https://cdn.shopify.com/s/files/1/2429/0345/products/57_d9a9f1c7-c8dc-4ea4-ad28-bd59181ddb55_580x.jpg?v=1507831313', 100, 350, 450, '2018-05-29 14:07:14+01', '2018-06-03 10:40:28+01', NULL, 0, NULL, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Over', 'Xigmatek Aquila NVIDIA GeForce GTX ABS Micro-ATX Mini Tower Computer Case EN5520', 'Xigmatek Aquila NVIDIA GeForce GTX ABS Micro-ATX Mini Tower Computer Case EN5520', 'not used at the moment', 'https://i.pinimg.com/originals/af/d5/93/afd593e2d9398ecfc101213a7352ef9c.jpg', 350, 710, 1000, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, '2016-04-07 16:10:10+01', 570, 3, 1, 7, 22);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Over', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'not used at the moment', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, '2018-04-04 09:45:40.80046+01', 600, 2, 10, 11, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Apple 11.6" MacBook Air', 'Apple 11.6" MacBook Air
Get a great deal with this online auction for a laptop presented by Property Room on behalf of a law enforcement or public agency client.

    Model: A1465
    Serial: C02JM5QNDXXX
    Processor: Intel Core i5 3317U CPU
    CPU Speed: 1.7 GHz
    Hard Drive: 64GB
    HDD Caddy: Included
    RAM: 4GB
    Drives: N/A
    Battery: Included
    Screen Size: 11.6"
    Power Adapter: None Included
    Accessories: None Included
    Cosmetic Condition: Marks, Scratches, Scuffs, and Dents On Casing; Screen is Scratched
    Testing Results: Tested and Powered On; Hard Drive Has Been Wiped; Requires Operating System Installation; Start-Up Disk Manager and OS Utilities were Both Accessible

Condition: Fair

Due to licensing restrictions, this item will be shipped without any software, including operating system software.', 'Get a great deal with this online auction for a laptop presented by Property Room on behalf of a law enforcement or public agency client.', 'http://content.propertyroom.com/listings/sellers/seller1/images/origimgs/apple-116-macbook-air-1_29320182052231193305.jpg', 200, 500, 800, '2018-05-30 22:43:23.582097+01', '2018-06-04 22:43:23.582097+01', NULL, 0, NULL, NULL, NULL, NULL, 5, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/41WtKtFCKoL._AC_SR160,160_.jpg', 150, 500, 600, '2018-05-30 16:10:10+01', '2018-06-05 02:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'NOX Hummer TGX ', 'NOX Hummer TGX ', 'not used at the moment', 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSYkvZPYNcIa0gD6hduh3i3OMiMp6kQRlC3xeDrOj9m9Ta0zioQaPwhEv7XVTUQLNrhVxWtT4g&usqp=CAc', 150, 500, 600, '2018-05-30 16:30:10+01', '2018-06-04 11:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'ASUS Mini-Tower Desktop Computer', 'ASUS Republic of Gamers GR8 II Mini-Tower Desktop Computer', 'not used at the moment', 'https://www.bhphotovideo.com/images/images2500x2500/asus_gr8_ii_t069z_i5_7400_16gb_512ssd_gtx_1319359.jpg', 450, 850, 1200, '2018-05-30 16:10:10+01', '2018-06-05 16:10:10+01', NULL, 0, NULL, NULL, NULL, 11, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Optiplex 755 Desktop CPU Computer Tower', 'Dell Optiplex 755 Desktop CPU Computer Tower', 'not used at the moment', 'https://i.ebayimg.com/images/g/e7QAAOSwT5tWM38T/s-l300.jpg', 50, 150, 300, '2018-05-30 16:10:10+01', '2018-06-04 16:50:10+01', NULL, 0, NULL, NULL, NULL, 12, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Acer Predator G6 Gaming Computer Tower', 'Acer Predator G6 Gaming Computer Tower', 'not used at the moment', 'https://gloimg.gbtcdn.com/gb/pdm-product-pic/Electronic/2017/12/05/source-img/20171205104209_19400.jpg', 775, 1100, 1450, '2018-05-30 06:10:10+01', '2018-06-05 16:10:10+01', NULL, 0, NULL, NULL, NULL, 13, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'CUK Switch 77 Black/Silver Mid Tower Desktop PC ATX', 'CUK Switch 77 Black/Silver Mid Tower Desktop PC ATX', 'not used at the moment', 'https://cukusa.com/media/catalog/product/cache/1/image/400x/9df78eab33525d08d6e5fb8d27136e95/b/l/black_light_final_1.jpg', 250, 500, 630, '2018-05-30 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 9, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Asus X205TA (Atom Z3735)', 'Asus X205TA (Atom Z3735)', 'not used at the moment', 'https://i.nextmedia.com.au/Utils/ImageResizer.ashx?n=http%3A%2F%2Fi.nextmedia.com.au%2FFeatures%2Fcover-r.png&w=900&c=0&s=0', 250, 400, 590, '2018-05-30 12:10:10+01', '2018-06-05 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec ISK110 Vesa-U3', 'Antec ISK110 Vesa-U3', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_97919/0-761345-10106-6.jpg', 150, 500, 600, '2018-05-29 16:10:10+01', '2018-06-04 11:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AZIO MK HUE Red USB Backlit Keyboard', 'AZIO MK HUE Red USB Backlit Keyboard', 'not used at the moment', 'https://images10.newegg.com/ProductImageCompressAll300/23-839-039-02.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 10:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' MSI RX 580', ' MSI RX 580', 'not used at the moment', 'https://3.bp.blogspot.com/-XSGH_w2pt_U/WQtZ3062d4I/AAAAAAAAIkg/utBZvxuF_UUfCliU9Prjwoovkhpq5-xrgCK4B/s320/MSI%2BRX%2B580%2BGAMING%2BX.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell XPS 15 9560', 'Dell XPS 15 9560', 'never used it', 'https://static.digit.in/default/a1a4383476c1125adbbae6e280ded659d853298b.jpeg', 750, 900, 1100, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec Nine Hundred Black Steel ATX Mid Tower', 'Antec Nine Hundred Black Steel ATX Mid Tower', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/71DEVmo3ExL._SY606_.jpg', 750, 990, 1100, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Natural Ergonomic Keyboard 4000', 'Microsoft - Natural Ergonomic Keyboard 4000', 'not used at the moment', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/7332/7332059_sd.jpg', 50, 100, 250, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Inno3D-iChill-GeForce-GTX-980-HerculeZ-x4_1', 'Inno3D-iChill-GeForce-GTX-980-HerculeZ-x4_1', 'not used at the moment', 'https://i.stack.imgur.com/3KsTF.jpg', 200, 400, 700, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Acer Nitro 5 Spin 15.6"', 'Acer Nitro 5 Spin 15.6"', 'not used at the moment', 'https://images.anandtech.com/doci/11752/acer_nitro_678_678x452.jpg', 650, 1020, 1435, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'EMachines Computer Tower EL1850', 'EMachines Computer Tower EL1850', 'not used at the moment', 'https://webshop.cashconverters.com.au/thumbnail/425x260/1938783-emachines-computer-tower-el1850-0.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'ASUS Cerberus RGB Mechanical Keyboard Kaihua Blue', 'ASUS Cerberus RGB Mechanical Keyboard Kaihua Blue', 'not used at the moment', 'https://files.pccasegear.com/images/1499915480-CERBERUS-KEYBOARD-BLUE-th.jpg', 110, 300, 550, '2018-07-11 16:10:10+01', '2018-07-17 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'sapphire_radeon_r9_290x_vapor-x_8gb_1', 'sapphire_radeon_r9_290x_vapor-x_8gb_1', 'not used at the moment', 'data:image/jpeg;base64,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', 250, 500, 810, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'HP next-generation Spectre x360', 'HP next-generation Spectre x360', 'not used at the moment', 'http://st1.bgr.in/wp-content/uploads/2018/02/hp-spectre-x360-main-2.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Optiplex 7010 Business Desktop Premium Computer Tower PC', 'Dell Optiplex 7010 Business Desktop Premium Computer Tower PC (Intel Quad Core i5-3470, 16GB RAM, 2TB HDD + 120GB Brand New SSD, USB 3.0, DVD-RW, Wireless WIFI) Win 10 Pro (Certified Refurbished)', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/61IogATqibL._SX355_.jpg', 270, 400, 680, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Bluetooth Foldable Keyboard Wireless Keyboards', 'Bluetooth Foldable Keyboard Wireless Keyboards', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/71tKQRmkfdL._SY355_.jpg', 50, 100, 200, '2018-05-28 16:10:10+01', '2018-06-03 06:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Gigabyte GeForce GTX 1070 WINDFORCE OC 8G REV2.0 Graphic Cards', 'Gigabyte GeForce GTX 1070 WINDFORCE OC 8G REV2.0 Graphic Cards', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/61IQQziOFdL._SX425_.jpg', 350, 600, 900, '2018-05-29 16:10:10+01', '2018-04-04 11:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Lenovo Yoga 920', 'Lenovo Yoga 920', 'not used at the moment', 'https://assets.pcmag.com/media/images/470292-lenovo-yoga-920.jpg?width=640&height=471', 350, 600, 770, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Lenovo Legion Y720 Tower (AMD)', 'Lenovo Legion Y720 Tower (AMD)', 'not used at the moment', 'https://www3.lenovo.com/medias/lenovo-desktop-legion-y720-tower-hero.png?context=bWFzdGVyfHJvb3R8Njk2NDR8aW1hZ2UvcG5nfGhkOS9oY2EvOTUwNjA5ODE1MTQ1NC5wbmd8NjlkZTI1NjMzOTkzODNiZDRjMmIzNjMxOWQ5MTczMGU4OTBmMzYyYWE4ZTIyOTY3MTc4NzRhNTM0NmVjZTk4Ng', 425, 670, 910, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Kogan Rainbow Backlit Gaming Keyboard', 'Kogan Rainbow Backlit Gaming Keyboard', 'not used at the moment', 'https://images.kogan.com/image/fetch/s--hk2Ahv_3--/b_white,c_pad,f_auto,h_400,q_auto:good,w_600/https://assets.kogan.com/files/product/KARAINMEMKEYA/KARAINMEMKEYA_2.jpg', 150, 500, 700, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'XFX Radeon RX Vega 56 8GB 3xDP HDMI Graphic Cards', 'XFX Radeon RX Vega 56 8GB 3xDP HDMI Graphic Cards', 'not used at the moment', 'https://cdn.shopify.com/s/files/1/2347/6843/products/51T8KpepbDL_600x600.jpg?v=1518763735', 50, 200, 350, '2018-05-29 12:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Samsung NP900X3L-K06US Notebook 9 13.3"', 'Samsung NP900X3L-K06US Notebook 9 13.3"', 'not used at the moment', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYVW9qd0LpOXgtMie_b_y-xfW-xRxi2w58PXAzMsM2QASq6B3q9g', 850, 1270, 1600, '2018-05-29 11:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'DESKTOP PC CORE i5 1TB 4GB POWERFUL 2.4GHZ HP', 'DESKTOP PC CORE i5 1TB 4GB POWERFUL 2.4GHZ HP', 'not used at the moment', 'https://maximumcomputers.co.uk/wp-content/uploads/hp-compaq-8200-elite-sff-pc_8.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'LOGITECH CRAFT ADVANCED WIRELESS KEYBOARD', 'LOGITECH CRAFT ADVANCED WIRELESS KEYBOARD', 'not used at the moment', 'https://banleong.com/sg/wp-content/uploads/2017/11/920-008507.png', 200, 320, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AMD Radeon RX Vega 56', 'AMD Radeon RX Vega 56', 'not used at the moment', 'https://cdn3.techadvisor.co.uk/cmsdata/reviews/3667887/radeon-vega-rx_release-date-ports_thumb800.jpg', 150, 300, 400, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' Logitech G602 Black ', ' Logitech G602 Black ', 'not used at the moment', 'https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Fonte Alim. Antec 550W', 'Fonte Alim. Antec 550W', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'VicTsing MM057 2.4G Wireless Mouse', 'VicTsing MM057 2.4G Wireless Mouse Portable Mobile Optical Mouse with USB Receiver, 5 Adjustable DPI Levels, 6 Buttons for Notebook, PC, Laptop', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/718i4jG9n2L._SL1280_.jpg', 50, 100, 250, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Corsair CX Series 500 Watt Power Supply CX500M', 'Corsair CX Series 500 Watt Power Supply CX500M', 'not used at the moment', 'http://multimonitorcomputer.com/images/lp_images/CXM500_sideview_cable.png', 250, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Usb Computer Gaming Mouse', 'Usb Computer Gaming Mouse', 'not used at the moment', 'https://www.dhresource.com/0x0s/f2-albu-g1-M01-76-C9-rBVaGFWIIcyAMb25AAFXCJURnqA473.jpg/usb-computer-gaming-mouse-laptop-gamer-air.jpg', 200, 400, 620, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', '400W ATX 12V Computer PSU w/ PCIe & SATA', '400W ATX 12V Computer PSU w/ PCIe & SATA', 'not used at the moment', 'https://sgcdn.startech.com/005329/media/products/gallery_large/ATX2PW400PRO.main.jpg', 350, 500, 650, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'iMice A8 USB Wired Gaming Mouse', 'iMice A8 USB Wired Gaming Mouse, 6 Buttons Optical Professional', 'not used at the moment', 'https://ae01.alicdn.com/kf/HTB1d.hTRXXXXXcwapXXq6xXFXXXi/New-iMice-A8-USB-Wired-Gaming-Mouse-6-Buttons-Optical-Professional-Mouse-Gamer-Computer-Mice-For.jpg_640x640.jpg', 150, 500, 600, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Seasonic SS-400/500L1U 400W & 500W 1U Rack Mount Computer AC-DC Power Supply', 'Seasonic SS-400/500L1U 400W & 500W 1U Rack Mount Computer AC-DC Power Supply', 'not used at the moment', 'https://media.rs-online.com/t_large/R7542419-01.jpg', 150, 300, 600, '2018-05-14 16:10:10+01', '2018-05-20 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Wireless Mouse with Nano Receiver', 'Wireless Mouse with Nano Receiver', 'not used at the moment', 'https://i.pinimg.com/originals/c0/58/ad/c058ad8a9c9d8504d6575526bcf0a442.jpg', 30, 80, 150, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'EVGA 500 B1 100-B1-0500-KR 80+ BRONZE 500W', 'EVGA 500 B1 100-B1-0500-KR 80+ BRONZE 500W', 'not used at the moment', 'https://images10.newegg.com/ProductImage/17-438-012-19.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Crystal USB Optical Computer Mouse', 'Crystal USB Optical Computer Mouse', 'not used at the moment', 'https://i.pinimg.com/originals/db/5a/85/db5a853664dd56a2f29935e056058546.jpg', 150, 300, 400, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Silencer Mk III 750W ATX Modular Power Supply', 'Silencer Mk III 750W ATX Modular Power Supply', 'not used at the moment', 'https://cache.custompcguide.net/wp-content/uploads/2013/03/407825_306852_02_back_comping-300x300.jpg', 80, 200, 500, '2018-05-29 13:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Havit HV-MS735 MMO Gaming Mouse', 'Havit HV-MS735 MMO Gaming Mouse', 'not used at the moment', 'https://assets.pcmag.com/media/images/443983-havit-hv-ms735-mmo-gaming-mouse.jpg?width=810&height=456', 250, 500, 700, '2018-05-28 16:10:10+01', '2018-06-03 09:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Game Max Modular PSU GM1050', 'Game Max Modular PSU GM1050 — 1050W 80 PLUS® Silver', 'not used at the moment', 'https://www.dinopc.com/media/catalog/product/cache/75eed2686e01eb22cb4050b2f40ddf97/g/a/gamemax_1050.jpg', 250, 450, 700, '2018-05-29 16:10:10+01', '2018-06-04 10:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);

INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', '3.5 Inch Desktop Hard Drive', 'WD Blue 1TB SATA 6 Gb/s 7200 RPM 64MB Cache 3.5 Inch Desktop Hard Drive', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/81SYu2aMXRL._SL1500_.jpg', 350, 500, 750, '2018-05-29 19:10:10+01', '2018-06-04 20:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Notebook-Harddisk 1 TB', 'Notebook-Harddisk 1 TB, Seagate Mobile SEAGATE ST1000LM035', 'not used at the moment', 'https://cdn-reichelt.de/bilder/web/xxl_ws/E600/ST1000LM035_06.png', 150, 300, 450, '2018-05-28 16:10:10+01', '2018-06-03 18:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 11, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Seagate 1TB Laptop HDD Internal Hard Disk', 'Seagate 1TB Laptop HDD Internal Hard Disk', 'not used at the moment', 'https://ae01.alicdn.com/kf/HTB1Hiz4QVXXXXbJapXXq6xXFXXXV/Seagate-1TB-Laptop-HDD-Internal-Hard-Disk-Drive-2-5-HDD-1TB-7mm-5400RPM-SATA-6Gb.jpg', 250, 400, 600, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 12, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'SATA Desktop OEM Internal Hard Drive', 'WD 1TB WD Caviar Blue 3.5" SATA Desktop OEM Internal Hard Drive', 'not used at the moment', 'https://www.bhphotovideo.com/images/images2500x2500/western_digital_wd10ezex_1tb_wd_caviar_blue_903174.jpg', 90, 200, 400, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 13, NULL, 25);

INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Asus P5P43TD Desktop Motherboard', 'Asus P5P43TD Desktop Motherboard P43 Socket LGA 775 Q8200 Q8300 DDR3 16G ATX UEFI BIOS Original', 'not used at the moment', 'https://ae01.alicdn.com/kf/HTB121quoRfH8KJjy1Xbq6zLdXXaG/Asus-P5P43TD-Desktop-Motherboard-P43-Socket-LGA-775-Q8200-Q8300-DDR3-16G-ATX-UEFI-BIOS-Original.jpg_640x640.jpg', 350, 730, 985, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'MSI Z77A-G45 Desktop Motherboard ', 'MSI Z77A-G45 GAMING Original Used Desktop Motherboard Z77 Socket LGA 1155 i3 i5 i7', 'not used at the moment', 'https://ae01.alicdn.com/kf/HTB1t38xXrArBKNjSZFLq6A_dVXan/MSI-Z77A-G45-GAMING-Original-Used-Desktop-Motherboard-Z77-Socket-LGA-1155-i3-i5-i7-DDR3.jpg_640x640.jpg', 450, 890, 1000, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Zebronics G31 Motherboard', 'Zebronics G31 Motherboard', 'not used at the moment', 'https://rukminim1.flixcart.com/image/312/312/motherboard/9/d/k/zebronics-g31-original-imaeg8b6mmwhaums.jpeg?q=70', 280, 400, 700, '2018-05-28 16:10:10+01', '2018-06-03 10:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Intel Motherboard', 'ASRock B250M Pro4 LGA 1151 Intel B250 HDMI SATA 6Gb/s USB 3.1 Micro ATX Motherboards', 'not used at the moment', 'https://croptitan.com/wp-content/uploads/2017/12/13-157-734-V01.jpg', 370, 560, 900, '2018-05-28 11:10:10+01', '2018-06-03 11:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Asus ROG STRIX X99 GAMING/RGB STRIP MotherBoard MotherBoard', 'Asus ROG STRIX X99 GAMING/RGB STRIP MotherBoard MotherBoard', 'not used at the moment', 'https://ak1.ostkcdn.com/images/products/is/images/direct/4e2703e70a7dc81a5f2e4dfff5311b3eadf986b6/Asus-ROG-STRIX-X99-GAMING-RGB-STRIP-MotherBoard-MotherBoard.jpg?imwidth=320&impolicy=medium', 500, 900, 1400, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);

INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AMD Ryzen 5 processor', 'AMD Ryzen 5 processor', 'not used at the moment', 'https://images.techhive.com/images/article/2017/03/ryzen_5_9-100715958-large.jpg', 390, 500, 780, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Intel i7 6950X Broadwell Extreme Unlocked CPU/Processor', 'Intel i7 6950X Broadwell Extreme Unlocked CPU/Processor', 'not used at the moment', 'https://www.scan.co.uk/images/products/2723371-d.jpg', 450, 600, 820, '2018-05-28 16:10:10+01', '2018-06-03 11:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Intel Xeon X3450 SLBLD Server CPU Processor', 'Intel Xeon X3450 SLBLD Server CPU Processor LGA1156 8M 2.66GHz', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/71rbyFbUC0L._SL1500_.jpg', 350, 450, 700, '2018-05-28 11:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Intel Core i5-8400 6-Core 6-Thread CPU', 'Intel Core i5-8400 6-Core 6-Thread CPU', 'not used at the moment', 'https://eteknix-eteknixltd.netdna-ssl.com/wp-content/uploads/2017/09/DSC_5831-800x663.jpg', 250, 400, 500, '2018-05-28 11:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AMD A8-7600 65W 3.3GHz Socket FM2+', 'AMD A8-7600 65W 3.3GHz Socket FM2+', 'not used at the moment', 'https://www.techspot.com/images/products/processors/amd/org/2014-09-10-product-1.jpg', 150, 300, 400, '2018-05-28 16:10:10+01', '2018-06-03 11:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);

INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', '16GB Laptop Memory RAM', '16GB 2x 8GB DDR3 1600 MHz PC3-12800 Sodimm Laptop Memory RAM Kit 16 G GB', 'not used at the moment', 'https://i.ebayimg.com/images/i/251420608123-0-1/s-l1000.jpg', 150, 200, 400, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Memória RAM G.SKILL Trident Z RGB 16GB (2x8GB)', 'Memória RAM G.SKILL Trident Z RGB 16GB (2x8GB)', 'not used at the moment', 'https://www.pcdiga.com/media/catalog/product/cache/1/image/2718f121925249d501c6086d4b8f9401/1/_/1_6_50.jpg', 50, 100, 200, '2018-05-29 10:10:10+01', '2018-04-04 10:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Memoria Ram DDR4 16GB 2400MHz', 'Memoria Ram DDR4 16GB 2400MHz', 'not used at the moment', 'https://www.spdigital.cl/img/products/BLS8G4D240FSE.jpg', 150, 300, 500, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Memória RAM KINGSTON Hyperx Predator 8GB', 'Memória RAM KINGSTON Hyperx Predator 8GB DDR4 3000Mhz CL15 DIMM', 'not used at the moment', 'https://www.worten.pt/i/3f3c3e2bbf78eb3704a4762f7f404bc6850ac898.jpg', 250, 300, 600, '2018-05-28 10:10:10+01', '2018-06-03 10:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'CORSAIR DDR3 1600 MHz PC RAM - 8 GB', 'CORSAIR DDR3 1600 MHz PC RAM - 8 GB', 'not used at the moment', 'https://brain-images-ssl.cdn.dixons.com/2/5/10143252/l_10143252_001.jpg', 150, 280, 350, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);

--DUPLICATES
--1
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 500, 600, '2018-05-29 16:19:10+01', '2018-06-03 03:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
--7
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'GETWORTH T25 Computer Tower', 'GETWORTH T25 Computer Tower', 'not used at the moment', 'https://gloimg.gbtcdn.com/gb/pdm-product-pic/Maiyang/2017/09/17/source-img/20170917180055_49745.jpg', 1500, 3500, 5000, '2018-05-30 16:10:10+01', '2018-06-04 11:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 25);
--10
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Notebook 7 Spin', 'Notebook 7 Spin', 'New!!!!', 'https://cdn.mos.cms.futurecdn.net/cndBsdKvcSFbnh7srJhRzS-320-80.jpg', 820, 1340, 1700, '2018-05-29 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, 25);
--12
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' GETWORTH R12 Computer Tower - WHITE', ' GETWORTH R12 Computer Tower - WHITE', 'Brand new and I did not like the color', 'https://gloimg.gbtcdn.com/gb/pdm-product-pic/Electronic/2017/03/24/source-img/20170324174956_87899.jpg', 100, 450, 800, '2018-05-29 11:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 22);
--15
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Lenovo V110-15ISK 15.6"', 'Lenovo V110-15ISK 15.6" Cheap Intel Core i3 Laptop, 4GB RAM, 500GB', 'New!!!!', 'https://www.laptopoutlet.co.uk/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/5/4/5454_114.jpg', 600, 900, 1150, '2018-05-29 16:59:10+01', '2018-06-03 15:11:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, 25);
--18
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Diypc SECC ATX Gaming Computer Case Full Tower USB3.0 w/ 7 x 120mm', 'Diypc SECC ATX Gaming Computer Case Full Tower USB3.0 w/ 7 x 120mm', 'Bought another one', 'https://images.prod.meredith.com/product/cd4e9ae697733aceb2666934d8000202/1500542931548/l/diypc-secc-atx-gaming-computer-case-full-tower-usb3-0-with-7-x-120mm-blue-fans-black-skyline-07-b-new-open-box', 300, 965, 1500, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, 10, NULL, 25);
--19
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'not used at the moment', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 150, 500, 600, '2018-05-29 01:10:10+01', '2018-06-03 06:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 25);
--20
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'RAIDMAX Cobra Z ATX Mid Tower Computer Case', 'RAIDMAX Cobra Z ATX Mid Tower Computer Case / Steel/Plastic / USB 3.0 x 1 + USB 2.0 x 1 / Patented Wide Body Design / Supports 120mm Liquid Cooling System', 'not used at the moment', 'https://www.evetech.co.za/repository/ProductImages/raidmax-cobra-z-computer-case-0003.jpg', 500, 1100, 2000, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, 25);
--21
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'HP Omen Core i7 Desktop Tower', 'HP Omen Core i7 Desktop Tower', 'not used at the moment', 'https://images.officeworks.com.au/api/2/img/https://s3-ap-southeast-2.amazonaws.com/wc-prod-pim/JPEG_1000x1000/HPOMENCI7_C_hp_omen_core_i7_desktop_tower.jpg/resize?size=706&auth=MjA5OTcwODkwMg__', 320, 700, 1250, '2018-05-29 16:10:10+01', '2018-05-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 1, 8, NULL, 25);
--23
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'HP Compaq 6000 Pro MicroTower HP Desktop Computer Tower PC Intel Core 2 Duo Windows 10 Pro', 'HP Compaq 6000 Pro MicroTower HP Desktop Computer Tower PC Intel Core 2 Duo Windows 10 Pro', 'too slow for me', 'https://cdn.shopify.com/s/files/1/2429/0345/products/57_d9a9f1c7-c8dc-4ea4-ad28-bd59181ddb55_580x.jpg?v=1507831313', 100, 350, 450, '2018-05-29 14:07:14+01', '2018-06-03 10:40:28+01', NULL, 0, NULL, NULL, NULL, NULL, 7, NULL, 25);
--27
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Apple 11.6" MacBook Air', 'Apple 11.6" MacBook Air
Get a great deal with this online auction for a laptop presented by Property Room on behalf of a law enforcement or public agency client.

    Model: A1465
    Serial: C02JM5QNDXXX
    Processor: Intel Core i5 3317U CPU
    CPU Speed: 1.7 GHz
    Hard Drive: 64GB
    HDD Caddy: Included
    RAM: 4GB
    Drives: N/A
    Battery: Included
    Screen Size: 11.6"
    Power Adapter: None Included
    Accessories: None Included
    Cosmetic Condition: Marks, Scratches, Scuffs, and Dents On Casing; Screen is Scratched
    Testing Results: Tested and Powered On; Hard Drive Has Been Wiped; Requires Operating System Installation; Start-Up Disk Manager and OS Utilities were Both Accessible

Condition: Fair

Due to licensing restrictions, this item will be shipped without any software, including operating system software.', 'Get a great deal with this online auction for a laptop presented by Property Room on behalf of a law enforcement or public agency client.', 'http://content.propertyroom.com/listings/sellers/seller1/images/origimgs/apple-116-macbook-air-1_29320182052231193305.jpg', 200, 500, 800, '2018-05-30 22:43:23.582097+01', '2018-06-04 22:43:23.582097+01', NULL, 0, NULL, NULL, NULL, NULL, 5, NULL, NULL);
--28
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/41WtKtFCKoL._AC_SR160,160_.jpg', 150, 500, 600, '2018-05-30 16:10:10+01', '2018-06-05 02:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
--29
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'NOX Hummer TGX ', 'NOX Hummer TGX ', 'not used at the moment', 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSYkvZPYNcIa0gD6hduh3i3OMiMp6kQRlC3xeDrOj9m9Ta0zioQaPwhEv7XVTUQLNrhVxWtT4g&usqp=CAc', 150, 500, 600, '2018-05-30 16:30:10+01', '2018-06-04 11:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
--30
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'ASUS Mini-Tower Desktop Computer', 'ASUS Republic of Gamers GR8 II Mini-Tower Desktop Computer', 'not used at the moment', 'https://www.bhphotovideo.com/images/images2500x2500/asus_gr8_ii_t069z_i5_7400_16gb_512ssd_gtx_1319359.jpg', 450, 850, 1200, '2018-05-30 16:10:10+01', '2018-06-05 16:10:10+01', NULL, 0, NULL, NULL, NULL, 11, NULL, 25);
--31
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Optiplex 755 Desktop CPU Computer Tower', 'Dell Optiplex 755 Desktop CPU Computer Tower', 'not used at the moment', 'https://i.ebayimg.com/images/g/e7QAAOSwT5tWM38T/s-l300.jpg', 50, 150, 300, '2018-05-30 16:10:10+01', '2018-06-04 16:50:10+01', NULL, 0, NULL, NULL, NULL, 12, NULL, 25);
--32
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Acer Predator G6 Gaming Computer Tower', 'Acer Predator G6 Gaming Computer Tower', 'not used at the moment', 'https://gloimg.gbtcdn.com/gb/pdm-product-pic/Electronic/2017/12/05/source-img/20171205104209_19400.jpg', 775, 1100, 1450, '2018-05-30 06:10:10+01', '2018-06-05 16:10:10+01', NULL, 0, NULL, NULL, NULL, 13, NULL, 25);
--33
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'CUK Switch 77 Black/Silver Mid Tower Desktop PC ATX', 'CUK Switch 77 Black/Silver Mid Tower Desktop PC ATX', 'not used at the moment', 'https://cukusa.com/media/catalog/product/cache/1/image/400x/9df78eab33525d08d6e5fb8d27136e95/b/l/black_light_final_1.jpg', 250, 500, 630, '2018-05-30 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 9, NULL, 25);
--34
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Asus X205TA (Atom Z3735)', 'Asus X205TA (Atom Z3735)', 'not used at the moment', 'https://i.nextmedia.com.au/Utils/ImageResizer.ashx?n=http%3A%2F%2Fi.nextmedia.com.au%2FFeatures%2Fcover-r.png&w=900&c=0&s=0', 250, 400, 590, '2018-05-30 12:10:10+01', '2018-06-05 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--35
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec ISK110 Vesa-U3', 'Antec ISK110 Vesa-U3', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_97919/0-761345-10106-6.jpg', 150, 500, 600, '2018-05-29 16:10:10+01', '2018-06-04 11:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--36
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AZIO MK HUE Red USB Backlit Keyboard', 'AZIO MK HUE Red USB Backlit Keyboard', 'not used at the moment', 'https://images10.newegg.com/ProductImageCompressAll300/23-839-039-02.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 10:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--37
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' MSI RX 580', ' MSI RX 580', 'not used at the moment', 'https://3.bp.blogspot.com/-XSGH_w2pt_U/WQtZ3062d4I/AAAAAAAAIkg/utBZvxuF_UUfCliU9Prjwoovkhpq5-xrgCK4B/s320/MSI%2BRX%2B580%2BGAMING%2BX.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--38
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell XPS 15 9560', 'Dell XPS 15 9560', 'never used it', 'https://static.digit.in/default/a1a4383476c1125adbbae6e280ded659d853298b.jpeg', 750, 900, 1100, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--39
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec Nine Hundred Black Steel ATX Mid Tower', 'Antec Nine Hundred Black Steel ATX Mid Tower', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/71DEVmo3ExL._SY606_.jpg', 750, 990, 1100, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--41
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Inno3D-iChill-GeForce-GTX-980-HerculeZ-x4_1', 'Inno3D-iChill-GeForce-GTX-980-HerculeZ-x4_1', 'not used at the moment', 'https://i.stack.imgur.com/3KsTF.jpg', 200, 400, 700, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--42
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Acer Nitro 5 Spin 15.6"', 'Acer Nitro 5 Spin 15.6"', 'not used at the moment', 'https://images.anandtech.com/doci/11752/acer_nitro_678_678x452.jpg', 650, 1020, 1435, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--43
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'EMachines Computer Tower EL1850', 'EMachines Computer Tower EL1850', 'not used at the moment', 'https://webshop.cashconverters.com.au/thumbnail/425x260/1938783-emachines-computer-tower-el1850-0.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--45
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'sapphire_radeon_r9_290x_vapor-x_8gb_1', 'sapphire_radeon_r9_290x_vapor-x_8gb_1', 'not used at the moment', 'data:image/jpeg;base64,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', 250, 500, 810, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--46
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'HP next-generation Spectre x360', 'HP next-generation Spectre x360', 'not used at the moment', 'http://st1.bgr.in/wp-content/uploads/2018/02/hp-spectre-x360-main-2.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--47
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Optiplex 7010 Business Desktop Premium Computer Tower PC', 'Dell Optiplex 7010 Business Desktop Premium Computer Tower PC (Intel Quad Core i5-3470, 16GB RAM, 2TB HDD + 120GB Brand New SSD, USB 3.0, DVD-RW, Wireless WIFI) Win 10 Pro (Certified Refurbished)', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/61IogATqibL._SX355_.jpg', 270, 400, 680, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--48
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Bluetooth Foldable Keyboard Wireless Keyboards', 'Bluetooth Foldable Keyboard Wireless Keyboards', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/71tKQRmkfdL._SY355_.jpg', 50, 100, 200, '2018-05-28 16:10:10+01', '2018-06-03 06:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--49
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Gigabyte GeForce GTX 1070 WINDFORCE OC 8G REV2.0 Graphic Cards', 'Gigabyte GeForce GTX 1070 WINDFORCE OC 8G REV2.0 Graphic Cards', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/61IQQziOFdL._SX425_.jpg', 350, 600, 900, '2018-05-29 16:10:10+01', '2018-04-04 11:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--50
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Lenovo Yoga 920', 'Lenovo Yoga 920', 'not used at the moment', 'https://assets.pcmag.com/media/images/470292-lenovo-yoga-920.jpg?width=640&height=471', 350, 600, 770, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--51
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Lenovo Legion Y720 Tower (AMD)', 'Lenovo Legion Y720 Tower (AMD)', 'not used at the moment', 'https://www3.lenovo.com/medias/lenovo-desktop-legion-y720-tower-hero.png?context=bWFzdGVyfHJvb3R8Njk2NDR8aW1hZ2UvcG5nfGhkOS9oY2EvOTUwNjA5ODE1MTQ1NC5wbmd8NjlkZTI1NjMzOTkzODNiZDRjMmIzNjMxOWQ5MTczMGU4OTBmMzYyYWE4ZTIyOTY3MTc4NzRhNTM0NmVjZTk4Ng', 425, 670, 910, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--52
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Kogan Rainbow Backlit Gaming Keyboard', 'Kogan Rainbow Backlit Gaming Keyboard', 'not used at the moment', 'https://images.kogan.com/image/fetch/s--hk2Ahv_3--/b_white,c_pad,f_auto,h_400,q_auto:good,w_600/https://assets.kogan.com/files/product/KARAINMEMKEYA/KARAINMEMKEYA_2.jpg', 150, 500, 700, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--53
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'XFX Radeon RX Vega 56 8GB 3xDP HDMI Graphic Cards', 'XFX Radeon RX Vega 56 8GB 3xDP HDMI Graphic Cards', 'not used at the moment', 'https://cdn.shopify.com/s/files/1/2347/6843/products/51T8KpepbDL_600x600.jpg?v=1518763735', 50, 200, 350, '2018-05-29 12:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--54
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Samsung NP900X3L-K06US Notebook 9 13.3"', 'Samsung NP900X3L-K06US Notebook 9 13.3"', 'not used at the moment', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYVW9qd0LpOXgtMie_b_y-xfW-xRxi2w58PXAzMsM2QASq6B3q9g', 850, 1270, 1600, '2018-05-29 11:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--55
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'DESKTOP PC CORE i5 1TB 4GB POWERFUL 2.4GHZ HP', 'DESKTOP PC CORE i5 1TB 4GB POWERFUL 2.4GHZ HP', 'not used at the moment', 'https://maximumcomputers.co.uk/wp-content/uploads/hp-compaq-8200-elite-sff-pc_8.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--56
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'LOGITECH CRAFT ADVANCED WIRELESS KEYBOARD', 'LOGITECH CRAFT ADVANCED WIRELESS KEYBOARD', 'not used at the moment', 'https://banleong.com/sg/wp-content/uploads/2017/11/920-008507.png', 200, 320, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--57
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AMD Radeon RX Vega 56', 'AMD Radeon RX Vega 56', 'not used at the moment', 'https://cdn3.techadvisor.co.uk/cmsdata/reviews/3667887/radeon-vega-rx_release-date-ports_thumb800.jpg', 150, 300, 400, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--58
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' Logitech G602 Black ', ' Logitech G602 Black ', 'not used at the moment', 'https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--59
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Fonte Alim. Antec 550W', 'Fonte Alim. Antec 550W', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--60
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'VicTsing MM057 2.4G Wireless Mouse', 'VicTsing MM057 2.4G Wireless Mouse Portable Mobile Optical Mouse with USB Receiver, 5 Adjustable DPI Levels, 6 Buttons for Notebook, PC, Laptop', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/718i4jG9n2L._SL1280_.jpg', 50, 100, 250, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--61
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Corsair CX Series 500 Watt Power Supply CX500M', 'Corsair CX Series 500 Watt Power Supply CX500M', 'not used at the moment', 'http://multimonitorcomputer.com/images/lp_images/CXM500_sideview_cable.png', 250, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--62
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Usb Computer Gaming Mouse', 'Usb Computer Gaming Mouse', 'not used at the moment', 'https://www.dhresource.com/0x0s/f2-albu-g1-M01-76-C9-rBVaGFWIIcyAMb25AAFXCJURnqA473.jpg/usb-computer-gaming-mouse-laptop-gamer-air.jpg', 200, 400, 620, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--63
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', '400W ATX 12V Computer PSU w/ PCIe & SATA', '400W ATX 12V Computer PSU w/ PCIe & SATA', 'not used at the moment', 'https://sgcdn.startech.com/005329/media/products/gallery_large/ATX2PW400PRO.main.jpg', 350, 500, 650, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--64
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'iMice A8 USB Wired Gaming Mouse', 'iMice A8 USB Wired Gaming Mouse, 6 Buttons Optical Professional', 'not used at the moment', 'https://ae01.alicdn.com/kf/HTB1d.hTRXXXXXcwapXXq6xXFXXXi/New-iMice-A8-USB-Wired-Gaming-Mouse-6-Buttons-Optical-Professional-Mouse-Gamer-Computer-Mice-For.jpg_640x640.jpg', 150, 500, 600, '2018-05-29 16:10:10+01', '2018-04-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--65
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Seasonic SS-400/500L1U 400W & 500W 1U Rack Mount Computer AC-DC Power Supply', 'Seasonic SS-400/500L1U 400W & 500W 1U Rack Mount Computer AC-DC Power Supply', 'not used at the moment', 'https://media.rs-online.com/t_large/R7542419-01.jpg', 150, 300, 600, '2018-05-14 16:10:10+01', '2018-05-20 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--66
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Wireless Mouse with Nano Receiver', 'Wireless Mouse with Nano Receiver', 'not used at the moment', 'https://i.pinimg.com/originals/c0/58/ad/c058ad8a9c9d8504d6575526bcf0a442.jpg', 30, 80, 150, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--67
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'EVGA 500 B1 100-B1-0500-KR 80+ BRONZE 500W', 'EVGA 500 B1 100-B1-0500-KR 80+ BRONZE 500W', 'not used at the moment', 'https://images10.newegg.com/ProductImage/17-438-012-19.jpg', 150, 500, 600, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--68
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Crystal USB Optical Computer Mouse', 'Crystal USB Optical Computer Mouse', 'not used at the moment', 'https://i.pinimg.com/originals/db/5a/85/db5a853664dd56a2f29935e056058546.jpg', 150, 300, 400, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--69
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Silencer Mk III 750W ATX Modular Power Supply', 'Silencer Mk III 750W ATX Modular Power Supply', 'not used at the moment', 'https://cache.custompcguide.net/wp-content/uploads/2013/03/407825_306852_02_back_comping-300x300.jpg', 80, 200, 500, '2018-05-29 13:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--70
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Havit HV-MS735 MMO Gaming Mouse', 'Havit HV-MS735 MMO Gaming Mouse', 'not used at the moment', 'https://assets.pcmag.com/media/images/443983-havit-hv-ms735-mmo-gaming-mouse.jpg?width=810&height=456', 250, 500, 700, '2018-05-28 16:10:10+01', '2018-06-03 09:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--71
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Game Max Modular PSU GM1050', 'Game Max Modular PSU GM1050 — 1050W 80 PLUS® Silver', 'not used at the moment', 'https://www.dinopc.com/media/catalog/product/cache/75eed2686e01eb22cb4050b2f40ddf97/g/a/gamemax_1050.jpg', 250, 450, 700, '2018-05-29 16:10:10+01', '2018-06-04 10:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--72
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', '3.5 Inch Desktop Hard Drive', 'WD Blue 1TB SATA 6 Gb/s 7200 RPM 64MB Cache 3.5 Inch Desktop Hard Drive', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/81SYu2aMXRL._SL1500_.jpg', 350, 500, 750, '2018-05-29 19:10:10+01', '2018-06-04 20:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 25);
--73
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Notebook-Harddisk 1 TB', 'Notebook-Harddisk 1 TB, Seagate Mobile SEAGATE ST1000LM035', 'not used at the moment', 'https://cdn-reichelt.de/bilder/web/xxl_ws/E600/ST1000LM035_06.png', 150, 300, 450, '2018-05-28 16:10:10+01', '2018-06-03 18:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 11, NULL, 25);
--74
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Seagate 1TB Laptop HDD Internal Hard Disk', 'Seagate 1TB Laptop HDD Internal Hard Disk', 'not used at the moment', 'https://ae01.alicdn.com/kf/HTB1Hiz4QVXXXXbJapXXq6xXFXXXV/Seagate-1TB-Laptop-HDD-Internal-Hard-Disk-Drive-2-5-HDD-1TB-7mm-5400RPM-SATA-6Gb.jpg', 250, 400, 600, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 12, NULL, 25);
--75
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'SATA Desktop OEM Internal Hard Drive', 'WD 1TB WD Caviar Blue 3.5" SATA Desktop OEM Internal Hard Drive', 'not used at the moment', 'https://www.bhphotovideo.com/images/images2500x2500/western_digital_wd10ezex_1tb_wd_caviar_blue_903174.jpg', 90, 200, 400, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 13, NULL, 25);
--76
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Asus P5P43TD Desktop Motherboard', 'Asus P5P43TD Desktop Motherboard P43 Socket LGA 775 Q8200 Q8300 DDR3 16G ATX UEFI BIOS Original', 'not used at the moment', 'https://ae01.alicdn.com/kf/HTB121quoRfH8KJjy1Xbq6zLdXXaG/Asus-P5P43TD-Desktop-Motherboard-P43-Socket-LGA-775-Q8200-Q8300-DDR3-16G-ATX-UEFI-BIOS-Original.jpg_640x640.jpg', 350, 730, 985, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--77
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'MSI Z77A-G45 Desktop Motherboard ', 'MSI Z77A-G45 GAMING Original Used Desktop Motherboard Z77 Socket LGA 1155 i3 i5 i7', 'not used at the moment', 'https://ae01.alicdn.com/kf/HTB1t38xXrArBKNjSZFLq6A_dVXan/MSI-Z77A-G45-GAMING-Original-Used-Desktop-Motherboard-Z77-Socket-LGA-1155-i3-i5-i7-DDR3.jpg_640x640.jpg', 450, 890, 1000, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--78
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Zebronics G31 Motherboard', 'Zebronics G31 Motherboard', 'not used at the moment', 'https://rukminim1.flixcart.com/image/312/312/motherboard/9/d/k/zebronics-g31-original-imaeg8b6mmwhaums.jpeg?q=70', 280, 400, 700, '2018-05-28 16:10:10+01', '2018-06-03 10:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
--79
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Intel Motherboard', 'ASRock B250M Pro4 LGA 1151 Intel B250 HDMI SATA 6Gb/s USB 3.1 Micro ATX Motherboards', 'not used at the moment', 'https://croptitan.com/wp-content/uploads/2017/12/13-157-734-V01.jpg', 370, 560, 900, '2018-05-28 11:10:10+01', '2018-06-03 11:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--80
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Asus ROG STRIX X99 GAMING/RGB STRIP MotherBoard MotherBoard', 'Asus ROG STRIX X99 GAMING/RGB STRIP MotherBoard MotherBoard', 'not used at the moment', 'https://ak1.ostkcdn.com/images/products/is/images/direct/4e2703e70a7dc81a5f2e4dfff5311b3eadf986b6/Asus-ROG-STRIX-X99-GAMING-RGB-STRIP-MotherBoard-MotherBoard.jpg?imwidth=320&impolicy=medium', 500, 900, 1400, '2018-05-29 16:10:10+01', '2018-06-04 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--81
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AMD Ryzen 5 processor', 'AMD Ryzen 5 processor', 'not used at the moment', 'https://images.techhive.com/images/article/2017/03/ryzen_5_9-100715958-large.jpg', 390, 500, 780, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--82
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Intel i7 6950X Broadwell Extreme Unlocked CPU/Processor', 'Intel i7 6950X Broadwell Extreme Unlocked CPU/Processor', 'not used at the moment', 'https://www.scan.co.uk/images/products/2723371-d.jpg', 450, 600, 820, '2018-05-28 16:10:10+01', '2018-06-03 11:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--83
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Intel Xeon X3450 SLBLD Server CPU Processor', 'Intel Xeon X3450 SLBLD Server CPU Processor LGA1156 8M 2.66GHz', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/71rbyFbUC0L._SL1500_.jpg', 350, 450, 700, '2018-05-28 11:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--84
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Intel Core i5-8400 6-Core 6-Thread CPU', 'Intel Core i5-8400 6-Core 6-Thread CPU', 'not used at the moment', 'https://eteknix-eteknixltd.netdna-ssl.com/wp-content/uploads/2017/09/DSC_5831-800x663.jpg', 250, 400, 500, '2018-05-28 11:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--85
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AMD A8-7600 65W 3.3GHz Socket FM2+', 'AMD A8-7600 65W 3.3GHz Socket FM2+', 'not used at the moment', 'https://www.techspot.com/images/products/processors/amd/org/2014-09-10-product-1.jpg', 150, 300, 400, '2018-05-28 16:10:10+01', '2018-06-03 11:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--86
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', '16GB Laptop Memory RAM', '16GB 2x 8GB DDR3 1600 MHz PC3-12800 Sodimm Laptop Memory RAM Kit 16 G GB', 'not used at the moment', 'https://i.ebayimg.com/images/i/251420608123-0-1/s-l1000.jpg', 150, 200, 400, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--87
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Memória RAM G.SKILL Trident Z RGB 16GB (2x8GB)', 'Memória RAM G.SKILL Trident Z RGB 16GB (2x8GB)', 'not used at the moment', 'https://www.pcdiga.com/media/catalog/product/cache/1/image/2718f121925249d501c6086d4b8f9401/1/_/1_6_50.jpg', 50, 100, 200, '2018-05-29 10:10:10+01', '2018-04-04 10:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--88
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Memoria Ram DDR4 16GB 2400MHz', 'Memoria Ram DDR4 16GB 2400MHz', 'not used at the moment', 'https://www.spdigital.cl/img/products/BLS8G4D240FSE.jpg', 150, 300, 500, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--89
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Memória RAM KINGSTON Hyperx Predator 8GB', 'Memória RAM KINGSTON Hyperx Predator 8GB DDR4 3000Mhz CL15 DIMM', 'not used at the moment', 'https://www.worten.pt/i/3f3c3e2bbf78eb3704a4762f7f404bc6850ac898.jpg', 250, 300, 600, '2018-05-28 10:10:10+01', '2018-06-03 10:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
--90
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'CORSAIR DDR3 1600 MHz PC RAM - 8 GB', 'CORSAIR DDR3 1600 MHz PC RAM - 8 GB', 'not used at the moment', 'https://brain-images-ssl.cdn.dixons.com/2/5/10143252/l_10143252_001.jpg', 150, 280, 350, '2018-05-28 16:10:10+01', '2018-06-03 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);

--
-- Data for Name: bid; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 20:10:10+01', 165, 1, 3, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 20:20:10+01', 167, 1, 4, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 16:30:10+01', 175, 1, 6, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 16:15:10+01', 1600, 7, 9, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 16:20:10+01', 150, 12, 11, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2016-04-07 16:10:10+01', 160, 12, 5, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 16:15:10+01', 570, 12, 4, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 01:57:47.609897+01', 500, 1, 18, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 09:34:44.568129+01', 1650, 7, 11, false);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 09:38:20.780618+01', 1800, 7, 11, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 09:45:40.80046+01', 2000, 7, 11, true);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 10:18:45.488189+01', 505, 1, 6, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 10:20:12.186704+01', 600, 1, 8, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 10:21:40.598228+01', 650, 1, 11, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 10:29:30.442617+01', 660, 1, 3, NULL);


--
-- Data for Name: blocks; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO blocks VALUES ('Blocked', 'This user did not respect the rules of the site in doing comments with insults.', '2018-03-26 16:10:10+01', 29, 25);


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO category (name, parent) VALUES ('Towers w/ Components', NULL);
INSERT INTO category (name, parent) VALUES ('Towers', NULL);
INSERT INTO category (name, parent) VALUES ('Laptops', NULL);
INSERT INTO category (name, parent) VALUES ('Components', NULL);
INSERT INTO category (name, parent) VALUES ('Peripherals', NULL);
INSERT INTO category (name, parent) VALUES ('Motherboards', 4);
INSERT INTO category (name, parent) VALUES ('Processors', 4);
INSERT INTO category (name, parent) VALUES ('RAM', 4);
INSERT INTO category (name, parent) VALUES ('Graphic Cards', 4);
INSERT INTO category (name, parent) VALUES ('Power Supplies', 4);
INSERT INTO category (name, parent) VALUES ('Keyboards', 5);
INSERT INTO category (name, parent) VALUES ('HDD', 4);
INSERT INTO category (name, parent) VALUES ('Mouse', 5);


--
-- Data for Name: categoryofauction; Type: TABLE DATA; Schema: public; Owner: lbaw1716

INSERT INTO categoryofauction VALUES (1, 1);
INSERT INTO categoryofauction VALUES (12, 2);
INSERT INTO categoryofauction VALUES (4, 2);
INSERT INTO categoryofauction VALUES (3, 3);
INSERT INTO categoryofauction VALUES (12, 4);
INSERT INTO categoryofauction VALUES (4, 4);
INSERT INTO categoryofauction VALUES (3, 5);
INSERT INTO categoryofauction VALUES (12, 6);
INSERT INTO categoryofauction VALUES (4, 6);
INSERT INTO categoryofauction VALUES (1, 7);
INSERT INTO categoryofauction VALUES (2, 7);
INSERT INTO categoryofauction VALUES (3, 8);
INSERT INTO categoryofauction VALUES (12, 9);
INSERT INTO categoryofauction VALUES (4, 9);
INSERT INTO categoryofauction VALUES (3, 10);
INSERT INTO categoryofauction VALUES (12, 11);
INSERT INTO categoryofauction VALUES (4, 11);
INSERT INTO categoryofauction VALUES (1, 12);
INSERT INTO categoryofauction VALUES (2, 12);
INSERT INTO categoryofauction VALUES (3, 13);
INSERT INTO categoryofauction VALUES (12, 14);
INSERT INTO categoryofauction VALUES (4, 14);
INSERT INTO categoryofauction VALUES (3, 15);
INSERT INTO categoryofauction VALUES (12, 16);
INSERT INTO categoryofauction VALUES (4, 16);
INSERT INTO categoryofauction VALUES (3, 17);
INSERT INTO categoryofauction VALUES (1, 18);
INSERT INTO categoryofauction VALUES (12, 19);
INSERT INTO categoryofauction VALUES (4, 19);
INSERT INTO categoryofauction VALUES (1, 20);
INSERT INTO categoryofauction VALUES (1, 21);
INSERT INTO categoryofauction VALUES (12, 22);
INSERT INTO categoryofauction VALUES (4, 22);
INSERT INTO categoryofauction VALUES (1, 23);
INSERT INTO categoryofauction VALUES (3, 24);
INSERT INTO categoryofauction VALUES (1, 25);
INSERT INTO categoryofauction VALUES (3, 26);
INSERT INTO categoryofauction VALUES (3, 27);
INSERT INTO categoryofauction VALUES (2, 28);
INSERT INTO categoryofauction VALUES (2, 29);
INSERT INTO categoryofauction VALUES (2, 30);
INSERT INTO categoryofauction VALUES (2, 31);
INSERT INTO categoryofauction VALUES (2, 32);
INSERT INTO categoryofauction VALUES (2, 33);
INSERT INTO categoryofauction VALUES (3, 34);
INSERT INTO categoryofauction VALUES (2, 35);
INSERT INTO categoryofauction VALUES (5, 36);
INSERT INTO categoryofauction VALUES (11, 36);
INSERT INTO categoryofauction VALUES (9, 37);
INSERT INTO categoryofauction VALUES (4, 37);
INSERT INTO categoryofauction VALUES (3, 38);
INSERT INTO categoryofauction VALUES (2, 39);
INSERT INTO categoryofauction VALUES (5, 40);
INSERT INTO categoryofauction VALUES (11, 40);
INSERT INTO categoryofauction VALUES (9, 41);
INSERT INTO categoryofauction VALUES (4, 41);
INSERT INTO categoryofauction VALUES (3, 42);
INSERT INTO categoryofauction VALUES (2, 43);
INSERT INTO categoryofauction VALUES (5, 44);
INSERT INTO categoryofauction VALUES (11, 44);
INSERT INTO categoryofauction VALUES (9, 45);
INSERT INTO categoryofauction VALUES (4, 45);
INSERT INTO categoryofauction VALUES (3, 46);
INSERT INTO categoryofauction VALUES (2, 47);
INSERT INTO categoryofauction VALUES (5, 48);
INSERT INTO categoryofauction VALUES (11, 48);
INSERT INTO categoryofauction VALUES (9, 49);
INSERT INTO categoryofauction VALUES (4, 49);
INSERT INTO categoryofauction VALUES (3, 50);
INSERT INTO categoryofauction VALUES (2, 51);
INSERT INTO categoryofauction VALUES (5, 52);
INSERT INTO categoryofauction VALUES (11, 52);
INSERT INTO categoryofauction VALUES (9, 53);
INSERT INTO categoryofauction VALUES (4, 53);
INSERT INTO categoryofauction VALUES (3, 54);
INSERT INTO categoryofauction VALUES (2, 55);
INSERT INTO categoryofauction VALUES (5, 56);
INSERT INTO categoryofauction VALUES (11, 56);
INSERT INTO categoryofauction VALUES (9, 57);
INSERT INTO categoryofauction VALUES (4, 57);
INSERT INTO categoryofauction VALUES (5, 58);
INSERT INTO categoryofauction VALUES (13, 58);
INSERT INTO categoryofauction VALUES (10, 59);
INSERT INTO categoryofauction VALUES (4, 59);
INSERT INTO categoryofauction VALUES (5, 60);
INSERT INTO categoryofauction VALUES (13, 60);
INSERT INTO categoryofauction VALUES (10, 61);
INSERT INTO categoryofauction VALUES (4, 61);
INSERT INTO categoryofauction VALUES (5, 62);
INSERT INTO categoryofauction VALUES (13, 62);
INSERT INTO categoryofauction VALUES (10, 63);
INSERT INTO categoryofauction VALUES (4, 63);
INSERT INTO categoryofauction VALUES (5, 64);
INSERT INTO categoryofauction VALUES (13, 64);
INSERT INTO categoryofauction VALUES (10, 65);
INSERT INTO categoryofauction VALUES (4, 65);
INSERT INTO categoryofauction VALUES (5, 66);
INSERT INTO categoryofauction VALUES (13, 66);
INSERT INTO categoryofauction VALUES (10, 67);
INSERT INTO categoryofauction VALUES (4, 67);
INSERT INTO categoryofauction VALUES (5, 68);
INSERT INTO categoryofauction VALUES (13, 68);
INSERT INTO categoryofauction VALUES (10, 69);
INSERT INTO categoryofauction VALUES (4, 69);
INSERT INTO categoryofauction VALUES (5, 70);
INSERT INTO categoryofauction VALUES (13, 70);
INSERT INTO categoryofauction VALUES (10, 71);
INSERT INTO categoryofauction VALUES (4, 71);
INSERT INTO categoryofauction VALUES (4, 72);
INSERT INTO categoryofauction VALUES (12, 72);
INSERT INTO categoryofauction VALUES (4, 73);
INSERT INTO categoryofauction VALUES (12, 73);
INSERT INTO categoryofauction VALUES (4, 74);
INSERT INTO categoryofauction VALUES (12, 74);
INSERT INTO categoryofauction VALUES (4, 75);
INSERT INTO categoryofauction VALUES (12, 75);
INSERT INTO categoryofauction VALUES (4, 76);
INSERT INTO categoryofauction VALUES (6, 76);
INSERT INTO categoryofauction VALUES (4, 77);
INSERT INTO categoryofauction VALUES (6, 77);
INSERT INTO categoryofauction VALUES (4, 78);
INSERT INTO categoryofauction VALUES (6, 78);
INSERT INTO categoryofauction VALUES (4, 79);
INSERT INTO categoryofauction VALUES (6, 79);
INSERT INTO categoryofauction VALUES (4, 80);
INSERT INTO categoryofauction VALUES (6, 80);
INSERT INTO categoryofauction VALUES (4, 81);
INSERT INTO categoryofauction VALUES (7, 81);
INSERT INTO categoryofauction VALUES (4, 82);
INSERT INTO categoryofauction VALUES (7, 82);
INSERT INTO categoryofauction VALUES (4, 83);
INSERT INTO categoryofauction VALUES (7, 83);
INSERT INTO categoryofauction VALUES (4, 84);
INSERT INTO categoryofauction VALUES (7, 84);
INSERT INTO categoryofauction VALUES (4, 85);
INSERT INTO categoryofauction VALUES (7, 85);
INSERT INTO categoryofauction VALUES (4, 86);
INSERT INTO categoryofauction VALUES (8, 86);
INSERT INTO categoryofauction VALUES (4, 87);
INSERT INTO categoryofauction VALUES (8, 87);
INSERT INTO categoryofauction VALUES (4, 88);
INSERT INTO categoryofauction VALUES (8, 88);
INSERT INTO categoryofauction VALUES (4, 89);
INSERT INTO categoryofauction VALUES (8, 89);
INSERT INTO categoryofauction VALUES (4, 90);
INSERT INTO categoryofauction VALUES (8, 90);
INSERT INTO categoryofauction VALUES (1, 91);
INSERT INTO categoryofauction VALUES (1, 92);
INSERT INTO categoryofauction VALUES (2, 92);
INSERT INTO categoryofauction VALUES (3, 93);
INSERT INTO categoryofauction VALUES (1, 94);
INSERT INTO categoryofauction VALUES (2, 94);
INSERT INTO categoryofauction VALUES (3, 95);
INSERT INTO categoryofauction VALUES (1, 96);
INSERT INTO categoryofauction VALUES (12, 97);
INSERT INTO categoryofauction VALUES (4, 97);
INSERT INTO categoryofauction VALUES (1, 98);
INSERT INTO categoryofauction VALUES (1, 99);
INSERT INTO categoryofauction VALUES (1, 100);
INSERT INTO categoryofauction VALUES (3, 101);
INSERT INTO categoryofauction VALUES (2, 102);
INSERT INTO categoryofauction VALUES (2, 103);
INSERT INTO categoryofauction VALUES (2, 104);
INSERT INTO categoryofauction VALUES (2, 105);
INSERT INTO categoryofauction VALUES (2, 106);
INSERT INTO categoryofauction VALUES (2, 107);
INSERT INTO categoryofauction VALUES (3, 108);
INSERT INTO categoryofauction VALUES (2, 109);
INSERT INTO categoryofauction VALUES (5, 110);
INSERT INTO categoryofauction VALUES (11, 110);
INSERT INTO categoryofauction VALUES (9, 111);
INSERT INTO categoryofauction VALUES (4, 111);
INSERT INTO categoryofauction VALUES (3, 112);
INSERT INTO categoryofauction VALUES (2, 113);
INSERT INTO categoryofauction VALUES (9, 114);
INSERT INTO categoryofauction VALUES (4, 114);
INSERT INTO categoryofauction VALUES (3, 115);
INSERT INTO categoryofauction VALUES (2, 116);
INSERT INTO categoryofauction VALUES (9, 117);
INSERT INTO categoryofauction VALUES (4, 117);
INSERT INTO categoryofauction VALUES (3, 118);
INSERT INTO categoryofauction VALUES (2, 119);
INSERT INTO categoryofauction VALUES (5, 120);
INSERT INTO categoryofauction VALUES (11, 120);
INSERT INTO categoryofauction VALUES (9, 121);
INSERT INTO categoryofauction VALUES (4, 121);
INSERT INTO categoryofauction VALUES (3, 122);
INSERT INTO categoryofauction VALUES (2, 123);
INSERT INTO categoryofauction VALUES (5, 124);
INSERT INTO categoryofauction VALUES (11, 124);
INSERT INTO categoryofauction VALUES (9, 125);
INSERT INTO categoryofauction VALUES (4, 125);
INSERT INTO categoryofauction VALUES (3, 126);
INSERT INTO categoryofauction VALUES (2, 127);
INSERT INTO categoryofauction VALUES (5, 128);
INSERT INTO categoryofauction VALUES (11, 128);
INSERT INTO categoryofauction VALUES (9, 129);
INSERT INTO categoryofauction VALUES (4, 129);
INSERT INTO categoryofauction VALUES (5, 130);
INSERT INTO categoryofauction VALUES (13, 130);
INSERT INTO categoryofauction VALUES (10, 131);
INSERT INTO categoryofauction VALUES (4, 131);
INSERT INTO categoryofauction VALUES (5, 132);
INSERT INTO categoryofauction VALUES (13, 132);
INSERT INTO categoryofauction VALUES (10, 133);
INSERT INTO categoryofauction VALUES (4, 133);
INSERT INTO categoryofauction VALUES (5, 134);
INSERT INTO categoryofauction VALUES (13, 134);
INSERT INTO categoryofauction VALUES (10, 135);
INSERT INTO categoryofauction VALUES (4, 135);
INSERT INTO categoryofauction VALUES (5, 136);
INSERT INTO categoryofauction VALUES (13, 136);
INSERT INTO categoryofauction VALUES (10, 137);
INSERT INTO categoryofauction VALUES (4, 137);
INSERT INTO categoryofauction VALUES (5, 138);
INSERT INTO categoryofauction VALUES (13, 138);
INSERT INTO categoryofauction VALUES (10, 139);
INSERT INTO categoryofauction VALUES (4, 139);
INSERT INTO categoryofauction VALUES (5, 140);
INSERT INTO categoryofauction VALUES (13, 140);
INSERT INTO categoryofauction VALUES (10, 141);
INSERT INTO categoryofauction VALUES (4, 141);
INSERT INTO categoryofauction VALUES (5, 142);
INSERT INTO categoryofauction VALUES (13, 142);
INSERT INTO categoryofauction VALUES (10, 143);
INSERT INTO categoryofauction VALUES (4, 143);
INSERT INTO categoryofauction VALUES (4, 144);
INSERT INTO categoryofauction VALUES (12, 144);
INSERT INTO categoryofauction VALUES (4, 145);
INSERT INTO categoryofauction VALUES (12, 145);
INSERT INTO categoryofauction VALUES (4, 146);
INSERT INTO categoryofauction VALUES (12, 146);
INSERT INTO categoryofauction VALUES (4, 147);
INSERT INTO categoryofauction VALUES (12, 147);
INSERT INTO categoryofauction VALUES (4, 148);
INSERT INTO categoryofauction VALUES (6, 148);
INSERT INTO categoryofauction VALUES (4, 149);
INSERT INTO categoryofauction VALUES (6, 149);
INSERT INTO categoryofauction VALUES (4, 150);
INSERT INTO categoryofauction VALUES (6, 150);
INSERT INTO categoryofauction VALUES (4, 151);
INSERT INTO categoryofauction VALUES (6, 151);
INSERT INTO categoryofauction VALUES (4, 152);
INSERT INTO categoryofauction VALUES (6, 152);
INSERT INTO categoryofauction VALUES (4, 153);
INSERT INTO categoryofauction VALUES (7, 153);
INSERT INTO categoryofauction VALUES (4, 154);
INSERT INTO categoryofauction VALUES (7, 154);
INSERT INTO categoryofauction VALUES (4, 155);
INSERT INTO categoryofauction VALUES (7, 155);
INSERT INTO categoryofauction VALUES (4, 156);
INSERT INTO categoryofauction VALUES (7, 156);
INSERT INTO categoryofauction VALUES (4, 157);
INSERT INTO categoryofauction VALUES (7, 157);
INSERT INTO categoryofauction VALUES (4, 158);
INSERT INTO categoryofauction VALUES (8, 158);
INSERT INTO categoryofauction VALUES (4, 159);
INSERT INTO categoryofauction VALUES (8, 159);
INSERT INTO categoryofauction VALUES (4, 160);
INSERT INTO categoryofauction VALUES (8, 160);
INSERT INTO categoryofauction VALUES (4, 161);
INSERT INTO categoryofauction VALUES (8, 161);
INSERT INTO categoryofauction VALUES (4, 162);
INSERT INTO categoryofauction VALUES (8, 162);

--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO comment (date,description,auctioncommented,usercommenter) VALUES ('2018-03-31 16:10:10+01', 'Engaging. It keeps your mind occupied while you wait.', 1, 2);
INSERT INTO comment (date,description,auctioncommented,usercommenter) VALUES ('2018-03-31 16:12:10+01', 'Overly slick m8!', 10, 10);
INSERT INTO comment (date,description,auctioncommented,usercommenter) VALUES ('2018-03-31 16:17:10+01', 'It''s nice not just beastly!', 7, 10);
INSERT INTO comment (date,description,auctioncommented,usercommenter) VALUES ('2018-03-31 16:15:10+01', 'Just magnificent, friend.', 7, 8);
INSERT INTO comment (date,description,auctioncommented,usercommenter) VALUES ('2018-03-31 16:20:10+01', 'Bold. So neat.', 10, 11);


--
-- Data for Name: edit_categories; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO edit_categories VALUES (1, 2);
INSERT INTO edit_categories VALUES (2, 2);
INSERT INTO edit_categories VALUES (3, 2);
INSERT INTO edit_categories VALUES (4, 2);
INSERT INTO edit_categories VALUES (5, 2);
INSERT INTO edit_categories VALUES (6, 2);
INSERT INTO edit_categories VALUES (7, 2);
INSERT INTO edit_categories VALUES (8, 2);
INSERT INTO edit_categories VALUES (9, 2);
INSERT INTO edit_categories VALUES (10, 2);


--
-- Data for Name: edit_moderator; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO edit_moderator VALUES (21, 2);
INSERT INTO edit_moderator VALUES (22, 2);
INSERT INTO edit_moderator VALUES (23, 2);
INSERT INTO edit_moderator VALUES (24, 2);
INSERT INTO edit_moderator VALUES (25, 2);

--
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO report VALUES ('2018-03-31 20:10:10+01', '"It may continue to grow in China, but not in Europe or the U.S. We don''t need the imaginary outlet to feel a sense of accomplishment here."
', 1, 25);
INSERT INTO report VALUES ('2018-03-31 20:20:10+01', '"To believe that Apple can somehow succeed where all others have failed is to ignore some fundamental realities of tablet computing."
', 7, 8);
