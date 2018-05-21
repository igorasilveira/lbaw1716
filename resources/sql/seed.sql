
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
    description character varying(50) NOT NULL,
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

INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 22);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 22);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 21);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 23);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'not used at the moment', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 1, 8, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Rejected', 'HDD - Toshiba 2TB 7200RPM ', 'HDD - Toshiba 2TB 7200RPM ', 'New, with some factory malformation but does not influence performance.', 'https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg', 300, 400, 600, '2018-04-26 16:10:10+01', '2018-04-30 16:10:10+01', '2018-04-26 22:10:10+01', 0, 'How can you prove that it has no malfunctions? We are not convinced...', NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 350, 400, '2018-04-03 14:07:14.311868+01', '2018-04-10 10:40:28.876944+01', NULL, 0, NULL, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Pending', 'Apple MacBook Pro 13'' ', 'Apple MacBook Pro 13'' ', 'New!!!!', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 800, 1200, 1500, '2018-03-26 16:10:10+01', '2018-03-31 16:10:10+01', NULL, 0, NULL, NULL, NULL, NULL, 9, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,numberofbids,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Over', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'Dell Premium Desktop Tower with Keyboard&Mouse', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, '2016-04-07 16:10:10+01', 570, 3, 1, 7, 22);
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


Due to licensing restrictions, this item will be shipped without any software, including operating system software.', 'Get a great deal with this online auction for a laptop presented by Property Room on behalf of a law enforcement or public agency client.', 'http://content.propertyroom.com/listings/sellers/seller1/images/origimgs/apple-116-macbook-air-1_29320182052231193305.jpg', 200, 500, 800, '2018-04-07 22:43:23.582097+01', '2018-04-13 22:43:23.582097+01', NULL, 0, NULL, NULL, NULL, NULL, 5, NULL, NULL);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/41WtKtFCKoL._AC_SR160,160_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'NOX Hummer TGX ', 'NOX Hummer TGX ', 'not used at the moment', 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSYkvZPYNcIa0gD6hduh3i3OMiMp6kQRlC3xeDrOj9m9Ta0zioQaPwhEv7XVTUQLNrhVxWtT4g&usqp=CAc', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 10, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/41WtKtFCKoL._AC_SR160,160_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 11, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'NOX Hummer TGX ', 'NOX Hummer TGX ', 'not used at the moment', 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSYkvZPYNcIa0gD6hduh3i3OMiMp6kQRlC3xeDrOj9m9Ta0zioQaPwhEv7XVTUQLNrhVxWtT4g&usqp=CAc', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 12, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer', 'not used at the moment', 'https://images-na.ssl-images-amazon.com/images/I/41WtKtFCKoL._AC_SR160,160_.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 13, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'NOX Hummer TGX ', 'NOX Hummer TGX ', 'not used at the moment', 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSYkvZPYNcIa0gD6hduh3i3OMiMp6kQRlC3xeDrOj9m9Ta0zioQaPwhEv7XVTUQLNrhVxWtT4g&usqp=CAc', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 9, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Apple MacBook Pro 13', 'Apple MacBook Pro 13', 'not used at the moment', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec ISK110 Vesa-U3', 'Antec ISK110 Vesa-U3', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_97919/0-761345-10106-6.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AZIO MK HUE Red USB Backlit Keyboard', 'AZIO MK HUE Red USB Backlit Keyboard', 'not used at the moment', 'https://images10.newegg.com/ProductImageCompressAll300/23-839-039-02.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' MSI RX 580', ' MSI RX 580', 'not used at the moment', 'https://3.bp.blogspot.com/-XSGH_w2pt_U/WQtZ3062d4I/AAAAAAAAIkg/utBZvxuF_UUfCliU9Prjwoovkhpq5-xrgCK4B/s320/MSI%2BRX%2B580%2BGAMING%2BX.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Apple MacBook Pro 13', 'Apple MacBook Pro 13', 'not used at the moment', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec ISK110 Vesa-U3', 'Antec ISK110 Vesa-U3', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_97919/0-761345-10106-6.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AZIO MK HUE Red USB Backlit Keyboard', 'AZIO MK HUE Red USB Backlit Keyboard', 'not used at the moment', 'https://images10.newegg.com/ProductImageCompressAll300/23-839-039-02.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' MSI RX 580', ' MSI RX 580', 'not used at the moment', 'https://3.bp.blogspot.com/-XSGH_w2pt_U/WQtZ3062d4I/AAAAAAAAIkg/utBZvxuF_UUfCliU9Prjwoovkhpq5-xrgCK4B/s320/MSI%2BRX%2B580%2BGAMING%2BX.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Apple MacBook Pro 13', 'Apple MacBook Pro 13', 'not used at the moment', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec ISK110 Vesa-U3', 'Antec ISK110 Vesa-U3', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_97919/0-761345-10106-6.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AZIO MK HUE Red USB Backlit Keyboard', 'AZIO MK HUE Red USB Backlit Keyboard', 'not used at the moment', 'https://images10.newegg.com/ProductImageCompressAll300/23-839-039-02.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' MSI RX 580', ' MSI RX 580', 'not used at the moment', 'https://3.bp.blogspot.com/-XSGH_w2pt_U/WQtZ3062d4I/AAAAAAAAIkg/utBZvxuF_UUfCliU9Prjwoovkhpq5-xrgCK4B/s320/MSI%2BRX%2B580%2BGAMING%2BX.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Apple MacBook Pro 13', 'Apple MacBook Pro 13', 'not used at the moment', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec ISK110 Vesa-U3', 'Antec ISK110 Vesa-U3', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_97919/0-761345-10106-6.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AZIO MK HUE Red USB Backlit Keyboard', 'AZIO MK HUE Red USB Backlit Keyboard', 'not used at the moment', 'https://images10.newegg.com/ProductImageCompressAll300/23-839-039-02.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' MSI RX 580', ' MSI RX 580', 'not used at the moment', 'https://3.bp.blogspot.com/-XSGH_w2pt_U/WQtZ3062d4I/AAAAAAAAIkg/utBZvxuF_UUfCliU9Prjwoovkhpq5-xrgCK4B/s320/MSI%2BRX%2B580%2BGAMING%2BX.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Apple MacBook Pro 13', 'Apple MacBook Pro 13', 'not used at the moment', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec ISK110 Vesa-U3', 'Antec ISK110 Vesa-U3', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_97919/0-761345-10106-6.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AZIO MK HUE Red USB Backlit Keyboard', 'AZIO MK HUE Red USB Backlit Keyboard', 'not used at the moment', 'https://images10.newegg.com/ProductImageCompressAll300/23-839-039-02.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' MSI RX 580', ' MSI RX 580', 'not used at the moment', 'https://3.bp.blogspot.com/-XSGH_w2pt_U/WQtZ3062d4I/AAAAAAAAIkg/utBZvxuF_UUfCliU9Prjwoovkhpq5-xrgCK4B/s320/MSI%2BRX%2B580%2BGAMING%2BX.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Apple MacBook Pro 13', 'Apple MacBook Pro 13', 'not used at the moment', 'https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Antec ISK110 Vesa-U3', 'Antec ISK110 Vesa-U3', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_97919/0-761345-10106-6.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'AZIO MK HUE Red USB Backlit Keyboard', 'AZIO MK HUE Red USB Backlit Keyboard', 'not used at the moment', 'https://images10.newegg.com/ProductImageCompressAll300/23-839-039-02.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' MSI RX 580', ' MSI RX 580', 'not used at the moment', 'https://3.bp.blogspot.com/-XSGH_w2pt_U/WQtZ3062d4I/AAAAAAAAIkg/utBZvxuF_UUfCliU9Prjwoovkhpq5-xrgCK4B/s320/MSI%2BRX%2B580%2BGAMING%2BX.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' Logitech G602 Black ', ' Logitech G602 Black ', 'not used at the moment', 'https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Fonte Alim. Antec 550W', 'Fonte Alim. Antec 550W', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' Logitech G602 Black ', ' Logitech G602 Black ', 'not used at the moment', 'https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Fonte Alim. Antec 550W', 'Fonte Alim. Antec 550W', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' Logitech G602 Black ', ' Logitech G602 Black ', 'not used at the moment', 'https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Fonte Alim. Antec 550W', 'Fonte Alim. Antec 550W', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' Logitech G602 Black ', ' Logitech G602 Black ', 'not used at the moment', 'https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Fonte Alim. Antec 550W', 'Fonte Alim. Antec 550W', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' Logitech G602 Black ', ' Logitech G602 Black ', 'not used at the moment', 'https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Fonte Alim. Antec 550W', 'Fonte Alim. Antec 550W', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' Logitech G602 Black ', ' Logitech G602 Black ', 'not used at the moment', 'https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Fonte Alim. Antec 550W', 'Fonte Alim. Antec 550W', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', ' Logitech G602 Black ', ' Logitech G602 Black ', 'not used at the moment', 'https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 5, NULL, 25);
INSERT INTO "auction" (state,title,description,sellingreason,pathtophoto,startingprice,minimumsellingprice,buynow,startdate,limitdate,refusaldate,reasonofrefusal,finaldate,finalprice,rate,auctioncreator,auctionwinner,responsiblemoderator) VALUES ('Active', 'Fonte Alim. Antec 550W', 'Fonte Alim. Antec 550W', 'not used at the moment', 'https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg', 150, 500, 600, '2018-03-31 16:10:10+01', '2016-04-07 16:10:10+01', NULL, 0, NULL, NULL, NULL, 7, NULL, 25);
--
-- Data for Name: bid; Type: TABLE DATA; Schema: public; Owner: lbaw1716
--

INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 20:10:10+01', 165, 1, 3, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 20:20:10+01', 167, 1, 4, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 16:30:10+01', 175, 1, 6, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 16:15:10+01', 160, 7, 9, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 16:20:10+01', 150, 12, 11, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2016-04-07 16:10:10+01', 160, 12, 2, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-03-31 16:15:10+01', 570, 12, 4, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 01:57:47.609897+01', 500, 1, 18, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 09:34:44.568129+01', 200, 7, 11, false);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 09:38:20.780618+01', 205, 7, 11, NULL);
INSERT INTO bid (date,value,auction_id,user_id,"isBuyNow") VALUES ('2018-04-04 09:45:40.80046+01', 600, 7, 11, true);
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
INSERT INTO categoryofauction VALUES (3, 8);
INSERT INTO categoryofauction VALUES (12, 9);
INSERT INTO categoryofauction VALUES (4, 9);
INSERT INTO categoryofauction VALUES (3, 10);
INSERT INTO categoryofauction VALUES (12, 11);
INSERT INTO categoryofauction VALUES (4, 11);
INSERT INTO categoryofauction VALUES (1, 12);
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
INSERT INTO categoryofauction VALUES (1, 34);
INSERT INTO categoryofauction VALUES (2, 35);
INSERT INTO categoryofauction VALUES (11, 36);
INSERT INTO categoryofauction VALUES (5, 36);
INSERT INTO categoryofauction VALUES (9, 37);
INSERT INTO categoryofauction VALUES (4, 37);
INSERT INTO categoryofauction VALUES (1, 38);
INSERT INTO categoryofauction VALUES (2, 39);
INSERT INTO categoryofauction VALUES (11, 40);
INSERT INTO categoryofauction VALUES (5, 40);
INSERT INTO categoryofauction VALUES (9, 41);
INSERT INTO categoryofauction VALUES (4, 41);
INSERT INTO categoryofauction VALUES (1, 42);
INSERT INTO categoryofauction VALUES (2, 43);
INSERT INTO categoryofauction VALUES (11, 44);
INSERT INTO categoryofauction VALUES (5, 44);
INSERT INTO categoryofauction VALUES (9, 45);
INSERT INTO categoryofauction VALUES (4, 45);
INSERT INTO categoryofauction VALUES (1, 46);
INSERT INTO categoryofauction VALUES (2, 47);
INSERT INTO categoryofauction VALUES (11, 48);
INSERT INTO categoryofauction VALUES (5, 48);
INSERT INTO categoryofauction VALUES (9, 49);
INSERT INTO categoryofauction VALUES (4, 49);
INSERT INTO categoryofauction VALUES (1, 50);
INSERT INTO categoryofauction VALUES (2, 51);
INSERT INTO categoryofauction VALUES (11, 52);
INSERT INTO categoryofauction VALUES (5, 52);
INSERT INTO categoryofauction VALUES (9, 53);
INSERT INTO categoryofauction VALUES (4, 53);
INSERT INTO categoryofauction VALUES (1, 54);
INSERT INTO categoryofauction VALUES (2, 55);
INSERT INTO categoryofauction VALUES (11, 56);
INSERT INTO categoryofauction VALUES (5, 56);
INSERT INTO categoryofauction VALUES (9, 57);
INSERT INTO categoryofauction VALUES (4, 57);--here
INSERT INTO categoryofauction VALUES (13, 58);
INSERT INTO categoryofauction VALUES (10, 59);
INSERT INTO categoryofauction VALUES (4, 59);
INSERT INTO categoryofauction VALUES (13, 60);
INSERT INTO categoryofauction VALUES (10, 61);
INSERT INTO categoryofauction VALUES (4, 61);
INSERT INTO categoryofauction VALUES (13, 62);
INSERT INTO categoryofauction VALUES (10, 63);
INSERT INTO categoryofauction VALUES (4, 63);
INSERT INTO categoryofauction VALUES (13, 64);
INSERT INTO categoryofauction VALUES (10, 65);
INSERT INTO categoryofauction VALUES (4, 65);
INSERT INTO categoryofauction VALUES (13, 66);
INSERT INTO categoryofauction VALUES (10, 67);
INSERT INTO categoryofauction VALUES (4, 67);
INSERT INTO categoryofauction VALUES (13, 68);
INSERT INTO categoryofauction VALUES (10, 69);
INSERT INTO categoryofauction VALUES (4, 69);
INSERT INTO categoryofauction VALUES (13, 70);
INSERT INTO categoryofauction VALUES (10, 71);
INSERT INTO categoryofauction VALUES (4, 71);


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
