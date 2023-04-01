/*
 ------------------------------------- MM CREATE VIEWS SCRIPT -------------------------------------
|                                                                                                  |
| Name: GenViews.sql                                                                               |
| Created: Akos Ujvary                                                                             |
| Last modified: 2023.04.01 - v1.6 - Adding V_FIXED_STAGE_HUN_NAMES, V_FIXED_MOVIEDATA_HUN_NAMES   |
|                2023.03.18 - v1.5 - Fix IMDB_VOTES ranking with isnumeric (newers are N/A)        |   
|                2023.03.03 - v1.4 - Modify MOVIEDATA.V_STAGE_MD_DUPLICATIONS (prioritize VOTES )  |
|                2022.12.28 - v1.3 - Adding MOVIEDATA.V_STAGE_MD_DUPLICATIONS                      |
|                2022.11.28 - v1.2 - Adding MOVIEDATA.V_STAGE_FROM_MD                              |
|                2022.10.10 - v1.1 - Adding keyword                                                |
|                2017.08.20 - Creation                                                             |
 --------------------------------------------------------------------------------------------------
*/

CREATE OR ALTER VIEW control.V_MOVIEDATA_SCHEMA_COL_STRUCT
AS
select
         COLUMN_NAME,
         IS_NULLABLE,
         DATA_TYPE,
         CHARACTER_MAXIMUM_LENGTH,
         NUMERIC_PRECISION,
         NUMERIC_SCALE
  from INFORMATION_SCHEMA.COLUMNS where  UPPER(table_name) in (
                                                'COUNTRY',
                                                'MOVIE',
                                                'GENRE',
                                                'ACTOR',
                                                'DIRECTOR',
                                                'WRITER',
                                                /* So v1,1 */
                                                'KEYWORD'                                                
                                                /* Eo v1,1 */
                                                )
                           and UPPER(table_schema) in ('MOVIEDATA')
                           and UPPER(column_name) not in (
                                                'ACTOR_ID',
                                                'COUNTRY_ID',
                                                'DIRECTOR_ID',
                                                'MOVIE_ID',
                                                'GENRE_ID',
                                                'WRITER_ID',
                                                /* So v1,1 */
                                                'KEYWORD_ID'
                                                /* Eo v1,1 */
                                               );

GO

