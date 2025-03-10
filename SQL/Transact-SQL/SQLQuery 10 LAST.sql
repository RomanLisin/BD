USE VPD_311_Import
GO

--9.*��� ������������ ������ (PD_212) ��������� ���������� �� ������� ������� �� ����� 12-21

DECLARE @DateTable TABLE (DayName NVARCHAR(10));
INSERT INTO @DateTable (DayName) VALUES ('Monday'), ('Wednesday'), ('Friday');

DECLARE @scheme NVARCHAR(50) = N'12-21';
DECLARE @FirstWeekNumber TINYINT = CAST(PARSENAME(REPLACE(@scheme, '-', '.'), 2) AS TINYINT);
DECLARE @SecondWeekNumber TINYINT = CAST(PARSENAME(REPLACE(@scheme, '-', '.'), 1) AS TINYINT);
DECLARE @group INT = (SELECT group_id FROM Groups WHERE group_name = N'PD_212');
DECLARE @discipline_1 SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name = N'Hardware-PC');
DECLARE @discipline_2 SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name = N'���������� Windows-���������� �� ����� C++');
DECLARE @number_of_lessons_1 SMALLINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_1);
DECLARE @number_of_lessons_2 SMALLINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_2);
DECLARE @Teacher SMALLINT = (SELECT teacher_id FROM Teachers WHERE last_name = N'��������');
DECLARE @start_date DATE = N'2024-09-01';
DECLARE @date DATE = @start_date;
DECLARE @time AS TIME(0);
DECLARE @start_time TIME(0) = N'10:00';
DECLARE @current_week_scheme BIT = 0;
DECLARE @day_counter TINYINT = 0;
DECLARE @disc1_days_this_week TINYINT = 0;
DECLARE @disc2_days_this_week TINYINT = 0;
DECLARE @change_discipline    BIT = 0;

WHILE (@number_of_lessons_1 > 0 OR @number_of_lessons_2 > 0)
BEGIN
    SET @disc1_days_this_week  = IIF(@current_week_scheme = 0, FLOOR(@FirstWeekNumber / 10), FLOOR(@SecondWeekNumber / 10));
    SET @disc2_days_this_week  = IIF(@current_week_scheme = 0, @SecondWeekNumber % 10, @FirstWeekNumber % 10);
    SET @day_counter		   = 0;
    SET @change_discipline	   = 0;

    WHILE @day_counter < 7
    BEGIN
        DECLARE @current_day NVARCHAR(10) = DATENAME(WEEKDAY, @date);

        IF EXISTS (SELECT 1 FROM @DateTable WHERE DayName = @current_day)
        BEGIN
            IF @change_discipline = 0 AND @disc1_days_this_week > 0 -- AND @number_of_lessons_1 > 0
            BEGIN
                SET @time = @start_time;
				EXEC sp_InsertLessonToSchedule @group, @discipline_1, @teacher, @date, @time;

				SET @number_of_lessons_1 = @number_of_lessons_1 - 1;
				IF @number_of_lessons_1 >0

				BEGIN
					SET @time = DATEADD(MINUTE,95, @time)
					EXEC sp_InsertLessonToSchedule @group, @discipline_1, @teacher, @date, @time;

					SET @number_of_lessons_1 = @number_of_lessons_1 - 1;
				END 
				ELSE IF @number_of_lessons_2 > 0
				BEGIN
					SET @time = DATEADD(MINUTE,95, @time);
					EXEC sp_InsertLessonToSchedule @group, @discipline_2, @teacher, @date, @time;

					SET @number_of_lessons_2 = @number_of_lessons_2 - 1;
				END
                SET @disc1_days_this_week = @disc1_days_this_week - 1;
                IF @disc1_days_this_week = 0 OR @number_of_lessons_1 = 0
                    SET @change_discipline = 1;
            END
            ELSE
			BEGIN 
				IF @change_discipline = 1 AND @disc2_days_this_week > 0 --AND @number_of_lessons_2 > 0
				BEGIN
					SET @time = DATEADD(MINUTE,95, @time);
					EXEC sp_InsertLessonToSchedule @group, @discipline_2, @teacher, @date, @time;

				    SET @number_of_lessons_2 = @number_of_lessons_2 - 1;
					IF @number_of_lessons_2 >0
					BEGIN
						SET @time = DATEADD(MINUTE,95, @time);
						EXEC sp_InsertLessonToSchedule @group, @discipline_2, @teacher, @date, @time;

						SET @number_of_lessons_2 = @number_of_lessons_2 - 1;
					END 
					ELSE 
					BEGIN IF @number_of_lessons_1 > 0
					BEGIN
						SET @time = DATEADD(MINUTE,95, @time);
						EXEC sp_InsertLessonToSchedule @group, @discipline_1, @teacher, @date, @time;

						SET @number_of_lessons_1 = @number_of_lessons_1 - 1;
					END
					END
				    SET @disc2_days_this_week = @disc2_days_this_week - 1;
					PRINT(@disc2_days_this_week);
				    IF @disc2_days_this_week = 0 OR @number_of_lessons_2 = 0
				        SET @change_discipline = 0; 
				END
			END
        END
        -- ��������� � ���������� ��� � ����� ������
        SET @date = DATEADD(DAY, 1, @date);
        SET @day_counter = @day_counter + 1;
    END

    -- ����������� ������ 
    SET @current_week_scheme = IIF(@current_week_scheme = 0, 1, 0);
END

