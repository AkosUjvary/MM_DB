
/*
 -------------------------------------------------- MM SCORE BIAS YEAR FUNCTION ----------------------------------------------------------
|                                                                                                                                         |
| Name: ScoreBiasYearLocal.sql                                                                                                            |
| Created: Akos Ujvary                                                                                                                    |
|                                                                                                                                         |
| Desc :  Setting the weight of years                                                                                                     |
|                                                                                                                                         |
| Last modified: 2022.09.08   Creation                                                                                                    |        
 -----------------------------------------------------------------------------------------------------------------------------------------
*/ 


CREATE OR ALTER FUNCTION control.f_ScoreBiasYearLocal(@BIAS_TYPE varchar(30), @CB_TYPE varchar(30), @YEAR NUMERIC(4), @MIN_YEAR NUMERIC(4), @MAX_YEAR NUMERIC(4))
RETURNS NUMERIC(4)
WITH SCHEMABINDING
AS
BEGIN
  DECLARE @RTN NUMERIC(3);
  DECLARE @GLOBAL_MULTIPLIER NUMERIC(3);

  IF(@BIAS_TYPE='COUNTRY') SELECT @GLOBAL_MULTIPLIER=GLOBAL_MULTIPLIER_COUNTRY FROM CONTROL.BIAS_SETTING WHERE CB_TYPE=@CB_TYPE;
  IF(@BIAS_TYPE='GLOBAL') SELECT @GLOBAL_MULTIPLIER=GLOBAL_MULTIPLIER_GLOBAL FROM CONTROL.BIAS_SETTING WHERE CB_TYPE=@CB_TYPE;


  DECLARE @YEAR_SCORE NUMERIC(3)
  SELECT @YEAR_SCORE = YEAR_SCORE FROM CONTROL.BIAS_SETTING WHERE CB_TYPE=@CB_TYPE;

  SET @RTN = IIF(@YEAR<=@MAX_YEAR AND @YEAR>=@MIN_YEAR,@YEAR_SCORE,0)

  SET @RTN=@RTN * @GLOBAL_MULTIPLIER;
  RETURN @RTN    

END

----------------- End of code ------------------------

/*
testing

SELECT CONTROL.F_SCOREBIASYEARLOCAL('COUNTRY', 'BASIC_1', 1980, 1976, 2001)
   

*/