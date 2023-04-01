/*
 ------------------------------------------- MM CREATE TABLE SCRIPT --------------------------------------------
|                                                                                                               |
| Name: GenStageAndMovieData.sql                                                                                |
| Created: Akos Ujvary                                                                                          |
| Last modified: 2023.04.01 - V1.8 - Adding STAGE.HUN_NAMES_FIX                                                 |
|                2023.03.20 - v1.7 - Change all CARCHAR to NVARCHAR                                             |
|                2022.12.28 - v1.6 - Changing table from DUPL to NODUPL, add MOVIEDATA.ARCHIVED_MOVIES          |                                     |
|                2022.12.01 - v1.5 - Adding LOAD_TYPE field to STAGE.MOVIEDATA                                  |
|                2022.11.21 - v1.4 - Adding RUN_DTTM to MOVIEDATA.MOVIE                                         |
|                2022.11.20 - v1.3 - Addig Release Date                                                         |
|                2022.11.09 - v1.2 - Modify STAGE.MOVIEDATA: adding LOAD_ID for Azure Function DB LOADER        |
|                2022.10.10 - v1.1 - Adding keywords, runtime, plot, awards, poster                             |
|                2022.08.10 - v1.0 - Migrating to Mssql                                                         |
|                2017.01.30 - Creation                                                                          |
 ---------------------------------------------------------------------------------------------------------------
*/
 
---------------------- STAGE ----------------------------------------------------
 
DROP TABLE IF EXISTS STAGE.MOVIEDATA;
CREATE TABLE STAGE.MOVIEDATA
(
    LOAD_ID INT IDENTITY PRIMARY KEY,
    LOAD_TYPE NVARCHAR(6), 
    IMDB_ID NVARCHAR(1000),
    TITLE NVARCHAR(1000),
    TITLE_ALT NVARCHAR(1000),
    RELEASE_YEAR NVARCHAR(1000),  
    GENRES NVARCHAR(1000),
    COUNTRY NVARCHAR(1000),
    ACTORS NVARCHAR(1000),
    DIRECTORS NVARCHAR(1000),
    WRITERS NVARCHAR(1000),
    IMDB_RATING NVARCHAR(1000),
    IMDB_VOTES NVARCHAR(1000), 
    METASCORE NVARCHAR(1000),
    TOMATOMETER NVARCHAR(1000),
    TOMATO_USER_METER NVARCHAR(1000),
    TOMATO_USER_REVIEWS NVARCHAR(1000),
    RELEASE_DATE NVARCHAR(1000),
    KEYWORDS NVARCHAR(1000),
    RUNTIME NVARCHAR(1000), 
    PLOT NVARCHAR(1000),
    AWARDS NVARCHAR(1000),
    POSTER NVARCHAR(1000)
);
 
 
DROP TABLE IF EXISTS STAGE.TMP_MOVIEDATA;
CREATE TABLE STAGE.TMP_MOVIEDATA
(
    IMDB_ID NVARCHAR(1000),
    TITLE NVARCHAR(1000),
    TITLE_ALT NVARCHAR(1000),
    RELEASE_YEAR NVARCHAR(1000),  
    GENRES NVARCHAR(1000),
    COUNTRY NVARCHAR(1000),
    ACTORS NVARCHAR(1000),
    DIRECTORS NVARCHAR(1000),
    WRITERS NVARCHAR(1000),
    IMDB_RATING NVARCHAR(1000),
    IMDB_VOTES NVARCHAR(1000), 
    METASCORE NVARCHAR(1000),
    TOMATOMETER NVARCHAR(1000),
    TOMATO_USER_METER NVARCHAR(1000),
    TOMATO_USER_REVIEWS NVARCHAR(1000),
    RELEASE_DATE NVARCHAR(1000),
    KEYWORDS NVARCHAR(1000),
    RUNTIME NVARCHAR(1000), 
    PLOT NVARCHAR(1000),
    AWARDS NVARCHAR(1000),
    POSTER NVARCHAR(1000)  
);

DROP TABLE IF EXISTS STAGE.TMP_NODUPL_MOVIEDATA;
CREATE TABLE STAGE.TMP_NODUPL_MOVIEDATA
(
    IMDB_ID NVARCHAR(1000),
    TITLE NVARCHAR(1000),
    TITLE_ALT NVARCHAR(1000),
    RELEASE_YEAR NVARCHAR(1000),  
    GENRES NVARCHAR(1000),
    COUNTRY NVARCHAR(1000),
    ACTORS NVARCHAR(1000),
    DIRECTORS NVARCHAR(1000),
    WRITERS NVARCHAR(1000),
    IMDB_RATING NVARCHAR(1000),
    IMDB_VOTES NVARCHAR(1000), 
    METASCORE NVARCHAR(1000),
    TOMATOMETER NVARCHAR(1000),
    TOMATO_USER_METER NVARCHAR(1000),
    TOMATO_USER_REVIEWS NVARCHAR(1000),
    RELEASE_DATE NVARCHAR(1000),
    KEYWORDS NVARCHAR(1000),
    RUNTIME NVARCHAR(1000), 
    PLOT NVARCHAR(1000),
    AWARDS NVARCHAR(1000),
    POSTER NVARCHAR(1000)   
);

