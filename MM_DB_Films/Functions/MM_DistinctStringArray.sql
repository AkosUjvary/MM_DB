
/*
 --------------------------------------------- MM REPLACE STRING ARRAY FUNCTION ----------------------------------------------------------
|                                                                                                                                         |
| Name: MM_DistinctStringArray.sql                                                                                                        |
| Created: Akos Ujvary                                                                                                                    |
|                                                                                                                                         |
| Desc :  Removes duplicates from string array. Order based on number of occurrences or original ordering                                 |
|                                                                                                                                         |
| Last modified:  2023.04.08   Ordering development, new parameter                                                                        |        
|                 2022.11.28   Creation                                                                                                   |
 -----------------------------------------------------------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER FUNCTION control.f_mm_distinctStringArray(@SRC NVARCHAR(MAX), @SEP VARCHAR(10), @ADD_SPACE_AFTER_SEP_FLG CHAR(1), @NOO_ORDERING_FLG CHAR(1))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @RTN NVARCHAR(MAX);
    IF @NOO_ORDERING_FLG='Y'

        SELECT @RTN=STRING_AGG(RWS, @SEP) WITHIN GROUP (ORDER BY RN DESC, ORDINAL ) FROM (
            SELECT RWS, RN, ORDINAL, ROW_NUMBER() OVER (PARTITION BY RWS ORDER BY RN DESC) AS RN2
            FROM (SELECT TRIM(VALUE) AS RWS, ORDINAL, ROW_NUMBER() OVER (PARTITION BY TRIM(VALUE) ORDER BY (SELECT 1)) AS RN 
        FROM string_split(@SRC, @SEP, 1)) BASE_1)BASE_2
        WHERE RN2=1
    ELSE
        SELECT @RTN=STRING_AGG(RWS, @SEP) WITHIN GROUP (ORDER BY ORDINAL) FROM (SELECT TRIM(VALUE) AS RWS, ORDINAL, ROW_NUMBER() OVER (PARTITION BY TRIM(VALUE) ORDER BY (SELECT 1)) AS RN 
        FROM string_split(@SRC, @SEP, 1)) BASE
        WHERE RN=1 
    IF @ADD_SPACE_AFTER_SEP_FLG='Y' SELECT @RTN=REPLACE(@RTN, ',', ', ') 
    RETURN @RTN;
END


/*
TESTING:

SELECT control.f_mm_distinctStringArray('FF, DSA, XASD, Z, Z, Z, XASD, CC', ',', 'Y', 'Y')

*/
 
 
 




