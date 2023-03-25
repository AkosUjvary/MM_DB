/*
 ------------------------------ MM ADD USER PROCEDURE ---------------------------------
|                                                                                      |
| Name: Add_User.sql                                                                   |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   USERID, PW                                                             |
|                                                                                      |
| Last modified: 2022.09.05   TSQL migrating                                           |
|                2018.01.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.ADD_USER(@USERNAME VARCHAR(100), @PW NVARCHAR(100))
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'ADD_USER';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of ADD_USER procedure';

DECLARE @CNT INTEGER;
SELECT @CNT=COUNT(*) FROM USERDATA.USR WHERE USER_NM = @USERNAME;
DECLARE @USER_ID VARCHAR(10);
DECLARE @PW_SALTED NVARCHAR(100);
DECLARE @PW_HASHED VARBINARY(200);
DECLARE @MSG VARCHAR(100);

IF @CNT=0
  BEGIN
    SET @USER_ID = control.f_genuserid(NEXT VALUE FOR USERDATA.SEQ_USER_ID);
    SET @PW_SALTED = @USER_ID+@PW;
    
    SET @PW_HASHED=HASHBYTES('MD5', @PW_SALTED) 
   
    INSERT INTO USERDATA.USR VALUES(@USER_ID, @USERNAME, @PW_HASHED);
    SET @MSG='User: '+@USERNAME+' was added';
    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='INFO', @DETAIL=@MSG;
    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of ADD_USER procedure';
    RETURN 1
  END
  ELSE
  BEGIN
    SET @MSG='Username already in DB: '+@USERNAME;
    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='ERROR', @DETAIL=@MSG;
    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of ADD_USER procedure';
  RETURN 0
  END

END

/*
testing

declare @returnparam varchar(5);
exec @returnparam=control.add_user @username='admin', @pw='god';
select @returnparam;

select * from userdata.usr
*/