DROP TABLE IF EXISTS STAGE.HUN_NAMES_FIX;
CREATE TABLE STAGE.HUN_NAMES_FIX
(
    PR_ID NVARCHAR(10), 
    IMDB_ID NVARCHAR(1000),
    TYPE NVARCHAR(1),
    FIXED_NAMES NVARCHAR(1000),
);

---------------------- MOVIEDATA -------------------------------------------------

DROP TABLE IF EXISTS MOVIEDATA.ARCHIVED_MOVIES;
CREATE TABLE MOVIEDATA.ARCHIVED_MOVIES
(
    PR_ID NVARCHAR(10), 
    MOVIE_ID NVARCHAR(10),
    IMDB_ID NVARCHAR(10)
);

DROP TABLE IF EXISTS MOVIEDATA.MOVIEFEATURE;
CREATE TABLE MOVIEDATA.MOVIEFEATURE
(
    MOVIE_FEATURE_ID NVARCHAR(20) primary key,
    MOVIE_ID NVARCHAR(10),
    FEATURE_CD CHAR(1),
    FEATURE_ID NUMERIC(5)
);

DROP TABLE IF EXISTS MOVIEDATA.MOVIE;
CREATE TABLE MOVIEDATA.MOVIE
(    
    MOVIE_ID NVARCHAR(10) primary key,  
    IMDB_ID NVARCHAR(10)  not null,
    TITLE_NM NVARCHAR(150) not null,
    TITLE_ALT_NM NVARCHAR(150),
    RELEASE_YEAR NUMERIC(4) not null,
    IMDB_RATING NUMERIC(3,1) not null,
    IMDB_VOTES NUMERIC(7) not null,
    METASCORE NUMERIC(3),
    TOMATOMETER NUMERIC(3),
    TOMATO_USER_METER NUMERIC(3),
    TOMATO_USER_REVIEWS NUMERIC(8),
    RELEASE_DATE DATE,
    RUNTIME NVARCHAR(50),
    PLOT NVARCHAR(1000),
    AWARDS NVARCHAR(100),
    POSTER NVARCHAR(1000),
    RUN_DTTM DATETIME
);


DROP TABLE IF EXISTS MOVIEDATA.GENRE;
CREATE TABLE MOVIEDATA.GENRE
(
    GENRE_ID NUMERIC(2) primary key,
    GENRE_NM NVARCHAR(30)
);

DROP TABLE IF EXISTS MOVIEDATA.COUNTRY;
CREATE TABLE MOVIEDATA.COUNTRY
(
    COUNTRY_ID NUMERIC(3) primary key,
    COUNTRY_NM NVARCHAR(50)
);

DROP TABLE IF EXISTS MOVIEDATA.ACTOR;
CREATE TABLE MOVIEDATA.ACTOR
(
    ACTOR_ID NUMERIC(7) primary key,
    ACTOR_NM NVARCHAR(100)  
);

DROP TABLE IF EXISTS MOVIEDATA.DIRECTOR;
CREATE TABLE MOVIEDATA.DIRECTOR
(
    DIRECTOR_ID NUMERIC(6) primary key,
    DIRECTOR_NM NVARCHAR(100)
);

DROP TABLE IF EXISTS MOVIEDATA.WRITER;
CREATE TABLE MOVIEDATA.WRITER
(
    WRITER_ID NUMERIC(6) primary key,
    WRITER_NM NVARCHAR(100)
);

DROP TABLE IF EXISTS MOVIEDATA.REF_FEATURE;
CREATE TABLE MOVIEDATA.REF_FEATURE
(
    FEATURE_CD CHAR(1) primary key,
    FEATURE_DESC NVARCHAR(20)    
);

DROP TABLE IF EXISTS GENERAL.PARAMETER;
CREATE TABLE GENERAL.PARAMETER
(
    PARAMETER_ID CHAR(6) primary key,
    PARAMETER_NM NVARCHAR(32),
    PARAMETER_CD NVARCHAR(32)
);

/* So v1.1 */
DROP TABLE IF EXISTS MOVIEDATA.KEYWORDFEATURE;   
CREATE TABLE MOVIEDATA.KEYWORDFEATURE
(
    KEYWORD_FEATURE_ID INT primary key,
    MOVIE_ID NVARCHAR(10),
    KEYWORD_ID INT   
);

DROP TABLE IF EXISTS MOVIEDATA.KEYWORD;   
CREATE TABLE MOVIEDATA.KEYWORD
(
    KEYWORD_ID INT primary key,
    KEYWORD_NM NVARCHAR(100) 
);

/* Eo v1.1 */
 
---------------------- End of code -------------------------------------------------