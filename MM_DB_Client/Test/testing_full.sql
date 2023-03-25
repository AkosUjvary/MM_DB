
/* 1. Reset log */
exec control.reset_log_tables;

/* 2. Reset MD */
exec control.reset_md_tables;

/* 3. LoadMovieData */
EXEC CONTROL.LOADMOVIEDATA; /* 6:30 */

/* 4. Reset UD */
exec control.reset_ud_tables;


/* 5.  ADD BOTI   */
/* 5. 1. add full user */

exec control.add_user @username='KK', @pw='test';


/* 5. 2. add full ratings then UF*/
GO
declare @userid varchar(30);
set @userid='USE000007';

select stmnt from 
(select 'exec control.add_rating @imdbid='''+imdb_id+''', @userid='''+@userid+''', @rating='+cast(rating as varchar)+';' as stmnt, rank() over (order by imdb_id) as rnk from 
(select 'tt0087843' as imdb_id, 	80 as rating union all
select 'tt0047528' as imdb_id, 90 as rating union all
select 'tt0373981' as imdb_id, 70 as rating union all
select 'tt0070511' as imdb_id, 90 as rating union all
select 'tt0068646' as imdb_id, 70 as rating  ) boti_full )inner_1
--where rnk%2=1

/* 5. 3. add base user */

exec control.add_user @username='Boti_base', @pw='boi';


/* 5. 4. add base ratings then UF*/
GO
declare @userid varchar(30);
set @userid='USE000002';

select stmnt from 
(select 'exec control.add_rating @imdbid='''+imdb_id+''', @userid='''+@userid+''', @rating='+cast(rating as varchar)+';' as stmnt, rank() over (order by imdb_id) as rnk from 
(select 'tt1273235' as imdb_id, 	1 as rating union all
select 'tt0113264' as imdb_id, 		20 as rating union all
select 'tt1798709' as imdb_id, 		40 as rating union all
select 'tt0067927' as imdb_id, 		55 as rating union all
select 'tt0490086' as imdb_id, 		60 as rating union all
select 'tt0067116' as imdb_id, 		60 as rating union all
select 'tt1148204' as imdb_id, 		60 as rating union all
select 'tt0437086' as imdb_id, 		60 as rating union all
select 'tt4975280' as imdb_id, 		65 as rating union all
select 'tt3037164' as imdb_id, 		65 as rating union all
select 'tt0064665' as imdb_id, 		65 as rating union all
select 'tt0092890' as imdb_id, 		65 as rating union all
select 'tt3465916' as imdb_id, 		70 as rating union all
select 'tt2543164' as imdb_id, 		70 as rating union all
select 'tt0072890' as imdb_id, 		70 as rating union all
select 'tt0488120' as imdb_id, 		70 as rating union all
select 'tt0118971' as imdb_id, 		70 as rating union all
select 'tt6723592' as imdb_id, 		70 as rating union all
select 'tt0067023' as imdb_id, 		70 as rating union all
select 'tt0079501' as imdb_id, 		70 as rating union all
select 'tt0067866' as imdb_id, 		70 as rating union all
select 'tt0070735' as imdb_id, 		70 as rating union all
select 'tt0106856' as imdb_id, 		75 as rating union all
select 'tt8613070' as imdb_id, 		75 as rating union all
select 'tt8648880' as imdb_id, 		75 as rating union all
select 'tt5871080' as imdb_id, 		75 as rating union all
select 'tt0079261' as imdb_id, 		75 as rating union all
select 'tt0070047' as imdb_id, 		75 as rating union all
select 'tt0084787' as imdb_id, 		75 as rating union all
select 'tt0070666' as imdb_id, 		75 as rating union all
select 'tt7984734' as imdb_id, 		80 as rating union all
select 'tt0033467' as imdb_id, 		80 as rating union all
select 'tt0060827' as imdb_id, 		80 as rating union all
select 'tt0034583' as imdb_id, 		80 as rating union all
select 'tt10633456' as imdb_id, 	80 as rating union all
select 'tt0290673' as imdb_id, 		80 as rating union all
select 'tt2584384' as imdb_id, 		85 as rating union all
select 'tt0091251' as imdb_id, 		85 as rating union all
select 'tt0075467' as imdb_id, 		85 as rating union all
select 'tt0470752' as imdb_id, 		85 as rating union all
select 'tt1979320' as imdb_id, 		85 as rating union all
select 'tt6751668' as imdb_id, 		85 as rating union all
select 'tt10288566' as imdb_id, 	90 as rating union all
select 'tt1675434' as imdb_id, 		90 as rating union all
select 'tt0073486' as imdb_id, 		92 as rating union all
select 'tt2948372' as imdb_id, 		10 as rating union all
select 'tt0268695' as imdb_id, 		55 as rating  ) boti_full )inner_1
where rnk%2=1


 /* 5. 5. add test user */

exec control.add_user @username='Boti_test', @pw='boi';

GO

/* 5. 6. add test ratings then UF*/

declare @userid varchar(30);
set @userid='USE000003';

select stmnt from 
(select 'exec control.add_rating @imdbid='''+imdb_id+''', @userid='''+@userid+''', @rating='+cast(rating as varchar)+';' as stmnt, rank() over (order by imdb_id) as rnk from 
(select 'tt1273235' as imdb_id, 	1 as rating union all
select 'tt0113264' as imdb_id, 		20 as rating union all
select 'tt1798709' as imdb_id, 		40 as rating union all
select 'tt0067927' as imdb_id, 		55 as rating union all
select 'tt0490086' as imdb_id, 		60 as rating union all
select 'tt0067116' as imdb_id, 		60 as rating union all
select 'tt1148204' as imdb_id, 		60 as rating union all
select 'tt0437086' as imdb_id, 		60 as rating union all
select 'tt4975280' as imdb_id, 		65 as rating union all
select 'tt3037164' as imdb_id, 		65 as rating union all
select 'tt0064665' as imdb_id, 		65 as rating union all
select 'tt0092890' as imdb_id, 		65 as rating union all
select 'tt3465916' as imdb_id, 		70 as rating union all
select 'tt2543164' as imdb_id, 		70 as rating union all
select 'tt0072890' as imdb_id, 		70 as rating union all
select 'tt0488120' as imdb_id, 		70 as rating union all
select 'tt0118971' as imdb_id, 		70 as rating union all
select 'tt6723592' as imdb_id, 		70 as rating union all
select 'tt0067023' as imdb_id, 		70 as rating union all
select 'tt0079501' as imdb_id, 		70 as rating union all
select 'tt0067866' as imdb_id, 		70 as rating union all
select 'tt0070735' as imdb_id, 		70 as rating union all
select 'tt0106856' as imdb_id, 		75 as rating union all
select 'tt8613070' as imdb_id, 		75 as rating union all
select 'tt8648880' as imdb_id, 		75 as rating union all
select 'tt5871080' as imdb_id, 		75 as rating union all
select 'tt0079261' as imdb_id, 		75 as rating union all
select 'tt0070047' as imdb_id, 		75 as rating union all
select 'tt0084787' as imdb_id, 		75 as rating union all
select 'tt0070666' as imdb_id, 		75 as rating union all
select 'tt7984734' as imdb_id, 		80 as rating union all
select 'tt0033467' as imdb_id, 		80 as rating union all
select 'tt0060827' as imdb_id, 		80 as rating union all
select 'tt0034583' as imdb_id, 		80 as rating union all
select 'tt10633456' as imdb_id, 	80 as rating union all
select 'tt0290673' as imdb_id, 		80 as rating union all
select 'tt2584384' as imdb_id, 		85 as rating union all
select 'tt0091251' as imdb_id, 		85 as rating union all
select 'tt0075467' as imdb_id, 		85 as rating union all
select 'tt0470752' as imdb_id, 		85 as rating union all
select 'tt1979320' as imdb_id, 		85 as rating union all
select 'tt6751668' as imdb_id, 		85 as rating union all
select 'tt10288566' as imdb_id, 	90 as rating union all
select 'tt1675434' as imdb_id, 		90 as rating union all
select 'tt0073486' as imdb_id, 		92 as rating union all
select 'tt2948372' as imdb_id, 		10 as rating union all
select 'tt0268695' as imdb_id, 		55 as rating  ) boti_full )inner_1
where rnk%2=0 

/* 5. 7. RUN UF*/

exec control.ADD_USERFEATURE @userid='USE000001';
exec control.ADD_USERFEATURE @userid='USE000002';
exec control.ADD_USERFEATURE @userid='USE000003';


/* 6. Rec BOTI_FULL */
GO

declare @returnparam varchar(5);
exec @returnparam=control.LoadRecCB @USERID='USE000001', @CB_TYPE='BASIC_1', @ALLROWCNT=20;
select @returnparam;

select * from userdata.TMP_REC_CB where user_id='USE000001' 

select * from userdata.userfeature
left join moviedata.actor actor on actor.actor_id=feature_id
 where user_id='USE000001' and feature_cd='A' order   by score DESC


/* 7. RecTEST BOTI_BASE */
GO

declare @returnparam varchar(5);
exec @returnparam=control.TestingRecCB @USERNM='Boti_base', @CBTYPE='BASIC_1', @USERNM_T='Boti_test';
select @returnparam;


select * from userdata.V_TESTING_REC_CB where user_id='USE000002'

 

-- Adorján


exec control.add_user @username='Adorjan_full', @pw='boi';

GO

/* 5. 6. add test ratings then UF*/

declare @userid varchar(30);
set @userid='USE000005';

select stmnt from 
(select 'exec control.add_rating @imdbid='''+imdb_id+''', @userid='''+@userid+''', @rating='+cast(rating as varchar)+';' as stmnt, rank() over (order by imdb_id) as rnk from 
(
select 'tt7984734' as imdb_id, 90 as rating union all
select 'tt2584384' as imdb_id, 80 as rating union all
select 'tt0490086' as imdb_id, 20 as rating union all
select 'tt2543164' as imdb_id, 80 as rating union all
select 'tt0072890' as imdb_id, 70 as rating union all
select 'tt0106856' as imdb_id, 75 as rating union all
select 'tt0113264' as imdb_id, 50 as rating union all
select 'tt0033467' as imdb_id, 75 as rating union all
select 'tt8613070' as imdb_id, 80 as rating union all
select 'tt0073486' as imdb_id, 50 as rating union all
select 'tt0470752' as imdb_id, 75 as rating union all
select 'tt1798709' as imdb_id, 50 as rating union all
select 'tt0060827' as imdb_id, 65 as rating union all
select 'tt0118971' as imdb_id, 70 as rating union all
select 'tt0034583' as imdb_id, 80 as rating union all
select 'tt0075467' as imdb_id, 70 as rating union all
select 'tt8648880' as imdb_id, 75 as rating union all
select 'tt5871080' as imdb_id, 80 as rating union all
select 'tt4975280' as imdb_id, 80 as rating union all
select 'tt6723592' as imdb_id, 70 as rating union all
select 'tt0067023' as imdb_id, 75 as rating union all
select 'tt1979320' as imdb_id, 80 as rating union all
select 'tt0067927' as imdb_id, 60 as rating union all
select 'tt2948372' as imdb_id, 80 as rating union all
select 'tt0079261' as imdb_id, 65 as rating union all
select 'tt0079501' as imdb_id, 70 as rating union all
select 'tt0067116' as imdb_id, 75 as rating union all
select 'tt10288566' as imdb_id, 70 as rating union all
select 'tt1148204' as imdb_id, 40 as rating union all
select 'tt0070047' as imdb_id, 75 as rating union all
select 'tt10633456' as imdb_id, 70 as rating union all
select 'tt6751668' as imdb_id, 85 as rating union all
select 'tt0084787' as imdb_id, 70 as rating union all
select 'tt3037164' as imdb_id, 75 as rating union all
select 'tt0067866' as imdb_id, 70 as rating union all
select 'tt1675434' as imdb_id, 80 as rating union all
select 'tt0070735' as imdb_id, 75 as rating union all
select 'tt0064665' as imdb_id, 65 as rating union all
select 'tt0290673' as imdb_id, 40 as rating union all
select 'tt1273235' as imdb_id, 30 as rating union all
select 'tt0437086' as imdb_id, 60 as rating union all
select 'tt0070666' as imdb_id, 73 as rating union all
select 'tt0092890' as imdb_id, 60 as rating union all
select 'tt0268695' as imdb_id, 45 as rating union all
select 'tt0780504' as imdb_id, 65 as rating union all
select 'tt0056663' as imdb_id, 65 as rating 
) boti_full )inner_1

/* 5. 7. RUN UF*/

exec control.ADD_USERFEATURE @userid='USE000005';

exec  control.LoadRecCB @USERID='USE000005', @CB_TYPE='BASIC_1', @ALLROWCNT=20;
 
select * from USERDATA.TMP_REC_CB where user_id='USE000005'


-- Zsolti


exec control.add_user @username='Zsolti_full', @pw='boi';
GO

/* 5. 6. add test ratings then UF*/

declare @userid varchar(30);
set @userid='USE000006';

select stmnt from 
(select 'exec control.add_rating @imdbid='''+imdb_id+''', @userid='''+@userid+''', @rating='+cast(rating as varchar)+';' as stmnt, rank() over (order by imdb_id) as rnk from 
(
select 'tt7984734' as imdb_id, 95 as rating union all
select 'tt2584384' as imdb_id, 78 as rating union all
select 'tt3465916' as imdb_id, 70 as rating union all
select 'tt0490086' as imdb_id, 45 as rating union all
select 'tt2543164' as imdb_id, 72 as rating union all
select 'tt0072890' as imdb_id, 75 as rating union all
select 'tt0106856' as imdb_id, 80 as rating union all
select 'tt0091251' as imdb_id, 75 as rating union all
select 'tt0113264' as imdb_id, 10 as rating union all
select 'tt0033467' as imdb_id, 85 as rating union all
select 'tt8613070' as imdb_id, 95 as rating union all
select 'tt0073486' as imdb_id, 85 as rating union all
select 'tt0470752' as imdb_id, 74 as rating union all
select 'tt1798709' as imdb_id, 60 as rating union all
select 'tt0060827' as imdb_id, 75 as rating union all
select 'tt0488120' as imdb_id, 71 as rating union all
select 'tt0118971' as imdb_id, 67 as rating union all
select 'tt0034583' as imdb_id, 100 as rating union all
select 'tt0075467' as imdb_id, 74 as rating union all
select 'tt8648880' as imdb_id, 80 as rating union all
select 'tt5871080' as imdb_id, 59 as rating union all
select 'tt4975280' as imdb_id, 30 as rating union all
select 'tt6723592' as imdb_id, 87 as rating union all
select 'tt0810913' as imdb_id, 25 as rating union all
select 'tt0067023' as imdb_id, 80 as rating union all
select 'tt1979320' as imdb_id, 85 as rating union all
select 'tt0067927' as imdb_id, 50 as rating union all
select 'tt2948372' as imdb_id, 90 as rating union all
select 'tt0079261' as imdb_id, 85 as rating union all
select 'tt0079501' as imdb_id, 72 as rating union all
select 'tt0067116' as imdb_id, 45 as rating union all
select 'tt10288566' as imdb_id, 90 as rating union all
select 'tt1148204' as imdb_id, 65 as rating union all
select 'tt0070047' as imdb_id, 95 as rating union all
select 'tt10633456' as imdb_id, 70 as rating union all
select 'tt6751668' as imdb_id, 88 as rating union all
select 'tt0084787' as imdb_id, 85 as rating union all
select 'tt3037164' as imdb_id, 85 as rating union all
select 'tt0067866' as imdb_id, 69 as rating union all
select 'tt1675434' as imdb_id, 90 as rating union all
select 'tt0070735' as imdb_id, 60 as rating union all
select 'tt0064665' as imdb_id, 89 as rating union all
select 'tt0290673' as imdb_id, 35 as rating union all
select 'tt1273235' as imdb_id, 15 as rating union all
select 'tt0437086' as imdb_id, 65 as rating union all
select 'tt0070666' as imdb_id, 70 as rating union all
select 'tt11271038' as imdb_id, 80 as rating union all
select 'tt0092890' as imdb_id, 69 as rating union all
select 'tt0268695' as imdb_id, 55 as rating union all
select 'tt0780504' as imdb_id, 85 as rating union all
select 'tt0056663' as imdb_id, 58 as rating 
) boti_full )inner_1

/* 5. 7. RUN UF*/

exec control.ADD_USERFEATURE @userid='USE000007';

exec  control.LoadRecCB @USERID='USE000007', @CB_TYPE='BASIC_1', @ALLROWCNT=20;
 
select * from USERDATA.TMP_REC_CB where user_id='USE000007'


-----

----




/*

SELECT * FROM USERDATA.V_TESTING_REC_CB where user_id='USE000002'


select * from log.process




DROP TABLE IF EXISTS CONTROL.BIAS_SETTING;
CREATE TABLE CONTROL.BIAS_SETTING
(  
    RATING_TYPE VARCHAR(30),
    MIN_RATING_SCORE NUMERIC(3),
    AVG_SCORE NUMERIC(3),
    AVG_MIN NUMERIC(3),
    AVG_MAX NUMERIC(3),
    RATING_RANK_MULTIPLIER FLOAT,
    YEAR_SCORE NUMERIC(3),
    VOTING_SCORE NUMERIC(3),
    AVG_VOTING_MIN_PCT NUMERIC(2),
    AVG_VOTING_MAX_PCT NUMERIC(2),
    GLOBAL_MULTIPLIER NUMERIC(5,2)
);

GO

INSERT INTO CONTROL.BIAS_SETTING VALUES('IMDB', 50, 40, 5, 8, 1, 60, 80, 30, 30, 1);
INSERT INTO CONTROL.BIAS_SETTING VALUES('META', 30, 25, 5, 8, 1, 60, 80, 30, 30,1 );
INSERT INTO CONTROL.BIAS_SETTING VALUES('TOM', 30, 25, 5, 8, 1, 60, 80, 30, 30, 1);
INSERT INTO CONTROL.BIAS_SETTING VALUES('TOM_USER', 30, 25, 5, 8, 1, 60, 80, 30, 30, 1);


DROP TABLE IF EXISTS CONTROL.FEATURE_SCORE;
CREATE TABLE CONTROL.FEATURE_SCORE
(  
    RATING_TYPE VARCHAR(30),
    ACTOR_SCORE NUMERIC(5,2),
    DIRECTOR_SCORE NUMERIC(5,2),
    WRITER_SCORE NUMERIC(5,2),
    GENRE_SCORE NUMERIC(5,2),
    COUNTRY_SCORE NUMERIC(5,2),
    GLOBAL_MULTIPLIER NUMERIC(5,2)
);

GO 

INSERT INTO CONTROL.FEATURE_SCORE VALUES('BASIC_1', 5, 2, 1.5, 0.3, 0.07, 0.1);

*/




