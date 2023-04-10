/*
 ---------------------------- MM TRIGGER STAGE MOVIEDATA PROCEDURE -----------------------------
|                                                                                               |
| Name: Trigger_on_stage_moviedata.sql                                                          |
| Created: Akos Ujvary                                                                          |
|                                                                                               |
| Last modified: 2022.11.10   Creation                                                          |
 -----------------------------------------------------------------------------------------------
*/ 

CREATE TRIGGER stage.trigger_on_stage_moviedata  
ON stage.moviedata  
AFTER INSERT   
AS  
   EXEC CONTROL.LOADMOVIEDATA  
GO  
--szemetes:
-- enable trigger  stage.Trigger_on_stage_moviedata on stage.moviedata
-- disable trigger  stage.Trigger_on_stage_moviedata on stage.moviedata

 

