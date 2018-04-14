--
-- PostgreSQL database
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

ALTER TABLE IF EXISTS ONLY public.report DROP CONSTRAINT report_normaluserid_fkey;
ALTER TABLE IF EXISTS ONLY public.report DROP CONSTRAINT report_auctionid_fkey;
ALTER TABLE IF EXISTS ONLY public.notification DROP CONSTRAINT notification_authenticated_userid_fkey;
ALTER TABLE IF EXISTS ONLY public.notification DROP CONSTRAINT notification_auctionassociated_fkey;
ALTER TABLE IF EXISTS ONLY public.edit_moderator DROP CONSTRAINT edit_moderator_removeradmin_fkey;
ALTER TABLE IF EXISTS ONLY public.edit_moderator DROP CONSTRAINT edit_moderator_removedmod_fkey;
ALTER TABLE IF EXISTS ONLY public.edit_categories DROP CONSTRAINT edit_categories_category_fkey;
ALTER TABLE IF EXISTS ONLY public.edit_categories DROP CONSTRAINT edit_categories_admin_fkey;
ALTER TABLE IF EXISTS ONLY public.comment DROP CONSTRAINT comment_usercommenter_fkey;
ALTER TABLE IF EXISTS ONLY public.comment DROP CONSTRAINT comment_auctioncommented_fkey;
ALTER TABLE IF EXISTS ONLY public.city DROP CONSTRAINT city_country_fkey;
ALTER TABLE IF EXISTS ONLY public.categoryofauction DROP CONSTRAINT categoryofauction_category_fkey;
ALTER TABLE IF EXISTS ONLY public.categoryofauction DROP CONSTRAINT categoryofauction_auction_fkey;
ALTER TABLE IF EXISTS ONLY public.category DROP CONSTRAINT category_parent_fkey;
ALTER TABLE IF EXISTS ONLY public.blocks DROP CONSTRAINT blocks_blocker_fkey;
ALTER TABLE IF EXISTS ONLY public.blocks DROP CONSTRAINT blocks_blocked_fkey;
ALTER TABLE IF EXISTS ONLY public.bid DROP CONSTRAINT bid_bidder_fkey;
ALTER TABLE IF EXISTS ONLY public.bid DROP CONSTRAINT bid_auctionbidded_fkey;
ALTER TABLE IF EXISTS ONLY public."user" DROP CONSTRAINT authenticated_user_city_fkey;
ALTER TABLE IF EXISTS ONLY public.auction DROP CONSTRAINT auction_responsiblemoderator_fkey;
ALTER TABLE IF EXISTS ONLY public.auction DROP CONSTRAINT auction_auctionwinner_fkey;
ALTER TABLE IF EXISTS ONLY public.auction DROP CONSTRAINT auction_auctioncreator_fkey;
ALTER TABLE IF EXISTS ONLY public.add_credits DROP CONSTRAINT add_credits_user_fkey;
DROP TRIGGER IF EXISTS IF EXISTS winner_rate_auction ON public.auction;
DROP TRIGGER IF EXISTS win_auction ON public.auction;
DROP TRIGGER IF EXISTS update_rating ON public.auction;
DROP TRIGGER IF EXISTS notification_auction ON public.auction;
DROP TRIGGER IF EXISTS delete_comment ON public.comment;
DROP TRIGGER IF EXISTS check_bid_value ON public.bid;
DROP TRIGGER IF EXISTS buy_now ON public.bid;
DROP TRIGGER IF EXISTS block_user ON public.blocks;
DROP TRIGGER IF EXISTS bidder_has_money ON public.bid;
DROP TRIGGER IF EXISTS bid_greater_than_last ON public.bid;
DROP TRIGGER IF EXISTS auction_reported ON public.report;
DROP TRIGGER IF EXISTS auction_creator ON public.bid;
DROP TRIGGER IF EXISTS add_credits_trigger ON public.add_credits;
ALTER TABLE IF EXISTS ONLY public.report DROP CONSTRAINT report_pkey;
ALTER TABLE IF EXISTS ONLY public.notification DROP CONSTRAINT notification_pkey;
ALTER TABLE IF EXISTS ONLY public.edit_moderator DROP CONSTRAINT edit_moderator_pkey;
ALTER TABLE IF EXISTS ONLY public.edit_categories DROP CONSTRAINT edit_categories_pkey;
ALTER TABLE IF EXISTS ONLY public.country DROP CONSTRAINT country_pkey;
ALTER TABLE IF EXISTS ONLY public.country DROP CONSTRAINT country_name_key;
ALTER TABLE IF EXISTS ONLY public.comment DROP CONSTRAINT comment_pkey;
ALTER TABLE IF EXISTS ONLY public.city DROP CONSTRAINT city_pkey;
ALTER TABLE IF EXISTS ONLY public.city DROP CONSTRAINT city_name_key;
ALTER TABLE IF EXISTS ONLY public.categoryofauction DROP CONSTRAINT categoryofauction_pkey;
ALTER TABLE IF EXISTS ONLY public.category DROP CONSTRAINT category_pkey;
ALTER TABLE IF EXISTS ONLY public.category DROP CONSTRAINT category_name_key;
ALTER TABLE IF EXISTS ONLY public.blocks DROP CONSTRAINT blocks_pkey;
ALTER TABLE IF EXISTS ONLY public.bid DROP CONSTRAINT bid_pkey;
ALTER TABLE IF EXISTS ONLY public."user" DROP CONSTRAINT authenticated_user_username_key;
ALTER TABLE IF EXISTS ONLY public."user" DROP CONSTRAINT authenticated_user_pkey;
ALTER TABLE IF EXISTS ONLY public."user" DROP CONSTRAINT authenticated_user_email_key;
ALTER TABLE IF EXISTS ONLY public.auction DROP CONSTRAINT auction_pkey;
ALTER TABLE IF EXISTS ONLY public.add_credits DROP CONSTRAINT add_credits_pkey;
DROP TABLE IF EXISTS public."user";
DROP TABLE IF EXISTS public.report;
DROP TABLE IF EXISTS public.notification;
DROP TABLE IF EXISTS public.edit_moderator;
DROP TABLE IF EXISTS public.edit_categories;
DROP TABLE IF EXISTS public.country;
DROP TABLE IF EXISTS public.comment;
DROP TABLE IF EXISTS public.city;
DROP TABLE IF EXISTS public.categoryofauction;
DROP TABLE IF EXISTS public.category;
DROP TABLE IF EXISTS public.blocks;
DROP TABLE IF EXISTS public.bid;
DROP SEQUENCE IF EXISTS public.auto_increment_user;
DROP SEQUENCE IF EXISTS public.auto_increment_notification;
DROP SEQUENCE IF EXISTS public.auto_increment_comment;
DROP SEQUENCE IF EXISTS public.auto_increment_city;
DROP SEQUENCE IF EXISTS public.auto_increment_category;
DROP TABLE IF EXISTS public.auction;
DROP SEQUENCE IF EXISTS public.auto_increment_auction;
DROP TABLE IF EXISTS public.add_credits;
DROP SEQUENCE IF EXISTS public.auto_increment_credits;
DROP FUNCTION IF EXISTS public.winner_rate_auction();
DROP FUNCTION IF EXISTS public.win_auction();
DROP FUNCTION IF EXISTS public.update_ratings();
DROP FUNCTION IF EXISTS public.notification_auction();
DROP FUNCTION IF EXISTS public.get_current_user();
DROP FUNCTION IF EXISTS public.delete_comment();
DROP FUNCTION IF EXISTS public.check_rejected_auction(state auctionstate, dateofrefusal timestamp with time zone, reasonofrefusal character varying);
DROP FUNCTION IF EXISTS public.check_edit_moderators(removedmod integer, removeradmin integer);
DROP FUNCTION IF EXISTS public.check_block_users(blocked integer, blocker integer);
DROP FUNCTION IF EXISTS public.check_bid_value();
DROP FUNCTION IF EXISTS public.check_auction_win(state auctionstate, finaldate timestamp with time zone, finalprice integer, auctionwinner integer);
DROP FUNCTION IF EXISTS public.check_auction_users(auctioncreator integer, auctionwinner integer, responsiblemoderator integer);
DROP FUNCTION IF EXISTS public.check_admin_modify_category(admin integer);
DROP FUNCTION IF EXISTS public.buy_now();
DROP FUNCTION IF EXISTS public.block_user();
DROP FUNCTION IF EXISTS public.bidder_has_money();
DROP FUNCTION IF EXISTS public.bid_greater_than_last();
DROP FUNCTION IF EXISTS public.auction_reported();
DROP FUNCTION IF EXISTS public.auction_creator();
DROP FUNCTION IF EXISTS public.add_credits_trigger();
DROP TYPE IF EXISTS public.typeofuser;
DROP TYPE IF EXISTS public.blockingstate;
DROP TYPE IF EXISTS public.auctionstate;
DROP SCHEMA IF EXISTS public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: lbaw1716
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO lbaw1716;

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


