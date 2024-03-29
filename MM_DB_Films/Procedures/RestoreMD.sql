/*
 -------------------------- MM RESTORE MD PROCEDURE ---------------------------------
|                                                                                      |
| Name: RestoreMD.sql                                                                  |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   'J' :  Loads Joker backup                                              |
|               'L' :  Loads current structure with datestamp                          |
|             '0330':  Restores specific backup                                        |
|                                                                                      |
| Last modified: 2022.10.10  - v1.1 - Adding Keyword and Keywordfeature                |
|                2022.08.22  - v1.0 - TSQL migrating                                   |
|                2018.03.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.restore_md(@TP VARCHAR(5))
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_MD', @TYPE='START', @DETAIL='Start of Restore_MD procedure', 
              @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;


  DECLARE @POSTFIX VARCHAR(5), @SET_SEQ INTEGER;

  IF (UPPER(@TP)='L') 
    BEGIN
      SELECT @POSTFIX='_'+RIGHT(SEL_1.NAME,4) 
	  	FROM (SELECT TOP 1 NAME from SYS.TABLES where SCHEMA_NAME(SCHEMA_ID)='BCKP' AND UPPER(NAME) LIKE 'ACTOR%' ORDER BY 1 DESC) SEL_1;
	  IF ISNUMERIC(RIGHT(@POSTFIX,4))=0 
	  	BEGIN
		  	EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_MD', @TYPE='START', @DETAIL='No datestamped backup table was found', 
              @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;
			RETURN 0;
		END		
    END
	
  IF (UPPER(@TP)='J') 
    BEGIN
	  SET @POSTFIX='';
	  IF NOT EXISTS(SELECT * from SYS.TABLES where SCHEMA_NAME(SCHEMA_ID)='BCKP' AND UPPER(NAME) LIKE 'ACTOR')
	  	BEGIN
        EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_MD', @TYPE='START', @DETAIL='No backup table was found without datestamp', 
              @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;
			RETURN 0;
		END		
    END

  IF ((UPPER(@TP)!='J' AND UPPER(@TP)!='L' AND UPPER(@TP)!='')) 
    BEGIN
    PRINT 'da';
      PRINT @TP;
       PRINT 'da2';
      SELECT @POSTFIX='_'+RIGHT(NAME,4) from SYS.TABLES where SCHEMA_NAME(SCHEMA_ID)='BCKP' AND UPPER(NAME) LIKE 'ACTOR_'+@TP
	  IF ISNUMERIC(RIGHT(@POSTFIX,4))=0
	  	BEGIN
		    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_MD', @TYPE='START', @DETAIL='No backup table was found with the desired datestamp', 
              @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;
			RETURN 0;
		END		
    END

  EXEC ('TRUNCATE TABLE MOVIEDATA.ACTOR; INSERT INTO MOVIEDATA.ACTOR SELECT * FROM BCKP.ACTOR'+@POSTFIX);

  EXEC ('TRUNCATE TABLE MOVIEDATA.DIRECTOR; INSERT INTO MOVIEDATA.DIRECTOR SELECT * FROM BCKP.DIRECTOR'+@POSTFIX);

  EXEC ('TRUNCATE TABLE MOVIEDATA.WRITER; INSERT INTO MOVIEDATA.WRITER SELECT * FROM BCKP.WRITER'+@POSTFIX);

  EXEC ('TRUNCATE TABLE MOVIEDATA.GENRE; INSERT INTO MOVIEDATA.GENRE SELECT * FROM BCKP.GENRE'+@POSTFIX);

  EXEC ('TRUNCATE TABLE MOVIEDATA.MOVIE; INSERT INTO MOVIEDATA.MOVIE SELECT * FROM BCKP.MOVIE'+@POSTFIX);

  EXEC ('TRUNCATE TABLE MOVIEDATA.MOVIEFEATURE; INSERT INTO MOVIEDATA.MOVIEFEATURE SELECT * FROM BCKP.MOVIEFEATURE'+@POSTFIX);

  EXEC ('TRUNCATE TABLE MOVIEDATA.COUNTRY; INSERT INTO MOVIEDATA.COUNTRY SELECT * FROM BCKP.COUNTRY'+@POSTFIX);
  /* So v1.1 */
  EXEC ('TRUNCATE TABLE MOVIEDATA.KEYWORD; INSERT INTO MOVIEDATA.KEYWORD SELECT * FROM BCKP.KEYWORD'+@POSTFIX);

  EXEC ('TRUNCATE TABLE MOVIEDATA.KEYWORDFEATURE; INSERT INTO MOVIEDATA.KEYWORDFEATURE SELECT * FROM BCKP.KEYWORDFEATURE'+@POSTFIX);
  /* Eo v1.1 */
  SELECT @SET_SEQ=MAX(ACTOR_ID) FROM MOVIEDATA.ACTOR;
  SET @SET_SEQ=COALESCE(@SET_SEQ, 0);
  EXEC ('ALTER SEQUENCE MOVIEDATA.SEQ_ACTOR_ID RESTART WITH '+@SET_SEQ);

  SELECT @SET_SEQ=MAX(DIRECTOR_ID) FROM MOVIEDATA.DIRECTOR;
  SET @SET_SEQ=COALESCE(@SET_SEQ, 0);
  EXEC ('ALTER SEQUENCE MOVIEDATA.SEQ_DIRECTOR_ID RESTART WITH '+@SET_SEQ);

  SELECT @SET_SEQ=MAX(WRITER_ID) FROM MOVIEDATA.WRITER;
  SET @SET_SEQ=COALESCE(@SET_SEQ, 0);
  EXEC ('ALTER SEQUENCE MOVIEDATA.SEQ_WRITER_ID RESTART WITH '+@SET_SEQ);

  SELECT @SET_SEQ=MAX(GENRE_ID) FROM MOVIEDATA.GENRE;
  SET @SET_SEQ=COALESCE(@SET_SEQ, 0);
  EXEC ('ALTER SEQUENCE MOVIEDATA.SEQ_GENRE_ID RESTART WITH '+@SET_SEQ);

  SELECT @SET_SEQ=MAX(CAST(RIGHT(MOVIE_ID,6) as INTEGER)) FROM MOVIEDATA.MOVIE;
  SET @SET_SEQ=COALESCE(CAST(RIGHT(@SET_SEQ, 7) AS INTEGER), 0);
  EXEC ('ALTER SEQUENCE MOVIEDATA.SEQ_MOVIE_ID RESTART WITH '+@SET_SEQ);

  SELECT @SET_SEQ=MAX(CAST(RIGHT(MOVIE_FEATURE_ID,7) as INTEGER)) FROM MOVIEDATA.MOVIEFEATURE;
  SET @SET_SEQ=COALESCE(CAST(RIGHT(@SET_SEQ, 8) AS INTEGER), 0);
  EXEC ('ALTER SEQUENCE MOVIEDATA.SEQ_MOVIEFEATURE_ID RESTART WITH '+@SET_SEQ);

  SELECT @SET_SEQ=MAX(COUNTRY_ID) FROM MOVIEDATA.COUNTRY;
  SET @SET_SEQ=COALESCE(@SET_SEQ, 0);
  EXEC ('ALTER SEQUENCE MOVIEDATA.SEQ_COUNTRY_ID RESTART WITH '+@SET_SEQ);
  /* So v1.1 */
  SELECT @SET_SEQ=MAX(KEYWORD_ID) FROM MOVIEDATA.KEYWORD;
  SET @SET_SEQ=COALESCE(@SET_SEQ, 0);
  EXEC ('ALTER SEQUENCE MOVIEDATA.SEQ_KEYWORD_ID RESTART WITH '+@SET_SEQ);

  SELECT @SET_SEQ=MAX(KEYWORD_FEATURE_ID) FROM MOVIEDATA.KEYWORDFEATURE;
  SET @SET_SEQ=COALESCE(@SET_SEQ, 0);
  EXEC ('ALTER SEQUENCE MOVIEDATA.SEQ_KEYWORDFEATURE_ID RESTART WITH '+@SET_SEQ);
   /* Eo v1.1 */
 EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_MD', @TYPE='END', @DETAIL='End of Restore_MD with parameter';
RETURN 1;
END

/*


declare @returnparam varchar(5);
exec @returnparam=control.restore_md @TP='0320';
select @returnparam;



select * from bckp.ACTOR_0320


select * from MOVIEDATA.MOVIE 
 
SELECT * FROM LOG.PROCESS ORDER BY RUN_DTTM DESC

*/