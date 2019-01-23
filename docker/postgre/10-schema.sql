
CREATE TABLE "USERS"
(
   "ID" SERIAL,
   "USER_NAME" character varying(30) NOT NULL,
   "LOGIN" character varying(30),
   "PASSWORD" character varying(30),
   "BOT_NAME" character varying(30),
    "PHONE" character varying(30),
   "TOKEN" character(32) NOT NULL,
   "EMAIL" character varying(200) NOT NULL,
   PRIMARY KEY ("ID")
);

CREATE TABLE "AUTHORITIES" (
  "USER_ID" integer NOT NULL,
  "AUTHORITY" varchar(20) NOT NULL,
  PRIMARY KEY ("USER_ID","AUTHORITY"),
  CONSTRAINT "USER_ID" FOREIGN KEY ("USER_ID") REFERENCES "USERS" ("ID") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "GAME_STATISTICS" (
  "GAME_ID" bigint NOT NULL,
  "TITLE" varchar(200) NOT NULL,
  "TYPE" varchar(30) DEFAULT NULL,
  "DESCRIPTION" text DEFAULT NULL,
  "WINNER_ID" integer DEFAULT NULL,
  "BOT_NAME" varchar(30) DEFAULT NULL,
  "NUMBER_OF_TURNS" bigint DEFAULT NULL,
  "LOG_PATH" varchar(200) DEFAULT NULL,
  "STATE" varchar(20) NOT NULL,
  PRIMARY KEY ("GAME_ID")
);

CREATE TABLE "PLAYERS" (
  "USER_ID" integer NOT NULL,
  "GAME_ID" bigint NOT NULL,
  PRIMARY KEY ("USER_ID","GAME_ID"),
  CONSTRAINT "USR_ID" FOREIGN KEY ("USER_ID") REFERENCES "USERS" ("ID") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "GAME_ID" FOREIGN KEY ("GAME_ID") REFERENCES "GAME_STATISTICS" ("GAME_ID") ON DELETE NO ACTION ON UPDATE NO ACTION
);


--   3.08  Add game's creator support (needed for user tournaments)

ALTER TABLE "GAME_STATISTICS"
   ADD COLUMN "CREATOR_ID" bigint DEFAULT NULL;
ALTER TABLE "GAME_STATISTICS"
  ADD CONSTRAINT "GAME_CREATOR_ID_PK" FOREIGN KEY ("CREATOR_ID") REFERENCES "USERS" ("ID")
   ON UPDATE NO ACTION ON DELETE NO ACTION;
CREATE INDEX "fki_GAME_CREATOR_ID_PK"
  ON "GAME_STATISTICS"("CREATOR_ID");



CREATE TABLE "GAME_SESSION_STATISTICS" (
  "CREATOR_ID" BIGINT DEFAULT NULL,
  "GAME_ID" BIGINT NOT NULL,
  "USER_ID" BIGINT NOT NULL,
  "UNIT_COUNT" BIGINT,
  "NUMBER_OF_TURNS" BIGINT DEFAULT NULL,
  PRIMARY KEY ("USER_ID","GAME_ID")
);

ALTER TABLE "GAME_STATISTICS"
ADD COLUMN "TIME_CREATED" TIMESTAMP DEFAULT NULL;

ALTER TABLE "GAME_SESSION_STATISTICS"
    ADD COLUMN "PLACE" INTEGER ;

ALTER TABLE "GAME_SESSION_STATISTICS"
    ADD COLUMN "BOT_NAME" character varying(30) ;

ALTER TABLE "GAME_SESSION_STATISTICS"
ADD COLUMN "EMAIL" character varying(200);

ALTER TABLE "GAME_SESSION_STATISTICS"
ADD COLUMN "TYPE" varchar(30) DEFAULT NULL;