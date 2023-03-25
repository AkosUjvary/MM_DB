/*
 --------------------------------------------- MM TRANSPOSE PROCEDURE --------------------------------------------------------------------
|                                                                                                                                         |
| Name: MM_Transpose.sql                                                                                                                  |
| Created: Akos Ujvary                                                                                                                    |
|                                                                                                                                         |
| Desc :  Creates transposed view based on the input view and the given key                                                               |
|                                                                                                                                         |
| Last modified: 2022.08.29   Creation                                                                                                    |        
 -----------------------------------------------------------------------------------------------------------------------------------------
*/ 


CREATE OR ALTER PROCEDURE control.f_mm_transpose(@inputViewSchema varchar(50), @inputViewName varchar(100), @idCol varchar(100), @SEPARATOR VARCHAR(10)='__', @outputViewSchema varchar(50), @outputViewName varchar(100))
WITH EXECUTE AS CALLER
AS
BEGIN


DECLARE @GEN_FINAL_SQL VARCHAR(MAX);
SET @GEN_FINAL_SQL ='';

DECLARE @inputViewColumns VARCHAR(MAX);
SELECT @inputViewColumns=STRING_AGG(COLUMN_NAME+' AS '+ COLUMN_NAME, ', ')+',' FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_SCHEMA) = @inputViewSchema AND UPPER(TABLE_NAME)=@inputViewName AND COLUMN_NAME !=@idCol;
--PRINT @inputViewColumns;

DECLARE @SQL_TEST NVARCHAR(MAX);
SET @SQL_TEST='
 select @out_sql_result=GEN_FINAL_SQL from 
 (SELECT  STRING_AGG(CONVERT(VARCHAR(MAX), REPLACE((CASE WHEN NUM=1 THEN GEN_SQL_1 ELSE GEN_SQL_2 END), '', FROM'', '' FROM'')), '' '') AS GEN_FINAL_SQL FROM 
(SELECT INPUT_VIEW.'+@idCol+',
  ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS NUM,
  ''SELECT * FROM (SELECT ''+REPLACE('''+@inputViewColumns+''', '','', '''+@SEPARATOR+'''+'+@idCol+'+'','')+'' FROM '+@inputViewSchema+'.'+@inputViewName+' WHERE UPPER(''+'''+@idCol+'''+'') = UPPER(''''''+'+@idCol+'+'''''')) AL_''+'+@idCol+'+'' '' AS GEN_SQL_1,
  ''LEFT JOIN (SELECT ''+REPLACE('''+@inputViewColumns+''', '','', '''+@SEPARATOR+'''+'+@idCol+'+'','')+'' FROM '+@inputViewSchema+'.'+@inputViewName+' WHERE UPPER(''+'''+@idCol+'''+'') = UPPER(''''''+'+@idCol+'+'''''')) AL_''+'+@idCol+'+'' ON 1=1'' AS GEN_SQL_2
  FROM
  (SELECT * FROM '+@inputViewSchema+'.'+@inputViewName+') AS INPUT_VIEW
) INNER_1)inner_2
';

exec sp_executesql @SQL_TEST, N'@out_sql_result varchar(MAX) out', @GEN_FINAL_SQL out
 
exec ('CREATE OR ALTER VIEW '+@outputViewSchema+'.'+@outputViewName+' AS '+@GEN_FINAL_SQL);

END
/*

SET @inputViewSchema = 'CONTROL';
SET @inputViewName = 'V_MOVIEDATA_SCHEMA_COL_STRUCT';
SET @outputViewSchema = 'CONTROL';
SET @outputViewName = 'V_TR_MOVIEDATA_SCHEMA_COL_STRUCT_2';
SET @idCol = 'COLUMN_NAME';


exec control.f_mm_transpose @inputViewSchema = 'CONTROL',  @inputViewName = 'V_MOVIEDATA_SCHEMA_COL_STRUCT', @outputViewSchema = 'CONTROL', @outputViewName = 'V_TR_MOVIEDATA_SCHEMA_COL_STRUCT_2', @idCol = 'COLUMN_NAME';
SELECT * FROM CONTROL.V_TR_MOVIEDATA_SCHEMA_COL_STRUCT_2

*/