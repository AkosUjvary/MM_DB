

/* 1. reset log */

declare @returnparam smallint;
exec @returnparam=control.reset_log_tables;
select @returnparam;

/* 2. backup stage */

exec @returnparam=control.backup_stage @tp='L';
select @returnparam;

/*
select * from INFORMATION_SCHEMA.tables where table_schema = 'bckp' and table_name like 'MOVIEDATA%'
select count(*) from bckp.MOVIEDATA_0831
*/

/* 3. reset stage */

truncate table stage.moviedata;
select count(*) from stage.MOVIEDATA;

/* 4. restore stage */

exec @returnparam=control.restore_STAGE @tp='L';
select @returnparam;
select count(*) from stage.MOVIEDATA;

/* 5. loadmoviedata rossz*/

EXEC CONTROL.LOADMOVIEDATA; /* régi:  70, 56, 52 új: 55, 48, 48 tehát insert into helyett ha lehet select into kell */

/* 6. javítás */
update stage.moviedata 
set release_year='1940', IMDB_RATING='8.2'
where imdb_id='tt0032976';

update stage.moviedata 
set release_year='1940' 
where imdb_id='tt0032910';

/* 7. backup a jóra */

exec @returnparam=control.backup_stage @tp='J';
select @returnparam;

/* 8. loadmoviedata jó*/

EXEC CONTROL.LOADMOVIEDATA;
select * from log.loading_error;
select * from log.process;

/* 9. restore rosszra */

exec @returnparam=control.restore_STAGE @tp='L';
select @returnparam;
select count(*) from stage.MOVIEDATA;

/* 10. loadmoviedata rossz*/

EXEC CONTROL.LOADMOVIEDATA;
select * from log.loading_error;
select * from log.process;

select * from moviedata.moviefeature;
select * from moviedata.movie;