
-- hibás rekordok
select err.nature_key_value, err.FAILED_COLUMN as imdb_id, err.FAILED_COLUMN_VALUE from log.loading_error  err
where err_type = 'FORMAT'
and nature_key_value not in (select imdb_id from moviedata.movie)
and nature_key_value not in ('tt0036126','tt0086545','tt7661266', 'tt14882302', 'tt8132778', 'tt8431078') --kivételek, nem lehetett korrekciózni mert már törölve voltak a csv-ből
 

-- betöltött filmek éves bontásban
select count(*) as cnt, release_year from moviedata.movie 
group by release_year
order by release_year desc


-- futási idők
select pr_id, detail_msg,
trim(str(DATEDIFF(minute, start_dttm, end_dttm))) +':'+ 
iif(len(trim(str(DATEDIFF(second, start_dttm, end_dttm)%60)))>1, 
    trim(str(DATEDIFF(second, start_dttm, end_dttm)%60)),
    '0'+trim(str(DATEDIFF(second, start_dttm, end_dttm)%60))) as futas_ido,
    start_dttm,
    end_dttm 
from
(
select lgp.*, detail_msg from 
(select pr_id, min(run_dttm) as start_dttm, max(run_dttm) as end_dttm from log.process lgp
where name='LoadMovieData'
group by pr_id) lgp
inner join 
(select detail_msg, pr_id from log.process where step_id=5) mov_cnt
on mov_cnt.pr_id=lgp.pr_id
) sel_1
order by pr_id desc

 


-- havi kimutatások

select  month(release_date) as month, sum(imdb_votes) votes from moviedata.movie 
where release_year>2015
group by month(release_date)
order by month(release_date)

select  month(release_date) as month, count(*) films from moviedata.movie 
where release_year>2015
group by month(release_date)
order by month(release_date)


 

 