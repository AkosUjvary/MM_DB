/*
 -------------------------- MM ADD USER RATING PROCEDURE ------------------------------
|                                                                                      |
| Name: Add_Rating.sql                                                                 |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   USERID, IMDBID, RATING                                                 |
|                                                                                      |
| Last modified: 2022.09.05   TSQL migrating                                           |
|                2018.01.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.ADD_RATING(@USERID VARCHAR(100), @IMDBID VARCHAR(9), @RATING NUMERIC)
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'ADD_RATING';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of ADD_RATING procedure';

DECLARE @CNT INTEGER;
DECLARE @MOVIEID VARCHAR(10);
DECLARE @ISRATED INTEGER;
DECLARE @RATINGID VARCHAR(10);
DECLARE @MSG VARCHAR(100);

SELECT @CNT=COUNT(*) FROM MOVIEDATA.MOVIE WHERE IMDB_ID=@IMDBID;

IF @CNT= 1 
  BEGIN
    SELECT @MOVIEID=MOVIE_ID FROM MOVIEDATA.MOVIE WHERE IMDB_ID=@IMDBID;

    SELECT @CNT=COUNT(*) FROM USERDATA.USR WHERE USER_ID=@USERID;
    IF @CNT=0 
      BEGIN
        SET @MSG='No user '+@USERID+' was found.';
        EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='INFO', @DETAIL=@MSG;
        RETURN 0;
      END

    SELECT @ISRATED=COUNT(*) FROM USERDATA.RATING WHERE MOVIE_ID=@MOVIEID AND USER_ID=@USERID;
    IF @ISRATED=0 
      BEGIN
        SELECT @RATINGID=control.f_genratingid(NEXT VALUE FOR USERDATA.SEQ_RATING_ID);        
        INSERT INTO USERDATA.RATING VALUES(@RATINGID, @USERID, @MOVIEID, @RATING, CURRENT_TIMESTAMP)
        SET @MSG='New rating for '+@MOVIEID+' from user '+@USERID+' was inserted.'
        EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='INFO', @DETAIL=@MSG,
                          @ADDITIONAL_VARIABLE_NAME_1='IMDB_ID', @ADDITIONAL_VARIABLE_VALUE_1=@IMDBID;
      END
    ELSE
      BEGIN
        UPDATE USERDATA.RATING SET RATING=@RATING, RATING_DTTM=CURRENT_TIMESTAMP WHERE MOVIE_ID=@MOVIEID AND USER_ID=@USERID;        
        SET @MSG='New rating for '+@MOVIEID+' from user '+@USERID+' was set.';
        EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='INFO', @DETAIL=@MSG;
      END    
  END
ELSE
  BEGIN
    EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='ERROR', @DETAIL='No film was found in the DB during ADD_RATING procedure',
                          @ADDITIONAL_VARIABLE_NAME_1='IMDB_ID', @ADDITIONAL_VARIABLE_VALUE_1=@IMDBID;
    RETURN 0;
  END


EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of ADD_RATING procedure';

RETURN 1;
END


/*
testing

declare @returnparam varchar(5);
exec @returnparam=control.add_rating @imdbid='tt0133093', @userid='USE000001', @rating=90;
select @returnparam;



*/