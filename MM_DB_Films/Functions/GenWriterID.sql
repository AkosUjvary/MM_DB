/*
 ---------- MM GENERATE WRITER ID FUNCTION --------
|                                                 |
| Name: GenWriterID.sql                           |
| Created: Akos Ujvary                            |
| Last modified: 2022.08.31    TSQL migrating     |      
|                2018.01.30    Creation           |
|                                                 |
 -------------------------------------------------
*/

CREATE OR ALTER FUNCTION control.f_genwriterid(@seq_num NUMERIC)
RETURNS NUMERIC
AS
BEGIN
    RETURN @seq_num;
END
----------- End of code ------------------------
 
/*
TEST:

select control.f_genwriterid(NEXT VALUE FOR MOVIEDATA.SEQ_WRITER_ID)
*/