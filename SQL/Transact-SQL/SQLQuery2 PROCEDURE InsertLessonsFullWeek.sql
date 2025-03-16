--SQLQuery2 PROCEDURE InsertLessonsFullWeek.sql

USE VPD_311_Import
SET DATEFIRST 1;
GO

ALTER PROCEDURE sp_InsertWeeklySchedule
    @group_id INT,
    @teacher_id SMALLINT,
    @discipline_1_id SMALLINT,
    @discipline_2_id SMALLINT,
    @number_of_lessons_1 SMALLINT OUTPUT,
    @number_of_lessons_2 SMALLINT OUTPUT,
    @week_scheme AS NVARCHAR(10),
    @start_date DATE,
	@date AS DATE OUTPUT,
	@start_time AS TIME,
	@time AS TIME OUTPUT,
	@change_discipline AS BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @DateTable TABLE (DayName NVARCHAR(10));
	INSERT INTO @DateTable (DayName) VALUES ('Monday'), ('Wednesday'), ('Friday');
   
    DECLARE @disc1_days_this_week TINYINT = FLOOR(@week_scheme / 10);
    DECLARE @disc2_days_this_week TINYINT = @week_scheme % 10;
    DECLARE @discipline SMALLINT;
    DECLARE @number_of_lessons SMALLINT;
    SET @time = @start_time;

    WHILE DATENAME(WEEKDAY, @date) <> 'Sunday'
    BEGIN
        SET @discipline = IIF(@change_discipline = 0, @discipline_1_id, @discipline_2_id);
        SET @number_of_lessons = IIF(@change_discipline = 0, @number_of_lessons_1, @number_of_lessons_2);

        --eсли день недели входит в расписание, ставим занятия
        IF EXISTS (SELECT 1 FROM @DateTable WHERE DayName = DATENAME(WEEKDAY, @date))
        BEGIN
            IF (@change_discipline = 0 AND @disc1_days_this_week > 0) OR (@change_discipline = 1 AND @disc2_days_this_week > 0)
            BEGIN
				--			-- Проверяем, является ли день праздничным
				--IF EXISTS (SELECT 1 FROM Holidays WHERE HolidayDate = @date)
				--BEGIN
				--    PRINT N'Занятие на ' + CAST(@date AS NVARCHAR) + N' отменено: праздничный день!';
				--    --RETURN;
				--END
				--ELSE 
				--BEGIN
                EXEC sp_InsertLessonsFullDay @group_id, @discipline, @teacher_id, @date OUTPUT, @time OUTPUT, @start_time, 2, @number_of_lessons OUTPUT;
						--SET @change_discipline = IIF (@number_of_lessons_2 =0,1,0);
						--SET @change_discipline = IIF (@number_of_lessons_1 = 0,0,1);
					IF @change_discipline = 0
					BEGIN
						SET @number_of_lessons_1 = @number_of_lessons;
						SET @disc1_days_this_week = @disc1_days_this_week - 1;
						IF @disc1_days_this_week = 0
						IF @number_of_lessons_2 <>0
						SET @change_discipline = 1; -- IIF(@change_discipline = 0 AND @number_of_lessons_2 <>0, 1, 0);
						ELSE BREAK
					END
					ELSE
					BEGIN
						SET @number_of_lessons_2 = @number_of_lessons;
						SET @disc2_days_this_week = @disc2_days_this_week - 1;
						IF @disc2_days_this_week = 0
						IF @number_of_lessons_1 <>0
						SET @change_discipline = 0; --  IIF(@change_discipline = 1 AND  @number_of_lessons_1 <>0, 0, 1);
						ELSE BREAK
					END
				--END
			END
        END
        SET @date = DATEADD(DAY, 1, @date);
    END
 SET @date = DATEADD(DAY, 1, @date);
 END;

