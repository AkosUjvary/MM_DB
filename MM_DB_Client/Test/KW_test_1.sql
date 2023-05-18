
WITH 

N_KW AS (
SELECT KWF.MOVIE_ID, KWF.KEYWORD_ID, KEYWORD_NM FROM MOVIEDATA.KEYWORDFEATURE KWF
LEFT JOIN MOVIEDATA.KEYWORD KW ON KW.KEYWORD_ID=KWF.KEYWORD_ID 
),

RNK_KW AS (
 SELECT DISTINCT 
    KEYWORD_ID, 
    CAST(ROUND((100.0 /(COUNT(*) OVER (PARTITION BY KEYWORD_ID))),2)AS FLOAT)   AS SPEC_CNT  
 FROM N_KW  )
 

--SELECT * FROM RNK_KW  

SELECT  
   -- MAIN.MOVIE_ID as MAIN_MOV_ID, MAIN.KEYWORD_NM as MAIN_KW,
   -- NB1_MOV.MOVIE_ID as NB1_MOVIE, NB1_KWS.KEYWORD_ID  as NB1_KW, NB1_KWS.KEYWORD_NM AS NB1_KW_NAME,
   -- RNK_N.SPEC_CNT
    
    --NB1_KWS.KEYWORD_NM, (count(*))  as cnt

    --distinct main.KEYWORD_NM

    distinct main.keyword_nm, rnk_m.SPEC_CNT

        
FROM N_KW MAIN 
LEFT JOIN N_KW NB1_MOV
ON NB1_MOV.KEYWORD_ID=MAIN.KEYWORD_ID
LEFT JOIN N_KW NB1_KWS
ON NB1_MOV.MOVIE_ID=NB1_KWS.MOVIE_ID
LEFT JOIN RNK_KW RNK_N
ON RNK_N.KEYWORD_ID =NB1_KWS.KEYWORD_ID
LEFT JOIN RNK_KW RNK_M
ON RNK_M.KEYWORD_ID =MAIN.KEYWORD_ID 

WHERE 1=1
and MAIN.MOVIE_ID != NB1_MOV.MOVIE_ID
AND MAIN.KEYWORD_ID!=NB1_KWS.KEYWORD_ID


and MAIN.MOVIE_ID='MOV032979'  

-- MOV028394  Rush             
-- 1970s	            0,55
-- formula 1       	50
-- racecar driver  	33,33
-- rivalry	         1,59

-- MOV022312  Felpörgetve      
-- car racing	   5
-- german	      2,56
-- legs	         8,33
-- rookie	      25

-- MOV009998  Le Mans          
-- 24 hours le mans race	50
-- 24 hours of le mans	   50
-- car racing	            5
-- driver	               4,76
-- race car             	20

-- MOV007813  Grand Prix       
-- american abroad	      1,47
-- car crash	            2,33
-- car racing	            5
-- formula 1	            50
-- grand prix	            50

-- MOV023415  Michel Vaillant  
-- 24 hours of le mans	   50
-- le mans	               50
-- race	                  5,56
-- sabotage	               2,5

-- MOV032979 Ford v Ferrari 
-- 24 hours le mans race   50
-- based on book	         1,85
-- based on true story	   0,47
-- car racing	            5
-- motor sports	         25


 --group by NB1_KWS.KEYWORD_NM
--order by 2 desc

 -- select * from moviedata.movie where lower(title_alt_nm) like '%ferrari%'

