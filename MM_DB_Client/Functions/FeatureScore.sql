
/*
 --------------------------------------------- MM REPLACE STRING ARRAY FUNCTION ----------------------------------------------------------
|                                                                                                                                         |
| Name: FeatureScore.sql                                                                                                                  |
| Created: Akos Ujvary                                                                                                                    |
|                                                                                                                                         |
| Desc :  Generates full feature score based on individual scores.                                                                        |
|                                                                                                                                         |
| Last modified: 2022.09.06   Creation                                                                                                    |        
 -----------------------------------------------------------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER FUNCTION control.f_featurescore(@TYPE VARCHAR(20), @ACTOR_SCORE NUMERIC(5), @DIRECTOR_SCORE NUMERIC(5), @WRITER_SCORE NUMERIC(5), @GENRE_SCORE NUMERIC(5), @COUNTRY_SCORE NUMERIC(5))
RETURNS NUMERIC(6)
AS
BEGIN
    DECLARE @RTN NUMERIC(6);

    SELECT @RTN = (COALESCE(@ACTOR_SCORE,0)*ACTOR_SCORE + COALESCE(@DIRECTOR_SCORE, 0)*DIRECTOR_SCORE + COALESCE(@WRITER_SCORE, 0)*WRITER_SCORE + COALESCE(@GENRE_SCORE, 0)*GENRE_SCORE +  COALESCE(@COUNTRY_SCORE, 0)*COUNTRY_SCORE)*GLOBAL_MULTIPLIER
    FROM CONTROL.FEATURE_SCORE WHERE RATING_TYPE=@TYPE

    RETURN @RTN;
    
END

/*
testing

select control.f_featurescore('BASIC_1', 3,3,3,3,3)
*/

 