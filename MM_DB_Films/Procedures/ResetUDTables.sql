/*
 -------------------------- MM RESET UD TABLES PROCEDURE ------------------------------
|                                                                                      |
| Name: ResetUDTables.sql                                                              |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   No Parameters.                                                         |
|                                                                                      |
| Last modified: 2022.08.24   TSQL migrating                                           |
|                2018.01.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.reset_ud_tables
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'RESET_UD_TABLES';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of Reset_UD_tables procedure';

ALTER SEQUENCE USERDATA.SEQ_USER_ID RESTART WITH 1;
ALTER SEQUENCE USERDATA.SEQ_USERFEATURE_ID RESTART WITH 1;
ALTER SEQUENCE USERDATA.SEQ_RECOMMENDATION_ID RESTART WITH 1;
ALTER SEQUENCE USERDATA.SEQ_RATING_ID RESTART WITH 1;
 
TRUNCATE TABLE USERDATA.USR;
TRUNCATE TABLE USERDATA.USERFEATURE;
TRUNCATE TABLE USERDATA.RECOMMENDATION;
TRUNCATE TABLE USERDATA.RATING;
 
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of Reset_UD_tables procedure';

RETURN 1;
END

/*

declare @returnparam varchar(5);
exec @returnparam=control.reset_ud_tables;
select @returnparam;

select * from log.process

*/
