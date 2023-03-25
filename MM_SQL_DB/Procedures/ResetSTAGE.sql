/*
 --------------------------- MM RESET STAGE PROCEDURE ---------------------------------
|                                                                                      |
| Name: ResetSTAGE.sql                                                                 |
| Created: Akos Ujvary                                                                 |
|                                                                                      |
| Last modified: 2022.11.09   Truncating MOVIEDATA.STAGE table                         |
 --------------------------------------------------------------------------------------
*/ 

CREATE OR ALTER PROCEDURE control.reset_stage
WITH EXECUTE AS CALLER
AS
BEGIN

/*--- Start Process ---*/
DECLARE @PROCESS_NAME VARCHAR(50);
SET @PROCESS_NAME= 'RESET_STAGE';
DECLARE @PROCESS_ID VARCHAR(10);
SELECT @PROCESS_ID=control.f_genprocessid(NEXT VALUE FOR LOG.SEQ_PROCESS_ID)
EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='START', @DETAIL='Start of Reset STAGE procedure';

TRUNCATE TABLE STAGE.MOVIEDATA

EXEC CONTROL.LOG_PROCESS @PR_ID=@PROCESS_ID, @NAME=@PROCESS_NAME, @TYPE='END', @DETAIL='End of Reset STAGE procedure';

RETURN 1;

END
--------------------------------------------------- End of code ---------------------------------------------------------
/*
TEST:

declare @returnparam smallint;
exec @returnparam=control.reset_stage;
select @returnparam;

*/
 
 

 
 
 
 
