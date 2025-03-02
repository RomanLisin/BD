--SQLQuery2 INSERT LessonToSchedule.sql
USE VPD_311_Import
SET DATEFIRST 1;
GO

CREATE PROCEDURE sp_InsertLessonToSchedule
	@group		AS	INT,
	@discipline AS	SMALLINT,
	@teacher	AS	SMALLINT,
	@date		AS	DATE,
	@time		AS	TIME
AS 
BEGIN
	IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [group] = @group AND discipline = @discipline AND [date] = @date AND [time] = @time )
	BEGIN
	INSERT Schedule
			([group], discipline, teacher,[date],[time], spent)
	VALUES  (@group, @discipline, @teacher, @date,  @time,IIF(@date < GETDATE(), 1,0));	
		RETURN 1;
	END
	ELSE
	BEGIN
		RETURN 0;
	END
END