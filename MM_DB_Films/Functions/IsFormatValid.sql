/*
 -------------------------- MM LOAD MOVIEDATA SCHEMA PROCEDURE --------------------------
|                                                                                        |
| Name: isFormatValid.sql                                                                |
| Created: Akos Ujvary                                                                   |
|                                                                                        |
| Desc :  Checks whether the value that is given has the correct format (STAGE to MD)    |
|                                                                                        |
| Last modified:    2023.04.09   Fixing nvarchar                                         |
|                   2022.11.21   Adding date data type                                   |
|                   2022.08.30   TSQL migrating                                          |
|                   2018.01.30   Creation                                                |        
 ----------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER FUNCTION control.f_isformatvalid(
  @colValue varchar(1000), 
  @multiple_values_flg char(1),
  @isNullable varchar(3),
  @data_type varchar(50),
  @data_length numeric,
  @data_precision numeric,
  @data_scale numeric
  )
/*WITH EXECUTE AS CALLER*/
RETURNS INT
AS
BEGIN

DECLARE @DUMMY NUMERIC;
DECLARE @MAX_LENGTH NUMERIC;
DECLARE @DATE_TYPE VARCHAR;

IF (UPPER(@data_type)='NUMERIC') 
BEGIN
  IF(@isNullable='YES' AND ((@data_scale=0 AND LEN(@colValue) BETWEEN 1 AND @data_precision) OR @colValue is null)) return 1; -- TOMATOES: 88
  IF(isnumeric(@colValue)=1 AND @isNullable='NO' AND @data_scale!=0 AND CAST(@colValue as float)<=10) return 1; -- imdbID: 7.5 6.0
  IF(isnumeric(@colValue)=1 AND @isNullable='NO' AND @data_scale=0 AND LEN(@colValue) BETWEEN 1 AND @data_precision) return 1; -- imdbVotes: 10310
END
IF (UPPER(@data_type)='VARCHAR' OR UPPER(@data_type)='NVARCHAR') 
BEGIN
  IF (@multiple_values_flg)='Y'  
    SELECT @MAX_LENGTH=MAX(LEN(value)) FROM STRING_SPLIT(@colValue, ',');
  ELSE
    SET @MAX_LENGTH=LEN(@colValue);
  IF(@isNullable='NO' AND @MAX_LENGTH BETWEEN 1 AND @data_length) return 1;
  IF(@isNullable='YES' AND ((@MAX_LENGTH <= @data_length)OR(@colValue is null))) return 1;
END
IF (UPPER(@data_type)='DATE') 
BEGIN
  SELECT @DATE_TYPE=TRY_CONVERT(DATE, @colValue);
  IF(@DATE_TYPE IS NOT NULL) return 1
END
return 0;
END

/*

testing
 
select control.f_isformatvalid('4025', 'NO', 'numeric', NULL, 4, 0);
 
select control.f_isformatvalid(NULL, 'YES', 'varchar', 100, NULL, NULL)

select control.f_isformatvalid('asd,dds,ds', 'Y', 'YES', 'varchar', 4, NULL, NULL)

select control.f_isformatvalid('25 JUN 1976', 'N', 'YES', 'date', 4, NULL, NULL)

*/ 