CREATE OR ALTER VIEW MOVIEDATA.V_STAGE_FROM_MD
AS
(SELECT 
	CAST(MOV.[IMDB_ID] as VARCHAR) as IMDB_ID, 
       CAST(MOV.[MOVIE_ID] AS VARCHAR) AS MOVIE_ID,
	CAST(MOV.[TITLE_NM] as VARCHAR) as TITLE ,
	CAST(MOV.[TITLE_ALT_NM] as VARCHAR) as TITLE_ALT,
	CAST(MOV.[RELEASE_YEAR] as VARCHAR) as RELEASE_YEAR, 
       CAST(control.f_mm_distinctStringArray(string_agg(GENRE.GENRE_NM, ','), ',', 'Y') as VARCHAR(5000)) as GENRES,
       CAST(control.f_mm_distinctStringArray(string_agg(COUNTRY.COUNTRY_NM, ','), ',', 'Y') as VARCHAR(5000)) as COUNTRY,
       CAST(control.f_mm_distinctStringArray(string_agg(ACTOR.ACTOR_NM, ','), ',', 'Y') as VARCHAR(5000)) as ACTORS,
       CAST(control.f_mm_distinctStringArray(string_agg(DIRECTOR.DIRECTOR_NM, ','), ',', 'Y') as VARCHAR(5000)) as DIRECTORS,
       CAST(control.f_mm_distinctStringArray(string_agg(WRITER.WRITER_NM, ','), ',', 'Y') as VARCHAR(5000)) as WRITERS,
	CAST(MOV.[IMDB_RATING] as VARCHAR) as IMDB_RATING, 
	CAST(MOV.[IMDB_VOTES] as VARCHAR) as IMDB_VOTES,
	CAST(MOV.[METASCORE] as VARCHAR) as METASCORE, 
	CAST(MOV.[TOMATOMETER] as VARCHAR) as TOMATOMETER,  
	CAST(MOV.[TOMATO_USER_METER] as VARCHAR) as TOMATO_USER_METER,  
	CAST(MOV.[TOMATO_USER_REVIEWS] as VARCHAR) as TOMATO_USER_REVIEWS, 
       CAST(control.f_mm_distinctStringArray(string_agg(KW.KEYWORD_NM, ','), ',', 'Y') as VARCHAR(5000)) as KEYWORDS,
       CAST(MOV.[RELEASE_DATE] as VARCHAR(5000))  as RELEASE_DATE,
	CAST(MOV.[RUNTIME] as VARCHAR(5000))  as RUNTIME,
	CAST(MOV.[PLOT] as VARCHAR(5000))  as PLOT,
	CAST(MOV.[AWARDS] as VARCHAR(5000)) as AWARDS,
	CAST(MOV.[POSTER] as VARCHAR(5000)) as POSTER 
 
FROM MOVIEDATA.MOVIE MOV
LEFT JOIN MOVIEDATA.MOVIEFEATURE MF ON MF.MOVIE_ID=MOV.MOVIE_ID
LEFT JOIN MOVIEDATA.ACTOR ACTOR ON MF.FEATURE_ID=ACTOR.ACTOR_ID AND MF.FEATURE_CD='A'
LEFT JOIN MOVIEDATA.COUNTRY COUNTRY ON MF.FEATURE_ID=COUNTRY.COUNTRY_ID AND MF.FEATURE_CD='C'
LEFT JOIN MOVIEDATA.GENRE GENRE ON MF.FEATURE_ID=GENRE.GENRE_ID AND MF.FEATURE_CD='G'
LEFT JOIN MOVIEDATA.DIRECTOR DIRECTOR ON MF.FEATURE_ID=DIRECTOR.DIRECTOR_ID AND MF.FEATURE_CD='D'
LEFT JOIN MOVIEDATA.WRITER WRITER ON MF.FEATURE_ID=WRITER.WRITER_ID AND MF.FEATURE_CD='W'

LEFT JOIN MOVIEDATA.KEYWORDFEATURE KWF ON KWF.MOVIE_ID=MOV.MOVIE_ID
LEFT JOIN MOVIEDATA.KEYWORD KW ON KW.KEYWORD_ID=KWF.KEYWORD_ID

GROUP BY 
	MOV.[MOVIE_ID], 
	MOV.[IMDB_ID], 
	MOV.[TITLE_NM] ,
	MOV.[TITLE_ALT_NM] ,
	MOV.[RELEASE_YEAR],  
	MOV.[IMDB_RATING] , 
	MOV.[IMDB_VOTES] ,
	MOV.[METASCORE] , 
	MOV.[TOMATOMETER],  
	MOV.[TOMATO_USER_METER],  
	MOV.[TOMATO_USER_REVIEWS] , 
	MOV.[RELEASE_DATE]  ,
	MOV.[RUNTIME]  ,
	MOV.[PLOT]  ,
	MOV.[AWARDS] ,
	MOV.[POSTER]  ,
	MOV.[RUN_DTTM]);

GO
 
