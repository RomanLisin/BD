--SQLQuery2 PROCEDURE InsertLessonsFullDay.sql

USE VPD_311_Import
SET DATEFIRST 1;
GO

--Процедура выполняет вставку заданной дисциплины в расписание пока не заполниться весь день или не заполним всё необходимое количество занятий по данной дисциплине.
-- При этом, если количество занятий заполнено в полном объёме, выходим из процедуры с возвращаемым значением 0.

ALTER PROCEDURE sp_InsertLessonsFullDay
	@group		AS	INT,
	@discipline AS	SMALLINT,
	@teacher	AS	SMALLINT,
	@date		AS	DATE OUTPUT,
	@time		AS	TIME OUTPUT,
	@start_time AS TIME,
	@lessons_left AS TINYINT,
	@number_of_lessons AS SMALLINT OUTPUT
AS 
BEGIN
	DECLARE @number_lessons_of_day AS TINYINT = @lessons_left;
	WHILE @lessons_left > 0 AND @number_of_lessons > 0 
	BEGIN
		-- Проверяем, является ли день праздничным
		IF EXISTS (SELECT 1 FROM Holidays WHERE HolidayDate = @date)
		BEGIN
		    PRINT N'Занятие на ' + CAST(@date AS NVARCHAR) + N' отменено: праздничный день!';
			--SET @date = DATEADD(DAY,1,@date);
		    RETURN;
		END
		EXEC sp_InsertLessonToSchedule @group, @discipline, @teacher, @date, @time ;
		SET @lessons_left = @lessons_left - 1;
		SET @number_of_lessons = @number_of_lessons - 1;

		SET @time = DATEADD(MINUTE, 95,@time);
		IF @time = DATEADD(MINUTE,@number_lessons_of_day*95,@start_time)
		SET @time = @start_time;
	END
	IF @number_of_lessons = 0
		RETURN 0;
	ELSE
	BEGIN
		SET @time = @start_time;
		SET @date = DATEADD(DAY,1,@date);
		RETURN 1;
	END
END

