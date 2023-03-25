
/*
 -------------------------------------------------- MM SCORE BIAS VOTES FUNCTION ---------------------------------------------------------
|                                                                                                                                         |
| Name: ScoreBiasVotesLocal.sql                                                                                                           |
| Created: Akos Ujvary                                                                                                                    |
|                                                                                                                                         |
| Desc :  Setting the weight of votes                                                                                                     |
|                                                                                                                                         |
| Last modified: 2022.09.08   Creation                                                                                                    |        
 -----------------------------------------------------------------------------------------------------------------------------------------
*/ 
 

CREATE OR ALTER FUNCTION control.f_ScoreBiasVotesLocal(@BIAS_TYPE varchar(30), @CB_TYPE varchar(30), @IMDB_VOTES NUMERIC(8), @TOMATO_VOTES NUMERIC(8), @MIN_IMDB_VOTES NUMERIC(8), @AVG_IMDB_VOTES NUMERIC(8), @MIN_TOMATO_VOTES NUMERIC(8), @AVG_TOMATO_VOTES NUMERIC(8))
RETURNS NUMERIC(4)
WITH SCHEMABINDING 
AS
BEGIN
  DECLARE @RTN NUMERIC(3);
  DECLARE @GLOBAL_MULTIPLIER NUMERIC(3);

  IF(@BIAS_TYPE='COUNTRY') SELECT @GLOBAL_MULTIPLIER=GLOBAL_MULTIPLIER_COUNTRY FROM CONTROL.BIAS_SETTING WHERE CB_TYPE=@CB_TYPE;
  IF(@BIAS_TYPE='GLOBAL') SELECT @GLOBAL_MULTIPLIER=GLOBAL_MULTIPLIER_GLOBAL FROM CONTROL.BIAS_SETTING WHERE CB_TYPE=@CB_TYPE;


  DECLARE @VOTING_SCORE NUMERIC(3), @AVG_VOTING_MIN_PCT NUMERIC(3), @AVG_VOTING_MAX_PCT NUMERIC(3);
  SELECT @VOTING_SCORE = VOTING_SCORE, @AVG_VOTING_MIN_PCT = AVG_VOTING_MIN_PCT, @AVG_VOTING_MAX_PCT=AVG_VOTING_MAX_PCT FROM CONTROL.BIAS_SETTING WHERE CB_TYPE=@CB_TYPE;

  SET @RTN = IIF((@IMDB_VOTES>=@MIN_IMDB_VOTES OR @TOMATO_VOTES>=@MIN_TOMATO_VOTES), @VOTING_SCORE/2, 0);
  SET @RTN = IIF(@IMDB_VOTES>=(@AVG_IMDB_VOTES-@AVG_IMDB_VOTES*0.01*@AVG_VOTING_MIN_PCT) AND @IMDB_VOTES<=(@AVG_IMDB_VOTES+@AVG_IMDB_VOTES*0.01*@AVG_VOTING_MAX_PCT) OR
                 @TOMATO_VOTES>=(@AVG_TOMATO_VOTES-@AVG_TOMATO_VOTES*0.01*@AVG_VOTING_MIN_PCT) AND @TOMATO_VOTES<=(@AVG_TOMATO_VOTES+@AVG_TOMATO_VOTES*0.01*@AVG_VOTING_MAX_PCT)
                  , @RTN+@VOTING_SCORE/2, @RTN);

  SET @RTN=@RTN * @GLOBAL_MULTIPLIER;
  RETURN @RTN    

END

----------------- End of code ------------------------

/*
testing

SELECT CONTROL.F_SCOREBIASVOTESLOCAL(1864012, 35796391, 1000,1200000, 100, 1200)
    

*/
