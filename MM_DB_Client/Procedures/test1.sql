/* 1. reset log */

exec control.reset_log_tables;

/* 2. reset ud */
exec control.reset_ud_tables;

/* 3A add user */
exec control.add_user @username='admin', @pw='god';

/* 4A sign-in */
declare @returnpar varchar(10);
exec control.sign_in @username='admin', @pw='gogd', @rtn=@returnpar output;
select 'sign_in: '+@returnpar;

/* 4A sign-in 2 */
exec control.sign_in @username='admin', @pw='god', @rtn=@returnpar output;
select 'sign_in: '+@returnpar;
 
/* 5A add ratings */ 
exec control.add_rating @imdbid='tt0133093', @userid='USE000001', @rating=90;
exec control.add_rating @imdbid='tt3890160', @userid='USE000001', @rating=70;
exec control.add_rating @imdbid='tt0102685', @userid='USE000001', @rating=75;
/* automatic on */
exec control.ADD_USERFEATURE @userid='USE000001';
exec control.LoadRecCB @USERID='USE000001', @ALLROWCNT=35;
/* automatic off */


/* 3B add user */
exec control.add_user @username='jack', @pw='jackfilmz123';

/* 4B sign-in */
declare @returnpar varchar(10);
exec control.sign_in @username='jack', @pw='jackfilmz123', @rtn=@returnpar output;
select 'sign_in: '+@returnpar;
 
/* 5B add ratings */ 
exec control.add_rating @imdbid='tt2800240', @userid='USE000002', @rating=70;
exec control.add_rating @imdbid='tt0152930', @userid='USE000002', @rating=75;
exec control.add_rating @imdbid='tt0281364', @userid='USE000002', @rating=65;
exec control.add_rating @imdbid='tt1675434', @userid='USE000002', @rating=85;
--exec control.add_rating @imdbid='tt0054215', @userid='USE000002', @rating=85;
--exec control.add_rating @imdbid='tt0081505', @userid='USE000002', @rating=78;

/* automatic on */
exec control.ADD_USERFEATURE @userid='USE000002';
exec control.LoadRecCB @USERID='USE000002', @ALLROWCNT=50;
/* automatic off */


/* 3C add user */
exec control.add_user @username='olduser', @pw='asd';

/* 4C sign-in */
declare @returnpar varchar(10);
exec control.sign_in @username='olduser', @pw='asd', @rtn=@returnpar output;
select 'sign_in: '+@returnpar;
 
/* 5C add ratings */ 
exec control.add_rating @imdbid='tt0052357', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0040746', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0047396', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0038787', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0036342', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0096874', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0101745', @userid='USE000003', @rating=80;
exec control.add_rating @imdbid='tt0107290', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0106941', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0183330', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0303184', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt0088763', @userid='USE000003', @rating=100;
exec control.add_rating @imdbid='tt2379713', @userid='USE000003', @rating=100;


/* automatic on */
exec control.ADD_USERFEATURE @userid='USE000003';
exec control.LoadRecCB @USERID='USE000003', @CB_TYPE='BASIC_1', @ALLROWCNT=50;
/* automatic off */




select * from USERDATA.USR;
select * from USERDATA.RATING;

select * from USERDATA.TMP_REC_CB where user_id='USE000003';


select title_nm, imdb_id, movie_id, country_id, BIASED_FEATURE_SCORE, CAST(ROUND((((30398.00-inner_1.rnk)/30397)*100),2) AS DECIMAL(13,2)) as PRC from
(select title_nm, imdb_id, movie_id, country_id, BIASED_FEATURE_SCORE, rank() over (order by biased_feature_score desc) as rnk from USERDATA.TMP_REC_CB where user_id='USE000003') inner_1


select * from USERDATA.RECOMMENDATION;


select * from log.process 


select 1.00/2


TRUNCATE TABLE CONTROL.BIAS_SETTING;
GO 
/* RATING_TYPE,
    MIN_RATING_SCORE,
    AVG_SCORE,
    AVG_MIN,
    AVG_MAX,
    RATING_RANK_MULTIPLIER,
    YEAR_SCORE,
    VOTING_SCORE,
    AVG_VOTING_MIN_PCT,
    AVG_VOTING_MAX_PCT,
    GLOBAL_MULTIPLIER */
