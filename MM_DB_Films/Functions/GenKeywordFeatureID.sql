/*
 -------- MM GENERATE KEYWORD FEATURE ID FUNCTION -------
|                                                        |
| Name: GenKeywordID.sql                                 |
| Created: Akos Ujvary                                   |
| Last modified: 2022.10.10    Creation                  |
|                                                        |
 --------------------------------------------------------
*/

CREATE OR ALTER FUNCTION control.f_genkeywordfeatureid(@seq_num NUMERIC)
RETURNS NUMERIC
AS
BEGIN
    RETURN @seq_num;
END
----------- End of code ------------------------
 
/*
TEST:

select control.f_genkeywordfeatureid(NEXT VALUE FOR MOVIEDATA.SEQ_KEYWORDFEATURE_ID)
*/

