
/*
 --------------------------------------------- MM REPLACE STRING ARRAY FUNCTION ----------------------------------------------------------
|                                                                                                                                         |
| Name: MM_DistinctStringArray.sql                                                                                                         |
| Created: Akos Ujvary                                                                                                                    |
|                                                                                                                                         |
| Desc :  Removes duplicates from string array                                                                                            |
|                                                                                                                                         |
| Last modified: 2022.11.28   Creation                                                                                                    |        
 -----------------------------------------------------------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER FUNCTION control.f_mm_distinctStringArray(@SRC VARCHAR(MAX), @SEP VARCHAR(10), @ADD_SPACE_AFTER_SEP_FLG CHAR(1))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @RTN VARCHAR(MAX);
    SELECT 
    @RTN=STRING_AGG(SPLIT.RWS, @SEP) FROM (SELECT DISTINCT TRIM(VALUE) AS RWS FROM STRING_SPLIT(@SRC, @SEP)) SPLIT
    IF @ADD_SPACE_AFTER_SEP_FLG='Y' SELECT @RTN=REPLACE(@RTN, ',', ', ') 
    RETURN @RTN;
END


/*
TESTING:


SELECT control.f_mm_distinctStringArray('ASD, DSA, ASD, ASD', ',', 'Y')

SELECT 


*/




