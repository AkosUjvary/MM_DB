with ekezetes_nevek as (
    select name as hun_name, 
         --upper(name) as name_0,
         replace(replace(upper(name), N'Ő', 'O'), 'Ű', 'Ü') as try_name_1,
         replace(replace(upper(name), N'Ő', 'Õ'), 'Ű', 'Ü') as try_name_2, 
         replace(replace(upper(name), N'Ő', 'Ö'), 'Ű', 'Ü') as try_name_3
   
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


 