/*
 -------------------------- MM RESTORE MD PROCEDURE ---------------------------------
|                                                                                      |
| Name: LogProcess.sql                                                                 |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Parameters:  ERR_ID:  Primary key from LOG.LOADING_ERROR table                       |
|              NAME:    Name of the procedure                                          |
|              TYPE:    Type of the process (START, END, ERROR, INFO)                  |
|              DETAIL:  Detailed message of the step                                   |
|                                                                                      |
| Last modified: 2022.08.22   TSQL migrating                                           |
|                2018.03.30   Creation (PostgreSQL)                                    |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.log_process(@PR_ID VARCHAR(10), @NAME varchar(50), @TYPE varchar(10), @DETAIL varchar(200),
                                              @ADDITIONAL_VARIABLE_NAME_1 VARCHAR(50) = NULL, @ADDITIONAL_VARIABLE_VALUE_1 VARCHAR(200) = NULL,
                                              @ADDITIONAL_VARIABLE_NAME_2 VARCHAR(50) = NULL, @ADDITIONAL_VARIABLE_VALUE_2 VARCHAR(200) = NULL,
                                              @ADDITIONAL_VARIABLE_NAME_3 VARCHAR(50) = NULL, @ADDITIONAL_VARIABLE_VALUE_3 VARCHAR(200) = NULL
                                              )
WITH EXECUTE AS CALLER
AS
BEGIN
  DECLARE @POSTFIX VARCHAR(5), @SET_SEQ INTEGER, @STEP_ID INTEGER;

  SELECT @STEP_ID=MAX(STEP_ID)+1 FROM LOG.PROCESS WHERE PR_ID=@PR_ID;
  SET @STEP_ID=COALESCE(@STEP_ID, 1);

  EXEC ('INSERT INTO LOG.PROCESS 
             (PR_ID, STEP_ID, NAME, TYPE, DETAIL_MSG, ADDITIONAL_VARIABLE_NAME_1, ADDITIONAL_VARIABLE_VALUE_1, ADDITIONAL_VARIABLE_NAME_2, ADDITIONAL_VARIABLE_VALUE_2, ADDITIONAL_VARIABLE_NAME_3, ADDITIONAL_VARIABLE_VALUE_3, RUN_DTTM)   
             VALUES ('''+@PR_ID+''', '''+@STEP_ID+''', '''+@NAME+''', '''+@TYPE+''', '''+@DETAIL+''', 
                      '''+@ADDITIONAL_VARIABLE_NAME_1+''', '''+@ADDITIONAL_VARIABLE_VALUE_1+''', 
                      '''+@ADDITIONAL_VARIABLE_NAME_2+''', '''+@ADDITIONAL_VARIABLE_VALUE_2+''', 
                      '''+@ADDITIONAL_VARIABLE_NAME_3+''', '''+@ADDITIONAL_VARIABLE_VALUE_3+''', 
                        CURRENT_TIMESTAMP)');
  
RETURN 1;
END
 
/*
TESTING

EXEC CONTROL.LOG_PROCESS @ERR_ID='TESTING', @NAME='RESTORE_MD', @TYPE='ERROR', @DETAIL='No datestamped backup table was found';

EXEC CONTROL.LOG_PROCESS @PR_ID='test', @NAME='RESTORE_MD', @TYPE='ERROR', @DETAIL='No datestamped backup table was found';

select * from log.process  

*/