CREATE OR ALTER VIEW MOVIEDATA.V_STAGE_MD_DUPLICATIONS
AS
(     
       SELECT * FROM  
       (SELECT  
       ROW_NUMBER() OVER (PARTITION BY IMDB_ID
              ORDER BY
              IIF(LOAD_TYPE='CORR', 1, 2),
              LEN(TITLE) DESC,
              LEN(IIF(TITLE=TITLE_ALT, '', TITLE_ALT)) DESC,
              IIF(LEN(RELEASE_YEAR)>0, 1, 0) DESC,
              LEN(GENRES) DESC,
              LEN(COUNTRY) DESC,
              LEN(ACTORS) DESC,
              LEN(DIRECTORS) DESC,
              LEN(WRITERS) DESC,
              IIF(ISNUMERIC(IMDB_VOTES)=1,(CAST(COALESCE(IMDB_VOTES,0) as numeric)),0) DESC,
              IIF(LEN(IMDB_RATING)>0, 1, 0) DESC,              
              LEN(METASCORE) DESC,
              LEN(TOMATOMETER) DESC,
              LEN(KEYWORDS) DESC,
              IIF(LEN(RELEASE_DATE)>0, 1, 0) DESC,
              IIF(LEN(RUNTIME)>0, 1, 0) DESC,
              LEN(PLOT) DESC,
              LEN(AWARDS) DESC,
              IIF(LEN(POSTER)>0, 1, 0) DESC,
              IIF(TYP='OLD', 2, 1) ASC -- Prefer newer. Handy when release_date might change during ong loadings.
              ) as RNK,
       UN.* FROM ( 
       select 'OLD' as TYP, LOAD_TYPE='STNDRD', OLD.* from  (select * from MOVIEDATA.V_STAGE_FROM_MD where imdb_id in (select imdb_id from stage.moviedata)) OLD
       union all
       select 'NEW' as TYP, 
                     LOAD_TYPE,                    
                     IMDB_ID,
                      '' AS MOVIE_ID,                     
                     TITLE,
                     TITLE_ALT,
                     RELEASE_YEAR,
                     GENRES,
                     COUNTRY,
                     ACTORS,
                     DIRECTORS,
                     WRITERS,
                     IMDB_RATING,
                     IMDB_VOTES,
                     METASCORE,
                     TOMATOMETER,
                     TOMATO_USER_METER,
                     TOMATO_USER_REVIEWS,
                     KEYWORDS,
                     RELEASE_DATE,
                     RUNTIME,
                     PLOT,
                     AWARDS,
                     POSTER
       from STAGE.MOVIEDATA NEW
       ) UN )DUPL_LIST
);
GO

CREATE OR ALTER VIEW CONTROL.V_FIXED_MOVIEDATA_HUN_NAMES
AS
with ekezetes_nevek as (
    select name as hun_name, 
         --upper(name) as name_0,
         replace(replace(upper(name), N'Ő', 'O'), N'Ű', 'Ü') as try_name_1,
         replace(replace(upper(name), N'Ő', 'Õ'), N'Ű', 'Ü') as try_name_2, 
         replace(replace(upper(name), N'Ő', 'Ö'), N'Ű', 'Ü') as try_name_3
   
         from control.hungarian_first_name_list
    where upper(name) like N'%Ő%' or upper(name) like N'%Ű%'
)

,actor_hun as (
    select base.*,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.actor_nm, ' ')) a where rn=1) as first_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.actor_nm, ' ')) a where rn=2) as second_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.actor_nm, ' ')) a where rn=3) as third_name 
    from
    (select distinct actor.*  from moviedata.movie mov
    inner join (select * from moviedata.moviefeature where feature_cd='C') mf_country
        on mf_country.MOVIE_ID=mov.MOVIE_ID
    inner join (select COUNTRY_ID from moviedata.COUNTRY where country_nm='Hungary') country 
        on country.COUNTRY_ID=mf_country.FEATURE_ID
    inner join  (select * from moviedata.moviefeature where feature_cd='A') mf_actor
        on mov.MOVIE_ID=mf_actor.movie_ID
    inner join  moviedata.actor actor
        on actor.actor_ID=mf_actor.FEATURE_ID) base
)

