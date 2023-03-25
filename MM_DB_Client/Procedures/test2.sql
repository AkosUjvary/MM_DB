
/* 1. add full user */

exec control.add_user @username='Boti_full', @pw='boi';


/* 2. add full ratings then UF*/

declare @userid varchar(30);
set @userid='USE000004';

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
select 'tt0470752' as imdb_id, 		85 as rating union all
select 'tt0075467' as imdb_id, 		85 as rating union all
select 'tt1979320' as imdb_id, 		85 as rating union all
select 'tt6751668' as imdb_id, 		85 as rating union all
select 'tt10288566' as imdb_id, 	90 as rating union all
select 'tt1675434' as imdb_id, 		90 as rating union all
select 'tt0073486' as imdb_id, 		92 as rating union all
select 'tt2948372' as imdb_id, 		10 as rating union all
select 'tt0810913' as imdb_id, 		1 as rating union all
select 'tt0268695' as imdb_id, 		55 as rating  ) boti_full )inner_1
--where rnk%2=1

/* 3. add base user */

exec control.add_user @username='Boti_base', @pw='boi';


/* 4. add base ratings then UF*/

declare @userid varchar(30);
set @userid='USE000005';

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
select 'tt0470752' as imdb_id, 		85 as rating union all
select 'tt0075467' as imdb_id, 		85 as rating union all
select 'tt1979320' as imdb_id, 		85 as rating union all
select 'tt6751668' as imdb_id, 		85 as rating union all
select 'tt10288566' as imdb_id, 	90 as rating union all
select 'tt1675434' as imdb_id, 		90 as rating union all
select 'tt0073486' as imdb_id, 		92 as rating union all
select 'tt2948372' as imdb_id, 		10 as rating union all
select 'tt0810913' as imdb_id, 		1 as rating union all
select 'tt0268695' as imdb_id, 		55 as rating  ) boti_full )inner_1
where rnk%2=1


 /* 3. add base user */

exec control.add_user @username='Boti_test', @pw='boi';


/* 4. add base ratings then UF*/

declare @userid varchar(30);
set @userid='USE000006';

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
select 'tt0470752' as imdb_id, 		85 as rating union all
select 'tt0075467' as imdb_id, 		85 as rating union all
select 'tt1979320' as imdb_id, 		85 as rating union all
select 'tt6751668' as imdb_id, 		85 as rating union all
select 'tt10288566' as imdb_id, 	90 as rating union all
select 'tt1675434' as imdb_id, 		90 as rating union all
select 'tt0073486' as imdb_id, 		92 as rating union all
select 'tt2948372' as imdb_id, 		10 as rating union all
select 'tt0810913' as imdb_id, 		1 as rating union all
select 'tt0268695' as imdb_id, 		55 as rating  ) boti_full )inner_1
where rnk%2=0




exec control.ADD_USERFEATURE @userid='USE000003';
exec control.ADD_USERFEATURE @userid='USE000004';
exec control.ADD_USERFEATURE @userid='USE000005';