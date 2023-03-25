/*
 ------------- MM GENERATE USER ID FUNCTION ----------------
|                                                           |
| Name: GenUserID.sql                                       |
| Created: Akos Ujvary                                      |
| Last modified: 2022.08.31    TSQL migrating               |      
|                2018.01.30    Creation                     |
|                                                           |
 ------------------------------------------------------------
*/

CREATE OR ALTER FUNCTION control.f_genuserid(@seq_num NUMERIC)
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @SEQ_VALUE INTEGER, @ID VARCHAR(10), @i INTEGER, @RTN varchar(10);

    SET @i=1;
    SET @ID='USE'
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

select control.f_genuserid(NEXT VALUE FOR USERDATA.SEQ_USER_ID)

*/
