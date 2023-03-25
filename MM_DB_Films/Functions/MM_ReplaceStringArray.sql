
/*
 --------------------------------------------- MM REPLACE STRING ARRAY FUNCTION ----------------------------------------------------------
|                                                                                                                                         |
| Name: MM_ReplaceStringArray.sql                                                                                                         |
| Created: Akos Ujvary                                                                                                                    |
|                                                                                                                                         |
| Desc :  Replaces the source array's values to the target array's values. Space can't be used as separator.                              |
|                                                                                                                                         |
| Last modified: 2022.08.31   Creation                                                                                                    |        
 -----------------------------------------------------------------------------------------------------------------------------------------
*/ 


CREATE OR ALTER FUNCTION control.f_mm_replaceStringArray(@ToReplace VARCHAR(MAX), @SEP_ToReplace VARCHAR(10), @ReplaceWith VARCHAR(MAX), @SEP_ReplaceWith VARCHAR(10), @SEP_out VARCHAR(10))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @RTN VARCHAR(MAX);

    IF RIGHT(@ReplaceWith, 1)!=@SEP_ReplaceWith SET @ReplaceWith=@ReplaceWith+@SEP_ReplaceWith;
    
   SELECT 
    @RTN=STRING_AGG(REPLACED_VALUES, @SEP_out) FROM
    (SELECT 
    SUBSTRING(
    SUBSTRING(ALL_COLUMNS, CHARINDEX(FAILED_COLUMNS, ALL_COLUMNS)+LEN(FAILED_COLUMNS)+1, 1000000),   /* LEFT SIDE TRUNCATED */ 
    1, CHARINDEX(@SEP_ReplaceWith,SUBSTRING(ALL_COLUMNS, CHARINDEX(FAILED_COLUMNS, ALL_COLUMNS)+LEN(FAILED_COLUMNS)+1, 1000000)   /* LEFT SIDE TRUNCATED */)-1 /* RIGHT SIDE TRUNCATED */
    )as REPLACED_VALUES
    FROM
    (SELECT TO_REPLACE_SEPARATED.VALUE AS FAILED_COLUMNS,
        REPLACE_WITH.ALL_COLUMNS
    FROM STRING_SPLIT(REPLACE(@ToReplace, ' ', ''), @SEP_ToReplace) TO_REPLACE_SEPARATED
    LEFT JOIN (SELECT @ReplaceWith AS ALL_COLUMNS) REPLACE_WITH
    ON 1=1) INNER_1 ) INNER_2

    RETURN @RTN;
END


 /*
testing

select control.f_mm_replaceStringArray('RELEASE_YEAR, IMDB_RATING, TOMATO_USER_REVIEWS',
                                        ',',
                                        'TITLE|Rebecca|TITLE_ALT|A Manderley-ház asszonya|RELEASE_YEAR|19r40|GENRES|Drama,Mystery,Romance|COUNTRY|USA|ACTORS|Laurence Olivier,Joan Fontaine,George Sanders,Judith Anderson|DIRECTORS|Alfred Hitchcock|WRITERS|Daphne Du Maurier,Robert E. Sherwood,Joan Harrison,Philip MacDonald,Michael Hogan|IMDB_RATING|82|IMDB_VOTES|96723|TOMATOMETER|100|TOMATO_USER_METER|92|TOMATO_USER_REVIEWS|39079',
                                        '|',
                                        ', ')

 

*/