ALTER TYPE auctionstate OWNER TO lbaw1716;

--
-- Name: blockingstate; Type: TYPE; Schema: public; Owner: lbaw1716
--

CREATE TYPE blockingstate AS ENUM (
    'Blocked',
    'Allowed'
);


ALTER TYPE blockingstate OWNER TO lbaw1716;

--
-- Name: typeofuser; Type: TYPE; Schema: public; Owner: lbaw1716
--

CREATE TYPE typeofuser AS ENUM (
    'Moderator',
    'Administrator',
    'Normal'
);


ALTER TYPE typeofuser OWNER TO lbaw1716;

--
-- Name: add_credits_trigger(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION add_credits_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
UPDATE "user" SET balance = ((SELECT balance FROM "user" WHERE id = NEW.user) +  NEW.value) WHERE id = NEW.user;
RETURN NEW;
END;$$;


ALTER FUNCTION public.add_credits_trigger() OWNER TO lbaw1716;

--
-- Name: auction_creator(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION auction_creator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF EXISTS (SELECT * FROM auction
    INNER JOIN "user" ON "user".id = auction.auctioncreator
    WHERE NEW.auctionbidded = auction.id AND NEW.bidder = "user".id) THEN
    RAISE EXCEPTION 'The creator of an auction cannot make a bid on it!';
  END IF;
  RETURN NEW;
END;$$;


ALTER FUNCTION public.auction_creator() OWNER TO lbaw1716;

--
-- Name: auction_reported(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION auction_reported() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your auction was reported!', 'Auction Reported', NEW.auctionid, (SELECT "auctioncreator" FROM "auction" WHERE id = NEW.auctionid));
RETURN NEW;
END;$$;


ALTER FUNCTION public.auction_reported() OWNER TO lbaw1716;

--
-- Name: bid_greater_than_last(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION bid_greater_than_last() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF EXISTS (SELECT * FROM bid WHERE NEW.auctionbidded = auctionbidded AND NEW.value <= value) THEN
		RAISE EXCEPTION 'A bid on this auction has to have a greater value than a previous one on this auction.';
        ELSE
         UPDATE "user" SET balance = ((SELECT value FROM "bid" WHERE "bid".auctionBidded=NEW.auctionbidded ORDER BY value DESC LIMIT 1) + (SELECT balance FROM "user" WHERE id = (SELECT bidder FROM "bid" WHERE auctionbidded = NEW.auctionbidded ORDER BY value DESC LIMIT 1))) WHERE id = (SELECT bidder FROM "bid" WHERE auctionbidded = NEW.auctionbidded ORDER BY value DESC LIMIT 1);
        INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your bid on this auction was surpassed. Try again!', 'Bid Exceeded', NEW.auctionbidded, (SELECT bidder FROM "bid" WHERE auctionbidded = NEW.auctionbidded ORDER BY value DESC LIMIT 1));
        END IF;
	RETURN NEW;
END$$;


ALTER FUNCTION public.bid_greater_than_last() OWNER TO lbaw1716;

--
-- Name: FUNCTION bid_greater_than_last(); Type: COMMENT; Schema: public; Owner: lbaw1716
--

COMMENT ON FUNCTION bid_greater_than_last() IS '       ';


--
-- Name: bidder_has_money(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION bidder_has_money() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF EXISTS (SELECT * FROM "user" WHERE NEW.bidder = id AND NEW.value > balance)          THEN
		RAISE EXCEPTION 'To make a bid on this auction the bidder must have a balance greater than bid value';
ELSE IF EXISTS (SELECT * FROM "user" WHERE NEW.bidder = id AND NEW.value <= balance)
THEN
      UPDATE "user" SET balance = (SELECT balance FROM "user" WHERE NEW.bidder = id) - NEW.value WHERE id = NEW.bidder;
END IF;
	END IF;
	RETURN NEW;
END$$;


ALTER FUNCTION public.bidder_has_money() OWNER TO lbaw1716;

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
END;$$;


ALTER FUNCTION public.block_user() OWNER TO lbaw1716;

--
-- Name: buy_now(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION buy_now() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
IF EXISTS (SELECT * FROM "auction" WHERE NEW.auctionbidded = id AND NEW.value = buyNow AND NEW."isBuyNow" = true)
THEN
UPDATE auction SET state = 'Over'::auctionstate, finaldate = NEW.date, finalprice = NEW.value, auctionwinner = NEW.bidder WHERE id = NEW.auctionbidded;
INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'You win this auction!', 'Won Auction', NEW.auctionbidded, (SELECT bidder FROM "bid" WHERE auctionbidded = NEW.auctionbidded ORDER BY value DESC LIMIT 1));
END IF;
RETURN NEW;
END;$$;


ALTER FUNCTION public.buy_now() OWNER TO lbaw1716;

--
-- Name: check_admin_modify_category(integer); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_admin_modify_category(admin integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE passed BOOLEAN;
DECLARE adminUser TypeOfUser;
BEGIN
SELECT typeOfUser INTO adminUser FROM "User" where id = admin ;
IF
adminUser = 'Administrator'::TypeOfUser THEN passed := true; ELSE passed := false;
END IF;
RETURN passed;
END;
$$;


ALTER FUNCTION public.check_admin_modify_category(admin integer) OWNER TO lbaw1716;

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
	IF createrUser = 'Normal'::TypeOfUser AND (winnerUser = 'Normal'::TypeOfUser OR winnerUser IS NULL) AND (
responsibleUser = 'Moderator'::TypeOfUser OR responsibleUser = 'Administrator'::TypeOfUser OR responsibleUser IS NULL
)
		THEN passed := true;
		ELSE passed := false;
		END IF;
		RETURN passed;
END;$$;


ALTER FUNCTION public.check_auction_users(auctioncreator integer, auctionwinner integer, responsiblemoderator integer) OWNER TO lbaw1716;

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


ALTER FUNCTION public.check_auction_win(state auctionstate, finaldate timestamp with time zone, finalprice integer, auctionwinner integer) OWNER TO lbaw1716;

--
-- Name: check_bid_value(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_bid_value() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
IF EXISTS (SELECT * FROM "auction" WHERE NEW.auctionbidded = id AND NEW.value < startingprice)
THEN
RAISE EXCEPTION 'A Bid has to have a greater value than starting price of auction.';
END IF;
RETURN NEW;
END;$$;


ALTER FUNCTION public.check_bid_value() OWNER TO lbaw1716;

--
-- Name: check_block_users(integer, integer); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_block_users(blocked integer, blocker integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE passed BOOLEAN;
DECLARE blokedUser TypeOfUser;
DECLARE blokerUser TypeOfUser;
BEGIN
		SELECT typeOfUser INTO blokedUser FROM "User" where id = blocked ;
		SELECT typeOfUser INTO blokerUser FROM "User" where id = blocker ;
		IF blokedUser = 'Normal'::TypeOfUser AND (blokerUser = 'Administrator'::TypeOfUser OR blokerUser = 'Moderator'::TypeOfUser)
		THEN passed := true;
		ELSE passed := false;
		END IF;
RETURN passed;
END;$$;


ALTER FUNCTION public.check_block_users(blocked integer, blocker integer) OWNER TO lbaw1716;

--
-- Name: check_edit_moderators(integer, integer); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION check_edit_moderators(removedmod integer, removeradmin integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE passed boolean;
DECLARE removerModUser TypeOfUser;
DECLARE removerAdminUser TypeOfUser;
BEGIN
	SELECT typeOfUser INTO removerModUser FROM "User" where id = removedMod ;
	SELECT typeOfUser INTO removerAdminUser FROM "User" where id = removerAdmin ;
	IF removerModUser = 'Moderator'::TypeOfUser AND removerAdminUser = 'Administrator'::TypeOfUser
	THEN passed := true;
	ELSE passed := false;
	END IF;
RETURN passed;
END;$$;


ALTER FUNCTION public.check_edit_moderators(removedmod integer, removeradmin integer) OWNER TO lbaw1716;

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


ALTER FUNCTION public.check_rejected_auction(state auctionstate, dateofrefusal timestamp with time zone, reasonofrefusal character varying) OWNER TO lbaw1716;

--
-- Name: delete_comment(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--

CREATE FUNCTION delete_comment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
INSERT INTO Notification (id, date, description, type, auctionassociated, authenticated_userid) VALUES (DEFAULT, transaction_timestamp(), 'Your Comment on this auction was removed!', 'Comment Removed', OLD.auctioncommented, OLD.usercommenter);
RETURN OLD;
END;$$;


ALTER FUNCTION public.delete_comment() OWNER TO lbaw1716;

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


ALTER FUNCTION public.get_current_user() OWNER TO lbaw1716;

--
-- Name: notification_auction(); Type: FUNCTION; Schema: public; Owner: lbaw1716
--






--
-- Name: auto_increment_credits; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_credits
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auto_increment_credits OWNER TO lbaw1716;

SET default_tablespace = '';

SET default_with_oids = false;

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


ALTER TABLE add_credits OWNER TO lbaw1716;

--
-- Name: auto_increment_auction; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_auction
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auto_increment_auction OWNER TO lbaw1716;

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
    startdate timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    limitdate timestamp with time zone NOT NULL,
    refusaldate timestamp with time zone,
    "/numberOfBids" integer,
    reasonofrefusal character varying,
    finaldate timestamp with time zone,
    finalprice integer,
    rate integer,
    auctioncreator integer NOT NULL,
    auctionwinner integer,
    responsiblemoderator integer,
    CONSTRAINT auction_buynow_check CHECK ((buynow > 0)),
    CONSTRAINT auction_check CHECK ((((minimumsellingprice > startingprice) OR (minimumsellingprice = NULL::integer)) AND ((buynow > startingprice) OR (buynow = NULL::integer)))),
    CONSTRAINT auction_minimumsellingprice_check CHECK ((minimumsellingprice > 0)),
    CONSTRAINT auction_rate_check CHECK (((rate >= 0) AND (rate <= 5))),
    CONSTRAINT auction_startingprice_check CHECK ((startingprice > 0)),
    CONSTRAINT check_auction_win CHECK (check_auction_win(state, finaldate, finalprice, auctionwinner)),
    CONSTRAINT check_dates CHECK ((age(limitdate, startdate) <= '7 days'::interval)),
    CONSTRAINT check_rejected CHECK (check_rejected_auction(state, refusaldate, reasonofrefusal)),
    CONSTRAINT check_users CHECK (check_auction_users(auctioncreator, auctionwinner, responsiblemoderator))
);


ALTER TABLE auction OWNER TO lbaw1716;

--
-- Name: auto_increment_category; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_category
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auto_increment_category OWNER TO lbaw1716;

--
-- Name: auto_increment_city; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_city
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auto_increment_city OWNER TO lbaw1716;

--
-- Name: auto_increment_comment; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_comment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auto_increment_comment OWNER TO lbaw1716;

--
-- Name: auto_increment_notification; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_notification
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auto_increment_notification OWNER TO lbaw1716;

--
-- Name: auto_increment_user; Type: SEQUENCE; Schema: public; Owner: lbaw1716
--

CREATE SEQUENCE auto_increment_user
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auto_increment_user OWNER TO lbaw1716;

--
-- Name: bid; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE bid (
    date timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    value integer NOT NULL,
    auctionbidded integer NOT NULL,
    bidder integer NOT NULL,
    "isBuyNow" boolean
);


ALTER TABLE bid OWNER TO lbaw1716;

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


ALTER TABLE blocks OWNER TO lbaw1716;

--
-- Name: category; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE category (
    categoryid integer DEFAULT nextval('auto_increment_category'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    parent integer,
    CONSTRAINT check_parent_not_equal CHECK ((parent <> categoryid))
);


ALTER TABLE category OWNER TO lbaw1716;

--
-- Name: categoryofauction; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE categoryofauction (
    category integer NOT NULL,
    auction integer NOT NULL
);


ALTER TABLE categoryofauction OWNER TO lbaw1716;

--
-- Name: city; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE city (
    id integer DEFAULT nextval('auto_increment_city'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    country integer NOT NULL
);


ALTER TABLE city OWNER TO lbaw1716;

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


ALTER TABLE comment OWNER TO lbaw1716;

--
-- Name: country; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE country (
    id integer DEFAULT nextval('auto_increment_auction'::regclass) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE country OWNER TO lbaw1716;

--
-- Name: edit_categories; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE edit_categories (
    category integer NOT NULL,
    admin integer NOT NULL,
    CONSTRAINT check_admin_modify_category CHECK (check_admin_modify_category(admin))
);


ALTER TABLE edit_categories OWNER TO lbaw1716;

--
-- Name: edit_moderator; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE edit_moderator (
    removedmod integer NOT NULL,
    removeradmin integer NOT NULL,
    CONSTRAINT check_users CHECK (check_edit_moderators(removedmod, removeradmin))
);


ALTER TABLE edit_moderator OWNER TO lbaw1716;

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
    read boolean DEFAULT false
);


ALTER TABLE notification OWNER TO lbaw1716;

--
-- Name: report; Type: TABLE; Schema: public; Owner: lbaw1716; Tablespace:
--

CREATE TABLE report (
    date timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    reason character varying NOT NULL,
    auctionid integer NOT NULL,
    normaluserid integer NOT NULL
);


ALTER TABLE report OWNER TO lbaw1716;

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


ALTER TABLE "user" OWNER TO lbaw1716;

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
    ADD CONSTRAINT bid_pkey PRIMARY KEY (date, auctionbidded, bidder);


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
    ADD CONSTRAINT category_pkey PRIMARY KEY (categoryid);


--
-- Name: categoryofauction_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY categoryofauction
    ADD CONSTRAINT categoryofauction_pkey PRIMARY KEY (category, auction);


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
-- Name: notification_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: report_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1716; Tablespace:
--

ALTER TABLE IF EXISTS ONLY report
    ADD CONSTRAINT report_pkey PRIMARY KEY (auctionid, normaluserid);


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
-- Name: bidder_has_money; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER bidder_has_money BEFORE INSERT ON bid FOR EACH ROW EXECUTE PROCEDURE bidder_has_money();


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

CREATE TRIGGER notification_auction BEFORE INSERT OR UPDATE OF state ON auction FOR EACH ROW EXECUTE PROCEDURE notification_auction();


--
-- Name: update_rating; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER update_rating BEFORE INSERT OR UPDATE ON auction FOR EACH ROW EXECUTE PROCEDURE update_ratings();


--
-- Name: win_auction; Type: TRIGGER; Schema: public; Owner: lbaw1716
--

CREATE TRIGGER win_auction BEFORE UPDATE ON auction FOR EACH ROW EXECUTE PROCEDURE win_auction();


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
-- Name: bid_auctionbidded_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY bid
    ADD CONSTRAINT bid_auctionbidded_fkey FOREIGN KEY (auctionbidded) REFERENCES auction(id);


--
-- Name: bid_bidder_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY bid
    ADD CONSTRAINT bid_bidder_fkey FOREIGN KEY (bidder) REFERENCES "user"(id);


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
    ADD CONSTRAINT category_parent_fkey FOREIGN KEY (parent) REFERENCES category(categoryid);


--
-- Name: categoryofauction_auction_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY categoryofauction
    ADD CONSTRAINT categoryofauction_auction_fkey FOREIGN KEY (auction) REFERENCES auction(id);


--
-- Name: categoryofauction_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1716
--

ALTER TABLE IF EXISTS ONLY categoryofauction
    ADD CONSTRAINT categoryofauction_category_fkey FOREIGN KEY (category) REFERENCES category(categoryid);


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
    ADD CONSTRAINT edit_categories_category_fkey FOREIGN KEY (category) REFERENCES category(categoryid);


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


--
-- Name: public; Type: ACL; Schema: -; Owner: lbaw1716
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM lbaw1716;
GRANT ALL ON SCHEMA public TO lbaw1716;
