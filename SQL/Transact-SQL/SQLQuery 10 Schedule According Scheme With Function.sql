USE VPD_311_Import
SET DATEFIRST 1;
GO

DECLARE @scheme NVARCHAR(50) = N'12-21';
DECLARE @FirstWeekNumber TINYINT = CAST(PARSENAME(REPLACE(@scheme, '-', '.'), 2) AS TINYINT);
DECLARE @SecondWeekNumber TINYINT = CAST(PARSENAME(REPLACE(@scheme, '-', '.'), 1) AS TINYINT);
DECLARE @group INT = (SELECT group_id FROM Groups WHERE group_name = N'PD_212');
DECLARE @discipline_1 SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name = N'Hardware-PC');
DECLARE @discipline_2 SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name = N'Разработка Windows-приложений на языке C++');
DECLARE @number_of_lessons_1 SMALLINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_1);
DECLARE @number_of_lessons_2 SMALLINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_2);
DECLARE @Teacher SMALLINT = (SELECT teacher_id FROM Teachers WHERE last_name = N'Глазунов');
DECLARE @start_date DATE = N'2025-06-02';
DECLARE @date DATE = @start_date;
DECLARE @start_time TIME(0) = N'10:00';
DECLARE @time AS TIME(0);
DECLARE @current_week_scheme BIT = 0;
DECLARE @week_scheme AS TINYINT;
DECLARE @disc1_days_this_week TINYINT = 0;
DECLARE @disc2_days_this_week TINYINT = 0;
DECLARE @change_discipline BIT = 0;
DECLARE @discipline AS SMALLINT;
DECLARE @number_of_lessons AS SMALLINT;
SET @time = @start_time;


WHILE (@number_of_lessons_1 > 0 OR @number_of_lessons_2 > 0)
BEGIN
    -- Определяем количество дней занятий для текущей недели
    SET @disc1_days_this_week = IIF(@current_week_scheme = 0, FLOOR(@FirstWeekNumber / 10), FLOOR(@SecondWeekNumber / 10));
    SET @disc2_days_this_week = IIF(@current_week_scheme = 0, @FirstWeekNumber % 10, @SecondWeekNumber % 10);
	SET @week_scheme = IIF(@current_week_scheme = 0, @FirstWeekNumber, @SecondWeekNumber);
	SET @discipline = IIF(@change_discipline = 0, @discipline_1, @discipline_2);
	SET @number_of_lessons = IIF(@change_discipline = 0, @number_of_lessons_1, @number_of_lessons_2);

	IF (@change_discipline = 0 AND @disc1_days_this_week > 0) OR (@change_discipline = 1 AND @disc2_days_this_week > 0)
		BEGIN
			EXEC sp_InsertWeeklySchedule 
			@group, 
			@teacher,
			@discipline_1, 
			@discipline_2,
			@number_of_lessons_1 OUTPUT,
			@number_of_lessons_2 OUTPUT,
			@week_scheme,
			@start_date,
			@date OUTPUT,
			@start_time,
			@time OUTPUT,
			@change_discipline OUTPUT
		END
	
        SET @current_week_scheme = IIF(@current_week_scheme = 0, 1, 0);
END
