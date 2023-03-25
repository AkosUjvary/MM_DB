/* 1. reset LOG */

declare @returnparam smallint;
exec @returnparam=control.reset_log_tables;
select @returnparam;

/* 2. reset MD */

declare @returnparam smallint;
exec @returnparam=control.reset_md_tables;
select @returnparam;

/* 3. loadmoviedata rossz*/

EXEC CONTROL.LOADMOVIEDATA; /* régi: 30422  30398 */


select * from log.process;

select * from moviedata.MOVIEFEATURE
select * from moviedata.ACTOR;
select * from moviedata.COUNTRY;
select * from moviedata.DIRECTOR;
select * from moviedata.GENRE;
select * from moviedata.WRITER;


SELECT
    INNER_1.*,
    CAST((SUM(SECONDS) OVER (PARTITION BY PR_ID))/60 AS VARCHAR)+':'+CAST((SUM(SECONDS) OVER (PARTITION BY PR_ID))%60 AS VARCHAR) AS SUM_TIME 
FROM
(SELECT 
    PR_ID,
    STEP_ID,
    TYPE,
    DETAIL_MSG,
    IIF(STEP_ID!=1, COALESCE(DATEDIFF(SECOND, LAG(RUN_DTTM) OVER (ORDER BY PR_ID, STEP_ID), RUN_DTTM), 0), 0) SECONDS    
FROM 
LOG.PROCESS WHERE UPPER(NAME) = 'LOADMOVIEDATA') INNER_1


 

select count(*) from moviedata.MOVIE

 