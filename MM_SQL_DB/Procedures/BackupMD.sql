/*
 --------------------------- MM BACKUP MD PROCEDURE -----------------------------------
|                                                                                      |
| Name: BackupMD.sql                                                                   |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   'J' :  Creates Joker backup                                            |
|               'L' :  Saves current structure with datestamp                          |
|                                                                                      |
| Last modified: 2022.10.10  - v1.1 -  Adding Keyword and Keywordfeature migrating     |
|                2022.08.22  - v1.0 -  TSQL migrating                                  |
|                2018.03.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 
 

CREATE OR ALTER PROCEDURE control.backup_md(@TP CHAR)
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'BACKUP_MD';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of Backup MD procedure', @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;



DECLARE @POSTFIX VARCHAR(5);

 IF (UPPER(@TP)='L') 
	BEGIN
     SET @POSTFIX =  '_'+right(convert(varchar,getdate(),112),4); 	 
	 END
 IF (UPPER(@TP)='J') 
	BEGIN
     SET @POSTFIX =  ''; 	 
	 END

	
IF (@TP ='L' or @TP='J')  
BEGIN
	IF EXISTS (SELECT * FROM SYS.TABLES WHERE TYPE_DESC = 'USER_TABLE' AND NAME  = 'ACTOR'+@POSTFIX+'' AND UPPER(SCHEMA_NAME(SCHEMA_ID))='BCKP')
		BEGIN
			EXEC ('DROP TABLE BCKP.ACTOR'+@POSTFIX);			
			EXEC ('DROP TABLE BCKP.COUNTRY'+@POSTFIX);
			EXEC ('DROP TABLE BCKP.DIRECTOR'+@POSTFIX);
			EXEC ('DROP TABLE BCKP.MOVIE'+@POSTFIX);
			EXEC ('DROP TABLE BCKP.MOVIEFEATURE'+@POSTFIX);
			EXEC ('DROP TABLE BCKP.WRITER'+@POSTFIX);
			EXEC ('DROP TABLE BCKP.GENRE'+@POSTFIX);
			/* So v1.1 */
			EXEC ('DROP TABLE BCKP.KEYWORD'+@POSTFIX);
			EXEC ('DROP TABLE BCKP.KEYWORDFEATURE'+@POSTFIX);
			/* Eo v1.1 */
		END
	EXEC ('SELECT * INTO BCKP.ACTOR'+@POSTFIX+' FROM MOVIEDATA.ACTOR');	
	EXEC ('SELECT * INTO BCKP.COUNTRY'+@POSTFIX+' FROM MOVIEDATA.COUNTRY');	
	EXEC ('SELECT * INTO BCKP.DIRECTOR'+@POSTFIX+' FROM MOVIEDATA.DIRECTOR');	
	EXEC ('SELECT * INTO BCKP.MOVIE'+@POSTFIX+' FROM MOVIEDATA.MOVIE');	
	EXEC ('SELECT * INTO BCKP.MOVIEFEATURE'+@POSTFIX+' FROM MOVIEDATA.MOVIEFEATURE');	
	EXEC ('SELECT * INTO BCKP.WRITER'+@POSTFIX+' FROM MOVIEDATA.WRITER');	
	EXEC ('SELECT * INTO BCKP.GENRE'+@POSTFIX+' FROM MOVIEDATA.GENRE');	
	/* So v1.1 */
	EXEC ('SELECT * INTO BCKP.KEYWORD'+@POSTFIX+' FROM MOVIEDATA.KEYWORD');	
	EXEC ('SELECT * INTO BCKP.KEYWORDFEATURE'+@POSTFIX+' FROM MOVIEDATA.KEYWORDFEATURE');	
	/* Eo v1.1 */

	EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of Backup MD procedure';

	RETURN 1;
END

EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='ERROR', @DETAIL='Error during process', @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;

RETURN 0;

END
--------------------------------------------------- End of code ---------------------------------------------------------
/*
TEST:

declare @returnparam smallint;
exec @returnparam=control.backup_md @tp='L';
select @returnparam;

SELECT * FROM SYS.TABLES WHERE TYPE_DESC = 'USER_TABLE' AND UPPER(SCHEMA_NAME(SCHEMA_ID))='BCKP'
 
*/

 
 
 
 