,actor_NO_hun as (
    select distinct actor.* from moviedata.movie mov
    inner join (select * from moviedata.moviefeature where feature_cd='C') mf_country
        on mf_country.MOVIE_ID=mov.MOVIE_ID
    inner join (select COUNTRY_ID from moviedata.COUNTRY where country_nm!='Hungary') country 
        on country.COUNTRY_ID=mf_country.FEATURE_ID
    inner join  (select * from moviedata.moviefeature where feature_cd='A') mf_actor
        on mov.MOVIE_ID=mf_actor.movie_ID
    inner join  moviedata.actor actor
        on actor.actor_ID=mf_actor.FEATURE_ID
)

,director_hun as (
    select base.*,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.director_nm, ' ')) a where rn=1) as first_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.director_nm, ' ')) a where rn=2) as second_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.director_nm, ' ')) a where rn=3) as third_name 
    from
    (
  select distinct dir.* from moviedata.movie mov
    inner join (select * from moviedata.moviefeature where feature_cd='C') mf_country
        on mf_country.MOVIE_ID=mov.MOVIE_ID
    inner join (select COUNTRY_ID from moviedata.COUNTRY where country_nm='Hungary') country 
        on country.COUNTRY_ID=mf_country.FEATURE_ID
    inner join  (select * from moviedata.moviefeature where feature_cd='D') mf_dir
        on mov.MOVIE_ID=mf_dir.movie_ID
    inner join  moviedata.director dir
        on dir.director_ID=mf_dir.FEATURE_ID) base
)

,director_NO_hun as (
    select distinct dir.* from moviedata.movie mov
    inner join (select * from moviedata.moviefeature where feature_cd='C') mf_country
        on mf_country.MOVIE_ID=mov.MOVIE_ID
    inner join (select COUNTRY_ID from moviedata.COUNTRY where country_nm!='Hungary') country 
        on country.COUNTRY_ID=mf_country.FEATURE_ID
    inner join  (select * from moviedata.moviefeature where feature_cd='D') mf_dir
        on mov.MOVIE_ID=mf_dir.movie_ID
    inner join  moviedata.director dir
        on dir.director_ID=mf_dir.FEATURE_ID
)

,writer_hun as (
    select base.*,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.writer_nm, ' ')) a where rn=1) as first_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.writer_nm, ' ')) a where rn=2) as second_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.writer_nm, ' ')) a where rn=3) as third_name 
    from
    (
    select distinct writer.* from moviedata.movie mov
    inner join (select * from moviedata.moviefeature where feature_cd='C') mf_country
        on mf_country.MOVIE_ID=mov.MOVIE_ID
    inner join (select COUNTRY_ID from moviedata.COUNTRY where country_nm='Hungary') country 
        on country.COUNTRY_ID=mf_country.FEATURE_ID
    inner join  (select * from moviedata.moviefeature where feature_cd='W') mf_writer
        on mov.MOVIE_ID=mf_writer.movie_ID
    inner join  moviedata.writer writer
        on writer.writer_ID=mf_writer.FEATURE_ID) base
)

,writer_NO_hun as (
    select distinct writer.* from moviedata.movie mov
    inner join (select * from moviedata.moviefeature where feature_cd='C') mf_country
        on mf_country.MOVIE_ID=mov.MOVIE_ID
    inner join (select COUNTRY_ID from moviedata.COUNTRY where country_nm!='Hungary') country 
        on country.COUNTRY_ID=mf_country.FEATURE_ID
    inner join  (select * from moviedata.moviefeature where feature_cd='W') mf_writer
        on mov.MOVIE_ID=mf_writer.movie_ID
    inner join  moviedata.writer writer
        on writer.writer_ID=mf_writer.FEATURE_ID
)

select first_fixed_name+' '+second_fixed_name+' '+third_fixed_name as full_fixed_name,
        main_sel.* from  
