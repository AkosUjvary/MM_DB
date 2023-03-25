/*
 --------- MM GENERATE ACTOR ID FUNCTION ---------
|                                                 |
| Name: GenActorID.sql                            |
| Created: Akos Ujvary                            |
| Last modified: 2022.08.31    TSQL migrating     |      
|                2017.11.12    Creation           |
|                                                 |
 -------------------------------------------------
*/

CREATE OR ALTER FUNCTION control.f_genactorid(@seq_num NUMERIC)
RETURNS NUMERIC
AS
BEGIN
    RETURN @seq_num;
END
----------- End of code ------------------------
 
/*

test

select control.f_genactorid(NEXT VALUE FOR MOVIEDATA.SEQ_ACTOR_ID)

*/
