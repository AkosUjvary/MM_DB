/*
 -------------------------- MM RESTORE STAGE PROCEDURE --------------------------------
|                                                                                      |
| Name: RestoreSTAGE.sql                                                               |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   'J' :  Restores Joker backup (no postfix)                              |
|               'L' :  Restores last datestamped data                                  |
|             '0330':  Restores specific backup                                        |
|               'C' :  Restores current backup                                         |
|                                                                                      |
| Last modified: 2022.11.10   Using "C" parameter as restoring current data            |
|                2022.08.24   TSQL migrating                                           |
|                2018.03.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.restore_stage(@TP CHAR)
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_STAGE', @TYPE='START', @DETAIL='Start of Restore_STAGE procedure', 
              @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;


  DECLARE @POSTFIX VARCHAR(5), @SET_SEQ INTEGER;

  IF (UPPER(@TP)='L') 
    BEGIN
      SELECT @POSTFIX='_'+RIGHT(SEL_1.NAME,4) 
	  	FROM (SELECT TOP 1 NAME from SYS.TABLES where SCHEMA_NAME(SCHEMA_ID)='BCKP' AND UPPER(NAME) LIKE 'MOVIEDATA%' AND UPPER(NAME) !='MOVIEDATA_CURR' ORDER BY 1 DESC) SEL_1;
	  IF ISNUMERIC(RIGHT(@POSTFIX,4))=0 
	  	BEGIN
		  	EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_STAGE', @TYPE='START', @DETAIL='No datestamped backup table was found', 
              @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;
			RETURN 0;
		END		
    END
	
  IF (UPPER(@TP)='J') 
    BEGIN
	  SET @POSTFIX='';
	  IF NOT EXISTS(SELECT * from SYS.TABLES where SCHEMA_NAME(SCHEMA_ID)='BCKP' AND UPPER(NAME) LIKE 'MOVIEDATA')
	  	BEGIN
        EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_STAGE', @TYPE='START', @DETAIL='No backup table was found without datestamp', 
              @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;
			RETURN 0;
		END		
    END

  IF (UPPER(@TP)='C') 
    BEGIN
	  SET @POSTFIX='_CURR';
	  IF NOT EXISTS(SELECT * from SYS.TABLES where SCHEMA_NAME(SCHEMA_ID)='BCKP' AND UPPER(NAME) = 'MOVIEDATA'+@POSTFIX)
	  	BEGIN
        EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_STAGE', @TYPE='START', @DETAIL='No "current" table was found', 
              @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;
			RETURN 0;
		END		
    END

  IF ((UPPER(@TP)!='J' AND UPPER(@TP)!='L' AND UPPER(@TP)!='' AND UPPER(@TP)!='C')) 
    BEGIN
      SELECT @POSTFIX='_'+RIGHT(NAME,4) from SYS.TABLES where SCHEMA_NAME(SCHEMA_ID)='BCKP' AND UPPER(NAME) LIKE 'MOVIEDATA_'+@TP
	  IF ISNUMERIC(RIGHT(@POSTFIX,4))=0
	  	BEGIN
		    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_STAGE', @TYPE='START', @DETAIL='No backup table was found with the desired datestamp', 
              @ADDITIONAL_VARIABLE_NAME_1='TP (Type)', @ADDITIONAL_VARIABLE_VALUE_1=@TP;
			RETURN 0;
		END		
    END

   
   EXEC ('TRUNCATE TABLE STAGE.MOVIEDATA; INSERT INTO STAGE.MOVIEDATA SELECT * FROM BCKP.MOVIEDATA'+@POSTFIX);;
	 
 EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME='RESTORE_STAGE', @TYPE='END', @DETAIL='End of Restore_STAGE with parameter';
RETURN 1;
END

/*
 
declare @returnparam varchar(5);
exec @returnparam=control.restore_STAGE @tp='C';
select @returnparam;

select * from log.process

*/