(select 
    'A' as type,
    actor.actor_id as id,
    actor.actor_nm as orig_name,
    hunnames.*,
    coalesce((case 
        when (upper(hunnames.try_name_1)=upper(actor.first_name) 
          or upper(hunnames.try_name_2)=upper(actor.first_name)
          or upper(hunnames.try_name_3)=upper(actor.first_name))
        then hunnames.hun_name
    end),actor.first_name, '') as first_fixed_name, 
    coalesce((case 
        when (upper(hunnames.try_name_1)=upper(actor.second_name) 
          or upper(hunnames.try_name_2)=upper(actor.second_name)
          or upper(hunnames.try_name_3)=upper(actor.second_name))
        then hunnames.hun_name 
    end),actor.second_name, '') as second_fixed_name, 
    coalesce((case 
        when (upper(hunnames.try_name_1)=upper(actor.third_name) 
          or upper(hunnames.try_name_2)=upper(actor.third_name)
          or upper(hunnames.try_name_3)=upper(actor.third_name))
        then hunnames.hun_name 
    end),actor.third_name, '') as third_fixed_name 
from actor_hun actor
inner join ekezetes_nevek hunnames
on       upper(hunnames.try_name_1)=upper(actor.first_name)
    or   upper(hunnames.try_name_1)=upper(actor.second_name)
    or   upper(hunnames.try_name_1)=upper(actor.third_name)

    or   upper(hunnames.try_name_2)=upper(actor.first_name)
    or   upper(hunnames.try_name_2)=upper(actor.second_name)
    or   upper(hunnames.try_name_2)=upper(actor.third_name)

    or   upper(hunnames.try_name_3)=upper(actor.first_name)
    or   upper(hunnames.try_name_3)=upper(actor.second_name)
    or   upper(hunnames.try_name_3)=upper(actor.third_name) 

union all 

select 
    'D' as type,
    dir.director_id as id,
    dir.director_nm as orig_name,
    hunnames.*,
    COALESCE((case 
        when (upper(hunnames.try_name_1)=upper(dir.first_name) 
          or upper(hunnames.try_name_2)=upper(dir.first_name)
          or upper(hunnames.try_name_3)=upper(dir.first_name))
        then hunnames.hun_name
    end), dir.first_name, '') as first_fixed_name, 
    COALESCE((case 
        when (upper(hunnames.try_name_1)=upper(dir.second_name) 
          or upper(hunnames.try_name_2)=upper(dir.second_name)
          or upper(hunnames.try_name_3)=upper(dir.second_name))
        then hunnames.hun_name
    end), dir.second_name, '') as second_fixed_name, 
    COALESCE((case 
        when (upper(hunnames.try_name_1)=upper(dir.third_name) 
          or upper(hunnames.try_name_2)=upper(dir.third_name)
          or upper(hunnames.try_name_3)=upper(dir.third_name))
        then hunnames.hun_name
    end), dir.third_name, '') as third_fixed_name 
    
from director_hun dir
inner join ekezetes_nevek hunnames
on       upper(hunnames.try_name_1)=upper(dir.first_name)
    or   upper(hunnames.try_name_1)=upper(dir.second_name)
    or   upper(hunnames.try_name_1)=upper(dir.third_name)

    or   upper(hunnames.try_name_2)=upper(dir.first_name)
    or   upper(hunnames.try_name_2)=upper(dir.second_name)
    or   upper(hunnames.try_name_2)=upper(dir.third_name)

    or   upper(hunnames.try_name_3)=upper(dir.first_name)
    or   upper(hunnames.try_name_3)=upper(dir.second_name)
    or   upper(hunnames.try_name_3)=upper(dir.third_name)
 

union all

select 'W' as type,
         writer.writer_id as id,
         writer.writer_nm as orig_name,
         hunnames.*,
    coalesce((case 
        when (upper(hunnames.try_name_1)=upper(writer.first_name) 
          or upper(hunnames.try_name_2)=upper(writer.first_name)
          or upper(hunnames.try_name_3)=upper(writer.first_name))
        then hunnames.hun_name 
    end), writer.first_name, '') as first_fixed_name, 
    coalesce((case 
        when (upper(hunnames.try_name_1)=upper(writer.second_name) 
          or upper(hunnames.try_name_2)=upper(writer.second_name)
          or upper(hunnames.try_name_3)=upper(writer.second_name))
        then hunnames.hun_name
    end), writer.second_name, '') as second_fixed_name, 
    coalesce((case 
        when (upper(hunnames.try_name_1)=upper(writer.third_name) 
          or upper(hunnames.try_name_2)=upper(writer.third_name)
          or upper(hunnames.try_name_3)=upper(writer.third_name))
        then hunnames.hun_name
    end), writer.third_name, '') as third_fixed_name 

from writer_hun writer
inner join ekezetes_nevek hunnames
on       upper(hunnames.try_name_1)=upper(writer.first_name)
    or   upper(hunnames.try_name_1)=upper(writer.second_name)
    or   upper(hunnames.try_name_1)=upper(writer.third_name)

    or   upper(hunnames.try_name_2)=upper(writer.first_name)
    or   upper(hunnames.try_name_2)=upper(writer.second_name)
    or   upper(hunnames.try_name_2)=upper(writer.third_name)

    or   upper(hunnames.try_name_3)=upper(writer.first_name)
    or   upper(hunnames.try_name_3)=upper(writer.second_name)
    or   upper(hunnames.try_name_3)=upper(writer.third_name)
) main_sel
;
GO


