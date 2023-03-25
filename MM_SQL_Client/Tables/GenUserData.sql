/*
 ---------- MM CREATE TABLE SCRIPT ---------------
|                                                 |
| Name: GenUserData.sql                           |
| Created: �kos Ujv�ry                            |
| Last modified: 2017.11.05                       |
 -------------------------------------------------
*/

---------------------- USERDATA ----------------------------------------------------
DROP TABLE IF EXISTS USERDATA.USERFEATURE; 
CREATE TABLE USERDATA.USERFEATURE 
(    
    USER_ID VARCHAR(10) not null,    
    FEATURE_CD CHAR(1) not null,
    FEATURE_ID NUMERIC(6) not null,    
    SCORE NUMERIC(5)
);

DROP TABLE IF EXISTS USERDATA.USR;
CREATE TABLE USERDATA.USR
(
    USER_ID VARCHAR(10) primary key,
    USER_NM VARCHAR(100),
    USER_PW VARBINARY(200)
);

DROP TABLE IF EXISTS USERDATA.RATING; 
CREATE TABLE USERDATA.RATING
(
   RATING_ID CHAR(10) primary key,
   USER_ID VARCHAR(10) not null,
   MOVIE_ID CHAR(10) not null,   
   RATING NUMERIC(3),
   RATING_DTTM DATETIME 
);
 
DROP TABLE IF EXISTS USERDATA.TMP_REC_CB;
CREATE TABLE USERDATA.TMP_REC_CB(
	[USER_ID] [varchar](9) NOT NULL,
	[TITLE_NM] [varchar](150) NULL,
	[IMDB_ID] [varchar](10) NULL,
	[MOVIE_ID] [varchar](10) NULL,
	[COUNTRY_ID] [varchar](6) NULL,
	[COUNTRY_FLG] [varchar](1) NOT NULL,
	[SUM_SCORE_ACTOR] [numeric](38, 0) NULL,
	[SUM_SCORE_DIRECTOR] [numeric](38, 0) NULL,
	[SUM_SCORE_WRITER] [numeric](38, 0) NULL,
	[SUM_SCORE_GENRE] [numeric](38, 0) NULL,
	[SUM_SCORE_COUNTRY] [numeric](38, 0) NULL,
	[FEATURE_SCORE_ORIG] [numeric](38, 0) NULL,
	[FEATURE_SCORE] [numeric](5, 0) NULL,
	[BIAS_RATING_SCORE] [numeric](4, 0) NULL,
	[BIAS_YEAR_SCORE] [numeric](4, 0) NULL,
	[BIAS_VOTES_SCORE] [numeric](4, 0) NULL,
	[BIASED_FEATURE_SCORE] [numeric](8, 0) NULL
);

DROP TABLE IF EXISTS USERDATA.RECOMMENDATION;
CREATE TABLE USERDATA.RECOMMENDATION
(
   REC_ID CHAR(10) primary key,
   USER_ID CHAR(10) not null,
   MOVIE_ID CHAR(10) not null,   
   IMDB_ID VARCHAR(9) not null,
   REC_TYPE VARCHAR(9) not null,
   REC_SCORE NUMERIC not null, 
   REC_DTTM DATETIME 
);
 


---------------------- End of code -------------------------------------------------

