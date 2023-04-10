/*
 ---------------------------------- MM BACKUP STAGE PROCEDURE ----------------------------------
|                                                                                               |
| Name: BackupSTAGE.sql                                                                         |
| Created: Akos Ujvary                                                                          |
|                                                                                               |
| Parameters:   'J' :  Creates Joker backup                                                     |
|               'L' :  Saves current structure with datestamp                                   |
|               'C' :  Current data                                                             |
|                                                                                               |
| Last modified: 2022.12.12   Adding LOAD_TYPE field                                            |
|                2022.11.20   Adding Release_Date field                                         |                      
|                2022.11.10   Set _CURR for current stage.moviedata (original always truncated) |
|                2022.11.09   Leave out LOAD_ID column from backup process                      |
|                2022.08.22   TSQL migrating                                                    |
|                2017.11.30   Creation (PostgreSQL)                                             |
 -----------------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.backup_stage(@TP CHAR)
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'BACKUP_STAGE';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of Backup STAGE procedure', @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;

  DECLARE @POSTFIX VARCHAR(5);

  IF (UPPER(@TP)='L') 
    BEGIN
      SET @POSTFIX =  '_'+right(convert(varchar,getdate(),112),4); 	 
    END
  IF (UPPER(@TP)='J') 
    BEGIN
      SET @POSTFIX =  ''; 	 
    END
  IF (UPPER(@TP)='C') 
    BEGIN
      SET @POSTFIX =  '_CURR'; 	 
    END
    
  IF (@TP ='L' or @TP='J' or @TP='C')  
  BEGIN
    IF EXISTS (SELECT * FROM SYS.TABLES WHERE TYPE_DESC = 'USER_TABLE' AND NAME  = 'MOVIEDATA'+@POSTFIX+'' AND UPPER(SCHEMA_NAME(SCHEMA_ID))='BCKP')
      BEGIN
        EXEC ('DROP TABLE BCKP.MOVIEDATA'+@POSTFIX);			
      END
    EXEC ('SELECT 
              LOAD_TYPE,
              IMDB_ID,
              TITLE,
              TITLE_ALT,
              RELEASE_YEAR,
              GENRES,
              COUNTRY,
              ACTORS,
              DIRECTORS,
              WRITERS,
              IMDB_RATING,
              IMDB_VOTES,
              METASCORE,
              TOMATOMETER,
              TOMATO_USER_METER,
              TOMATO_USER_REVIEWS,
              RELEASE_DATE,
              KEYWORDS,
              RUNTIME,
              PLOT,
              AWARDS,
              POSTER
     INTO BCKP.MOVIEDATA'+@POSTFIX+' FROM STAGE.MOVIEDATA');		
    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of Backup STAGE procedure';
    RETURN 1;
  END

  EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='ERROR', @DETAIL='Error during process', @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;

  RETURN 0;
END
--------------------------------------------------- End of code ---------------------------------------------------------
/*
TEST:

declare @returnparam smallint;
exec @returnparam=control.backup_stage @tp='L';
select @returnparam;

SELECT * FROM SYS.TABLES WHERE TYPE_DESC = 'USER_TABLE' AND UPPER(SCHEMA_NAME(SCHEMA_ID))='BCKP'

*/

 
 

 
 
 
 
