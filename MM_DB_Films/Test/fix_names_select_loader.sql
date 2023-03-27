-- base testing

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
            from stage.moviedata stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=2) as actor_nm,
                2 as rn
            from stage.moviedata stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=3) as actor_nm,
                3 as rn
            from stage.moviedata stage
        union all 
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=4) as actor_nm,
                4 as rn
            from stage.moviedata stage
        union all
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=5) as actor_nm,
                5 as rn
            from stage.moviedata stage
        union all
            select 
                imdb_id,
                (select trim(value) from (select value, row_number() over (order by (select 1)) as rn from  string_split(stage.actors, ',')) a where rn=6) as actor_nm,
                6 as rn
            from stage.moviedata stage) actors_with_rn
       

    ) base
 