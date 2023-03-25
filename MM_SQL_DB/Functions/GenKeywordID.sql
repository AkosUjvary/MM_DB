/*
 -------- MM GENERATE KEYWORD ID FUNCTION -------
|                                                 |
| Name: GenKeywordID.sql                          |
| Created: Akos Ujvary                            |
| Last modified: 2022.10.10    Creation           |
|                                                 |
 -------------------------------------------------
*/

CREATE OR ALTER FUNCTION control.f_genkeywordid(@seq_num NUMERIC)
RETURNS NUMERIC
AS
BEGIN
    RETURN @seq_num;
END
----------- End of code ------------------------
 
/*
TEST:

select control.f_genkeywordid(NEXT VALUE FOR MOVIEDATA.SEQ_KEYWORD_ID)
*/

