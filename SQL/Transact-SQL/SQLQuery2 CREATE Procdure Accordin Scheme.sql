USE VPD_311_Import
GO
	
	ALTER PROCEDURE sp_SetLessonAccordingScheme
	@discipline_1 AS SMALLINT,
	@discipline_2 AS SMALLINT,
	@number_of_lessons_1 AS SMALLINT OUTPUT,
	@number_of_lessons_2 AS SMALLINT OUTPUT,
	@change_discipline AS BIT OUTPUT,
	@start_time AS TIME(0),
	@time AS TIME(0),
	@group AS INT,
	@teacher AS SMALLINT,
	@date AS DATE OUTPUT,
	@days_of_discipline_1_this_week AS TINYINT,
	@days_of_discipline_2_this_week AS TINYINT
AS
BEGIN
	DECLARE @discipline AS SMALLINT;
	DECLARE @days_of_discipline_this_week AS TINYINT;
	DECLARE @number_of_lessons AS INT;

	-- Определяем текущую дисциплину и количество занятий для неё
	IF @change_discipline = 0
	BEGIN
		SET @discipline = @discipline_1;
		SET @days_of_discipline_this_week = @days_of_discipline_1_this_week;
		SET @number_of_lessons = @number_of_lessons_1;
	END
	ELSE
	BEGIN
		SET @discipline = @discipline_2;
		SET @days_of_discipline_this_week = @days_of_discipline_2_this_week;
		SET @number_of_lessons = @number_of_lessons_2;
	END

	-- Цикл по дням в неделе
	WHILE @days_of_discipline_this_week > 0 AND @number_of_lessons > 0
    BEGIN
        SET @time = @start_time;
		EXEC sp_InsertLessonToSchedule @group, @discipline, @teacher, @date, @time;
		SET @number_of_lessons = @number_of_lessons - 1;

		-- Корректно уменьшаем количество оставшихся занятий
		IF @change_discipline = 0
			SET @number_of_lessons_1 = @number_of_lessons_1 - 1;
		ELSE
			SET @number_of_lessons_2 = @number_of_lessons_2 - 1;

		-- Добавляем ещё одно занятие, если есть место
		IF @number_of_lessons > 0
		BEGIN
			SET @time = DATEADD(MINUTE, 95, @time);
			EXEC sp_InsertLessonToSchedule @group, @discipline, @teacher, @date, @time;
			SET @number_of_lessons = @number_of_lessons - 1;

			IF @change_discipline = 0
				SET @number_of_lessons_1 = @number_of_lessons_1 - 1;
			ELSE
				SET @number_of_lessons_2 = @number_of_lessons_2 - 1;
		END

		-- Уменьшаем количество дней, в которые можно ставить занятия
		SET @days_of_discipline_this_week = @days_of_discipline_this_week - 1;
		SET @date = DATEADD(DAY, 1, @date);
	END 

	-- Переключение дисциплины на следующую итерацию вызова процедуры
	SET @change_discipline = IIF(@change_discipline = 0, 1, 0);
END


--USE VPD_311_Import
--GO


--ALTER PROCEDURE sp_SetLessonAccordingScheme
--	@discipline_1 AS SMALLINT,
--	@discipline_2 AS SMALLINT,
--	@number_of_lessons_1 AS INT,
--	@number_of_lessons_2 AS INT,
--	@change_discipline AS BIT,
--	@start_time AS TIME(0),
--	@time AS TIME(0),
--	@group AS INT,
--	@teacher AS SMALLINT,
--	@date AS DATE,
--	@days_of_discipline_1_this_week AS TINYINT,
--	@days_of_discipline_2_this_week AS TINYINT

--AS
--BEGIN
--	DECLARE @discipline AS SMALLINT
--	DECLARE @days_of_discipline_this_week AS TINYINT
--	DECLARE @number_of_lessons AS INT;

--	SET @discipline = IIF(@change_discipline = 0, @discipline_1, @discipline_2);
--	SET @days_of_discipline_this_week = IIF(@change_discipline = 0, @days_of_discipline_1_this_week, @days_of_discipline_2_this_week);
--	SET @number_of_lessons = IIF(@change_discipline = 0, @number_of_lessons_1, @number_of_lessons_2);
	
--	WHILE @days_of_discipline_this_week >0 AND @number_of_lessons > 0
--    BEGIN
--        SET @time = @start_time;
--		EXEC sp_InsertLessonToSchedule @group, @discipline, @teacher, @date, @time;
--		SET @number_of_lessons = @number_of_lessons - 1;

--		IF @number_of_lessons > 0
--		BEGIN
--			SET @time = DATEADD(MINUTE,95, @time)
--			EXEC sp_InsertLessonToSchedule @group, @discipline, @teacher, @date, @time;
--			SET @number_of_lessons_1 = @number_of_lessons_1 - 1;
--		END
--		ELSE IF @number_of_lessons_2 > 0
--				BEGIN
--					SET @time = DATEADD(MINUTE,95, @time)
--					EXEC sp_InsertLessonToSchedule @group, @discipline_2, @teacher, @date, @time;
--					SET @number_of_lessons_2 = @number_of_lessons_2 - 1;
--				END
--		SET @date = DATEADD(DAY, 1, @date);
--	END 
--	SET @change_discipline = IIF(@change_discipline = 0, 1,0);
--END
	
	


--GO

--CREATE PROCEDURE sp_NumberLessonsLess
--	@group AS INT, 
--	@discipline AS SMALLINT, 
--	@teacher AS SMALLINT, 
--	@date AS DATE OUTPUT, 
--	@time AS TIME(0),
--	@number_of_lessons AS SMALLINT OUTPUT

--AS
--BEGIN
---- Добавляем ещё одно занятие, если есть место
--		IF @number_of_lessons > 0
--		BEGIN
--			SET @time = DATEADD(MINUTE, 95, @time);
--			EXEC sp_InsertLessonToSchedule @group, @discipline, @teacher, @date, @time;
--			SET @number_of_lessons = @number_of_lessons - 1;
--		END
--END