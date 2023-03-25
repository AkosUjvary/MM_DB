/*
 ------------------------------ MM ADD USER PROCEDURE ---------------------------------
|                                                                                      |
| Name: TestingRecCB.sql                                                               |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   USERID, V_TESTRATINGS                                                  |
|                                                                                      |
| Last modified:    2022.09.13   Creation                                              |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.TestingRecCB(@USERNM VARCHAR(10), @CBTYPE VARCHAR(50), @USERNM_T VARCHAR(100))
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'TestingRecCB';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of TestingRecCB procedure';

DECLARE @MOVIE_CNT NUMERIC;
SELECT @MOVIE_CNT=COUNT(*) FROM MOVIEDATA.MOVIE

DECLARE @USERID VARCHAR(10);
SELECT @USERID=USER_ID FROM USERDATA.USR WHERE USER_NM=@USERNM

DECLARE @USERID_T VARCHAR(10);
SELECT @USERID_T=USER_ID FROM USERDATA.USR WHERE USER_NM=@USERNM_T

exec control.LoadRecCB @USERID=@USERID, @CB_TYPE=@CBTYPE, @ALLROWCNT=@MOVIE_CNT;

DECLARE @SQLSTMNT VARCHAR(MAX);

SET @SQLSTMNT = 'CREATE OR ALTER VIEW USERDATA.V_TESTING_REC_CB AS 
SELECT '''+@USERID+''' AS BASE_USER, '''+@USERID_T+''' AS TEST_USER, INNER_1.*, CAST(ROUND(((('+cast(@MOVIE_CNT as varchar)+'+1.00)-inner_1.rnk)/'+cast(@MOVIE_CNT as varchar)+'*100),2) AS DECIMAL(5,2)) as RATNG_CB, TEST.RATING RATING_ORIG from
(SELECT cb.*, rank() over (order by biased_feature_score desc) as rnk from USERDATA.TMP_REC_CB cb where user_id='''+@USERID+''') INNER_1
INNER JOIN 
(SELECT RATING, MOVIE_ID FROM USERDATA.RATING WHERE USER_ID='''+@USERID_T+''') TEST ON TEST.MOVIE_ID = INNER_1.MOVIE_ID';

exec (@SQLSTMNT);

EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of TestingRecCB procedure';
END

/*
testing

declare @returnparam varchar(5);
exec @returnparam=control.TestingRecCB @USERNM='Boti_base', @CBTYPE='BASIC_1', @USERNM_T='Boti_test';
select @returnparam;

SELECT * FROM USERDATA.V_TESTING_REC_CB

select * from userdata.TMP_REC_CB where bias_year_score_global >0


select * from log.process where run_dttm>'2022.09.14 00:00:00'

*/
  