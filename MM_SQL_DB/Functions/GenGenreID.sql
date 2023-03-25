/*
 ---------- MM GENERATE GENRE ID FUNCTION --------
|                                                 |
| Name: GenGenreID.sql                            |
| Created: Akos Ujvary                            |
| Last modified: 2022.08.23    TSQL migrating     |      
|                2018.01.30    Creation           |
|                                                 |
 -------------------------------------------------
*/

CREATE OR ALTER FUNCTION control.f_gengenreid(@seq_num NUMERIC)
RETURNS NUMERIC
AS
BEGIN
    RETURN @seq_num;
END
----------- End of code ------------------------
 
/*
TEST:

select control.f_gengenreid(NEXT VALUE FOR MOVIEDATA.SEQ_GENRE_ID)

*/