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