CREATE OR ALTER VIEW CONTROL.V_FIXED_STAGE_HUN_NAMES
AS
with ekezetes_nevek as (
    select name as hun_name,          
         replace(replace(upper(name), N'Ő', 'O'), N'Ű', 'Ü') as try_name_1,
         replace(replace(upper(name), N'Ő', 'Õ'), N'Ű', 'Ü') as try_name_2, 
         replace(replace(upper(name), N'Ő', 'Ö'), N'Ű', 'Ü') as try_name_3
   
         from control.hungarian_first_name_list
    where upper(name) like N'%Ő%' or upper(name) like N'%Ű%'
),

actor_hun as (
select base.*,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.actor_nm, ' ')) a where rn=1) as first_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.actor_nm, ' ')) a where rn=2) as second_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.actor_nm, ' ')) a where rn=3) as third_name 
    from
    (    
        select * from (
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=1) as actor_nm,
                1 as rn
            from (select imdb_id, max(ACTORS) as actors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=2) as actor_nm,
                2 as rn
            from (select imdb_id, max(ACTORS) as actors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=3) as actor_nm,
                3 as rn
            from (select imdb_id, max(ACTORS) as actors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=4) as actor_nm,
                4 as rn
            from (select imdb_id, max(ACTORS) as actors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=5) as actor_nm,
                5 as rn
            from (select imdb_id, max(ACTORS) as actors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=6) as actor_nm,
                6 as rn
            from (select imdb_id, max(ACTORS) as actors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage) actors_with_rn

    ) base
  WHERE ACTOR_NM IS NOT NULL
),

director_hun as (
select base.*,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.director_nm, ' ')) a where rn=1) as first_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.director_nm, ' ')) a where rn=2) as second_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.director_nm, ' ')) a where rn=3) as third_name 
    from
    (    
        select * from (
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.directors, ',')) a where rn=1) as director_nm,
                1 as rn
            from (select imdb_id, max(directors) as directors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.directors, ',')) a where rn=2) as director_nm,
                2 as rn
            from (select imdb_id, max(directors) as directors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.directors, ',')) a where rn=3) as director_nm,
                3 as rn
            from (select imdb_id, max(directors) as directors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.directors, ',')) a where rn=4) as director_nm,
                4 as rn
            from (select imdb_id, max(directors) as directors from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        ) directors_with_rn
    ) base
  WHERE DIRECTOR_NM IS NOT NULL
),