INSERT INTO CONTROL.BIAS_SETTING VALUES('BASIC_1', 'IMDB', 50, 40, 5, 8, 1, 60, 80, 30, 30, 1);
INSERT INTO CONTROL.BIAS_SETTING VALUES('BASIC_1', 'META', 30, 25, 5, 8, 1, 60, 80, 30, 30,1);
INSERT INTO CONTROL.BIAS_SETTING VALUES('BASIC_1', 'TOM', 30, 25, 5, 8, 1, 60, 80, 30, 30, 1);
INSERT INTO CONTROL.BIAS_SETTING VALUES('BASIC_1', 'TOM_USER', 30, 25, 5, 8, 1, 60, 80, 30, 30, 1);

TRUNCATE TABLE CONTROL.FEATURE_SCORE;
GO 
/*   RATING_TYPE, ACTOR_SCORE, DIRECTOR_SCORE, WRITER_SCORE, GENRE_SCORE, COUNTRY_SCORE, GLOBAL MULTIPLIER*/
INSERT INTO CONTROL.FEATURE_SCORE VALUES('BASIC_1', 5, 3, 2, 0.5, 0.6, 0.1);
/* old: A5  G0.5  D2  W1.5 C0.1     */

exec control.LoadRecCB @USERID='USE000003', @CB_TYPE='BASIC_1', @ALLROWCNT=30000;

 

select old_cb.title, old_cb.score, new_cb.biased_feature_score, new_cb.*  from (select * from USERDATA.TMP_REC_CB where user_id='USE000003') new_cb
left join 
(SELECT	'tt0099088' AS IMDB_ID, 	'BTTF 3' AS TITLE,                	            125.926 as score union all
SELECT	'tt1074638' AS IMDB_ID, 	'SKYFALL'  AS TITLE,    	                         71.181 as score union all
SELECT	'tt0096438' AS IMDB_ID, 	'Roger nyúl a pácban' AS TITLE,                    66.796	 as score union all
SELECT	'tt0112346' AS IMDB_ID, 	'Szerelem a Fehér Házban' AS TITLE, 	            63.864 as score union all
SELECT	'tt0116365' AS IMDB_ID, 	'Törjön ki a frász' AS TITLE,     	            60.771 as score union all
SELECT	'tt0093936' AS IMDB_ID, 	'Dupla vagy semmi' AS TITLE,      	            60.694 as score union all	
SELECT	'tt0230011' AS IMDB_ID, 	'Atlantisz: Az elveszett birodalom'	AS TITLE,     60.654 as score union all	
SELECT	'tt0102004' AS IMDB_ID, 	'Jobb ma egy zsaru, mint holnap kettő' AS TITLE, 	58.340 as score union all
SELECT	'tt0164912' AS IMDB_ID, 	'Stuart Little' AS TITLE,                     	58.029	 as score union all
SELECT	'tt0112541' AS IMDB_ID, 	'Blue in the Face' AS TITLE,                  	57.202 as score union all	
SELECT	'tt0081159' AS IMDB_ID, 	'Midnight Madness' AS TITLE,                 	    56.399 as score union all	
SELECT	'tt1235075' AS IMDB_ID, 	'Valami Amerika 2' AS TITLE,                  	56.347 as score union all	
SELECT	'tt0109936' AS IMDB_ID, 	'A pénz boldogít'	AS TITLE,                     55.680 as score union all	
SELECT	'tt0381061' AS IMDB_ID, 	'Casino Royale'  AS TITLE,                    	55.636 as score union all	
SELECT	'tt0097027' AS IMDB_ID, 	'A háború áldozatai' AS TITLE,                	55.461 as score union all	
SELECT	'tt0243585' AS IMDB_ID, 	'Stuart Little 2'  AS TITLE,                      55.297 as score union all	
SELECT	'tt0398237' AS IMDB_ID, 	'Nyócker' AS TITLE,                           	42.950 as score union all
SELECT	'tt0338801' AS IMDB_ID, 	'Boldog születésnapot'	AS TITLE,                 32.170	 as score union all
SELECT	'tt0379071' AS IMDB_ID, 	'Terézanyu' AS TITLE,                         	31.438	 as score union all
SELECT	'tt0141742' AS IMDB_ID, 	'Presszó'AS TITLE, 	                            31.127	 as score)  old_cb
on old_cb.IMDB_ID=new_cb.IMDB_ID

