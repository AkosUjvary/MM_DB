
/*
 -------------------------- MM RESET LOG TABLES PROCEDURE -----------------------------
|                                                                                      |
| Name: ResetLogTables.sql                                                             |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:   No Parameters.                                                         |
|                                                                                      |
| Last modified: 2022.08.31   Creation                                                 |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.reset_log_tables
WITH EXECUTE AS CALLER
AS
BEGIN

ALTER SEQUENCE LOG.SEQ_ERROR_ID RESTART WITH 1;
ALTER SEQUENCE LOG.SEQ_PROCESS_ID RESTART WITH 1;
  
TRUNCATE TABLE LOG.LOADING_ERROR;
TRUNCATE TABLE LOG.PROCESS;

RETURN 1;
END

/*

declare @returnparam varchar(5);
exec @returnparam=control.reset_log_tables;
select @returnparam;

select * from log.process order by run_dttm  desc;

select nature_key_value from log.loading_error err  
where err_type='format' and nature_key_value not in (select imdb_id from moviedata.movie)

order by run_dttm desc;

select * from bckp.moviedata_curr 
 select * from moviedata.movie where title_nm like '%Egy%'
*/
 