writer_hun as (
select base.*,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.writer_nm, ' ')) a where rn=1) as first_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.writer_nm, ' ')) a where rn=2) as second_name,
        (select value from (select value, row_number() over (order by (select 1)) as rn from  string_split(base.writer_nm, ' ')) a where rn=3) as third_name 
    from
    (    
        select * from (
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.writers, ',')) a where rn=1) as writer_nm,
                1 as rn
            from (select imdb_id, max(writers) as writers from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.writers, ',')) a where rn=2) as writer_nm,
                2 as rn
            from (select imdb_id, max(writers) as writers  from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.writers, ',')) a where rn=3) as writer_nm,
                3 as rn
            from (select imdb_id, max(writers) as writers  from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.writers, ',')) a where rn=4) as writer_nm,
                4 as rn
            from (select imdb_id, max(writers) as writers from STAGE.TMP_MOVIEDATA where country like '%Hungary%' or country='N/A' and load_type='STNDRD' group by imdb_id) stage 
        ) writers_with_rn
    ) base
  WHERE WRITER_NM IS NOT NULL 
)

SELECT CORRECTED_NAMES.IMDB_ID,
        (CASE WHEN TYPE='A' THEN FULL_FIXED_NAME ELSE NULL END) AS ACTORS,
        (CASE WHEN TYPE='D' THEN FULL_FIXED_NAME ELSE NULL END) AS DIRECTORS,
        (CASE WHEN TYPE='W' THEN FULL_FIXED_NAME ELSE NULL END) AS WRITERS
 FROM  (
    select IMDB_ID, TYPE, MAX(HUN_NAME) AS HUN_NAME, STRING_AGG(first_fixed_name+second_fixed_name+third_fixed_name, ', ') WITHIN GROUP (ORDER BY RN ASC) as FULL_FIXED_NAME
            from  
    (select 
        actor.imdb_id,
        'A' as type,
        RN,
        actor.actor_nm as orig_name,
        hunnames.*,
        coalesce((case 
            when (upper(hunnames.try_name_1)=upper(actor.first_name) 
            or upper(hunnames.try_name_2)=upper(actor.first_name)
            or upper(hunnames.try_name_3)=upper(actor.first_name))
            then hunnames.hun_name
        end),actor.first_name, '') as first_fixed_name, 
        coalesce((case 
            when (upper(hunnames.try_name_1)=upper(actor.second_name) 
            or upper(hunnames.try_name_2)=upper(actor.second_name)
            or upper(hunnames.try_name_3)=upper(actor.second_name))
            then ' '+hunnames.hun_name 
        end),' '+actor.second_name, '') as second_fixed_name, 
        coalesce((case 
            when (upper(hunnames.try_name_1)=upper(actor.third_name) 
            or upper(hunnames.try_name_2)=upper(actor.third_name)
            or upper(hunnames.try_name_3)=upper(actor.third_name))
            then ' '+hunnames.hun_name 
        end),' '+actor.third_name, '') as third_fixed_name 
    from actor_hun actor
    LEFT join ekezetes_nevek hunnames --TODO: ahol egyik színész ékezetes, ott a fullos listát hozza le sorrenddel (RN)
    on       upper(hunnames.try_name_1)=upper(actor.first_name)
        or   upper(hunnames.try_name_1)=upper(actor.second_name)
        or   upper(hunnames.try_name_1)=upper(actor.third_name)

        or   upper(hunnames.try_name_2)=upper(actor.first_name)
        or   upper(hunnames.try_name_2)=upper(actor.second_name)
        or   upper(hunnames.try_name_2)=upper(actor.third_name)

        or   upper(hunnames.try_name_3)=upper(actor.first_name)
        or   upper(hunnames.try_name_3)=upper(actor.second_name)
        or   upper(hunnames.try_name_3)=upper(actor.third_name) 

    union all 

    select 
        dir.imdb_id,
        'D' as type,
        RN,
        dir.director_nm as orig_name,
        hunnames.*,
        COALESCE((case 
            when (upper(hunnames.try_name_1)=upper(dir.first_name) 
            or upper(hunnames.try_name_2)=upper(dir.first_name)
            or upper(hunnames.try_name_3)=upper(dir.first_name))
            then hunnames.hun_name
        end), dir.first_name, '') as first_fixed_name, 
        COALESCE((case 
            when (upper(hunnames.try_name_1)=upper(dir.second_name) 
            or upper(hunnames.try_name_2)=upper(dir.second_name)
            or upper(hunnames.try_name_3)=upper(dir.second_name))
            then ' '+hunnames.hun_name
        end), ' '+dir.second_name, '') as second_fixed_name, 
        COALESCE((case 
            when (upper(hunnames.try_name_1)=upper(dir.third_name) 
            or upper(hunnames.try_name_2)=upper(dir.third_name)
            or upper(hunnames.try_name_3)=upper(dir.third_name))
            then ' '+hunnames.hun_name
        end), ' '+dir.third_name, '') as third_fixed_name 
        
    from director_hun dir
    LEFT join ekezetes_nevek hunnames
    on       upper(hunnames.try_name_1)=upper(dir.first_name)
        or   upper(hunnames.try_name_1)=upper(dir.second_name)
        or   upper(hunnames.try_name_1)=upper(dir.third_name)

        or   upper(hunnames.try_name_2)=upper(dir.first_name)
        or   upper(hunnames.try_name_2)=upper(dir.second_name)
        or   upper(hunnames.try_name_2)=upper(dir.third_name)

        or   upper(hunnames.try_name_3)=upper(dir.first_name)
        or   upper(hunnames.try_name_3)=upper(dir.second_name)
        or   upper(hunnames.try_name_3)=upper(dir.third_name)
    

    union all

    select 
            writer.imdb_id,
            'W' as type,
            RN,
            writer.writer_nm as orig_name,
            hunnames.*,
        coalesce((case 
            when (upper(hunnames.try_name_1)=upper(writer.first_name) 
            or upper(hunnames.try_name_2)=upper(writer.first_name)
            or upper(hunnames.try_name_3)=upper(writer.first_name))
            then hunnames.hun_name 
        end), writer.first_name, '') as first_fixed_name, 
        coalesce((case 
            when (upper(hunnames.try_name_1)=upper(writer.second_name) 
            or upper(hunnames.try_name_2)=upper(writer.second_name)
            or upper(hunnames.try_name_3)=upper(writer.second_name))
            then ' '+hunnames.hun_name
        end), ' '+writer.second_name, '') as second_fixed_name, 
        coalesce((case 
            when (upper(hunnames.try_name_1)=upper(writer.third_name) 
            or upper(hunnames.try_name_2)=upper(writer.third_name)
            or upper(hunnames.try_name_3)=upper(writer.third_name))
            then ' '+hunnames.hun_name
        end), ' '+writer.third_name, '') as third_fixed_name 

    from writer_hun writer
    LEFT join ekezetes_nevek hunnames
    on       upper(hunnames.try_name_1)=upper(writer.first_name)
        or   upper(hunnames.try_name_1)=upper(writer.second_name)
        or   upper(hunnames.try_name_1)=upper(writer.third_name)

        or   upper(hunnames.try_name_2)=upper(writer.first_name)
        or   upper(hunnames.try_name_2)=upper(writer.second_name)
        or   upper(hunnames.try_name_2)=upper(writer.third_name)

        or   upper(hunnames.try_name_3)=upper(writer.first_name)
        or   upper(hunnames.try_name_3)=upper(writer.second_name)
        or   upper(hunnames.try_name_3)=upper(writer.third_name)
    ) main_sel
    GROUP BY IMDB_ID, TYPE 
) CORRECTED_NAMES
WHERE HUN_NAME IS NOT NULL
;
GO
