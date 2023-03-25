/*
 -------- MM GENERATE DIRECTOR ID FUNCTION -------
|                                                 |
| Name: GenDirectorID.sql                         |
| Created: Akos Ujvary                            |
| Last modified: 2022.08.31    TSQL migrating     |      
|                2017.11.12    Creation           |
|                                                 |
 -------------------------------------------------
*/

CREATE OR ALTER FUNCTION control.f_gendirectorid(@seq_num NUMERIC)
RETURNS NUMERIC
AS
BEGIN
    RETURN @seq_num;
END
----------- End of code ------------------------
 
/*
TEST:

select control.f_gendirectorid(NEXT VALUE FOR MOVIEDATA.SEQ_DIRECTOR_ID)
*/
