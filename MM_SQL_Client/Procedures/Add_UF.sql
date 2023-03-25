/*
 -------------------------- MM ADD USER FEATURE PROCEDURE ------------------------------
|                                                                                      |
| Name: Add_UF.sql                                                                     |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   USERID.                                                                |
|                                                                                      |
| Last modified: 2022.09.05   TSQL migrating                                           |
|                2018.01.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.ADD_USERFEATURE(@USERID VARCHAR(10))
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'ADD_USERFEATURE';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of ADD_USERFEATURE procedure';

DELETE FROM USERDATA.USERFEATURE WHERE USER_ID=@USERID;

INSERT INTO USERDATA.USERFEATURE 
SELECT 
  @USERID AS USER_ID,
  MF.FEATURE_CD,
  MF.FEATURE_ID,  
  SUM(RATING-50) AS SCORE /* BASIC SCORING, GENERAL */
FROM MOVIEDATA.MOVIEFEATURE MF 
INNER JOIN (SELECT USER_ID, MOVIE_ID, RATING FROM USERDATA.RATING WHERE USER_ID=@USERID) USER_RATING 
ON USER_RATING.MOVIE_ID=MF.MOVIE_ID
GROUP BY MF.FEATURE_CD, MF.FEATURE_ID


DECLARE @MSG VARCHAR(100);
SET @MSG = 'Userfeatures were added for userID: '+@USERID
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='SUCCESS', @DETAIL=@MSG;

EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of ADD_USERFEATURE procedure';

RETURN 1;
END
---------------------- End of code --------------------------
/*
testing

declare @returnparam varchar(5);
exec @returnparam=control.ADD_USERFEATURE @userid='USE000001';
select @returnparam;


*/



