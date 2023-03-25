/*
 -------------------------- MM RESET MD TABLES PROCEDURE ------------------------------
|                                                                                      |
| Name: ResetMDTables.sql                                                              |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   No Parameters.                                                         |
|                                                                                      |
| Last modified: 2023.01.05 - v1.2 - Adding MOVIEDATA.ARCHIVED_MOVIES                  |
|                2022.10.10 - v1.1 - Adding Keyword and Keywordfeature                 |
|                2022.08.24 - v1.0 - TSQL migrating                                    |
|                2018.01.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.reset_md_tables
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'RESET_MD_TABLES';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of Reset_MD_tables procedure';

ALTER SEQUENCE MOVIEDATA.SEQ_ACTOR_ID RESTART WITH 1;
ALTER SEQUENCE MOVIEDATA.SEQ_WRITER_ID RESTART WITH 1;
ALTER SEQUENCE MOVIEDATA.SEQ_MOVIE_ID RESTART WITH 1;
ALTER SEQUENCE MOVIEDATA.SEQ_MOVIEFEATURE_ID RESTART WITH 1;
ALTER SEQUENCE MOVIEDATA.SEQ_GENRE_ID RESTART WITH 1;
ALTER SEQUENCE MOVIEDATA.SEQ_COUNTRY_ID RESTART WITH 1;
ALTER SEQUENCE MOVIEDATA.SEQ_DIRECTOR_ID RESTART WITH 1;
/* So v1.1 */
ALTER SEQUENCE MOVIEDATA.SEQ_KEYWORD_ID RESTART WITH 1;
ALTER SEQUENCE MOVIEDATA.SEQ_KEYWORDFEATURE_ID RESTART WITH 1;
/* Eo v1.1 */
TRUNCATE TABLE MOVIEDATA.ACTOR;
TRUNCATE TABLE MOVIEDATA.WRITER;
TRUNCATE TABLE MOVIEDATA.MOVIE;
TRUNCATE TABLE MOVIEDATA.GENRE;
TRUNCATE TABLE MOVIEDATA.MOVIEFEATURE;
TRUNCATE TABLE MOVIEDATA.COUNTRY;
TRUNCATE TABLE MOVIEDATA.DIRECTOR;
TRUNCATE TABLE MOVIEDATA.KEYWORD;
TRUNCATE TABLE MOVIEDATA.KEYWORDFEATURE;
/* So v1.2 */
TRUNCATE TABLE MOVIEDATA.ARCHIVED_MOVIES
/* Eo v1.2 */

EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of Reset_MD_tables procedure';

RETURN 1;
END

/*

declare @returnparam varchar(5);
exec @returnparam=control.reset_md_tables;
select @returnparam;

select * from log.process


select * from stage.TMP_NODUPL_MOVIEDATA
*/

 
select * from stage.MOVIEDATA 


insert into stage.TMP_NODUPL_MOVIEDATA
select replace(title_alt, '\"', '"')  from stage.moviedata

delete from stage.moviedata where load_id != 10

select * from bckp.moviedata_curr where imdb_id ='tt0032186'



EXEC CONTROL.LOADMOVIEDATA;