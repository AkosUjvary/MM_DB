/*
 --------- MM GENERATE RECOMMENDATION ID FUNCTION ----------
|                                                           |
| Name: GenRecommendationID.sql                             |
| Created: Akos Ujvary                                      |
| Last modified: 2022.08.31    TSQL migrating               |      
|                2017.11.12    Creation                     |
|                                                           |
 ------------------------------------------------------------
*/

CREATE OR ALTER FUNCTION control.f_genrecommendationid(@seq_num NUMERIC)
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @SEQ_VALUE INTEGER, @ID VARCHAR(10), @i INTEGER, @RTN varchar(10);

    SET @i=1;
    SET @ID='REC'
    SELECT @SEQ_VALUE=@seq_num;
    
    WHILE @i<10-len(@ID)-len(@SEQ_VALUE)
      BEGIN
        SET @ID = @ID+'0';
      END
      
    SET @ID = @ID+CAST(@SEQ_VALUE as varchar);
    SET @RTN=@ID;

    RETURN @RTN;
END
----------- End of code ------------------------
 
/*
TEST:

select control.f_genrecommendationid(NEXT VALUE FOR USERDATA.SEQ_RECOMMENDATION_ID)

*/