/*
 -------------------------- MM ADD USER FEATURE PROCEDURE ------------------------------
|                                                                                      |
| Name: Sign_In.sql                                                                    |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   USERNAME, PW                                                           |
|                                                                                      |
| Last modified: 2022.09.05   TSQL migrating                                           |
|                2018.01.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.SIGN_IN(@USERNAME VARCHAR(100), @PW NVARCHAR(100), @RTN VARCHAR(10) OUTPUT)
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'SIGN_IN';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of SIGN_IN procedure';

DECLARE @USERID VARCHAR(10);
SELECT @USERID=USER_ID FROM USERDATA.USR WHERE USER_NM=@USERNAME AND USER_PW=HASHBYTES('MD5', CAST(USER_ID as nvarchar)+@PW)

SET @RTN=COALESCE(@USERID, 'INVALID');

DECLARE @MSG VARCHAR(50);
IF @RTN='INVALID' 
  BEGIN
    SET @MSG = 'Invalid sign-in attempt for user: '+@USERNAME
    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='WARNING', @DETAIL=@MSG;
  END
  ELSE
  BEGIN
    SET @MSG = 'Successful sign-in for user: '+@USERNAME
    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='SUCCESS', @DETAIL=@MSG;
  END

EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of SIGN_IN procedure';

END

/*

testing
 
declare @returnpar varchar(10);
exec control.sign_in @username='admin', @pw='god', @rtn=@returnpar output;
select @returnpar;


*/
 









