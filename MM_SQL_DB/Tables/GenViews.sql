/*
 ------------------------------------- MM CREATE VIEWS SCRIPT -------------------------------------
|                                                                                                  |
| Name: GenViews.sql                                                                               |
| Created: Akos Ujvary                                                                             |
| Last modified: 2023.03.18 - v1.5 - Fix IMDB_VOTES ranking with isnumeric (newers are N/A)        |   
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
